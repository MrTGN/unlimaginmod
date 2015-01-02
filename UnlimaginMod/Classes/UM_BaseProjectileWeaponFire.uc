//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectileWeaponFire
//	Parent class:	 KFShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.04.2013 22:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base ProjectileWeapon fire class
//================================================================================
class UM_BaseProjectileWeaponFire extends KFShotgunFire
	DependsOn(UM_BaseActor)
	Abstract;

//========================================================================
//[block] Variables

const	DefaultAnimRate = 1.000000;
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

// Projectile Spawn Offset
struct	ProjSpawnData
{
	var	float	X;
	var	float	Y;
	var	float	Z;
	var	float	AimX;
	var	float	AimY;
	var	float	AimZ;
};

struct	PerkProjData
{
	var		class<Projectile>	PerkProjClass;
	var		int					PerkProjPerFire;
	var		float				PerkProjSpread;
	var		float				PerkProjMaxSpread;
	var		class<Projectile>	SecondPerkProjClass;
	var		int					SecondPerkProjPerFire;
	var		float				SecondPerkProjSpread;
	var		float				SecondPerkProjMaxSpread;
};

var(Object)		name			InitialStateName;	// After the first initialization object will be set to this state

var				UM_BaseWeapon	UMWeapon;
var				UM_HumanPawn	HumanOwner;
var	class< UM_BaseProjectile >	ProjClass;
var				bool			bCanDryFire;
var				bool			bIsDryFiring;
var				float			NextDryFireTime;

var				float			FirstPersonSoundVolumeScale;	// Scales sounds Volume at FirstPerson view

var(Recoil)		float			RecoilVelocityScale;	// How much to scale the recoil by based on how fast the player is moving
var(Recoil)		bool			bRecoilRightOnly;		// Only recoil the weapon's yaw to the right, not just randomly right and left
var(Recoil)		float			AimingVerticalRecoilBonus;	// VerticalRecoil Aiming Bonus
var(Recoil)		float			AimingHorizontalRecoilBonus;	// HorizontalRecoil Aiming Bonus

// New variables
var(KickMomentum)	bool		bNoKickMomentum;			// No KickMomentum at all
var(KickMomentum)	bool		bOnlyLowGravKickMomentum;	// Only gets KickMomentum on low grav

//[block] Spread Bonuses
var(Spread)		float			LastFireTime;	// Used for Spread bonus calculations. More info in KFFire
var(Spread)		float			AimingSpreadBonus;
var(Spread)		float			CrouchedSpreadBonus;
var(Spread)		float			VeterancySpreadBonus;
var(Spread)		float			MaxSpread;			// The maximum spread this weapon will ever have (like when firing in long bursts, etc)
var(Spread)		int				NumShotsInBurst, ShotsForMaxSpread;	// How many shots fired recently
var(Spread)		float			SpreadCooldownTime;	// Spread Cooldown from MaxSpread to Spread
//[end]

//[block] AimError Bonuses
var(AimError)	float			AimingAimErrorBonus;
var(AimError)	float			CrouchedAimErrorBonus;
var(AimError)	float			VeterancyAimErrorBonus;
//[end]

var(ShakeView)	float			AimingShakeBonus;	// Decreases the fire screen shake effects if player is aiming.

// Decreasing Instigator Velocity during the first shot or during the full fire rate firing
var				float			FirstShotMovingSpeedScale, FireMovingSpeedScale;

// Movement
var				float			InstigatorMovingSpeed;
var(Movement)	float			MaxMoveShakeScale;		// Increases the fire screen shake effects while player is moving up to MaxMoveShakeScale * ShakeRotMag.
var(Movement)	float			MovingAimErrorScale;	// Increases AimError when player is moving. Must be > 1.000000
var(Movement)	float			MovingSpreadScale;		// Increases Spread when player is moving. Must be > 1.000000

var				bool			bChangeProjByPerk;
var				bool			bRecoilIgnoreZVelocity;

// Array with projectiles data. Weapon will switch projectile info from default to info 
// from this array by PerkIndex if bChangeProjByPerk=True
var		array< PerkProjData >	PerkProjsInfo;

// This variable was deleted from original Killing Floor so I declare it here.
// They have returned this variable back in the next update. Commented out.
//var		float					LowGravKickMomentumScale;

var		bool					bTheLastShot;

var		byte					MuzzleNum;	// Muzzle Number

// ProjSpawnOffsets - array of vectors for weapons with more than 1 muzzles.
// Used in GetProjectileSpawnOffset function. 0 index is a first muzzle, 1 index is second muzzle etc.
// Switches between elements by MuzzleNum.
var		array< ProjSpawnData >	ProjSpawnOffsets;

// Fire Animation arrays
// Switches between elements by MuzzleNum.
var		array< UM_BaseActor.AnimData >	PreFireAnims,	PreFireAimedAnims;
var		array< UM_BaseActor.AnimData >	FireAnims,		FireAimedAnims;
var		array< UM_BaseActor.AnimData >	FireLoopAnims,	FireLoopAimedAnims;
var		array< UM_BaseActor.AnimData >	EmptyFireAnims,	EmptyFireAimedAnims;
var		array< UM_BaseActor.AnimData >	FireEndAnims,	FireEndAimedAnims;

// Arrays with Muzzles and ShellEjectes bones names.
// Switches between elements by MuzzleNum.
// In the MuzzleBones you need to assign FlashBoneName from the original Killing Floor.
var		array< name >			MuzzleBones;
var		array< name >			ShellEjectBones;

var		array< class<UM_BaseWeaponMuzzle> >	MuzzleClasses;
var		array< UM_BaseWeaponMuzzle >		Muzzles;

var		bool					bDoFiringEffects;

// Arrays with fire effects.
var		array< class<Emitter> >	FlashEmitterClasses, SmokeEmitterClasses, ShellEjectEmitterClasses;
var		array< Emitter >		FlashEmitters, SmokeEmitters, ShellEjectEmitters;

var		bool					bAssetsLoaded;
var		float					FireSpeedModif;

var		float					VeterancyShakeViewModifier;
var		float					VeterancyRecoilModifier;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

simulated static function PreloadAssets(LevelInfo LevelInfo, optional KFShotgunFire Spawned)
{
	//[block] Loading Defaults
	if ( default.FireSoundRef != "" )
		default.FireSound = sound(DynamicLoadObject(default.FireSoundRef, class'Sound', true));
	
	if ( LevelInfo.bLowSoundDetail || (default.StereoFireSoundRef == "" && default.StereoFireSound == None) )
		default.StereoFireSound = default.FireSound;
	else if ( default.StereoFireSoundRef != "" )
		default.StereoFireSound = sound(DynamicLoadObject(default.StereoFireSoundRef, class'Sound', true));
	
	if ( default.NoAmmoSoundRef != "" )
		default.NoAmmoSound = sound(DynamicLoadObject(default.NoAmmoSoundRef, class'Sound', true));
	//[end]
	
	if ( Spawned != None )  {
		if ( default.FireSound != None )
			Spawned.FireSound = default.FireSound;
		if ( default.StereoFireSound != None )
			Spawned.StereoFireSound = default.StereoFireSound;
		if ( default.NoAmmoSound != None )
			Spawned.NoAmmoSound = default.NoAmmoSound;
	}
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	if ( default.FireSound != None )
		default.FireSound = None;
	if ( default.StereoFireSound != None )
		default.StereoFireSound = None;
	if ( default.NoAmmoSound != None )
		default.NoAmmoSound = None;
	
	default.bAssetsLoaded = False;

	Return True;
}

