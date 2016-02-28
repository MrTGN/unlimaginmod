//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeapon
//	Parent class:	 KFWeapon
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.03.2013 01:23
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base weapon class in UnlimaginMod
//================================================================================
class UM_BaseWeapon extends KFWeapon 
	DependsOn(UM_BaseActor)
	Abstract;

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var		UM_BaseActor.SoundData	ModeSwitchSound;

var		bool					bHasTacticalReload, bAllowInterruptReload;	// bHasTacticalReload allows to turn on/off TacticalReload
var		int						TacticalReloadCapacityBonus;	// 0 - no capacity bonus on TacticalReload; 1 - MagCapacity + 1 ...

var		UM_BaseActor.AnimData	TacticalReloadAnim;		// Short tactical reload animation. If TacticalReloadAnim has another AnimRate use TacticalReloadAnim.Rate to set it.
var		float					TacticalReloadTime;		// Time needed to play TacticalReloadAnim

//Todo: ïåðåíåñòè ýòè ïåðåìåííûå íà AnimData
var()	name					EmptyIdleAimAnim, EmptyIdleAnim;	// Empty weapon animation
var()	name					EmptySelectAnim, EmptyPutDownAnim;	// Empty weapon animation

var		bool					bAssetsLoaded;
var		bool					bAllowAutoReload;
var		byte					AutoReloadRequestsNum;

var		Class< UM_BaseTacticalModule >			TacticalModuleClass;
var		UM_BaseTacticalModule					TacticalModule;
var		name									TacticalModuleBone;
var		UM_BaseActor.AnimData					TacticalModuleToggleAnim;
var		float									TacticalModuleToggleTime;
var		UM_BaseActor.SoundData					TacticalModuleToggleSound;
var		bool									bTacticalModuleIsActive;

var		float					OwnerMovementModifier;	// Owner movement speed modifier

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	// Server to clients
	reliable if ( Role == ROLE_Authority )
		ClientForceMagAmmoUpdate;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[block] Dynamic Loading
simulated static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	local	int				i;
	local	UM_BaseWeapon	BW;

	if ( !bSkipRefCount )
		default.ReferenceCount++;
	
	// Will be loaded actor variables
	if ( Inv != None )  {
		BW = UM_BaseWeapon(Inv);
		BaseActor.static.LoadActorSkeletalMesh(default.MeshRef, Inv);
	}
	// Only defaults will be loaded in this case
	else
		UpdateDefaultMesh( BaseActor.static.LoadSkeletalMesh(default.MeshRef) );
	
	default.HudImage = BaseActor.static.LoadMaterial(default.HudImageRef);
	default.SelectedHudImage = BaseActor.static.LoadMaterial(default.SelectedHudImageRef);
	default.SelectSound = BaseActor.static.LoadSound(default.SelectSoundRef);
	default.ModeSwitchSound.Snd = BaseActor.static.LoadSound(default.ModeSwitchSound.Ref);
	// default.Skins
	if ( default.SkinRefs.Length > 0 )  {
		if ( default.Skins.Length < default.SkinRefs.Length )
			default.Skins.Length = default.SkinRefs.Length;
		for ( i = 0; i < default.SkinRefs.Length; ++i )
			default.Skins[i] = BaseActor.static.LoadMaterial(default.SkinRefs[i]);
	}

	if ( BW != None )  {
		BW.HudImage = default.HudImage;
		BW.SelectedHudImage = default.SelectedHudImage;
		BW.SelectSound = default.SelectSound;
		BW.ModeSwitchSound.Snd = default.ModeSwitchSound.Snd;
		// Skins
		if ( default.Skins.Length > 0 )  {
			if ( BW.Skins.Length < default.Skins.Length )
				BW.Skins.Length = default.Skins.Length;
			for ( i = 0; i < default.Skins.Length; ++i )
				BW.Skins[i] = default.Skins[i];
		}
	}
	
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	default.ReferenceCount--;
	log("UnloadAssets RefCount after: " @ default.ReferenceCount);

	UpdateDefaultMesh(None);
	default.HudImage = None;
	default.SelectedHudImage = None;
	default.SelectSound = None;
	default.ModeSwitchSound.Snd = None;
	default.Skins.Length = 0;
	
	default.bAssetsLoaded = False;

	Return default.ReferenceCount == 0;
}
//[end]

//[block] Animation functions
// Play the animation once
simulated final function PlayAnimData( UM_BaseActor.AnimData AD, optional float RateMult )
{
	// Rate
	if ( AD.Rate <= 0.0 )
		AD.Rate = 1.0;
	// RateMult
	if ( RateMult > 0.0 )
		AD.Rate *= RateMult;
	// PlayAnim
	PlayAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
	// StartFrame
	if ( AD.StartFrame > 0.0 )
		SetAnimFrame(AD.StartFrame, AD.Channel, 1);
}

// Loop the animation playback
simulated final function LoopAnimData( UM_BaseActor.AnimData AD, optional float RateMult )
{
	// Rate
	if ( AD.Rate <= 0.0 )
		AD.Rate = 1.0;
	// RateMult
	if ( RateMult > 0.0 )
		AD.Rate *= RateMult;
	// LoopAnim
	LoopAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
}
//[end]

simulated final function Vector GetBoneLocation( name BoneName )
{
	if ( BoneName != '' )
		Return GetBoneCoords(BoneName).Origin;
	else
		Return vect(0.0, 0.0, 0.0);
}


// Notification on the server and on the client-owner that HumanOwner veterancy has been changed.
// Called from the UM_HumanPawn.
simulated function NotifyOwnerVeterancyChanged()
{
	local	int		m;
	
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
			UM_BaseProjectileWeaponFire(FireMode[m]).NotifyOwnerVeterancyChanged();
	}
}

// Called immediately after gameplay begins.
simulated event PostBeginPlay()
{
	local	int		m;
	
	if ( !default.bAssetsLoaded )
		PreloadAssets(self, true);

	//[block] Copied from the Weapon class to add some changes
	// Creating the FireMode objects
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireModeClass[m] != None )  {
			FireMode[m] = new(self) FireModeClass[m];
			if ( FireMode[m] != None )  {
				// Go to State 'Initialization'
				//if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
					//UM_BaseProjectileWeaponFire(FireMode[m]).GotoState('Initialization');
				//ToDo: ïåðåðàáîòàòü è âûíåñòè ïîèñê ïàòðîíîâ â îòäåëüíóþ ôóíêöèþ.
				AmmoClass[m] = FireMode[m].AmmoClass;
			}
		}
	}
	
	// Native WeaponFires instantiation
	InitWeaponFires();
	
	// Adjusting WeaponFires properties
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] != None )  {
			FireMode[m].ThisModeNum = m;
			FireMode[m].Level = Level;
			FireMode[m].Owner = self;
			// Sets the FireMode Instigator
			if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
				UM_BaseProjectileWeaponFire(FireMode[m]).SetInstigator(Instigator);
			else
				FireMode[m].Instigator = Instigator;
			FireMode[m].Weapon = self;
			// Calling actor spawning-like Events
			FireMode[m].PreBeginPlay();
			FireMode[m].BeginPlay();
			FireMode[m].PostBeginPlay();
			FireMode[m].SetInitialState();
			FireMode[m].PostNetBeginPlay();
		}
	}
	
	if ( Level.bDropDetail || Level.DetailMode == DM_Low )
		MaxLights = Min(4, MaxLights);
	
	if ( SmallViewOffset == vect(0.0,0.0,0.0) )
		SmallViewOffset = default.PlayerviewOffset;
	
	if ( SmallEffectOffset == vect(0.0,0.0,0.0) )
		SmallEffectOffset = EffectOffset + default.PlayerViewOffset - SmallViewOffset;
	
	if ( bUseOldWeaponMesh && OldMesh != None )  {
		bInitOldMesh = True;
		LinkMesh(OldMesh);
	}
	
	if ( Level.GRI != None )
		CheckSuperBerserk();
	//[end]
	
	//[block] Client code
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( !bHasScope )
			KFScopeDetail = KF_None;
		InitFOV();
	}
	//[end]
}

