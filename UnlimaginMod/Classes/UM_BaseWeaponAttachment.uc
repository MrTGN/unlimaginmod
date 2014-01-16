//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponAttachment
//	Parent class:	 KFWeaponAttachment
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.09.2013 19:37
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base weapon attachment class with multiple muzzles support.
//================================================================================
class UM_BaseWeaponAttachment extends KFWeaponAttachment
	Abstract;


//========================================================================
//[block] Variables

var		bool						bHasSecondFireMode, bHasSecondMesh;
var		bool						bNeedToInitEffects, bEffectsInitialized;

// SecondMeshActor used for the dual weapons.
// If bHasSecondMesh has set to True, right after this actor has spawned will be spawned 
// SecondMeshActor with the same mesh.
var		Class<UM_MeshActor>			SecondMeshActorClass;
var		UM_MeshActor				SecondMeshActor;	

var		bool						bAssetsLoaded;
var		byte						MuzzleNums[2];		// Muzzles Numbers for the 2 FireModes

enum EMeshNum
{
	MN_One,
	MN_Two
};

struct FireModeData
{
	var	array< EMeshNum >			MeshNums;
	var	array< name >				MuzzleBones;
	var	array< Class<Emitter> >		FlashClasses;
	var	array< Emitter >			Flashes;
	var	array< Class<Emitter> >		SmokeClasses;
	var	array< Emitter >			Smokes;
	var	array< name >				ShellEjectBones;
	var	array< Class<xEmitter> >	ShellEjectClasses;
	var	array< xEmitter >			ShellEjects;
};
var		FireModeData				FireModeEffects[2];

var		bool						bAttachFlashEmitter, bAttachSmokeEmitter;

var		array< string >				SkinRefs;

var		Class< UM_BaseWeaponModuleAttachment >	TacticalModuleClass;
var		UM_BaseWeaponModuleAttachment			TacticalModule;
var		name									TacticalModuleBone;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		MuzzleNums, SecondMeshActor, bNeedToInitEffects;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated static function PreloadAssets(optional KFWeaponAttachment Spawned)
{
	local	int		i;
	
	if ( default.MeshRef != "" )
		UpdateDefaultMesh( Mesh(DynamicLoadObject(default.MeshRef, class'Mesh', true)) );
	if ( default.AmbientSoundRef != "" )
		default.AmbientSound = sound(DynamicLoadObject(default.AmbientSoundRef, class'Sound', true));

	for ( i = 0; i < default.SkinRefs.Length; ++i )  {
		if ( default.SkinRefs[i] != "" )
			default.Skins[i] = Material(DynamicLoadObject(default.SkinRefs[i], class'Material'));
	}
	
	if ( Spawned != None )  {
		if ( default.Mesh != None )
			Spawned.LinkMesh(default.Mesh);
		if ( default.AmbientSound != None )
			Spawned.AmbientSound = default.AmbientSound;
		
		for ( i = 0; i < default.Skins.Length; ++i )  {
			if ( default.Skins[i] != None )
				Spawned.Skins[i] = default.Skins[i];
		}
	}
	
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	UpdateDefaultMesh(None);
	default.AmbientSound = None;
	default.bAssetsLoaded = False;

	Return True;
}

simulated event PostNetReceive()
{
	if ( Instigator != LastInstig )  {
		LastInstig = Instigator;
		if ( KFPawn(Instigator) != None )
			KFPawn(Instigator).SetWeaponAttachment(Self);
	}
	
	if ( bNeedToInitEffects && !bEffectsInitialized )
		InitThirdPersonEffects();
}

simulated event PostNetBeginPlay()
{
	if ( !default.bAssetsLoaded )
		PreloadAssets(self);

	if ( Instigator != None && xPawn(Instigator) != None )
		xPawn(Instigator).SetWeaponAttachment(self);
	
	LastInstig = Instigator;
	mHitLocation = vect(0.0,0.0,0.0);
	
	if ( bNeedToInitEffects && !bEffectsInitialized )
		InitThirdPersonEffects();
}