// Initialization state. 
// Weapon can't fire because some properties are not initialized yet.
state Initialization
{
	simulated function bool AllowFire()
	{
		Return False;
	}
	
	event EndState() { }
}

// Notification on the server and on the client-owner that HumanOwner veterancy has been changed.
// Called from the UM_BaseWeapon.
simulated function NotifyOwnerVeterancyChanged()
{
	if ( HumanOwner != None && HumanOwner.UM_PlayerRepInfo != None )  {
		VeterancySpreadBonus = HumanOwner.UM_PlayerRepInfo.GetSpreadModifier(Self);
		VeterancyAimErrorBonus = HumanOwner.UM_PlayerRepInfo.GetAimErrorModifier(Self);
		VeterancyRecoilModifier = HumanOwner.UM_PlayerRepInfo.GetRecoilModifier(Self);
		VeterancyShakeViewModifier = HumanOwner.UM_PlayerRepInfo.GetShakeViewModifier(Self);
	}
	else  {
		VeterancySpreadBonus = default.VeterancySpreadBonus;
		VeterancyAimErrorBonus = default.VeterancyAimErrorBonus;
		VeterancyRecoilModifier = default.VeterancyRecoilModifier;
		VeterancyShakeViewModifier = default.VeterancyShakeViewModifier;
	}
}

simulated event PreBeginPlay();

// Called after PreBeginPlay().
simulated event BeginPlay();

simulated function name GetMuzzleBoneName()
{
	local	name	BoneName;
	// Hack for the cases with replication
	// because engine do not support dynamic arrays replication
	BoneName = MuzzleBones[MuzzleNum];
	
	Return BoneName;
}

simulated function SetMuzzleNum(byte NewMuzzleNum)
{
	local	UM_BaseWeaponAttachment		UMWA;
	
	MuzzleNum = NewMuzzleNum;
	UMWA = UM_BaseWeaponAttachment(Weapon.ThirdPersonActor);
	//Server
	if ( UMWA != None && Weapon.Role == ROLE_Authority )
		UMWA.MuzzleNums[ThisModeNum] = NewMuzzleNum;
}

simulated function CheckAnimArrays()
{
	local	byte	i;
	
	//ToDo: îòïèëèòü!
	//[block] Checking arrays with animations data
	// If somebody forget to set ainmation Rate in arrays it will be set to DefaultAnimRate
	// and same for the TweenTime.
	// PreFireAnims
	for ( i = 0; i < PreFireAnims.Length; ++i )  {
		if ( PreFireAnims[i].Rate <= 0.0 )
			PreFireAnims[i].Rate = DefaultAnimRate;
		if ( PreFireAnims[i].TweenTime <= 0.0 )
			PreFireAnims[i].TweenTime = TweenTime;
	}
	
	// PreFireAimedAnims
	for ( i = 0; i < PreFireAimedAnims.Length; ++i )  {
		if ( PreFireAimedAnims[i].Rate <= 0.0 )
			PreFireAimedAnims[i].Rate = DefaultAnimRate;
		if ( PreFireAimedAnims[i].TweenTime <= 0.0 )
			PreFireAimedAnims[i].TweenTime = TweenTime;
	}
	
	// FireAnims
	for ( i = 0; i < FireAnims.Length; ++i )  {
		if ( FireAnims[i].Rate <= 0.0 )
			FireAnims[i].Rate = DefaultAnimRate;
		if ( FireAnims[i].TweenTime <= 0.0 )
			FireAnims[i].TweenTime = TweenTime;
	}
	
	// FireAimedAnims
	for ( i = 0; i < FireAimedAnims.Length; ++i )  {
		if ( FireAimedAnims[i].Rate <= 0.0 )
			FireAimedAnims[i].Rate = DefaultAnimRate;
		if ( FireAimedAnims[i].TweenTime <= 0.0 )
			FireAimedAnims[i].TweenTime = TweenTime;
	}
	
	// FireLoopAnims
	for ( i = 0; i < FireLoopAnims.Length; ++i )  {
		if ( FireLoopAnims[i].Rate <= 0.0 )
			FireLoopAnims[i].Rate = DefaultAnimRate;
		if ( FireLoopAnims[i].TweenTime <= 0.0 )
			FireLoopAnims[i].TweenTime = TweenTime;
	}
	
	// FireLoopAimedAnims
	for ( i = 0; i < FireLoopAimedAnims.Length; ++i )  {
		if ( FireLoopAimedAnims[i].Rate <= 0.0 )
			FireLoopAimedAnims[i].Rate = DefaultAnimRate;
		if ( FireLoopAimedAnims[i].TweenTime <= 0.0 )
			FireLoopAimedAnims[i].TweenTime = TweenTime;
	}
	
	// EmptyFireAnims
	for ( i = 0; i < EmptyFireAnims.Length; ++i )  {
		if ( EmptyFireAnims[i].Rate <= 0.0 )
			EmptyFireAnims[i].Rate = DefaultAnimRate;
		if ( EmptyFireAnims[i].TweenTime <= 0.0 )
			EmptyFireAnims[i].TweenTime = TweenTime;
	}
	
	// EmptyFireAimedAnims
	for ( i = 0; i < EmptyFireAimedAnims.Length; ++i )  {
		if ( EmptyFireAimedAnims[i].Rate <= 0.0 )
			EmptyFireAimedAnims[i].Rate = DefaultAnimRate;
		if ( EmptyFireAimedAnims[i].TweenTime <= 0.0 )
			EmptyFireAimedAnims[i].TweenTime = TweenTime;
	}
	
	// FireEndAnims
	for ( i = 0; i < FireEndAnims.Length; ++i )  {
		if ( FireEndAnims[i].Rate <= 0.0 )
			FireEndAnims[i].Rate = DefaultAnimRate;
		if ( FireEndAnims[i].TweenTime <= 0.0 )
			FireEndAnims[i].TweenTime = TweenTime;
	}
	
	// FireEndAimedAnims
	for ( i = 0; i < FireEndAimedAnims.Length; ++i )  {
		if ( FireEndAimedAnims[i].Rate <= 0.0 )
			FireEndAimedAnims[i].Rate = DefaultAnimRate;
		if ( FireEndAimedAnims[i].TweenTime <= 0.0 )
			FireEndAimedAnims[i].TweenTime = TweenTime;
	}
	//[end]
}