// Called after PostBeginPlay.
/*
simulated event SetInitialState()
{
	bScriptInitialized = True;
	GotoState(InitialState);
}	*/


simulated function GetViewAxes( out vector XAxis, out vector YAxis, out vector ZAxis )
{
	GetAxes( Instigator.GetViewRotation(), XAxis, YAxis, ZAxis );
}

function SpawnTacticalModule()
{
	local	UM_BaseWeaponAttachment			WA;
	local	UM_BaseTacticalModuleAttachment	TMA;
	
	if ( TacticalModuleClass != None && TacticalModuleBone != '' )  {
		TacticalModule = Spawn(TacticalModuleClass, Owner);
		if ( TacticalModule != None )  {
			AttachToBone(TacticalModule, TacticalModuleBone);
			WA = UM_BaseWeaponAttachment(ThirdPersonActor);
			if ( WA != None )
				TMA = WA.SpawnTacticalModule();
			
			TacticalModule.InitModule(bTacticalModuleIsActive, TMA);
		}
	}
}

simulated function DestroyTacticalModule()
{
	local	UM_BaseWeaponAttachment		WA;
	
	WA = UM_BaseWeaponAttachment(ThirdPersonActor);
	if ( WA != None )
		WA.DestroyTacticalModule();
	
	if ( TacticalModule != None )  {
		TacticalModule.Destroy();
		TacticalModule = None;
	}
}

simulated function bool FireModesReadyToFire()
{
	local	int		Mode;
	
	for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
		if ( FireMode[Mode] == None )
			Continue;
		else if ( FireMode[Mode].IsInState('Initialization')
				 || (FireMode[Mode].bModeExclusive && FireMode[Mode].bIsFiring) )
			Return False;
	}
	
	Return True;
}

function bool AllowToggleTacticalModule()
{
	if ( bIsReloading || TacticalModule == None || IsInState('TogglingTacticalModule') )
		Return False;
	
	Return FireModesReadyToFire();
}

exec function ToggleTacticalModule()
{
	if ( AllowToggleTacticalModule() )
		GotoState('TogglingTacticalModule');
}

state TogglingTacticalModule
{
	simulated event BeginState()
	{
		TacticalModule.Toggle();
		SetTimer(TacticalModuleToggleTime, False);
		if ( Instigator.IsLocallyControlled() && HasAnim( TacticalModuleToggleAnim.Anim ) )
			PlayAnim(TacticalModuleToggleAnim.Anim, TacticalModuleToggleAnim.Rate, TacticalModuleToggleAnim.TweenTime);
	}
	
	simulated event Timer()
	{		
		SetTimer(0.0, false);
		GotoState(InitialState);
	}
}

//[block] Copied from KFWeapon with some changes
// request an auto reload on the server - happens when the player dry fires
function ServerRequestAutoReload()
{
	if ( NumClicks > 0 )  {
		NumClicks = 0;
		ReloadMeNow();
		Return;
	}
	++NumClicks;
}

// Request an auto reload on the client-side
simulated function RequestAutoReload( byte Mode )
{
	if ( bAllowAutoReload && Role < ROLE_Authority && !bIsReloading )  {
		if ( !FireMode[Mode].bWaitForRelease && FireMode[Mode].bIsFiring )
			ClientStopFire(Mode);
		// AutoReloadRequests
		if ( AutoReloadRequestsNum > 0 )  {
			AutoReloadRequestsNum = 0;
			// Calling server function
			ReloadMeNow();
			Return;
		}
		++AutoReloadRequestsNum;
	}
}

simulated function Fire(float F) { }

simulated exec function ToggleIronSights()
{
	if ( bHasAimingMode )  {
		if ( bAimingRifle )
			PerformZoom(false);
		else  {
			/*
			if ( Owner != none && Owner.Physics == PHYS_Falling &&
				Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
				Return;
			*/
			if ( bHoldToReload )
				InterruptReload();

			if ( bIsReloading || !CanZoomNow() )
				Return;

			PerformZoom(True);
		}
	}
}

simulated exec function IronSightZoomIn()
{
	if ( bHasAimingMode )  {
		/*
		if ( Owner != none && Owner.Physics == PHYS_Falling &&
			Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
			Return;
		*/
		if ( bHoldToReload )
			InterruptReload();

		if ( bIsReloading || !CanZoomNow() )
			Return;

		PerformZoom(True);
	}
}

simulated function PlayIdle()
{
	if ( Instigator.IsLocallyControlled() )  {
		if ( bAimingRifle && MagAmmoRemaining < 1 && HasAnim(EmptyIdleAimAnim) )
			LoopAnim(EmptyIdleAimAnim, IdleAnimRate, 0.2);
		else if ( bAimingRifle && HasAnim(IdleAimAnim) )
			LoopAnim(IdleAimAnim, IdleAnimRate, 0.2);
		else if ( MagAmmoRemaining < 1 && HasAnim(EmptyIdleAnim) )
			LoopAnim(EmptyIdleAnim, IdleAnimRate, 0.2);
		else if ( HasAnim(IdleAnim) )
			LoopAnim(IdleAnim, IdleAnimRate, 0.2);
	}
}

simulated function vector CenteredEffectStart()
{
	Return Instigator.Location;
}

simulated function vector GetEffectStart()
{
	local	Vector		FlashLoc;
	local	UM_BaseProjectileWeaponFire		FFM, SFM;

	// jjs - this function should actually never be called in third person views
	// any effect that needs a 3rdp weapon offset should figure it out itself
	FFM = UM_BaseProjectileWeaponFire(FireMode[0]);
	SFM = UM_BaseProjectileWeaponFire(FireMode[1]);
	
	// 1st person
	if ( Instigator.IsFirstPerson() )  {
		if ( WeaponCentered() )
			Return CenteredEffectStart();

		if ( FFM != None && FFM.bIsFiring )
			FlashLoc = GetBoneCoords(FFM.GetMuzzleBoneName()).Origin;
		else if ( SFM != None && SFM.bIsFiring )
			FlashLoc = GetBoneCoords(SFM.GetMuzzleBoneName()).Origin;
		else
			FlashLoc = GetBoneCoords(FlashBoneName).Origin;
	}
	// 3rd person
	else
		FlashLoc = Instigator.Location + Instigator.EyeHeight * Vect(0,0,0.5) + Vector(Instigator.Rotation) * 40.0;
	
	Return FlashLoc;
}