function UM_BaseWeaponModuleAttachment SpawnTacticalModule()
{
	local	UM_BaseWeaponModule		Module;
	
	if ( TacticalModuleClass != None && TacticalModuleBone != '' )  {
		TacticalModule = Spawn(TacticalModuleClass, Owner);
		if ( TacticalModule != None )
			AttachToBone(TacticalModule, TacticalModuleBone);
	}
	
	Return TacticalModule;
}

simulated function DestroyTacticalModule()
{
	if ( TacticalModule != None )  {
		TacticalModule.Destroy();
		TacticalModule = None;
	}
}

function InitFor(Inventory I)
{
	local	name	RightHandBone;
	local	byte	f, g;
	
	Instigator = I.Instigator;
	
	if ( xPawn(I.Instigator) == None )
		return;

	if ( xPawn(I.Instigator).bClearWeaponOffsets )
		SetRelativeLocation(vect(0,0,0));

	// Checking for the SecondMesh in effects arrays.
	// If somebody has forgot to set bHasSecondMesh to True.
	if ( !bHasSecondMesh )  {
		for ( f = 0; f < ArrayCount(FireModeEffects); ++f )  {
			for ( g = 0; g < FireModeEffects[f].MeshNums.Length; ++g )  {
				if ( FireModeEffects[f].MeshNums[g] == MN_Two )  {
					default.bHasSecondMesh = True;
					bHasSecondMesh = True;
					Break;
				}
			}
			if ( bHasSecondMesh )
				Break;
		}
	}
	
	if ( bHasSecondMesh )  {
		SecondMeshActor = Spawn(SecondMeshActorClass, Instigator);
		if ( SecondMeshActor != None && default.Mesh != None )  {
			SecondMeshActor.LinkMesh(default.Mesh);
			RightHandBone = Instigator.GetOffhandBoneFor(I);
			if ( RightHandBone == '' )  {
				SecondMeshActor.SetLocation(Instigator.Location);
				SecondMeshActor.SetBase(Instigator);
			}
			else
				Instigator.AttachToBone(SecondMeshActor, RightHandBone);
		}
	}
	
	bNeedToInitEffects = True;
}


simulated final function Vector GetBoneLocation(name BoneName)
{
	local	Vector	L;
	
	if ( BoneName != '' )
		L = GetBoneCoords(BoneName).Origin;
	
	Return L;
}

simulated function WeaponLight()
{
    if ( FlashCount > 0 && !Level.bDropDetail && Instigator != None &&
			((Level.TimeSeconds - LastRenderTime) < 0.2 || 
				PlayerController(Instigator.Controller) != None) )  {
		if ( Instigator.IsFirstPerson() )  {
			LitWeapon = Instigator.Weapon;
			LitWeapon.bDynamicLight = true;
		}
		else
			bDynamicLight = true;
        SetTimer(0.15, false);
    }
    else
		Timer();
}

