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
	Abstract;

//========================================================================
//[block] Variables

var				float			NextAutoReloadCheckTime;
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
var(Spread)		float			MaxSpread;			// The maximum spread this weapon will ever have (like when firing in long bursts, etc)
var(Spread)		int				NumShotsInBurst, ShotsForMaxSpread;	// How many shots fired recently
var(Spread)		float			SpreadCooldownTime;	// Spread Cooldown from MaxSpread to Spread
//[end]

//[block] AimError Bonuses
var(AimError)	float			AimingAimErrorBonus;
var(AimError)	float			CrouchedAimErrorBonus;
//[end]

var(ShakeView)	float			AimingShakeBonus;	// Decreases the fire screen shake effects if player is aiming.

// Decreasing Instigator Velocity during the first shot or during the full fire rate firing
var				float			FirstShotMovingSpeedScale, FireMovingSpeedScale;

// Movement
var				float			InstigatorMovingSpeed;
var(Movement)	float			CrouchedMovingBonus;	// Decrease InstigatorMovingSpeed by this multiplier when Instigator is crouching
var(Movement)	float			MaxMoveShakeScale;		// Increases the fire screen shake effects while player is moving up to MaxMoveShakeScale * ShakeRotMag.
var(Movement)	float			MovingAimErrorScale;	// Increases AimError when player is moving. Must be > 1.000000
var(Movement)	float			MovingSpreadScale;		// Increases Spread when player is moving. Must be > 1.000000

var				bool			bChangeProjByPerk;

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

// Array with projectiles data. Weapon will switch projectile info from default to info 
// from this array by PerkIndex if bChangeProjByPerk=True
var		array< PerkProjData >	PerkProjsInfo;

// This variable was deleted from original Killing Floor so I declare it here.
// They have returned this variable back in the next update. Commented out.
//var		float					LowGravKickMomentumScale;

// If bFixedProjPerFire=False weapon will spawn (ProjPerFire * AmmoPerFire) number of projectiles per shot.
// If bFixedProjPerFire=True weapon will spawn fixed ProjPerFire number of projectiles per shot.
var		bool					bFixedProjPerFire;	// Load = AmmoPerFire

var		byte					MuzzleNum;	// Muzzle Number

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
// ProjSpawnOffsets - array of vectors for weapons with more than 1 muzzles.
// Used in GetProjectileSpawnOffset function. 0 index is a first muzzle, 1 index is second muzzle etc.
// Switches between elements by MuzzleNum.
var		array< ProjSpawnData >	ProjSpawnOffsets;

const	DefaultAnimRate = 1.000000;
struct	AnimData
{
	var	name	Anim;
	var	float	StartFrame;		// The frame number at which start to playing animation
	var	float	Rate;
	var	float	TweenTime;
	var	int		Channel;
};

struct	SoundData
{
	var	string		Ref;
	var	sound		Snd;
	var	ESoundSlot	Slot;
	var	float		Vol;
	var	bool		bNoOverride;
	var	float		Radius;
	var	float		Pitch;
	var	bool		Attenuate;
};
// Fire Animation arrays
// Switches between elements by MuzzleNum.
var		array< AnimData >		PreFireAnims,
								PreFireAimedAnims,
								FireAnims,
								FireAimedAnims,
								FireLoopAnims,
								FireLoopAimedAnims,
								EmptyFireAnims,
								EmptyFireAimedAnims,
								FireEndAnims,
								FireEndAimedAnims;

// Arrays with Muzzles and ShellEjectes bones names.
// Switches between elements by MuzzleNum.
// In the MuzzleBones you need to assign FlashBoneName from the original Killing Floor.
var		array< name >			MuzzleBones;
var		array< name >			ShellEjectBones;

var		bool					bDoFiringEffects;

// Arrays with fire effects.
var		array< class<Emitter> >	FlashEmitterClasses, SmokeEmitterClasses, ShellEjectEmitterClasses;
var		array< Emitter >		FlashEmitters, SmokeEmitters, ShellEjectEmitters;

var		bool					bAssetsLoaded;
var		float					FireSpeedModif;

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
	if ( UMWA != None && !Instigator.IsLocallyControlled() )  {
		UMWA.MuzzleNums[ThisModeNum] = NewMuzzleNum;
		//UMWA.NetUpdateTime = Level.TimeSeconds - 1;
	}
}