simulated function Vector GetFireModeEffectStart(int ModeNum)
{
	local	Vector		FlashLoc;
	local	UM_BaseProjectileWeaponFire		FM;
	
	// 1st person
	if ( Instigator.IsFirstPerson() )  {
		if ( WeaponCentered() )
			Return CenteredEffectStart();

		FM = UM_BaseProjectileWeaponFire(FireMode[ModeNum]);
		if ( FM != None )
			FlashLoc = GetBoneCoords(FM.GetMuzzleBoneName()).Origin;
		else
			FlashLoc = GetBoneCoords(FlashBoneName).Origin;
	}
	// 3rd person
	else
		FlashLoc = Instigator.Location + Instigator.EyeHeight * Vect(0,0,0.5) + Vector(Instigator.Rotation) * 40.0;
	
	Return FlashLoc;
}

//
// Function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles pickup, otherwise keep going through inventory list.
//
function bool HandlePickupQuery( Pickup Item )
{
	local	int		i;
	local	KFPlayerController	KFPC;

	if ( Inventory == None )
		Return False;
	
	if ( bNoAmmoInstances )  {
		// handle ammo pickups
		for ( i = 0; i < NUM_FIRE_MODES; ++i )  {
			if ( AmmoClass[i] != None && Item.InventoryType == AmmoClass[i] )  {
				if ( AmmoCharge[i] >= MaxAmmo(i) )
					Return True;
				else  {
					Item.AnnouncePickup(Pawn(Owner));
					AddAmmo(Ammo(Item).AmmoAmount, i);
					Item.SetRespawn();
					Return True;
				}
			}
		}
	}
	
	if ( Item.InventoryType == Class )  {
		if ( WeaponPickup(Item) != None )
			Return !WeaponPickup(Item).AllowRepeatPickup();
		else
			Return False;
	}

	KFPC = KFPlayerController(Instigator.Controller);
	if ( KFPC != None && KFPC.IsInInventory(Item.Class, True, True) )  {
		if ( LastHasGunMsgTime < Level.TimeSeconds )  {
			LastHasGunMsgTime = Level.TimeSeconds + 0.5;
			KFPC.ReceiveLocalizedMessage(Class'KFMainMessages',1);
		}
		Return True;
	}
    
	Return Inventory.HandlePickupQuery(Item);
}

simulated function IncrementFlashCount(int Mode)
{
    local	UM_BaseWeaponAttachment		UMWA;
	
	UMWA = UM_BaseWeaponAttachment(ThirdPersonActor);
	if ( UMWA != None )  {
        UMWA.FiringMode = Mode;
        ++UMWA.FlashCount;
		UMWA.NetUpdateTime = Level.TimeSeconds - 1.0;
        UMWA.ThirdPersonEffects();
    }
}

simulated function ZeroFlashCount(int Mode)
{
    local	UM_BaseWeaponAttachment		UMWA;
	
	UMWA = UM_BaseWeaponAttachment(ThirdPersonActor);
	if ( UMWA != None )  {
        UMWA.FiringMode = Mode;
        UMWA.FlashCount = 0;
		UMWA.NetUpdateTime = Level.TimeSeconds - 1.0;
        UMWA.ThirdPersonEffects();
    }
}

// Overridden to take out some UT stuff
simulated event RenderOverlays( Canvas Canvas )
{
	local int m;

	if ( Instigator == None )
		Return;

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;

	if ( Hand < -1.0 || Hand > 1.0 )
		Return;

	// draw muzzleflashes/smoke for all fire modes so idle state won't
	// cause emitters to just disappear
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] != None )
			FireMode[m].DrawMuzzleFlash(Canvas);
	}

	SetLocation( (Instigator.Location + Instigator.CalcDrawOffset(self)) );
	SetRotation( (Instigator.GetViewRotation() + ZoomRotInterp) );

	//PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)

	bDrawingFirstPerson = True;
	Canvas.DrawActor(self, false, false, DisplayFOV);
	bDrawingFirstPerson = False;
}

//simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	local	Inventory	Inv;
	local	bool		bOutOfAmmo;
	local	KFWeapon	KFW;

	if ( Super(Weapon).ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )  {
		if ( Load > 0.0 && (Mode == 0 || bReduceMagAmmoOnSecondaryFire) )  {
			MagAmmoRemaining = Max(0, (MagAmmoRemaining - int(Load)));
			NetUpdateTime = Level.TimeSeconds - 1;
		}

		if ( FireMode[Mode].AmmoPerFire > 0 && InventoryGroup > 0
			 && !bMeleeWeapon && bConsumesPhysicalAmmo
			 && (Ammo[0] == None || FireMode[0] == None || FireMode[0].AmmoPerFire <= 0
				 || Ammo[0].AmmoAmount < FireMode[0].AmmoPerFire)
			 && (Ammo[1] == None || FireMode[1] == None || FireMode[1].AmmoPerFire <= 0
				 || Ammo[1].AmmoAmount < FireMode[1].AmmoPerFire) )  {
			bOutOfAmmo = True;
			
			for ( Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory )  {
				KFW = KFWeapon(Inv);
				if ( KFW != None && Inv.InventoryGroup > 0
					 && !KFW.bMeleeWeapon && KFW.bConsumesPhysicalAmmo
					 && ( (KFW.Ammo[0] != None && KFW.FireMode[0] != None
						 && KFW.FireMode[0].AmmoPerFire > 0
						 && KFW.Ammo[0].AmmoAmount >= KFW.FireMode[0].AmmoPerFire)
					 || (KFW.Ammo[1] != None && KFW.FireMode[1] != None
						 && KFW.FireMode[1].AmmoPerFire > 0
						 && KFW.Ammo[1].AmmoAmount >= KFW.FireMode[1].AmmoPerFire)) )  {
					bOutOfAmmo = False;
					Break;
				}
			}

			if ( bOutOfAmmo )
				PlayerController(Instigator.Controller).Speech('AUTO', 3, "");
		}
		
		Return True;
	}

	Return False;
}
//[end]

simulated function ClientForceMagAmmoUpdate( int NewMagAmmoRemaining, int Mode, int NewAmount )
{
	if ( Role < ROLE_Authority )
		MagAmmoRemaining = NewMagAmmoRemaining;
	
	if ( bNoAmmoInstances )
		AmmoCharge[Mode] = NewAmount;
	else if ( Ammo[Mode] != None )
		Ammo[Mode].AmmoAmount = NewAmount;
}

// Clearing this
simulated function ClientForceKFAmmoUpdate(int NewMagAmmoRemaining, int TotalAmmoRemaining) { }

//[block] Copied from Engine/Weapon.uc with some optimizations
// Clearing the old function
simulated function ClientForceAmmoUpdate(int Mode, int NewAmount) { }

simulated function bool ReadyToFire(int Mode)
{
	if ( IsInState('TogglingTacticalModule') || !FireMode[Mode].AllowFire() 
		  || FireMode[Mode].NextFireTime > (Level.TimeSeconds + FireMode[Mode].PreFireTime) )
		Return False;

	Return FireModesReadyToFire();
}