simulated function SetInstigator( Pawn NewInstigator )
{
	local	int		i;
	
	Instigator = NewInstigator;
	HumanOwner = UM_HumanPawn(Instigator);
	for ( i = 0; i < Muzzles.Length; ++i )
		Muzzles[i].Instigator = Instigator;
}

// Called after BeginPlay().
simulated event PostBeginPlay()
{
	if ( !default.bAssetsLoaded )
		PreloadAssets(Level, self);
	
	KFWeap = KFWeapon(Weapon);
	UMWeapon = UM_BaseWeapon(Weapon);
	CheckAnimArrays();
	
	//[block] Copeid from WeaponFire class with some changes
	Load = AmmoPerFire;
	if ( bFireOnRelease )
		bWaitForRelease = True;

	if ( bWaitForRelease )
		bNowWaiting = True;
	//[end]

	SetMuzzleNum(default.MuzzleNum);
	UpdateSavedFireProperties();
}

// Called after PostBeginPlay().
simulated event SetInitialState()
{
	GotoState(InitialStateName);
}

// Called after SetInitialState().
simulated event PostNetBeginPlay();

// MaxRange
function float MaxRange()
{
	if ( Instigator.Region.Zone.bDistanceFog )
		Return Min(Instigator.Region.Zone.DistanceFogEnd, EffectiveRange);
	else 
		Return EffectiveRange;
}

// Initializate weapon muzzle actors
//ToDo: issue #183
function InitWeaponMuzzles()
{
	local	byte	i;
	
	if ( UM_BaseWeapon(Weapon) != None )  {
		if ( !IsInState('Initialization') )
			GotoState('Initialization');
		
		for ( i = 0; i < MuzzleClasses.Length; ++i )  {
			if ( MuzzleClasses[i] != None )  {
				Muzzles[i] = Weapon.Spawn( MuzzleClasses[i], Instigator );
				if ( Muzzles[i] != None )  {
					Log("AttachToBone", Name);
					Weapon.AttachToBone( Muzzles[i], MuzzleBones[i] );
					Muzzles[i].Instigator = Instigator;
					Muzzles[i].Weapon = UM_BaseWeapon(Weapon);
					Muzzles[i].SetFireMode(self);
					if ( Muzzles[i] == None )
						Log("Lost Muzzle!", Name);
				}
				else
					Log("Can't find Muzzle!",Name);
			}
		}
		
		SetInitialState();
	}
}

//ToDo: issue #183
function DestroyWeaponMuzzles()
{
	local	int		i;
	
	while ( Muzzles.Length > 0 )  {
		i = Muzzles.Length - 1;
		if ( Muzzles[i] != None )
			Muzzles[i].Destroy();
		Muzzles.Remove(i, 1);
	}
}

// Called from Weapon simulated event Timer()
// ToDo: move this to the WeaponMuzzle
simulated function InitEffects()
{
    local	byte	i;
	
	//if ( Weapon.Role == ROLE_Authority )
		//InitWeaponMuzzles();
	
	// don't even spawn on server
	if ( !bDoFiringEffects || Level.NetMode == NM_DedicatedServer 
		 || AIController(Instigator.Controller) != None )
		Return;
	
	// SmokeEmitters
	for ( i = 0; i < SmokeEmitterClasses.Length; ++i )  {
		if ( SmokeEmitterClasses[i] != None 
			 && (SmokeEmitters.Length <= i || SmokeEmitters[i] == None 
				 || SmokeEmitters[i].bDeleteMe) )
			SmokeEmitters[i] = Weapon.Spawn( SmokeEmitterClasses[i], Weapon );
			if ( SmokeEmitters[i] != None && bAttachSmokeEmitter )
				Weapon.AttachToBone( SmokeEmitters[i], MuzzleBones[i] );
	}
	
	// FlashEmitters
	for ( i = 0; i < FlashEmitterClasses.Length; ++i )  {
		if ( FlashEmitterClasses[i] != None
			 && (FlashEmitters.Length <= i || FlashEmitters[i] == None 
				 || FlashEmitters[i].bDeleteMe ) )  {
			FlashEmitters[i] = Weapon.Spawn( FlashEmitterClasses[i], Weapon );
			if ( FlashEmitters[i] != None && bAttachFlashEmitter )
				Weapon.AttachToBone( FlashEmitters[i], MuzzleBones[i] );
		}
	}
	
	// ShellEjectEmitters
	for ( i = 0; i < ShellEjectEmitterClasses.Length; ++i )  {
		if ( ShellEjectEmitterClasses[i] != None 
			 && (ShellEjectEmitters.Length <= i || ShellEjectEmitters[i] == None 
				 || ShellEjectEmitters[i].bDeleteMe) )  {
			ShellEjectEmitters[i] = Weapon.Spawn( ShellEjectEmitterClasses[i], Weapon );
			if ( ShellEjectEmitters[i] != None )
				Weapon.AttachToBone( ShellEjectEmitters[i], ShellEjectBones[i] );
		}
	}
}

// Called from Weapon simulated event Timer()
// ToDo: move this to the WeaponMuzzle
simulated function DestroyEffects()
{
	local	byte	i;
	
	if ( Weapon.Role == ROLE_Authority )
			DestroyWeaponMuzzles();
	
	while ( SmokeEmitters.Length > 0 )  {
		i = SmokeEmitters.Length - 1;
		if ( SmokeEmitters[i] != None )
			SmokeEmitters[i].Destroy();
		SmokeEmitters.Remove(i,1);
	}
	
	while ( FlashEmitters.Length > 0 )  {
		i = FlashEmitters.Length - 1;
		if ( FlashEmitters[i] != None )
			FlashEmitters[i].Destroy();
		FlashEmitters.Remove(i,1);
	}
	
	while ( ShellEjectEmitters.Length > 0 )  {
		i = ShellEjectEmitters.Length - 1;
		if ( ShellEjectEmitters[i] != None )
			ShellEjectEmitters[i].Destroy();
		ShellEjectEmitters.Remove(i,1);
	}
}