simulated function InitThirdPersonEffects()
{
	local	byte	f, i;
	
	bEffectsInitialized = True;
	
	if ( Level.NetMode == NM_DedicatedServer )
		Return;
	
	for ( f = 0; f < ArrayCount(FireModeEffects); ++f )  {
		//Smoke Effects
		for ( i = 0; i < FireModeEffects[f].SmokeClasses.Length; ++i )  {
			if ( FireModeEffects[f].SmokeClasses[i] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[f].MeshNums.Length > i && FireModeEffects[f].MeshNums[i] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[f].Smokes[i] = SecondMeshActor.Spawn( FireModeEffects[f].SmokeClasses[i], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( bAttachSmokeEmitter && FireModeEffects[f].Smokes[i] != None && FireModeEffects[f].MuzzleBones[i] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[f].Smokes[i], FireModeEffects[f].MuzzleBones[i] );
				}
				else  {
					FireModeEffects[f].Smokes[i] = Spawn( FireModeEffects[f].SmokeClasses[i], self );
					//Attaching
					if ( bAttachSmokeEmitter && FireModeEffects[f].Smokes[i] != None && FireModeEffects[f].MuzzleBones[i] != '' )
						AttachToBone( FireModeEffects[f].Smokes[i], FireModeEffects[f].MuzzleBones[i] );
				}
			}
		}
		//Flash Effects
		for ( i = 0; i < FireModeEffects[f].FlashClasses.Length; ++i )  {
			if ( FireModeEffects[f].FlashClasses[i] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[f].MeshNums.Length > i && FireModeEffects[f].MeshNums[i] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[f].Flashes[i] = SecondMeshActor.Spawn( FireModeEffects[f].FlashClasses[i], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( bAttachFlashEmitter && FireModeEffects[f].Flashes[i] != None && FireModeEffects[f].MuzzleBones[i] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[f].Flashes[i], FireModeEffects[f].MuzzleBones[i] );
				}
				else  {
					FireModeEffects[f].Flashes[i] = Spawn( FireModeEffects[f].FlashClasses[i], self );
					//Attaching
					if ( bAttachFlashEmitter && FireModeEffects[f].Flashes[i] != None && FireModeEffects[f].MuzzleBones[i] != '' )
						AttachToBone( FireModeEffects[f].Flashes[i], FireModeEffects[f].MuzzleBones[i] );
				}
			}
		}
		//ShellEjects
		for ( i = 0; i < FireModeEffects[f].ShellEjectClasses.Length; ++i )  {
			if ( FireModeEffects[f].ShellEjectClasses[i] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[f].MeshNums.Length > i && FireModeEffects[f].MeshNums[i] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[f].ShellEjects[i] = SecondMeshActor.Spawn( FireModeEffects[f].ShellEjectClasses[i], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( FireModeEffects[f].ShellEjects[i] != None && FireModeEffects[f].ShellEjectBones[i] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[f].ShellEjects[i], FireModeEffects[f].ShellEjectBones[i] );
				}
				else {
					FireModeEffects[f].ShellEjects[i] = Spawn( FireModeEffects[f].ShellEjectClasses[i], self );
					//Attaching
					if ( FireModeEffects[f].ShellEjects[i] != None && FireModeEffects[f].ShellEjectBones[i] != '' )
						AttachToBone( FireModeEffects[f].ShellEjects[i], FireModeEffects[f].ShellEjectBones[i] );
				}
			}
		}
	}
}

simulated function DestroyThirdPersonEffects()
{
	local	byte	f, i;
	
	bEffectsInitialized = False;
	
	if ( Level.NetMode == NM_DedicatedServer )
		Return;
	
	for ( f = 0; f < ArrayCount(FireModeEffects); ++f )  {
		//Smoke Effects
		while ( FireModeEffects[f].Smokes.Length > 0 )  {
			i = FireModeEffects[f].Smokes.Length - 1;
			FireModeEffects[f].Smokes[i].Destroy();
			FireModeEffects[f].Smokes.Remove(i, 1);
		}
		//Flash Effects
		while ( FireModeEffects[f].Flashes.Length > 0 )  {
			i = FireModeEffects[f].Flashes.Length - 1;
			FireModeEffects[f].Flashes[i].Destroy();
			FireModeEffects[f].Flashes.Remove(i, 1);
		}
		//ShellEjects
		while ( FireModeEffects[f].ShellEjects.Length > 0 )  {
			i = FireModeEffects[f].ShellEjects.Length - 1;
			FireModeEffects[f].ShellEjects[i].Destroy();
			FireModeEffects[f].ShellEjects.Remove(i, 1);
		}
	}
}

simulated function FlashMuzzleFlash()
{
	local	byte	i;
	local	Vector	Loc;
	
	//Muzzle Number for the current FiringMode
	i = MuzzleNums[FiringMode];
	if ( FireModeEffects[FiringMode].Flashes.Length > i 
		 && FireModeEffects[FiringMode].Flashes[i] != None )  {
		// If not attached
		if ( !bAttachFlashEmitter && FireModeEffects[FiringMode].MuzzleBones[i] != '' )  {
			if ( FireModeEffects[FiringMode].MeshNums.Length > i && FireModeEffects[FiringMode].MeshNums[i] == MN_Two && SecondMeshActor != None )
				Loc = SecondMeshActor.GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[i] );
			else
				Loc = GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[i] );
			FireModeEffects[FiringMode].Flashes[i].SetLocation( Loc );
		}
		FireModeEffects[FiringMode].Flashes[i].Trigger(self, Instigator);
	}
}