simulated function bool StartFire(int Mode)
{
	local int	alt;

	if ( !ReadyToFire(Mode) )
		Return False;

	if ( Mode == 0 )
		alt = 1;
	else
		alt = 0;

	FireMode[Mode].bIsFiring = True;
	FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime;

	// prevents rapidly alternating fire modes
	if ( FireMode[alt] != None && FireMode[alt].bModeExclusive )
		FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[alt].NextFireTime);

	if ( Instigator.IsLocallyControlled() )  {
		if ( FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease )
			FireMode[Mode].PlayPreFire();
		FireMode[Mode].FireCount = 0;
	}
	
	//[block] Copied from KFWeapon
	AutoReloadRequestsNum = 0;
	NumClicks = 0;
	if ( Mode == 0 && ForceZoomOutOnFireTime > 0 )
		ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnFireTime;
	else if ( Mode == 1 && ForceZoomOutOnAltFireTime > 0 )
		ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnAltFireTime;

	// Only HoldToReload weapon can Interrupt Reload with firing
	if ( bHoldToReload )
		InterruptReload();
	
	AnimStopLooping();
	FireMode[Mode].StartFiring();
	//[end]

	Return True;
}

event ServerStartFire(byte Mode)
{
	if ( Instigator != None && Instigator.Weapon != Self )  {
		if ( Instigator.Weapon == None )
			Instigator.ServerChangedWeapon(None, self);
		else
			Instigator.Weapon.SynchronizeWeapon(self);
		
		Return;
	}

    if ( FireMode[Mode].NextFireTime <= (Level.TimeSeconds + FireMode[Mode].PreFireTime)
		&& StartFire(Mode) )  {
        FireMode[Mode].ServerStartFireTime = Level.TimeSeconds;
        FireMode[Mode].bServerDelayStartFire = False;
    }
    else if ( FireMode[Mode].AllowFire() )
        FireMode[Mode].bServerDelayStartFire = True;
	else
		ClientForceMagAmmoUpdate( MagAmmoRemaining, Mode, AmmoAmount(Mode) );
}

simulated event ClientStartFire(int Mode)
{
	if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
		Return;
	
	if ( Role < ROLE_Authority )  {
		if ( StartFire(Mode) )
			ServerStartFire(Mode);
	}
	else
		StartFire(Mode);
}

simulated event StopFire(int Mode)
{
	if ( FireMode[Mode].bIsFiring )  {
	    FireMode[Mode].bInstantStop = True;
		FireMode[Mode].bIsFiring = False;
		if ( Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease )
			FireMode[Mode].PlayFireEnd();		
		
		FireMode[Mode].StopFiring();
		if ( !FireMode[Mode].bFireOnRelease )
			ZeroFlashCount(Mode);
	}
}

function ServerStopFire(byte Mode)
{
	// if a stop was received on the same frame as a start then we need to delay the stop for one frame
	if ( FireMode[Mode].bServerDelayStartFire 
		 || FireMode[Mode].ServerStartFireTime == Level.TimeSeconds )  {
		//log("Stop Delayed");
		FireMode[Mode].bServerDelayStopFire = True;
	}
	else  {
		//Log("ServerStopFire"@Level.TimeSeconds);
		StopFire(Mode);
	}
}

simulated event ClientStopFire(int Mode)
{
    if ( Role < ROLE_Authority )  {
        //Log("ClientStopFire"@Level.TimeSeconds);
        StopFire(Mode);
    }
	ServerStopFire(Mode);
}
//[end]

// Only Server-side function
function ActuallyFinishReloading()
{
   bDoSingleReload = False;
   bReloadEffectDone = False;
   ClientFinishReloading();
   bIsReloading = False;
}

simulated function ClientFinishReloading()
{
	if ( Level.NetMode != NM_DedicatedServer )  {
		bIsReloading = False;
		PlayIdle();
		if ( Instigator.PendingWeapon != None && Instigator.PendingWeapon != Self )
			Instigator.Controller.ClientSwitchToBestWeapon();
	}
}

//[block] WeaponTick(dt) Copied from KFWeapon and Overridden to disable automatic reloading
simulated event WeaponTick(float dt)
{
	local	float	LastSeenSeconds;

	if ( bHasAimingMode )  {
		if ( bForceLeaveIronsights )  {
			if ( bAimingRifle )  {
				ZoomOut(true);
				if ( Role < ROLE_Authority )
					ServerZoomOut(False);
			}
			bForceLeaveIronsights = False;
		}

		if ( ForceZoomOutTime > 0.0 )  {
			if ( bAimingRifle )  {
				if ( (Level.TimeSeconds - ForceZoomOutTime) > 0.0 )  {
					ForceZoomOutTime = 0.0;
					ZoomOut(True);
					if ( Role < ROLE_Authority )
						ServerZoomOut(False);
				}
			}
			else
				ForceZoomOutTime = 0.0;
		}
	}

	//[block] Server-side code
	if ( Role < ROLE_Authority || Instigator == None || 
		 KFFriendlyAI(Instigator.Controller) == None && Instigator.PlayerReplicationInfo == None )
		Return;

	// Turn it off on death  / battery expenditure
	if ( FlashLight != None )  {
		// Keep the 1Pweapon client beam up to date.
		AdjustLightGraphic();
		if ( FlashLight.bHasLight && (Instigator.Health <= 0 || 
				 KFHumanPawn(Instigator).TorchBatteryLife <= 0 || 
				 Instigator.PendingWeapon != None) )  {
			//Log("Killing Light...you're out of batteries, or switched / dropped weapons");
			KFHumanPawn(Instigator).bTorchOn = False;
			ServerSpawnLight();
		}
	}

	if ( !bIsReloading )  {
		//Bot
		if ( !Instigator.IsHumanControlled() )  {
			LastSeenSeconds = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
			if( MagAmmoRemaining == 0 || 
				((LastSeenSeconds >= 5 || LastSeenSeconds > MagAmmoRemaining) && 
					MagAmmoRemaining < MagCapacity) )
				ReloadMeNow();
		}
	}
	else  {
		if ( Level.TimeSeconds >= ReloadTimer )  {
			if ( !bHoldToReload && AmmoAmount(0) <= MagCapacity )  {
				MagAmmoRemaining = AmmoAmount(0);
				ActuallyFinishReloading();
			}
			else  {
				if ( bHoldToReload )  {
					if ( MagAmmoRemaining < MagCapacity && MagAmmoRemaining < AmmoAmount(0) )
						ReloadTimer = Level.TimeSeconds + ReloadRate;
					++NumLoadedThisReload;
				}
				AddReloadedAmmo();
				if ( MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) 
					 || !bHoldToReload || bDoSingleReload )
					ActuallyFinishReloading();
				else
					Instigator.SetAnimAction(WeaponReloadAnim);
			}
		}
		else if ( bIsReloading && !bReloadEffectDone && (ReloadTimer - Level.TimeSeconds) >= (ReloadRate / 2) )  {
			bReloadEffectDone = True;
			// Function call replicated from the server to the clients
			ClientReloadEffects();
		}
	}
	//[end]
}
//[end]