// Called from weapon simulated event RenderOverlays
// ToDo: move this to the WeaponMuzzle
simulated function DrawMuzzleFlash(Canvas Canvas)
{
	local	Vector			EffectStart;
	
	// don't even spawn on server
	if ( !bDoFiringEffects || Level.NetMode == NM_DedicatedServer 
		 || AIController(Instigator.Controller) != None )
		Return;
	
	if ( !bAttachSmokeEmitter || !bAttachFlashEmitter )  {
		if ( UMWeapon != None )
			EffectStart = UMWeapon.GetFireModeEffectStart(ThisModeNum);
		else
			EffectStart = Weapon.GetEffectStart();
	}
	
    // Draw smoke first
	if ( SmokeEmitters.Length > MuzzleNum && SmokeEmitters[MuzzleNum] != None )  {
        if ( !bAttachSmokeEmitter && SmokeEmitters[MuzzleNum].Base != Weapon )
			SmokeEmitters[MuzzleNum].SetLocation( EffectStart );
        Canvas.DrawActor( SmokeEmitters[MuzzleNum], false, false, Weapon.DisplayFOV );
    }
	
	if ( FlashEmitters.Length > MuzzleNum && FlashEmitters[MuzzleNum] != None )  {
        if ( !bAttachFlashEmitter && FlashEmitters[MuzzleNum].Base != Weapon )
			FlashEmitters[MuzzleNum].SetLocation( EffectStart );
		Canvas.DrawActor( FlashEmitters[MuzzleNum], false, false, Weapon.DisplayFOV );
	}
	
    // Draw shell ejects
    if ( ShellEjectEmitters.Length > MuzzleNum && ShellEjectEmitters[MuzzleNum] != None )
        Canvas.DrawActor( ShellEjectEmitters[MuzzleNum], false, false, Weapon.DisplayFOV );
	// If this weapon have more than one muzzle, but only one ShellEjectBone and ShellEjectEmitter
	else if ( ShellEjectEmitters.Length > 0 && ShellEjectEmitters[0] != None )
		Canvas.DrawActor( ShellEjectEmitters[0], false, false, Weapon.DisplayFOV );
}

function FlashMuzzleFlash()
{
	if ( FlashEmitters.Length > MuzzleNum && FlashEmitters[MuzzleNum] != None )
		FlashEmitters[MuzzleNum].Trigger(Weapon, Instigator);
}

function StartMuzzleSmoke()
{
	if ( SmokeEmitters.Length > MuzzleNum && SmokeEmitters[MuzzleNum] != None )
		SmokeEmitters[MuzzleNum].Trigger(Weapon, Instigator);
}

function EjectShell()
{
	if ( ShellEjectEmitters.Length > MuzzleNum && ShellEjectEmitters[MuzzleNum] != None )
		ShellEjectEmitters[MuzzleNum].Trigger(Weapon, Instigator);
	// If this weapon have more than one muzzle, but only one ShellEjectBone and ShellEjectEmitter
	else if ( ShellEjectEmitters.Length > 0 && ShellEjectEmitters[0] != None )
		ShellEjectEmitters[0].Trigger(Weapon, Instigator);
}

// Delivered this code into a separate function because
// dual weapons changes muzzle at each shot
function Vector GetProjectileSpawnOffset(Vector VX, Vector VY, Vector VZ)
{
	local	Vector		SpawnOffset, TraceStart, HitLocation, HitNormal;
	local	float		ProjectileSize;
    local	Actor		Other;
	
	if ( ProjSpawnOffsets.Length > MuzzleNum  )  {
		if ( !Weapon.WeaponCentered() && !KFWeap.bAimingRifle )  {
			//ProjSpawnOffset values
			ProjSpawnOffset.X = default.ProjSpawnOffsets[MuzzleNum].X + Weapon.PlayerViewOffset.X;
			ProjSpawnOffset.Y = default.ProjSpawnOffsets[MuzzleNum].Y + (Weapon.PlayerViewOffset.Y * Weapon.DisplayFOV / 90.0);
			ProjSpawnOffset.Z = default.ProjSpawnOffsets[MuzzleNum].Z + Weapon.PlayerViewOffset.Z;
		}
		else  {
			if ( default.ProjSpawnOffsets[MuzzleNum].AimX != 0.0 )
				ProjSpawnOffset.X = default.ProjSpawnOffsets[MuzzleNum].AimX + Weapon.PlayerViewOffset.X;
			else
				ProjSpawnOffset.X = default.ProjSpawnOffsets[MuzzleNum].X + Weapon.PlayerViewOffset.X;
			ProjSpawnOffset.Y = default.ProjSpawnOffsets[MuzzleNum].AimY;
			ProjSpawnOffset.Z = default.ProjSpawnOffsets[MuzzleNum].AimZ;
		}
	}
	else  {
		ProjSpawnOffset.X = default.ProjSpawnOffset.X;
		if ( !Weapon.WeaponCentered() && !KFWeap.bAimingRifle )  {
			ProjSpawnOffset.Y = default.ProjSpawnOffset.Y;
			ProjSpawnOffset.Z = default.ProjSpawnOffset.Z;
		}
		else  {
			ProjSpawnOffset.Y = 0.0;
			ProjSpawnOffset.Z = 0.0;
		}
	}
	
	//TraceStart and SpawnOffset
	TraceStart = Instigator.Location + Instigator.EyePosition() + VY * ProjSpawnOffset.Y * Weapon.Hand + VZ * ProjSpawnOffset.Z;
	SpawnOffset = TraceStart + VX * ProjSpawnOffset.X;

	// check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, SpawnOffset, TraceStart, false);
	// Collision attachment debugging
	//if( Other.IsA('ROCollisionAttachment'))
		//log(self$"'s trace hit "$Other.Base$" Collision attachment");
 	
	if ( Other != None )  {
		if ( ProjectileClass != None )
			ProjectileSize = 2.0 + FMax(ProjectileClass.default.CollisionRadius, ProjectileClass.default.CollisionHeight);
		else
			ProjectileSize = 2.0;
		SpawnOffset = ProjectileSize * -Normal(HitLocation - TraceStart) + HitLocation;
	}

	Return SpawnOffset;
}

function UpdateSavedFireProperties()
{
	SavedFireProperties.AmmoClass = AmmoClass;
	SavedFireProperties.ProjectileClass = ProjectileClass;
	SavedFireProperties.WarnTargetPct = WarnTargetPct;
	SavedFireProperties.MaxRange = MaxRange();
	SavedFireProperties.bTossed = bTossed;
	SavedFireProperties.bTrySplash = bRecommendSplashDamage;
	SavedFireProperties.bLeadTarget = bLeadTarget;
	SavedFireProperties.bInstantHit = bInstantHit;
	SavedFireProperties.bInitialized = True;
	
	/* ToDo: â äàëüíåéøåì ýòà ôóíêöèÿ äîëæíà âûçûâàòüñÿ åùå 
		ïðè ñìåíåíå òèïà ñíàðÿäà â îðóæèè. Issue #199. */
	ProjClass = Class<UM_BaseProjectile>(ProjectileClass);
	if ( ProjClass != None && !ProjClass.default.bDefaultPropertiesCalculated )
		ProjClass.static.CalcDefaultProperties();
}

function Rotator AdjustAim(Vector Start, float InAimError)
{
	//if ( !SavedFireProperties.bInitialized )
		//UpdateSavedFireProperties();

	Return Instigator.AdjustAim(SavedFireProperties, Start, InAimError);
}

//[block] Copied from BaseProjectileFire
// Accessor function that returns the type of projectile 
// we want this weapon to fire right now
function class<Projectile> GetDesiredProjectileClass()
{
	Return ProjectileClass;
}