simulated function StartMuzzleSmoke()
{
	local	byte	i;
	local	Vector	Loc;
	
	//Muzzle Number for the current FiringMode
	i = MuzzleNums[FiringMode];
	if ( !Level.bDropDetail && FireModeEffects[FiringMode].Smokes.Length > i 
		 && FireModeEffects[FiringMode].Smokes[i] != None )  {
		// If not attached
		if ( !bAttachSmokeEmitter && FireModeEffects[FiringMode].MuzzleBones[i] != '' )  {
			if ( FireModeEffects[FiringMode].MeshNums.Length > i && FireModeEffects[FiringMode].MeshNums[i] == MN_Two && SecondMeshActor != None )
				Loc = SecondMeshActor.GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[i] );
			else
				Loc = GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[i] );
			FireModeEffects[FiringMode].Smokes[i].SetLocation( Loc );
		}
		FireModeEffects[FiringMode].Smokes[i].Trigger(self, Instigator);
	}
}

simulated function EjectShell()
{
	local	byte	i;
	
	//Muzzle Number for the current FiringMode
	i = MuzzleNums[FiringMode];
	if ( FireModeEffects[FiringMode].ShellEjects.Length > i 
		 && FireModeEffects[FiringMode].ShellEjects[i] != None )
		FireModeEffects[FiringMode].ShellEjects[i].mStartParticles++;
	//If we have only one ShellEject
	else if ( FireModeEffects[FiringMode].ShellEjects.Length > 0 
		 && FireModeEffects[FiringMode].ShellEjects[0] != None )
		FireModeEffects[FiringMode].ShellEjects[0].mStartParticles++;
}



// ThirdPersonEffects called by Pawn's C++ tick if FlashCount incremented
// becomes true
// OR called locally for local player
simulated event ThirdPersonEffects()
{
	local	PlayerController	PC;

	if ( Level.NetMode == NM_DedicatedServer || Instigator == None
		 || (FiringMode == 1 && !bHasSecondFireMode) )
		Return;

	if ( FlashCount > 0 )  {
		if ( KFPawn(Instigator) != None )  {
			//AltFireAnim
			if ( FiringMode == 1
				 || (FireModeEffects[FiringMode].MeshNums.Length > MuzzleNums[FiringMode]
					 && FireModeEffects[FiringMode].MeshNums[ MuzzleNums[FiringMode] ] == MN_Two) )
				KFPawn(Instigator).StartFiringX(true, bRapidFire);
			//FireAnim
			else
				KFPawn(Instigator).StartFiringX(false, bRapidFire);
		}

		if ( bDoFiringEffects )  {
    		PC = Level.GetLocalPlayerController();
    		if ( (Level.TimeSeconds - LastRenderTime) > 0.2 && Instigator.Controller != PC )
    			Return;

    		WeaponLight();
    		FlashMuzzleFlash();
			StartMuzzleSmoke();
			EjectShell();
		}
	}
	else  {
		if( KFPawn(Instigator) != None )
			KFPawn(Instigator).StopFiring();
		GotoState('');
	}
}

simulated function Destroyed()
{
	bNeedToInitEffects = False;
	DestroyThirdPersonEffects();
	if ( SecondMeshActor != None )  {
		SecondMeshActor.Destroy();
		SecondMeshActor = None;
	}
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================


defaultproperties
{
	 bDoFiringEffects=True
	 bNetNotify=True
	 bAttachSmokeEmitter=True
	 bAttachFlashEmitter=True
	 bHasSecondFireMode=False
	 bHasSecondMesh=False
	 SecondMeshActorClass=Class'UnlimaginMod.UM_WeaponAttachmentMeshActor'
	 // Default effects for the FireMode 0
	 // These dynamic arrays must be declared using 
	 // the single line syntax: StructProperty=( DynamicArray=(Value, Value) )
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     CullDistance=5000.000000
}