// Add the ammo for this reload
function AddReloadedAmmo()
{
	if ( !bHoldToReload )  {
		if ( AmmoAmount(0) >= MagCapacity )
			MagAmmoRemaining = MagCapacity;
		else
			MagAmmoRemaining = AmmoAmount(0);
		
		ClientForceMagAmmoUpdate( MagAmmoRemaining, 0, AmmoAmount(0) );
	}
	else if ( AmmoAmount(0) > 0 )
		++MagAmmoRemaining;
}

function bool AllowReload()
{
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

	//Bots Reloading
	if ( (KFInvasionBot(Instigator.Controller) != None || KFFriendlyAI(Instigator.Controller) != None) &&
		 !bIsReloading && MagAmmoRemaining < MagCapacity && AmmoAmount(0) > MagAmmoRemaining)
		Return True;
	
	if ( bIsReloading || MagAmmoRemaining >= MagCapacity || ClientState == WS_BringUp 
		 || ClientState == WS_PutDown || AmmoAmount(0) <= MagAmmoRemaining 
		 || (FireMode[0].NextFireTime - Level.TimeSeconds) > 0.1 )
		Return False;
	
	Return FireModesReadyToFire();
}

exec function ReloadMeNow()
{
	local	int						Mode;
	local	float					ReloadMulti;
	local	class<KFVeterancyTypes>	CVS;

	AutoReloadRequestsNum = 0;
	NumClicks = 0;
	if ( !AllowReload() )
		Return;

	if ( bHasAimingMode && bAimingRifle )  {
		for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
			if ( FireMode[Mode] == None )
				Continue;
			else if ( FireMode[Mode].bIsFiring )
				ServerStopFire(Mode);
		}
		ZoomOut(false);
	}
	
	CVS = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill;
	if ( CVS != None )
		ReloadMulti = CVS.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
	
	if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus && 
		 default.TacticalReloadTime > 0.0 )
		ReloadRate = default.TacticalReloadTime / ReloadMulti;
	else
		ReloadRate = default.ReloadRate / ReloadMulti;
	ReloadTimer = Level.TimeSeconds + ReloadRate;
	
	if ( default.MagCapacity > 1 )  {
		if ( bHoldToReload )
			NumLoadedThisReload = 0;
		else if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus )
			MagAmmoRemaining = TacticalReloadCapacityBonus;
		else
			MagAmmoRemaining = 0;
	}
	
	bIsReloading = True;
	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);

	// Reload message commented out for now - Ramm
	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != None &&
		 (Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime) > KFPlayerController(Instigator.Controller).ReloadMessageDelay )  {
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function ClientReload()
{
	local	int						Mode;
	local	float					AnimRateMod;
	local	class<KFVeterancyTypes>	CVS;

	if ( Level.NetMode != NM_DedicatedServer )  {
		AutoReloadRequestsNum = 0;
		NumClicks = 0;
		bIsReloading = True;
		if ( bHasAimingMode && bAimingRifle )  {
			for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
				if ( FireMode[Mode] == None )
					Continue;
				else if ( FireMode[Mode].bIsFiring )
					StopFire(Mode);
			}
			ZoomOut(False);
		}
		// Only LocallyControlled
		if ( Instigator.IsLocallyControlled() )  {
			CVS = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill;
			if ( CVS != None )
				AnimRateMod = CVS.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
			else
				AnimRateMod = 1.0;
			
			AnimStopLooping();
			if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus
				 && HasAnim( TacticalReloadAnim.Anim ) )
				PlayAnimData(TacticalReloadAnim, AnimRateMod);
			else if ( HasAnim(ReloadAnim) )
				PlayAnim(ReloadAnim, (default.ReloadAnimRate * AnimRateMod), 0.1);
		}
	}
}

simulated function ClientReloadEffects() { }

// Only Server-side function
function ServerInterruptReload()
{
	bDoSingleReload = False;
	bReloadEffectDone = False;
	bIsReloading = False;
}

// Server forces the reload to be cancelled
simulated function ClientInterruptReload()
{
	if ( Level.NetMode != NM_DedicatedServer )  {
		bIsReloading = False;
		PlayIdle();
	}
}

// Interrupt the reload
simulated function bool InterruptReload()
{
	if ( bAllowInterruptReload && bIsReloading )  {
		ServerInterruptReload();
		ClientInterruptReload();
		
		Return True;
	}
	else
		Return False;
}

// From KFWeapon.uc
simulated event Timer()
{
	local	int		Mode;
	local	float	OldDownDelay;

	OldDownDelay = DownDelay;
	DownDelay = 0;
	
	if ( ClientState == WS_BringUp )  {
		for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	       FireMode[Mode].InitEffects();

		PlayIdle();
		ClientState = WS_ReadyToFire;

		if ( bPendingFlashlight && bTorchEnabled )  {
			if ( Level.NetMode != NM_Client )
				LightFire();
			else
				ClientStartFire(1);

			bPendingFlashlight = false;
		}
	}
	else if ( ClientState == WS_PutDown )  {
		if ( OldDownDelay > 0 )  {
			if ( Instigator.IsLocallyControlled() && Mesh != None )  {
				if ( MagAmmoRemaining < 1 && HasAnim(EmptyPutDownAnim) )
					PlayAnim(EmptyPutDownAnim, PutDownAnimRate, 0.0);
				else if ( HasAnim(PutDownAnim) )
					PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
			}
			SetTimer(PutDownTime, false);
			Return;
		}

		if ( Instigator.PendingWeapon == None )  {
			if ( ClientGrenadeState == GN_TempDown )  {
				if ( UM_HumanPawn(Instigator) != None )
					UM_HumanPawn(Instigator).StartToThrowGrenade();
			}
			else
	 			PlayIdle();

			ClientState = WS_ReadyToFire;
		}
		else  {
			if ( FlashLight != None )
				Tacshine.Destroy();
			
			ClientState = WS_Hidden;
			// Client side call
			//if ( Role < ROLE_Authority )
				Instigator.ChangedWeapon();
			
			if ( Instigator.Weapon == self )  {
				PlayIdle();
				ClientState = WS_ReadyToFire;
			}
			else  {
				for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
					FireMode[Mode].DestroyEffects();
			}
		}
	}
}