// If the first projectile spawn failed it's probably because we're trying 
// to spawn inside the collision bounds of an object with properties that ignore 
// zero extent traces. We need to do a non-zero extent trace so we can
// find a safe spawn loc for our projectile ..
// ToDo: ïåðåïèñàòü âñþ ôóíêöèþ!!! Issue #202
function Projectile ForceSpawnProjectile(Vector Start, Rotator Dir)
{
    local	Vector		HitLocation, HitNormal, StartTrace;
    local	Actor		Other;
    local	Projectile	P;
	local	Class<Projectile> CP;

	// perform the second trace ..
	StartTrace = Instigator.Location + Instigator.EyePosition();
    Other = Weapon.Trace(HitLocation, HitNormal, Start, StartTrace, True, vect(0,0,1));

    CP = GetDesiredProjectileClass();
	
	//ToDo: ïåðåïèñàòü!!!
	if ( CP != None )  {
		if ( Other != None )
			Start = HitLocation - Normal(Start - HitLocation) * FMax(Other.CollisionRadius, CP.default.CollisionRadius) * 1.1;
		P = Weapon.Spawn(CP, Weapon.Owner,, Start, Dir);
		//P = Muzzles[MuzzleNum].Spawn(CP, Muzzles[MuzzleNum],, Start, Dir);
	}
	else
		Return None;

    Return P;
}

// Convenient place to perform changes to a newly spawned projectile
function PostSpawnProjectile(Projectile P)
{
    //P.Damage *= DamageAtten;
}

//ToDo: íóæíà ëè ýòà ôóíêöèÿ âîîáùå?
function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local	Projectile	P;

	P = Weapon.Spawn(ProjectileClass, Weapon.Owner,, Start, Dir);
	//P = Muzzles[MuzzleNum].Spawn(ProjectileClass, Muzzles[MuzzleNum],, Start, Dir);

	if ( P == None || P.bDeleteMe )
		P = ForceSpawnProjectile(Start, Dir);
	
	if ( P != None )
		PostSpawnProjectile(P);
	
	Return P;
}
//[end]

function DoFireEffect()
{
    local	Vector		StartProj, VX, VY, VZ;
    local	Rotator		R, Aim;
    local	int			p;
    local	float		theta;

	Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(VX, VY, VZ);

	StartProj = GetProjectileSpawnOffset(VX, VY, VZ);
	//StartProj = Muzzles[MuzzleNum].Location;
    if ( HumanOwner != None )
		Aim = HumanOwner.GetAimRotation(self, StartProj);
	else
		Aim = AdjustAim(StartProj, AimError);
	
	
	switch (SpreadStyle)
	{
		case SS_Random:
			VX = Vector(Aim);
			for ( p = 0; p < ProjPerFire; ++p )  {
				R.Yaw = Spread * (FRand() - 0.5);
				R.Pitch = Spread * (FRand() - 0.5);
				R.Roll = Spread * (FRand() - 0.5);
				SpawnProjectile(StartProj, Rotator(VX >> R));
			}
			Break;
		
		case SS_Line:
			for ( p = 0; p < ProjPerFire; ++p )  {
				theta = Spread * PI / 32768 * (p - float(ProjPerFire - 1) / 2.0);
				VX.X = Cos(theta);
				VX.Y = Sin(theta);
				VX.Z = 0.0;
				SpawnProjectile(StartProj, Rotator(VX >> Aim));
			}
			Break;
		
		default:
			for ( p = 0; p < ProjPerFire; ++p )  {
				SpawnProjectile(StartProj, Aim);
			}
			Break;
	}
}

function AddKickMomentum()
{
	if ( Instigator != None && !bNoKickMomentum )  {
		if ( !bOnlyLowGravKickMomentum )
            Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
		else if ( Instigator.Physics == PHYS_Falling &&	
				  Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
            Instigator.AddVelocity((KickMomentum * LowGravKickMomentumScale) >> Instigator.GetViewRotation());
	}
}

// Clearing StartFiring function
function StartFiring() { }

// Clearing StopFiring function
function StopFiring() { }

function UpdateFireRate()
{
	local	KFPlayerReplicationInfo		KFPRI;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None )  {
		//ToDo: ýòà ôóíêöèÿ äîëæíà ïðèíèìàòü FireMode, à íå êëàññ îðóæèÿ
		FireSpeedModif = KFPRI.ClientVeteranSkill.Static.GetFireSpeedMod(KFPRI, Weapon);
		// FireSpeedModif in UM_HumanPawn replicates from the server to the clients
		if ( UM_HumanPawn(Instigator) != None && Weapon.Role == ROLE_Authority )
			UM_HumanPawn(Instigator).FireSpeedModif = FireSpeedModif;
		// FireRate
		FireRate = default.FireRate / FireSpeedModif;
	}
	else
		FireRate = default.FireRate;
}

/* ToDo: ïîñëå ðåàëèçàöèè ïåðåêëþ÷åíèÿ áîåïðèñïàñîâ ýòó ôóíêöèþ 
	íóæíî ïåðåïèñàòü àíàëîãè÷íî GetAimError(). Issue #201 */
// Calculate modifications to spread bonus
function float UpdateSpread( float NewSpread )
{
	if ( (Level.TimeSeconds - LastFireTime) > SpreadCooldownTime )
		NumShotsInBurst = 0;
	else  {
		NumShotsInBurst++;
		// Decrease accuracy up to MaxSpread by the number of recent shots up to ShotsForMaxSpread
		NewSpread = FMin( (NewSpread + (float(NumShotsInBurst) * (MaxSpread / float(ShotsForMaxSpread)))), MaxSpread );
	}
	
	// Scale spread by Instigator moving speed
	if ( !KFWeap.bSteadyAim && InstigatorMovingSpeed > 0.0 )
		NewSpread += InstigatorMovingSpeed * MovingSpreadScale;
	
	// Spread bonus for firing aiming
	if ( KFWeap.bAimingRifle )
		NewSpread *= AimingSpreadBonus;
	
	// Small spread bonus for firing crouched
	if ( Instigator != None && Instigator.bIsCrouched )
		NewSpread *= CrouchedSpreadBonus;
	
	Return NewSpread * VeterancySpreadBonus;
}

// This function returns the current AimError with all bonuses and 
// all weapon modules modifiers.
function float GetAimError()
{
	local	float	CurrentAimError;
	
	CurrentAimError = default.AimError * VeterancyAimErrorBonus;
	
	// Scale AimError by Instigator moving speed
	if ( !KFWeap.bSteadyAim && InstigatorMovingSpeed > 0.0 )
		CurrentAimError += InstigatorMovingSpeed * MovingAimErrorScale;
	
	// AimError bonus for firing aiming
	if ( KFWeap.bAimingRifle )
		CurrentAimError *= AimingAimErrorBonus;
	
	// Small AimError bonus for firing crouched
	if ( Instigator != None && Instigator.bIsCrouched )
		CurrentAimError *= CrouchedAimErrorBonus;
	
	Return CurrentAimError;
}