simulated function CheckAnimArrays()
{
	local	byte	i;
	
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

simulated event PostBeginPlay()
{
	if ( !default.bAssetsLoaded )
		PreloadAssets(Level, self);
	
	CheckAnimArrays();
	
	//[block] Copeid from WeaponFire.uc with some changes
	Load = float(AmmoPerFire);
	if ( bFireOnRelease )
		bWaitForRelease = True;

	if ( bWaitForRelease )
		bNowWaiting = True;
	//[end]

	if ( Weapon != None && KFWeapon(Weapon) != None )
		KFWeap = KFWeapon(Weapon);

	SetMuzzleNum(default.MuzzleNum);
}

simulated function InitEffects()
{
    local	byte	i;
	
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

simulated function DrawMuzzleFlash(Canvas Canvas)
{
	local	UM_BaseWeapon	UMW;
	local	Vector			EffectStart;
	
	// don't even spawn on server
	if ( !bDoFiringEffects || Level.NetMode == NM_DedicatedServer 
		 || AIController(Instigator.Controller) != None )
		Return;
	
	if ( !bAttachSmokeEmitter || !bAttachFlashEmitter )  {
		UMW = UM_BaseWeapon(Weapon);
		if ( UMW != None )
			EffectStart = UMW.GetFireModeEffectStart(ThisModeNum);
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

simulated function FlashMuzzleFlash()
{
	if ( FlashEmitters.Length > MuzzleNum && FlashEmitters[MuzzleNum] != None )
		FlashEmitters[MuzzleNum].Trigger(Weapon, Instigator);
}

simulated function StartMuzzleSmoke()
{
	if ( !Level.bDropDetail && SmokeEmitters.Length > MuzzleNum && SmokeEmitters[MuzzleNum] != None )
		SmokeEmitters[MuzzleNum].Trigger(Weapon, Instigator);
}

simulated function EjectShell()
{
	if ( ShellEjectEmitters.Length > MuzzleNum && ShellEjectEmitters[MuzzleNum] != None )
		ShellEjectEmitters[MuzzleNum].Trigger(Weapon, Instigator);
	// If this weapon have more than one muzzle, but only one ShellEjectBone and ShellEjectEmitter
	else if ( ShellEjectEmitters.Length > 0 && ShellEjectEmitters[0] != None )
		ShellEjectEmitters[0].Trigger(Weapon, Instigator);
}

simulated function DestroyEffects()
{
	local	byte	i;
	
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

//[block] Copied from BaseProjectileFire
// Convenient place to perform changes to a newly spawned projectile
function PostSpawnProjectile(Projectile P)
{
    //P.Damage *= DamageAtten;
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local	Projectile	P;

	if ( ProjectileClass != None )
		P = Weapon.Spawn(ProjectileClass, Instigator,, Start, Dir);
	
	if ( P == None )
		P = ForceSpawnProjectile(Start,Dir);
	
	if ( P != None )
		PostSpawnProjectile(P);
	else
		Return None;
	
	Return P;
}

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
function Projectile ForceSpawnProjectile(Vector Start, Rotator Dir)
{
    local	Vector		HitLocation, HitNormal, StartTrace;
    local	Actor		Other;
    local	Projectile	P;
	local	Class<Projectile> CP;

	// perform the second trace ..
	StartTrace = Instigator.Location + Instigator.EyePosition();
    Other = Weapon.Trace(HitLocation, HitNormal, Start, StartTrace, false, vect(0,0,1));

    CP = GetDesiredProjectileClass();
	
	if ( CP != None )  {
		if ( Other != None )
			Start = (2.0 + FMax(CP.default.CollisionRadius, CP.default.CollisionHeight)) * -Normal(HitLocation - Start) + HitLocation;
		P = Weapon.Spawn(CP, Instigator,, Start, Dir);
	}
	else
		Return None;

    Return P;
}
//[end]

function AdjustKickMomentum()
{
	if ( Instigator != None && !bNoKickMomentum )  {
		if ( !bOnlyLowGravKickMomentum )
            Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
		else if ( Instigator.Physics == PHYS_Falling &&	
				  Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
            Instigator.AddVelocity((KickMomentum * LowGravKickMomentumScale) >> Instigator.GetViewRotation());
	}
}

// Copied from KFShotgunFire with some changes
function DoFireEffect()
{
    local	Vector		StartProj, VX, VY, VZ;
    local	Rotator		R, Aim;
    local	int			p;
    local	int			SpawnCount;
    local	float		theta;

	Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(VX, VY, VZ);

	StartProj = GetProjectileSpawnOffset(VX, VY, VZ);
    Aim = AdjustAim(StartProj, AimError);
	
	if ( bFixedProjPerFire )
		SpawnCount = Max(1, ProjPerFire);
	else
		SpawnCount = Max(1, (ProjPerFire * int(Load)));
	
    if ( SpawnCount > 1 )  {
		switch (SpreadStyle)
		{
			case SS_Random:
				VX = Vector(Aim);
				for (p = 0; p < SpawnCount; p++)  {
					R.Yaw = Spread * (FRand() - 0.5);
					R.Pitch = Spread * (FRand() - 0.5);
					R.Roll = Spread * (FRand() - 0.5);
					SpawnProjectile(StartProj, Rotator(VX >> R));
				}
				Break;
				
			case SS_Line:
				for (p = 0; p < SpawnCount; p++)  {
					theta = Spread * PI / 32768 * (p - float(SpawnCount - 1) / 2.0);
					VX.X = Cos(theta);
					VX.Y = Sin(theta);
					VX.Z = 0.0;
					SpawnProjectile(StartProj, Rotator(VX >> Aim));
				}
				Break;
				
			default:
				for (p = 0; p < SpawnCount; p++)
					SpawnProjectile(StartProj, Aim);
				Break;
		}
	}
	else  {
		switch (SpreadStyle)
		{
			case SS_Random:
				VX = Vector(Aim);
				R.Yaw = Spread * (FRand() - 0.5);
				R.Pitch = Spread * (FRand() - 0.5);
				R.Roll = Spread * (FRand() - 0.5);
				SpawnProjectile(StartProj, Rotator(VX >> R));
				Break;
				
			case SS_Line:
				theta = Spread * PI / 32768 * (p - float(SpawnCount - 1) / 2.0);
				VX.X = Cos(theta);
				VX.Y = Sin(theta);
				VX.Z = 0.0;
				SpawnProjectile(StartProj, Rotator(VX >> Aim));
				Break;
				
			default:
				SpawnProjectile(StartProj, Aim);
				Break;
		}
	}
}

// Clearing StartFiring function
function StartFiring() {}

// Clearing StopFiring function
function StopFiring() {}

function UpdateFireRate()
{
	local	KFPlayerReplicationInfo		KFPRI;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None )  {
		FireSpeedModif = KFPRI.ClientVeteranSkill.Static.GetFireSpeedMod(KFPRI, Weapon);
		if ( UM_SRHumanPawn(Instigator) != None )
			UM_SRHumanPawn(Instigator).FireSpeedModif = FireSpeedModif;
		FireRate = default.FireRate / FireSpeedModif;
	}
	else
		FireRate = default.FireRate;
}

// Calculate modifications to spread bonus
function float UpdateSpread(float NewSpread)
{
	if ( (Level.TimeSeconds - LastFireTime) > SpreadCooldownTime )
		NumShotsInBurst = 0;
	else  {
		NumShotsInBurst++;
		// Decrease accuracy up to MaxSpread by the number of recent shots up to ShotsForMaxSpread
		NewSpread = FMin(( NewSpread + (float(NumShotsInBurst) * (MaxSpread / float(ShotsForMaxSpread))) ), MaxSpread);
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
		
	Return NewSpread;
}

// Calculate modifications to AimError bonus
function float UpdateAimError(float NewAimError)
{
	// Scale AimError by Instigator moving speed
	if ( !KFWeap.bSteadyAim && InstigatorMovingSpeed > 0.0 )
		NewAimError += InstigatorMovingSpeed * MovingAimErrorScale;
	
	// AimError bonus for firing aiming
	if ( KFWeap.bAimingRifle )
		NewAimError *= AimingAimErrorBonus;
	
	// Small AimError bonus for firing crouched
	if ( Instigator != None && Instigator.bIsCrouched )
		NewAimError *= CrouchedAimErrorBonus;
	
	Return NewAimError;
}

function UpdateFireProperties(KFPlayerReplicationInfo KFPRI, float RecoilModif)
{
	local	byte	DefPerkIndex;
	
	ProjectileClass = default.ProjectileClass;
	ProjPerFire = default.ProjPerFire;
	Spread = default.Spread;
	MaxSpread = default.MaxSpread;
	AimError = default.AimError;
	
	//[block] Switching ProjectileClass, ProjPerFire and Spread by Perk Index if Perk exist
	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None && bChangeProjByPerk )  {
		// Assign default.PerkIndex
		DefPerkIndex = KFPRI.ClientVeteranSkill.default.PerkIndex;
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
	Spread = UpdateSpread(Spread) * RecoilModif;
	AimError = UpdateAimError(AimError);
}

function ShakeView()
{
    local	PlayerController	P;
	local	float				ShakeScaler;

	P = PlayerController(Instigator.Controller);
	if ( P != None )  {
		// Add up to MaxMoveShakeScale shake depending on how fast the player is moving
		if ( !KFWeapon(Weapon).bSteadyAim && MaxMoveShakeScale > 1.0 )
			ShakeScaler = FMax((MaxMoveShakeScale * InstigatorMovingSpeed / Instigator.default.GroundSpeed), 1.0);
		else
			ShakeScaler = 1.0;
		
		// Aiming bonuses
		if ( KFWeap.bAimingRifle )
			ShakeScaler *= AimingShakeBonus;
		
		ShakeRotMag.X = default.ShakeRotMag.X * ShakeScaler;
		ShakeRotMag.Y = default.ShakeRotMag.Y * ShakeScaler;
		ShakeRotMag.Z = default.ShakeRotMag.Z * ShakeScaler;
		
		P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, 
						ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
	}
}

simulated function bool AllowFire()
{
	local	KFWeapon	KFW;
	
	KFW = KFWeapon(Weapon);
	
	if ( (KFW.bIsReloading && (!KFW.bHoldToReload || KFW.MagAmmoRemaining < 1))
		 || KFPawn(Instigator).SecondaryItem != None
		 || KFPawn(Instigator).bThrowingNade )
		Return False;
		

	if ( KFW.MagAmmoRemaining < 1 )  {
		//Dry fire and auto reload
		if ( UM_BaseWeapon(Weapon) != None && Level.TimeSeconds >= NextAutoReloadCheckTime )  {
			NextAutoReloadCheckTime = Level.TimeSeconds + FireRate;
			UM_BaseWeapon(Weapon).DryFire(ThisModeNum);
			//log(Self$": No Ammo!");
		}
		Return False;
	}

	Return Super(WeaponFire).AllowFire();
}

// Prevents the de-synchronization between the client and the server
simulated function CheckClientMuzzleNum()
{
	local	UM_BaseWeaponAttachment		UMWA;
	
	UMWA = UM_BaseWeaponAttachment(Weapon.ThirdPersonActor);
	if ( UMWA != None )
		MuzzleNum = UMWA.MuzzleNums[ThisModeNum];
}


simulated function ChangeMuzzleNum()
{
	/* Put your logic to Change MuzzleNum into this function */
}

event ModeDoFire()
{
	local	float	Rec, FireRateRatio;
	local	KFPlayerReplicationInfo	KFPRI;
	
	if ( Instigator == None || Instigator.Controller == None || 
		 !AllowFire() )
		Return;
	
	// Storing InstigatorMovingSpeed
	if ( Instigator.Velocity != Vect(0.0,0.0,0.0) )  {
		if ( Instigator.bIsCrouched )
			InstigatorMovingSpeed = VSize(Instigator.Velocity) * CrouchedMovingBonus;
		else
			InstigatorMovingSpeed = VSize(Instigator.Velocity);
	}
	else
		InstigatorMovingSpeed = 0.0;
	
	if ( Instigator.PlayerReplicationInfo != None
		 && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None )  {
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		KFPRI.ClientVeteranSkill.Static.ModifyRecoilSpread(KFPRI, self, Rec);
	}
	else
		Rec = 1.00;
	
	UpdateFireRate();
	
	//[block] Copeid from WeaponFire.uc with some changes. Added some new functions.
	if ( MaxHoldTime > 0.0 )
		HoldTime = FMin(HoldTime, MaxHoldTime);
	
	// server
    if ( Weapon.Role == ROLE_Authority )  {
		// Updating spread and projectile info. 
		UpdateFireProperties(KFPRI, Rec);
		DoFireEffect();
		AdjustKickMomentum();
		Weapon.ConsumeAmmo(ThisModeNum, Load);
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first

		if ( AIController(Instigator.Controller) != None )
			AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

		Instigator.DeactivateSpawnProtection();
    }
	
	// client
	if ( Instigator.IsLocallyControlled() )  {
		CheckClientMuzzleNum();
		PlayFiring();
		ShakeView();
		if ( bDoFiringEffects )  {
			FlashMuzzleFlash();
			StartMuzzleSmoke();
			EjectShell();
		}
		// client Updating Recoil
		HandleRecoil(Rec);
	}
	else // server
		ServerPlayFiring();

	//ThirdPerson FireEffects
	Weapon.IncrementFlashCount(ThisModeNum);
	// LastFireTime used for Spread bonus calculations. 
	// More info in UpdateSpread function.
	LastFireTime = Level.TimeSeconds;
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

	Load = float(AmmoPerFire);
	HoldTime = 0;
	//[end]
	
	if ( !bFiringDoesntAffectMovement )  {
		if ( FireRate > 0.25 )
			FireRateRatio = (Level.TimeSeconds - LastFireTime) / (FireRate * 1.25);
		else
			FireRateRatio = (Level.TimeSeconds - LastFireTime) / (FireRate * 1.50);
		
		if ( Instigator.Velocity != Vect(0.0,0.0,0.0) )  {
			if ( FireRateRatio < 1.0 )  {
				// Full Fire rate firing
				Instigator.Velocity.X *= FireMovingSpeedScale;
				Instigator.Velocity.Y *= FireMovingSpeedScale;
			}
			else  {
				// FirstShot or slow fire rate firing
				Instigator.Velocity.X *= FirstShotMovingSpeedScale;
				Instigator.Velocity.Y *= FirstShotMovingSpeedScale;
			}
		}
	}
	
	//[block] Copeid from WeaponFire.uc
	if ( Instigator.PendingWeapon != None && Instigator.PendingWeapon != Weapon )  {
		bIsFiring = False;
		Weapon.PutDown();
		Return;
	}
	//[end]
	
	ChangeMuzzleNum();
}

// Copied from KFShotgunFire with some changes like in KFFire
// Handle setting new recoil
simulated function HandleRecoil(float Rec)
{
	local rotator NewRecoilRotation;
	local KFPlayerController KFPC;
	local vector AdjustedVelocity;
	local float AdjustedSpeed;

	KFPC = KFPlayerController(Instigator.Controller);
	if ( Instigator != None && KFPC != None && !KFPC.bFreeCamera )  {
		if ( Weapon.GetFireMode(ThisModeNum).bIsFiring )  {
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
					Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
				{
					// Ignore Z velocity in low grav so we don't get massive recoil
					AdjustedVelocity.Z = 0.0;
					AdjustedSpeed = VSize(AdjustedVelocity);
					//log("AdjustedSpeed = "$AdjustedSpeed$" scale = "$(AdjustedSpeed* RecoilVelocityScale * 0.5));

					// Reduce the falling recoil in low grav
					NewRecoilRotation.Pitch += (AdjustedSpeed * RecoilVelocityScale * 0.5);
					NewRecoilRotation.Yaw += (AdjustedSpeed * RecoilVelocityScale * 0.5);
				}
				else  {
					AdjustedSpeed = VSize(AdjustedVelocity);
					//log("AdjustedSpeed = "$AdjustedSpeed$" scale = "$(AdjustedSpeed* RecoilVelocityScale));
					NewRecoilRotation.Pitch += (AdjustedSpeed * RecoilVelocityScale);
					NewRecoilRotation.Yaw += (AdjustedSpeed * RecoilVelocityScale);
				}
			}
			// Recoil based on how much Health the player have
    	    NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation *= Rec;

 		    KFPC.SetRecoil(NewRecoilRotation, (RecoilRate * FireSpeedModif));
    	}
 	}
}

// MaxRange of fire for bots
function float MaxRange()
{
	if (Instigator.Region.Zone.bDistanceFog)
		Return Min(Instigator.Region.Zone.DistanceFogEnd, EffectiveRange);
	else 
		Return EffectiveRange;
}

// Overriden because I'm using my own functions to update Spread and AimError.
// More info in the UpdateFireProperties function.
simulated function AccuracyUpdate(float Velocity){}

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
        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch),false);
	}
}


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

function PlayStartHold(){}

function PlayFiring()
{
    local	float	 RandPitch;
	
	if ( Weapon.Mesh != None )  {
		// If weapon is already firing and has ammo in mag play animation with out pauses.
		if ( FireCount > 0 && KFWeap.MagAmmoRemaining > 0 )  {
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
			if ( KFWeap.bAimingRifle && KFWeap.MagAmmoRemaining < 1 && EmptyFireAimedAnims.Length > MuzzleNum
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
			else if ( KFWeap.MagAmmoRemaining < 1 && EmptyFireAnims.Length > MuzzleNum
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
        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,(TransientSoundVolume * FirstPersonSoundVolumeScale),,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    else if ( FireSound != None )  {
        if ( bRandomPitchFireSound )  {
            RandPitch = FRand() * RandomPitchAdjustAmt;
            if( FRand() < 0.5 )
                RandPitch *= -1.0;
        }
        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch),false);
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
     TransientSoundRadius=400.000000
	 RandomPitchAdjustAmt=0.050000
	 //Booleans
	 bFiringDoesntAffectMovement=False
	 bFixedProjPerFire=False
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
	 AimingSpreadBonus=0.600000
	 CrouchedSpreadBonus=0.900000
	 //AimError
     AimingAimErrorBonus=0.700000
     CrouchedAimErrorBonus=0.900000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.100000
	 MovingAimErrorScale=4.000000
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