// From KFWeapon.uc
simulated function BringUp(optional Weapon PrevWeapon)
{
	local 	int 				Mode;
	local	KFPlayerController	Player;
	local	float				NewSelectAnimRate;
	local	bool				bQuickBringUp;

	HandleSleeveSwapping();

	// Hint check
	Player = KFPlayerController(Instigator.Controller);

	if ( Player != none && ClientGrenadeState != GN_BringUp )
	{
		if ( class == class'Single' )
			Player.CheckForHint(10);
		else if ( class == class'Dualies' )
			Player.CheckForHint(11);
		else if ( class == class'Deagle' )
			Player.CheckForHint(12);
		else if ( class == class'Bullpup' )
			Player.CheckForHint(13);
		else if ( class == class'Shotgun' )
			Player.CheckForHint(14);
		else if ( class == class'Winchester' )
			Player.CheckForHint(15);
		else if ( class == class'Crossbow' )
			Player.CheckForHint(16);
		else if ( class == class'BoomStick' )  {
			Player.CheckForHint(17);
			Player.WeaponPulloutRemark(21);
		}
		else if ( class == class'FlameThrower' )
			Player.CheckForHint(18);
		else if ( class == class'LAW' )  {
			Player.CheckForHint(19);
			Player.WeaponPulloutRemark(23);
		}
		else if ( class == class'Knife' && bShowPullOutHint )
			Player.CheckForHint(20);
		else if ( class == class'Machete' )
			Player.CheckForHint(21);
		else if ( class == class'Axe' )  {
			Player.CheckForHint(22);
			Player.WeaponPulloutRemark(24);
		}
		else if ( class == class'DualDeagle' || class == class'GoldenDualDeagle' )
			Player.WeaponPulloutRemark(22);

		bShowPullOutHint = true;
	}

	if ( KFHumanPawn(Instigator) != None )
		KFHumanPawn(Instigator).SetAiming(false);

	bAimingRifle = False;
	bIsReloading = False;
	IdleAnim = default.IdleAnim;

	// From Weapon.uc
    if ( ClientState == WS_Hidden || ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )  {
		PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

		if ( Instigator.IsLocallyControlled() && Mesh != None )  {
			if ( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
				NewSelectAnimRate = SelectAnimRate * BringUpTime / QuickBringUpTime;
			else
				NewSelectAnimRate = SelectAnimRate;
			
			if ( MagAmmoRemaining < 1 && HasAnim(EmptySelectAnim) )
				PlayAnim(EmptySelectAnim, NewSelectAnimRate, 0.0);
			else if ( HasAnim(SelectAnim) )
				PlayAnim(SelectAnim, NewSelectAnimRate, 0.0);
		}

		ClientState = WS_BringUp;
        if ( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )  {
			bQuickBringUp = True;
			ClientGrenadeState = GN_None;
			SetTimer(QuickBringUpTime, false);
		}
		else
			SetTimer(BringUpTime, false);
	}

	for ( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )  {
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}

	if ( PrevWeapon != None && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else if ( !bQuickBringUp )
		OldWeapon = None;
}

// From KFWeapon.uc
simulated function bool PutDown()
{
	local	int		Mode;
	local	float	NewPutDownAnimRate;
	local	bool	bQuickPutDown;

	InterruptReload();

	if ( bIsReloading )
		Return False;

	if ( bAimingRifle )
		ZoomOut(False);

	// From Weapon.uc
	if ( ClientState == WS_BringUp || ClientState == WS_ReadyToFire )  {
		if ( Instigator.PendingWeapon != None && !Instigator.PendingWeapon.bForceSwitch )  {
			for ( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )  {
		    	// if _RO_
				if( FireMode[Mode] == none )
					Continue;
				// End _RO_

				if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
					Return False;
					
				if ( FireMode[Mode].NextFireTime > (Level.TimeSeconds + FireMode[Mode].FireRate * (1.0 - MinReloadPct)))
					DownDelay = FMax(DownDelay, (FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate * (1.0 - MinReloadPct)));
			}
		}

		if ( Instigator.IsLocallyControlled() )  {
			for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
				if ( FireMode[Mode] == None )
					Continue;
				else if ( FireMode[Mode].bIsFiring )
					ClientStopFire(Mode);
			}

            if ( DownDelay <= 0 || KFPawn(Instigator).bIsQuickHealing > 0 )  {
				if ( ClientState == WS_BringUp )  {
					if ( MagAmmoRemaining < 1 && HasAnim(EmptySelectAnim) )
						TweenAnim(EmptySelectAnim, PutDownTime);
					else if ( HasAnim(SelectAnim) )
						TweenAnim(SelectAnim, PutDownTime);
				}
				else  {
					if ( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0 )
						NewPutDownAnimRate = PutDownAnimRate * PutDownTime / QuickPutDownTime;
					else
						NewPutDownAnimRate = PutDownAnimRate;
					
					if ( MagAmmoRemaining < 1 && HasAnim(EmptyPutDownAnim) )
						PlayAnim(EmptyPutDownAnim, NewPutDownAnimRate, 0.0);
					else if ( HasAnim(PutDownAnim) )
						PlayAnim(PutDownAnim, NewPutDownAnimRate, 0.0);
				}
			}
        }
		
		ClientState = WS_PutDown;
		if ( Level.GRI.bFastWeaponSwitching )
			DownDelay = 0;
		
		if ( DownDelay > 0 )
			SetTimer(DownDelay, false);
		else if ( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0 )  {
			bQuickPutDown = True;
			SetTimer(QuickPutDownTime, false);
		}
		else
			SetTimer(PutDownTime, false);
	}
	
	for ( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )  {
		// if _RO_
		if( FireMode[Mode] == none )
			continue;
		// End _RO_

		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
	}
	
	Instigator.AmbientSound = None;
	if ( !bQuickPutDown )
		OldWeapon = None;
	
	Return True; // return false if preventing weapon switch
}

simulated function AnimEnd(int channel)
{
	local	name	anim;
	local	float	frame, rate;
	local	UM_BaseProjectileWeaponFire		FFM, SFM;

	GetAnimParams(0, anim, frame, rate);
	FFM = UM_BaseProjectileWeaponFire(FireMode[0]);
	SFM = UM_BaseProjectileWeaponFire(FireMode[1]);
	
	if ( ClientState == WS_ReadyToFire )  {
		//FireMode[0]
		if ( FFM != None && anim == FFM.FireAnims[FFM.MuzzleNum].Anim 
			 && HasAnim( FFM.FireEndAnims[FFM.MuzzleNum].Anim ) )
			PlayAnim( FFM.FireEndAnims[FFM.MuzzleNum].Anim, FFM.FireEndAnims[FFM.MuzzleNum].Rate, 0.0 );
		//FireMode[1]
		else if ( SFM != None && anim == SFM.FireAnims[SFM.MuzzleNum].Anim 
			 && HasAnim( SFM.FireEndAnims[SFM.MuzzleNum].Anim ) )
			PlayAnim( SFM.FireEndAnims[SFM.MuzzleNum].Anim, SFM.FireEndAnims[SFM.MuzzleNum].Rate, 0.0 );
		else if ( (FFM == None || !FFM.bIsFiring) 
				&& (SFM == None || !SFM.bIsFiring) )
			PlayIdle();
	}
}


// Overriden because I'm using my own functions to update Spread and AimError in FireClass
// More info in UM_BaseProjectileWeaponFire.uc
function AccuracyUpdate(float Velocity) { }

// Overwrited to add bonus bullet in MagCapacity if MagAmmoRemaining >= TacticalReloadCapacityBonus
function UpdateMagCapacity(PlayerReplicationInfo PRI)
{
	local	int		NewMagCapacity;
	
	if ( default.MagCapacity > 1 )  {
		if ( KFPlayerReplicationInfo(PRI) != None && KFPlayerReplicationInfo(PRI).ClientVeteranSkill != None )
			NewMagCapacity = Round( default.MagCapacity * KFPlayerReplicationInfo(PRI).ClientVeteranSkill.Static.GetMagCapacityMod(KFPlayerReplicationInfo(PRI), self) );
		else
			NewMagCapacity = default.MagCapacity;
		
		if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus )
			NewMagCapacity += TacticalReloadCapacityBonus;
		
		// Need to use calculation like this because MagCapacity has always replicated to the clients
		MagCapacity = NewMagCapacity;
	}
}