function UpdateFireProperties( Class<UM_SRVeterancyTypes> SRVT )
{
	local	byte	DefPerkIndex;
	
	ProjectileClass = default.ProjectileClass;
	ProjPerFire = default.ProjPerFire;
	Spread = default.Spread;
	MaxSpread = default.MaxSpread;
		
	//[block] Switching ProjectileClass, ProjPerFire and Spread by Perk Index if Perk exist
	if ( SRVT != None && bChangeProjByPerk )  {
		// Assign default.PerkIndex
		DefPerkIndex = SRVT.default.PerkIndex;
		if ( PerkProjsInfo.Length > DefPerkIndex )  {
			// Checking and assigning ProjectileClass
			if ( PerkProjsInfo[DefPerkIndex].PerkProjClass != None )
				ProjectileClass = PerkProjsInfo[DefPerkIndex].PerkProjClass;
			
			// Checking and assigning ProjPerFire
			if ( PerkProjsInfo[DefPerkIndex].PerkProjPerFire > 0 )
				ProjPerFire = PerkProjsInfo[DefPerkIndex].PerkProjPerFire;
			
			// Checking and assigning Spread
			if ( PerkProjsInfo[DefPerkIndex].PerkProjSpread > 0.0 )
				Spread = PerkProjsInfo[DefPerkIndex].PerkProjSpread;
			
			// Checking and assigning MaxSpread
			if ( PerkProjsInfo[DefPerkIndex].PerkProjMaxSpread > 0.0 )
				MaxSpread = PerkProjsInfo[DefPerkIndex].PerkProjMaxSpread;
		}
	}
	//[end]
	// Updating Spread and AimError. Needed for the crouched and Aiming bonuses.
	Spread = UpdateSpread(Spread);
	UpdateSavedFireProperties();
}

// Cleaning up the old function
function ShakeView() { }

function ShakePlayerView()
{
    local	PlayerController	P;
	local	float				ShakeScaler;

	P = PlayerController(Instigator.Controller);
	if ( P != None )  {
		// Add up to MaxMoveShakeScale shake depending on how fast the player is moving
		if ( !KFWeapon(Weapon).bSteadyAim && MaxMoveShakeScale > 1.0 )
			ShakeScaler = FMax((MaxMoveShakeScale * InstigatorMovingSpeed / Instigator.default.GroundSpeed), 1.0) * VeterancyShakeViewModifier;
		else
			ShakeScaler = 1.0 * VeterancyShakeViewModifier;
		
		// Aiming bonuses
		if ( KFWeap.bAimingRifle )
			ShakeScaler *= AimingShakeBonus;
		
		ShakeRotMag = default.ShakeRotMag * ShakeScaler;
		ShakeOffsetMag = default.ShakeOffsetMag * ShakeScaler;
		
		P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
	}
}

//ToDo: ïåðåïèñàòü ýòó ôóíêöèþ äëÿ ðàáîòû ñ SoundData
function PlayNoAmmoSound()
{
	if ( NoAmmoSound != None )
		Weapon.PlayOwnedSound(NoAmmoSound, SLOT_None, TransientSoundVolume,, 300.0,, True);
}

// Dry fire and auto reload
function DryFire()
{
	if ( bCanDryFire && Level.TimeSeconds >= NextDryFireTime )  {
		bCanDryFire = False;
		NextDryFireTime = Level.TimeSeconds + FireRate;
		PlayNoAmmoSound();
		if ( UMWeapon != None && UMWeapon.default.MagCapacity > 1 )  {
			// Player
			if ( PlayerController(Instigator.Controller) != None )
				UMWeapon.RequestAutoReload(ThisModeNum);
			// Bots and other AI
			else if ( AIController(Instigator.Controller) != None )
				UMWeapon.ReloadMeNow();
		}
		bCanDryFire = default.bCanDryFire;
	}
}

simulated function bool AllowFire()
{
	if ( (KFWeap.bIsReloading && (!KFWeap.bHoldToReload || KFWeap.MagAmmoRemaining < AmmoPerFire))
		 || KFPawn(Instigator).SecondaryItem != None || KFPawn(Instigator).bThrowingNade
		 || Instigator.IsProneTransitioning() )
		Return False;
	
	if ( Weapon.AmmoAmount(ThisModeNum) < AmmoPerFire || KFWeap.MagAmmoRemaining < AmmoPerFire )  {
		DryFire();
		Return False;
	}

	Return True;
}

// Cleaning up the old function
simulated function HandleRecoil(float Rec) { }

function AddRecoil()
{
	local	Rotator				NewRecoilRotation;
	local	KFPlayerController	KFPC;
	local	Vector				AdjustedVelocity;
	local	float				AdjustedSpeed;

	KFPC = KFPlayerController(Instigator.Controller);
	if ( KFPC != None && !KFPC.bFreeCamera )  {
		// Aiming bonuses
		if ( KFWeap.bAimingRifle )  {
			maxVerticalRecoilAngle = default.maxVerticalRecoilAngle * AimingVerticalRecoilBonus;
			maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle * AimingHorizontalRecoilBonus;
		}
		else  {
			maxVerticalRecoilAngle = default.maxVerticalRecoilAngle;
			maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle;
		}
		NewRecoilRotation.Pitch = RandRange((maxVerticalRecoilAngle * 0.5), maxVerticalRecoilAngle);
		NewRecoilRotation.Yaw = RandRange((maxHorizontalRecoilAngle * 0.5), maxHorizontalRecoilAngle);

		if ( !bRecoilRightOnly && Rand(2) == 1 )
			NewRecoilRotation.Yaw *= -1.0;

		if ( RecoilVelocityScale > 0.0 )  {
			AdjustedVelocity = Instigator.Velocity;
			if ( Instigator.Physics == PHYS_Falling &&
				Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )  {
				// Ignore Z velocity in low grav so we don't get massive recoil
				AdjustedVelocity.Z = 0.0;
				AdjustedSpeed = VSize(AdjustedVelocity);
				//log("AdjustedSpeed = "$AdjustedSpeed$" scale = "$(AdjustedSpeed* RecoilVelocityScale * 0.5));
				// Reduce the falling recoil in low grav
				NewRecoilRotation.Pitch += Round(AdjustedSpeed * RecoilVelocityScale * 0.5);
				NewRecoilRotation.Yaw += Round(AdjustedSpeed * RecoilVelocityScale * 0.5);
			}
			else  {
				if ( bRecoilIgnoreZVelocity )
					AdjustedVelocity.Z = 0.0;
				AdjustedSpeed = VSize(AdjustedVelocity);
				//log("AdjustedSpeed = "$AdjustedSpeed$" scale = "$(AdjustedSpeed* RecoilVelocityScale));
				NewRecoilRotation.Pitch += Round(AdjustedSpeed * RecoilVelocityScale);
				NewRecoilRotation.Yaw += Round(AdjustedSpeed * RecoilVelocityScale);
			}
		}
		// Recoil based on how much Health the player have
		NewRecoilRotation.Pitch += Round(Instigator.HealthMax / float(Instigator.Health) * 5.0);
		NewRecoilRotation.Yaw += Round(Instigator.HealthMax / float(Instigator.Health) * 5.0);
		// Perk bouns
		KFPC.SetRecoil( (NewRecoilRotation * VeterancyRecoilModifier), (RecoilRate * FireSpeedModif) );
 	}
}

