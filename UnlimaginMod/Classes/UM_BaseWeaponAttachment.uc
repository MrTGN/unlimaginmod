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

var		Class< UM_BaseTacticalModuleAttachment >	TacticalModuleClass;
var		UM_BaseTacticalModuleAttachment				TacticalModule;
var		name										TacticalModuleBone;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		SecondMeshActor, bNeedToInitEffects, MuzzleNums;
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
		xPawn(Instigator).SetWeaponAttachment(Self);
	
	LastInstig = Instigator;
	mHitLocation = vect(0.0,0.0,0.0);
	
	if ( bNeedToInitEffects && !bEffectsInitialized )
		InitThirdPersonEffects();
}

function UM_BaseTacticalModuleAttachment SpawnTacticalModule()
{
	if ( TacticalModule != None )
		DestroyTacticalModule();
	
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
	local	byte	Mode, Muz;
	
	Instigator = I.Instigator;
	
	if ( xPawn(I.Instigator) == None )
		Return;

	if ( xPawn(I.Instigator).bClearWeaponOffsets )
		SetRelativeLocation(vect(0,0,0));

	// Checking for the SecondMesh in effects arrays.
	// If somebody has forgot to set bHasSecondMesh to True.
	if ( !bHasSecondMesh )  {
		for ( Mode = 0; Mode < ArrayCount(FireModeEffects); ++Mode )  {
			for ( Muz = 0; Muz < FireModeEffects[Mode].MeshNums.Length; ++Muz )  {
				if ( FireModeEffects[Mode].MeshNums[Muz] == MN_Two )  {
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
		SecondMeshActor = Spawn(SecondMeshActorClass, I.Owner);
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
	
	NetUpdateTime = Level.TimeSeconds - 1;
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
	local	byte	Mode, Muz;
	
	bEffectsInitialized = True;
	
	if ( Level.NetMode == NM_DedicatedServer )
		Return;
	
	for ( Mode = 0; Mode < ArrayCount(FireModeEffects); ++Mode )  {
		//Smoke Effects
		for ( Muz = 0; Muz < FireModeEffects[Mode].SmokeClasses.Length; ++Muz )  {
			if ( FireModeEffects[Mode].SmokeClasses[Muz] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[Mode].MeshNums.Length > Muz && FireModeEffects[Mode].MeshNums[Muz] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[Mode].Smokes[Muz] = SecondMeshActor.Spawn( FireModeEffects[Mode].SmokeClasses[Muz], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( bAttachSmokeEmitter && FireModeEffects[Mode].Smokes[Muz] != None && FireModeEffects[Mode].MuzzleBones[Muz] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[Mode].Smokes[Muz], FireModeEffects[Mode].MuzzleBones[Muz] );
				}
				else  {
					FireModeEffects[Mode].Smokes[Muz] = Spawn( FireModeEffects[Mode].SmokeClasses[Muz], self );
					//Attaching
					if ( bAttachSmokeEmitter && FireModeEffects[Mode].Smokes[Muz] != None && FireModeEffects[Mode].MuzzleBones[Muz] != '' )
						AttachToBone( FireModeEffects[Mode].Smokes[Muz], FireModeEffects[Mode].MuzzleBones[Muz] );
				}
			}
		}
		//Flash Effects
		for ( Muz = 0; Muz < FireModeEffects[Mode].FlashClasses.Length; ++Muz )  {
			if ( FireModeEffects[Mode].FlashClasses[Muz] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[Mode].MeshNums.Length > Muz && FireModeEffects[Mode].MeshNums[Muz] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[Mode].Flashes[Muz] = SecondMeshActor.Spawn( FireModeEffects[Mode].FlashClasses[Muz], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( bAttachFlashEmitter && FireModeEffects[Mode].Flashes[Muz] != None && FireModeEffects[Mode].MuzzleBones[Muz] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[Mode].Flashes[Muz], FireModeEffects[Mode].MuzzleBones[Muz] );
				}
				else  {
					FireModeEffects[Mode].Flashes[Muz] = Spawn( FireModeEffects[Mode].FlashClasses[Muz], self );
					//Attaching
					if ( bAttachFlashEmitter && FireModeEffects[Mode].Flashes[Muz] != None && FireModeEffects[Mode].MuzzleBones[Muz] != '' )
						AttachToBone( FireModeEffects[Mode].Flashes[Muz], FireModeEffects[Mode].MuzzleBones[Muz] );
				}
			}
		}
		//ShellEjects
		for ( Muz = 0; Muz < FireModeEffects[Mode].ShellEjectClasses.Length; ++Muz )  {
			if ( FireModeEffects[Mode].ShellEjectClasses[Muz] != None )  {
				//if SecondMeshActor
				if ( FireModeEffects[Mode].MeshNums.Length > Muz && FireModeEffects[Mode].MeshNums[Muz] == MN_Two && SecondMeshActor != None )  {
					FireModeEffects[Mode].ShellEjects[Muz] = SecondMeshActor.Spawn( FireModeEffects[Mode].ShellEjectClasses[Muz], SecondMeshActor, , SecondMeshActor.Location, SecondMeshActor.Rotation );
					//Attaching
					if ( FireModeEffects[Mode].ShellEjects[Muz] != None && FireModeEffects[Mode].ShellEjectBones[Muz] != '' )
						SecondMeshActor.AttachToBone( FireModeEffects[Mode].ShellEjects[Muz], FireModeEffects[Mode].ShellEjectBones[Muz] );
				}
				else {
					FireModeEffects[Mode].ShellEjects[Muz] = Spawn( FireModeEffects[Mode].ShellEjectClasses[Muz], self );
					//Attaching
					if ( FireModeEffects[Mode].ShellEjects[Muz] != None && FireModeEffects[Mode].ShellEjectBones[Muz] != '' )
						AttachToBone( FireModeEffects[Mode].ShellEjects[Muz], FireModeEffects[Mode].ShellEjectBones[Muz] );
				}
			}
		}
	}
}

simulated function DestroyThirdPersonEffects()
{
	local	byte	Mode, Muz;
	
	bEffectsInitialized = False;
	
	if ( Level.NetMode == NM_DedicatedServer )
		Return;
	
	for ( Mode = 0; Mode < ArrayCount(FireModeEffects); ++Mode )  {
		//Smoke Effects
		while ( FireModeEffects[Mode].Smokes.Length > 0 )  {
			Muz = FireModeEffects[Mode].Smokes.Length - 1;
			FireModeEffects[Mode].Smokes[Muz].Destroy();
			FireModeEffects[Mode].Smokes.Remove(Muz, 1);
		}
		//Flash Effects
		while ( FireModeEffects[Mode].Flashes.Length > 0 )  {
			Muz = FireModeEffects[Mode].Flashes.Length - 1;
			FireModeEffects[Mode].Flashes[Muz].Destroy();
			FireModeEffects[Mode].Flashes.Remove(Muz, 1);
		}
		//ShellEjects
		while ( FireModeEffects[Mode].ShellEjects.Length > 0 )  {
			Muz = FireModeEffects[Mode].ShellEjects.Length - 1;
			FireModeEffects[Mode].ShellEjects[Muz].Destroy();
			FireModeEffects[Mode].ShellEjects.Remove(Muz, 1);
		}
	}
}

simulated function FlashMuzzleFlash()
{
	local	byte	Muz;
	local	Vector	Loc;
	
	//Muzzle Number for the current FiringMode
	Muz = MuzzleNums[FiringMode];
	if ( FireModeEffects[FiringMode].Flashes.Length > Muz 
		 && FireModeEffects[FiringMode].Flashes[Muz] != None )  {
		// If not attached
		if ( !bAttachFlashEmitter && FireModeEffects[FiringMode].MuzzleBones[Muz] != '' )  {
			if ( FireModeEffects[FiringMode].MeshNums.Length > Muz && FireModeEffects[FiringMode].MeshNums[Muz] == MN_Two && SecondMeshActor != None )
				Loc = SecondMeshActor.GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[Muz] );
			else
				Loc = GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[Muz] );
			FireModeEffects[FiringMode].Flashes[Muz].SetLocation( Loc );
		}
		FireModeEffects[FiringMode].Flashes[Muz].Trigger(self, Instigator);
	}
}

simulated function StartMuzzleSmoke()
{
	local	byte	Muz;
	local	Vector	Loc;
	
	//Muzzle Number for the current FiringMode
	Muz = MuzzleNums[FiringMode];
	if ( !Level.bDropDetail && FireModeEffects[FiringMode].Smokes.Length > Muz 
		 && FireModeEffects[FiringMode].Smokes[Muz] != None )  {
		// If not attached
		if ( !bAttachSmokeEmitter && FireModeEffects[FiringMode].MuzzleBones[Muz] != '' )  {
			if ( FireModeEffects[FiringMode].MeshNums.Length > Muz && FireModeEffects[FiringMode].MeshNums[Muz] == MN_Two && SecondMeshActor != None )
				Loc = SecondMeshActor.GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[Muz] );
			else
				Loc = GetBoneLocation( FireModeEffects[FiringMode].MuzzleBones[Muz] );
			FireModeEffects[FiringMode].Smokes[Muz].SetLocation( Loc );
		}
		FireModeEffects[FiringMode].Smokes[Muz].Trigger(self, Instigator);
	}
}

simulated function EjectShell()
{
	local	byte	Muz;
	
	//Muzzle Number for the current FiringMode
	Muz = MuzzleNums[FiringMode];
	if ( FireModeEffects[FiringMode].ShellEjects.Length > Muz 
		 && FireModeEffects[FiringMode].ShellEjects[Muz] != None )
		FireModeEffects[FiringMode].ShellEjects[Muz].mStartParticles++;
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