// Called on the server from ServerChangedWeapon function in Pawn class
function AttachToPawn( Pawn P )
{
	local	name	LeftHandBone;
	
	Instigator = P;
	if ( AttachmentClass != None )  {
		if ( ThirdPersonActor == None )  {
			ThirdPersonActor = Spawn(AttachmentClass, Owner);
			if ( ThirdPersonActor != None )
				InventoryAttachment(ThirdPersonActor).InitFor(Self);
		}
		else
			ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1.0;
		
		LeftHandBone = P.GetWeaponBoneFor(Self);
		if ( LeftHandBone == '' )  {
			ThirdPersonActor.SetLocation(P.Location);
			ThirdPersonActor.SetBase(P);
		}
		else
			P.AttachToBone(ThirdPersonActor, LeftHandBone);
	}
	
	SpawnTacticalModule();
}

//ToDo: äîïèñàòü!
function SpawnTacticalModuleHidden()
{

}

// Attach to the pawn, but keep the attachement hidden
function AttachToPawnHidden( Pawn P )
{
	local	name	LeftHandBone;
	
	Instigator = P;
	if ( AttachmentClass != None )  {
		if ( ThirdPersonActor == None )  {
			ThirdPersonActor = Spawn(AttachmentClass, Owner);
			if ( ThirdPersonActor != None )  {
				ThirdPersonActor.bHidden = True;
				InventoryAttachment(ThirdPersonActor).InitFor(Self);
			}
		}
		else  {
			ThirdPersonActor.bHidden = True;
			ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1.0;
		}
		
		LeftHandBone = P.GetWeaponBoneFor(Self);
		if ( LeftHandBone == '' )  {
			ThirdPersonActor.SetLocation(P.Location);
			ThirdPersonActor.SetBase(P);
		}
		else
			P.AttachToBone(ThirdPersonActor, LeftHandBone);
	}
	
	SpawnTacticalModuleHidden();
}


// Clear links on this weapon
simulated function ClearReferencesToThisWeapon()
{
	local	int			m, Count;
	local	Inventory	I;
	local	bool		bSaveThisAmmo;
	
	Instigator.DeleteInventory(Self);
	// Delete Ammo
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		// Resets bool
		bSaveThisAmmo = False;
		if ( Ammo[m] != None )  {
			// Check Ammo to save it for other weapon
			for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
				if ( I == Ammo[m] )  {
					bSaveThisAmmo = True;
					Break;
				}
				// To prevent the infinity loop because of the error in the LinkedList
				++Count;
			}
			
			if ( !bSaveThisAmmo )  {
				Instigator.DeleteInventory( Ammo[m] );
				Ammo[m].Destroy();
				Ammo[m] = None;
			}
		}
	}
}

simulated event Destroyed()
{
	local	int		m;
	
	AmbientSound = None;
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] != None )
			FireMode[m].DestroyEffects();
	}
	
	if ( FlashLight != None )
		FlashLight.Destroy();
	
	if ( TacShine != None )
		TacShine.Destroy();
	
	DestroyTacticalModule();
	ClearReferencesToThisWeapon();
	
	if ( ThirdPersonActor != None )  {
		ThirdPersonActor.Destroy();
		ThirdPersonActor = None;
	}
}

// Called on the server from ServerChangedWeapon function in Pawn class
function DetachFromPawn(Pawn P)
{
	DestroyTacticalModule();
	if ( ThirdPersonActor != None )  {
		ThirdPersonActor.Destroy();
		ThirdPersonActor = None;
	}
	P.AmbientSound = None;
}

// This function call replicated from the server to the client-owner
simulated function ClientWeaponSet( bool bPossiblySwitch )
{
	local	int		m;
	
	Instigator = Pawn(Owner);
	bPendingSwitch = bPossiblySwitch;
	if ( Instigator == None )  {
		// Wait for replication
		GotoState('PendingClientWeaponSet');
		Return;
	}
	
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireModeClass[m] != None && (FireMode[m] == None || (FireMode[m].AmmoClass != None && !bNoAmmoInstances && Ammo[m] == None && FireMode[m].AmmoPerFire > 0)) )  {
			GotoState('PendingClientWeaponSet');
			Return;
		}
		// Sets the FireMode Instigator
		if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
			UM_BaseProjectileWeaponFire(FireMode[m]).SetInstigator(Instigator);
		else
			FireMode[m].Instigator = Instigator;
		FireMode[m].Level = Level;
	}
	
	ClientState = WS_Hidden;
    GotoState('Hidden');
	
	// Client-side code next
	if ( Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled() )
		Return;
	
	// this weapon was switched to while waiting for replication, switch to it now
	if ( Instigator.Weapon == self || Instigator.PendingWeapon == self )  {
		if ( Instigator.PendingWeapon != None )
			Instigator.ChangedWeapon();
		else
			BringUp();
		
		Return;
	}
	
	if ( Instigator.PendingWeapon != None && Instigator.PendingWeapon.bForceSwitch )
		Return;
	
	// Switch Weapon On Pickup
	if ( Instigator.Weapon == None )  {
		Instigator.PendingWeapon = self;
		Instigator.ChangedWeapon();
	}
	else if ( bPossiblySwitch && !Instigator.Weapon.IsFiring() )  {
		if ( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bNeverSwitchOnPickup )
			Return;
		
		if ( Instigator.PendingWeapon != None )  {
			if ( RateSelf() > Instigator.PendingWeapon.RateSelf() )  {
				Instigator.PendingWeapon = self;
				Instigator.Weapon.PutDown();
			}
		}
		else if ( RateSelf() > Instigator.Weapon.RateSelf() )  {
			Instigator.PendingWeapon = self;
			Instigator.Weapon.PutDown();
		}
	}
}

state PendingClientWeaponSet
{
	simulated event BeginState()
	{
		SetTimer(0.05, false);
	}

	simulated event Timer()
	{
		if ( Pawn(Owner) != None )
			ClientWeaponSet(bPendingSwitch);
		// Not all data was replicated. Waiting.
		if ( IsInState('PendingClientWeaponSet') )
			SetTimer(0.05, false);
	}

	simulated event EndState()
	{
	}
}