// Prevents the de-synchronization between the client and the server
function CheckClientMuzzleNum()
{
	local	UM_BaseWeaponAttachment		UMWA;
	
	UMWA = UM_BaseWeaponAttachment(Weapon.ThirdPersonActor);
	if ( UMWA != None )
		MuzzleNum = UMWA.MuzzleNums[ThisModeNum];
}


function ChangeMuzzleNum()
{
	/* Put your logic to Change MuzzleNum into this function.
	Use SetMuzzleNum() function to set the new MuzzleNum. */
}

// Copeid from the WeaponFire class with some changes. Added new functions.
event ModeDoFire()
{
	local	float	FireRateRatio;

	if ( Instigator == None || Instigator.Controller == None || 
		 !AllowFire() )
		Return;
	
	/*
	if ( Muzzles[MuzzleNum] == None )  {
		Log("Can't find Muzzle Object #"$MuzzleNum, Name);
		InitWeaponMuzzles();
		Return;
	}	*/
	
	bTheLastShot = KFWeap.MagAmmoRemaining <= AmmoPerFire;
	// Storing InstigatorMovingSpeed
	if ( Instigator.Velocity != Vect(0.0,0.0,0.0) )
		InstigatorMovingSpeed = VSize(Instigator.Velocity);
	else
		InstigatorMovingSpeed = 0.0;
	
	UpdateFireRate();
	
	if ( MaxHoldTime > 0.0 )
		HoldTime = FMin(HoldTime, MaxHoldTime);
	
	// server
    if ( Weapon.Role == ROLE_Authority )  {
		// Updating spread and projectile info. 
		UpdateFireProperties( Class<UM_SRVeterancyTypes>(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill) );
		Weapon.ConsumeAmmo(ThisModeNum, Load);
		DoFireEffect();
		AddKickMomentum();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
    }
	
	// client
	if ( Instigator.IsLocallyControlled() )  {
		CheckClientMuzzleNum();
		PlayFiring();
		ShakePlayerView();
		if ( bDoFiringEffects && !Level.bDropDetail )  {
			FlashMuzzleFlash();
			StartMuzzleSmoke();
			EjectShell();
		}
		// client Updating Recoil
		AddRecoil();
	}
	else // server
		ServerPlayFiring();

	//ThirdPerson FireEffects
	Weapon.IncrementFlashCount(ThisModeNum);
	
	// Affect on the Instigator movement
	if ( !bFiringDoesntAffectMovement && Instigator.Physics != PHYS_Falling
		 && Instigator.Velocity != Vect(0.0,0.0,0.0) )  {
		// FireRateRatio
		if ( FireRate > 0.25 )
			FireRateRatio = (Level.TimeSeconds - LastFireTime) / (FireRate * 1.25);
		else
			FireRateRatio = (Level.TimeSeconds - LastFireTime) / (FireRate * 1.50);
		// Full Fire rate firing
		if ( FireRateRatio < 1.0 )  {
			Instigator.Velocity.X *= FireMovingSpeedScale;
			Instigator.Velocity.Y *= FireMovingSpeedScale;
		}
		// FirstShot or slow fire rate firing
		else  {
			Instigator.Velocity.X *= FirstShotMovingSpeedScale;
			Instigator.Velocity.Y *= FirstShotMovingSpeedScale;
		}
	}
	
	// Set the next firing time. 
	// Must be careful here so client and server do not get out of sync.
	if ( bFireOnRelease )  {
		if ( bIsFiring )
			NextFireTime += MaxHoldTime + FireRate;
		else
			NextFireTime = Level.TimeSeconds + FireRate;
	}
	else
		NextFireTime = FMax((NextFireTime + FireRate), Level.TimeSeconds);
	
	if ( bTheLastShot )
		NextDryFireTime = NextFireTime;
	
	// LastFireTime used for Spread bonus calculations. 
	// More info in UpdateSpread function.
	LastFireTime = Level.TimeSeconds;
	Load = AmmoPerFire;
	HoldTime = 0;
	ChangeMuzzleNum();
	
	if ( Instigator.PendingWeapon != None && Instigator.PendingWeapon != Weapon )  {
		bIsFiring = False;
		Weapon.PutDown();
		Return;
	}
}

// Overriden because I'm using my own functions to update Spread and AimError.
// More info in the UpdateFireProperties function.
simulated function AccuracyUpdate(float Velocity) { }