function GiveTo( Pawn Other, optional Pickup Pickup )
{
	local	Inventory			I;
	local	class<KFWeapon>		SW;	// single weapon
	local	int					SWAmmo, SWMagAmmoRemaining, m;
    local	Weapon				W;
    local	bool				bPossiblySwitch, bJustSpawned;
	
	UpdateMagCapacity(Other.PlayerReplicationInfo);

	SW = Class<UM_BaseWeaponPickup>(PickupClass).default.SingleWeaponClass;
	if ( SW != None )  {
		for ( I = Other.Inventory; I != None; I = I.Inventory )  {
			// if Pawn already have one single weapon
			if ( I.Class == SW )  {
				if ( Pickup != None && WeaponPickup(Pickup) != None )
					WeaponPickup(Pickup).AmmoAmount[0] += Weapon(I).AmmoAmount(0);
				else
					SWAmmo = Weapon(I).AmmoAmount(0);
				
				//Saving single weapon MagAmmoRemaining
				SWMagAmmoRemaining = KFWeapon(I).MagAmmoRemaining;
				I.Destroyed();
				I.Destroy();
				Break;
			}
		}
		// If we have a Pickup actor
		if ( Pickup != None && KFWeaponPickup(Pickup) != None && Pickup.bDropped )
			MagAmmoRemaining = Clamp((SWMagAmmoRemaining + KFWeaponPickup(Pickup).MagAmmoRemaining), 0, MagCapacity);
		else
			MagAmmoRemaining = Clamp((SWMagAmmoRemaining + SW.default.MagCapacity), 0, MagCapacity);
	}
	else  {
		// If we have a Pickup actor
		if ( Pickup != None && KFWeaponPickup(Pickup) != None && Pickup.bDropped )
			MagAmmoRemaining = Clamp(KFWeaponPickup(Pickup).MagAmmoRemaining, 0, MagCapacity);
		else
			MagAmmoRemaining = MagCapacity;
	}
	
	// From the Weapon class
	/*	Note:	Instigator variable does not replicated in Weapon (Inventory) classes. 
				On the client it sets in ClientWeaponSet() function from the Owner variable, 
				which sets in the Pawn AddInventory() function (calling from here) 
				and then replicated to the client. */
	if ( Owner != Other )
		SetOwner(Other);
	Instigator = Other;
	W = Weapon( Instigator.FindInventoryType(Class) );
	// added class check because somebody made FindInventoryType() return subclasses for some reason
	// Don't have a single weapon
	if ( W == None || W.Class != Class )  {
		//bJustSpawned = Instigator.AddInventory( Self );
		bJustSpawned = True;
		Super(Inventory).GiveTo(Other);
		bPossiblySwitch = True;
		W = Self;
	}
	else if ( !W.HasAmmo() )
		bPossiblySwitch = True;
	
	if ( Pickup == None )
		bPossiblySwitch = True;
	
	// Giving ammo
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] != None )  {
			// Sets the FireMode Instigator
			if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
				UM_BaseProjectileWeaponFire(FireMode[m]).SetInstigator(Instigator);
			else
				FireMode[m].Instigator = Instigator;
			W.GiveAmmo(m, WeaponPickup(Pickup), bJustSpawned);
		}
	}
	
	if ( Instigator.Weapon != W )
		W.ClientWeaponSet( bPossiblySwitch );
	
	if ( !bJustSpawned )  {
		for ( m = 0; m < NUM_FIRE_MODES; ++m )
			Ammo[m] = None;
		
		Destroy();
		Return;
	}
	
	if ( SWAmmo > 0 )
		AddAmmo(Clamp(SWAmmo, 0, MaxAmmo(0)), 0);
}

function SilentGiveTo(Pawn Other, optional Pickup Pickup)
{
	local	int					m;
    local	Weapon				W;
    local	bool				bPossiblySwitch, bJustSpawned;
	
	if ( Owner != Other )
		SetOwner(Other);
	Instigator = Other;
	W = Weapon( Instigator.FindInventoryType(Class) );
	// added class check because somebody made FindInventoryType() return subclasses for some reason
	if ( W == None || W.Class != Class )  {
		bJustSpawned = Instigator.AddInventory( Self );
		//Super(Inventory).GiveTo(Other);
		bPossiblySwitch = True;
		W = Self;
	}
	else if ( !W.HasAmmo() )
		bPossiblySwitch = True;
	
	if ( Pickup == None )
		bPossiblySwitch = True;
	
	// Giving ammo
	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] != None )  {
			// Sets the FireMode Instigator
			if ( UM_BaseProjectileWeaponFire(FireMode[m]) != None )
				UM_BaseProjectileWeaponFire(FireMode[m]).SetInstigator(Instigator);
			else
				FireMode[m].Instigator = Instigator;
			W.GiveAmmo(m, WeaponPickup(Pickup), bJustSpawned);
		}
	}
	
	if ( !bJustSpawned )  {
		for ( m = 0; m < NUM_FIRE_MODES; ++m )
			Ammo[m] = None;
		
		Destroy();
	}
}

simulated function ClientWeaponThrown()
{
	AmbientSound = None;
	Instigator.AmbientSound = None;
	
	// Client-side only
	if ( Level.NetMode == NM_Client )
		ClearReferencesToThisWeapon();
}

function DropFrom( vector StartLocation )
{
	local	int					m, AmmoThrown, OtherAmmo;
	local	Pickup				Pickup;
	local	vector				Direction;
	local	class<KFWeapon>		SW;
	local	KFWeapon			KFW;

	if ( !bCanThrow )
		Return;

	ClientWeaponThrown();

	for ( m = 0; m < NUM_FIRE_MODES; ++m )  {
		if ( FireMode[m] == None )
			Continue;
		else if (FireMode[m].bIsFiring)
			StopFire(m);
	}

	if ( Instigator != None )  {
		DetachFromPawn(Instigator);
		Direction = vector(Instigator.Rotation);
		Velocity = Instigator.Velocity;
		if ( Instigator.Health > 0 )  {
			SW = Class<UM_BaseWeaponPickup>(PickupClass).default.SingleWeaponClass;
			if ( SW != None )  {
				KFW = Spawn(SW, Owner);
				if ( KFW != None )  {
					KFW.GiveTo(Instigator);
					OtherAmmo = AmmoThrown / 2;
					AmmoThrown -= OtherAmmo;
					KFW.Ammo[0].AmmoAmount = OtherAmmo;
					KFW.MagAmmoRemaining = MagAmmoRemaining / 2;
					MagAmmoRemaining = Max((MagAmmoRemaining - KFW.MagAmmoRemaining), 0);
				}
			}
		}
	}
	else if ( Owner != None )  {
		Direction = vector(Owner.Rotation);
		Velocity = Owner.Velocity;
	}

	if ( PickupClass != None )
		Pickup = Spawn( PickupClass, Owner,, StartLocation );
	
	if ( Pickup != None )  {
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity + (Direction * 200.0);
		if ( SW != None && KFW != None && KFWeaponPickup(Pickup) != None )  {
			KFWeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
			KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
		}
		if ( Instigator != None && Instigator.Health > 0 )
			WeaponPickup(Pickup).bThrown = True;
	}

	Destroyed();
	Destroy();
}

//[end] Functions
//====================================================================


defaultproperties
{
     OwnerMovementModifier=1.0
	 bAllowInterruptReload=True
	 bAllowAutoReload=True
	 bHasTacticalReload=False
	 TacticalReloadCapacityBonus=1
	 TacticalReloadAnim=(Rate=1.000000,TweenTime=0.100000)
	 ModeSwitchSound=(Ref="Inf_Weapons_Foley.stg44.stg44_firemodeswitch01",Vol=2.2,Radius=300.0,bUse3D=True)
	 IdleAimAnim="Idle_Iron"
	 TransientSoundVolume=1.000000
     TransientSoundRadius=300.000000
	 bBlockZeroExtentTraces=False
	 bBlockNonZeroExtentTraces=False
}