//// client animation ////
function PlayPreFire()
{
    if ( Weapon.Mesh != None )  {
		// PreFireAimedAnims
		if ( KFWeap.bAimingRifle && PreFireAimedAnims.Length > MuzzleNum
			 && Weapon.HasAnim( PreFireAimedAnims[MuzzleNum].Anim ) )
			Weapon.PlayAnim( PreFireAimedAnims[MuzzleNum].Anim, 
							 (PreFireAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
							 PreFireAimedAnims[MuzzleNum].TweenTime );
		// PreFireAnims
		else if ( PreFireAnims.Length > MuzzleNum && Weapon.HasAnim( PreFireAnims[MuzzleNum].Anim ) )
			Weapon.PlayAnim( PreFireAnims[MuzzleNum].Anim, 
							 (PreFireAnims[MuzzleNum].Rate * FireSpeedModif), 
							 PreFireAnims[MuzzleNum].TweenTime );
	}
}

function PlayStartHold() { }

//// server propagation of firing ////
function ServerPlayFiring()
{
	local	float	RandPitch;
	
	if ( FireSound != None )  {
		if ( bRandomPitchFireSound )  {
            RandPitch = FRand() * RandomPitchAdjustAmt;
            if ( FRand() < 0.5 )
                RandPitch *= -1.0;
        }
        Weapon.PlayOwnedSound(FireSound, SLOT_Interact, TransientSoundVolume,, TransientSoundRadius, (1.0 + RandPitch), True);
	}
}

function PlayFiring()
{
    local	float	 RandPitch;
	
	if ( Weapon.Mesh != None )  {
		// If weapon is already firing and has ammo in mag play animation with out pauses.
		// MagAmmoRemaining replicates with delay. So if have one round in mag it is the last shot.
		if ( FireCount > 0 && !bTheLastShot )  {
			// FireAimedAnims
			if ( KFWeap.bAimingRifle && FireAimedAnims.Length > MuzzleNum
				 && Weapon.HasAnim( FireAimedAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( FireAimedAnims[MuzzleNum].Anim, 
								 (FireAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
								 0.0 );
			// FireAnims
			else if ( FireAnims.Length > MuzzleNum && Weapon.HasAnim( FireAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( FireAnims[MuzzleNum].Anim, 
								 (FireAnims[MuzzleNum].Rate * FireSpeedModif), 
								 0.0 );
		}
		// This is a first shot or there is no ammo left in mag
		else  {
			// EmptyFireAimedAnims
			if ( KFWeap.bAimingRifle && bTheLastShot && EmptyFireAimedAnims.Length > MuzzleNum
				 && Weapon.HasAnim( EmptyFireAimedAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( EmptyFireAimedAnims[MuzzleNum].Anim, 
								 (EmptyFireAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
								 EmptyFireAimedAnims[MuzzleNum].TweenTime );
			// FireAimedAnims
			else if ( KFWeap.bAimingRifle && FireAimedAnims.Length > MuzzleNum
				 && Weapon.HasAnim( FireAimedAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( FireAimedAnims[MuzzleNum].Anim, 
								 (FireAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
								 FireAimedAnims[MuzzleNum].TweenTime );
			// EmptyFireAnims
			else if ( bTheLastShot && EmptyFireAnims.Length > MuzzleNum
					  && Weapon.HasAnim( EmptyFireAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( EmptyFireAnims[MuzzleNum].Anim, 
								 (EmptyFireAnims[MuzzleNum].Rate * FireSpeedModif), 
								 EmptyFireAnims[MuzzleNum].TweenTime );
			// FireAnims
			else if ( FireAnims.Length > MuzzleNum && Weapon.HasAnim( FireAnims[MuzzleNum].Anim ) )
				Weapon.PlayAnim( FireAnims[MuzzleNum].Anim, 
								 (FireAnims[MuzzleNum].Rate * FireSpeedModif), 
								 FireAnims[MuzzleNum].TweenTime );
		}
	}
	
	if ( Weapon.Instigator != None && Weapon.Instigator.IsLocallyControlled() 
		 && Weapon.Instigator.IsFirstPerson() && StereoFireSound != None )  {
        if ( bRandomPitchFireSound )  {
            RandPitch = FRand() * RandomPitchAdjustAmt;
            if ( FRand() < 0.5 )
                RandPitch *= -1.0;
        }
        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,(TransientSoundVolume * FirstPersonSoundVolumeScale),,TransientSoundRadius,(1.0 + RandPitch), False);
    }
    else if ( FireSound != None )  {
        if ( bRandomPitchFireSound )  {
            RandPitch = FRand() * RandomPitchAdjustAmt;
            if( FRand() < 0.5 )
                RandPitch *= -1.0;
        }
        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch), True);
    }
    ClientPlayForceFeedback(FireForce);  // jdf

    ++FireCount;
}

// Copied from KFFire with some optimiztions
function PlayFireEnd()
{
    if ( Weapon.Mesh != None )  {
		// FireEndAimedAnims
		if ( KFWeap.bAimingRifle && FireEndAimedAnims.Length > MuzzleNum 
			 && Weapon.HasAnim( FireEndAimedAnims[MuzzleNum].Anim ) )
			Weapon.PlayAnim( FireEndAimedAnims[MuzzleNum].Anim, 
							 (FireEndAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
							 FireEndAimedAnims[MuzzleNum].TweenTime );
		// FireEndAnims
		else if ( FireEndAnims.Length > MuzzleNum && Weapon.HasAnim( FireEndAnims[MuzzleNum].Anim ) )
			Weapon.PlayAnim( FireEndAnims[MuzzleNum].Anim, 
							 (FireEndAnims[MuzzleNum].Rate * FireSpeedModif), 
							 FireEndAnims[MuzzleNum].TweenTime );
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 VeterancyRecoilModifier=1.0
	 VeterancyShakeViewModifier=1.0
	 InitialStateName=""
	 bCanDryFire=True
	 MuzzleNum=0
	 bDoFiringEffects=True
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 MuzzleClasses(0)=Class'UnlimaginMod.UM_TestWeaponMuzzle'
	 //[end]
	 // Animation
	 //ReloadAnim
	 ReloadAnim="Reload"
	 ReloadAnimRate=1.000000
	 //PreFireAnims
	 PreFireAnims(0)=(Anim="PreFire",Rate=1.000000)
	 //FireAnims
	 FireAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 //FireLoopAnims
	 FireLoopAnims(0)=(Anim="FireLoop",Rate=1.000000)
	 //FireEndAnims
	 FireEndAnims(0)=(Anim="FireEnd",Rate=1.000000)
	 //Sounds
	 FirstPersonSoundVolumeScale=0.860000
	 TransientSoundVolume=0.500000
     TransientSoundRadius=300.000000
	 RandomPitchAdjustAmt=0.050000
	 //Booleans
	 bFiringDoesntAffectMovement=False
	 bLeadTarget=True
     bInstantHit=False
	 bModeExclusive=True
	 bRandomPitchFireSound=True
	 bRecoilRightOnly=False
	 bNoKickMomentum=True
	 bOnlyLowGravKickMomentum=False
	 bChangeProjByPerk=False
	 bWaitForRelease=False
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.750000
	 FireMovingSpeedScale=0.500000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.950000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.950000
	 VeterancySpreadBonus=1.000000
	 //AimError
     AimingAimErrorBonus=0.600000
     CrouchedAimErrorBonus=0.850000
	 VeterancyAimErrorBonus=1.00000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 MaxMoveShakeScale=1.100000
	 MovingAimErrorScale=4.000000
	 // Max InstigatorMovingSpeed (GroundSpeed) = 200
	 // Total MaxSpread = MaxSpread + (200 * MovingSpreadScale)
	 MovingSpreadScale=0.001000
	 //[end]
     //Fire properties
	 EffectiveRange=5000.000000
	 LowGravKickMomentumScale=2.000000
	 AmmoPerFire=1
	 ProjPerFire=1
	 // ProjSpawnOffset calculates automaticly. It uses Weapon.PlayerViewOffset X, Y, Z values.
	 // Here you can use ProjSpawnOffset just for fine-tuning of projectile spawn position.
	 // X - pointing from the observer to the screen (length)
	 // Y - horizontal axis (width)
	 // Z - vertical axis (height)
	 // If ProjSpawnOffset.X >= Weapon.PlayerViewOffset.X will be used only ProjSpawnOffset.X value.
	 // You can use this to force spwan on the fixed distance on the X Axis.
	 ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=0.000000)
	 RecoilVelocityScale=3.000000
	 AimError=10.000000
	 // DamageAtten - attenuate instant-hit/projectile damage by this multiplier
	 // In fact this class don't use this variable at all. 
	 // I've stored this value here just for not picking up other value from the parent class.
	 DamageAtten=1.000000
	 //Spread
	 Spread=500.000000
	 ShotsForMaxSpread=6
	 MaxSpread=500.000000
     SpreadStyle=SS_Random
}

