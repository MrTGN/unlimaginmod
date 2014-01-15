//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseWeapon
//	Parent class:	 KFWeapon
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 21.03.2013 01:23
//������������������������������������������������������������������������������
//	Comments:		 Base weapon class in UnlimaginMod
//================================================================================
class UM_BaseWeapon extends KFWeapon
	Abstract;


//========================================================================
//[block] Variables

var		sound				ModeSwitchSound;
var		string				ModeSwitchSoundRef;
var		float				ModeSwitchSoundVolume;

var		bool				bHasTacticalReload, bAllowInterruptReload;	// bHasTacticalReload allows to turn on/off TacticalReload
var		int					TacticalReloadCapacityBonus;	// 0 - no capacity bonus on TacticalReload; 1 - MagCapacity + 1 ...

var		name				TacticalReloadAnim;		// Short tactical reload animation
var		float				TacticalReloadAnimRate;	// If TacticalReloadAnim has another AnimRate use TacticalReloadAnimRate variable to set it.
var		float				TacticalReloadRate;		// Actually it's a time needed to play TacticalReloadAnim

var()	name				EmptyIdleAimAnim, EmptyIdleAnim;	// Empty weapon animation
var()	name				EmptySelectAnim, EmptyPutDownAnim;	// Empty weapon animation

var		bool				bAssetsLoaded;
var		bool				bAllowAutoReload;
var		byte				AutoReloadRequestsNum;

struct	AnimData
{
	var	name	Anim;
	var	float	Rate;
	var	float	TweenTime;
};


//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[block] Dynamic Loading
simulated static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	local	int		i;

	if ( !bSkipRefCount )
		default.ReferenceCount++;

	if ( default.MeshRef != "" )
		UpdateDefaultMesh(SkeletalMesh(DynamicLoadObject(default.MeshRef, class'SkeletalMesh')));
	if ( default.HudImageRef != "" )
		default.HudImage = texture(DynamicLoadObject(default.HudImageRef, class'texture'));
	if ( default.SelectedHudImageRef != "" )
		default.SelectedHudImage = texture(DynamicLoadObject(default.SelectedHudImageRef, class'texture'));
	if ( default.SelectSoundRef != "" )
		default.SelectSound = sound(DynamicLoadObject(default.SelectSoundRef, class'sound'));
	if ( default.ModeSwitchSoundRef != "" )
		default.ModeSwitchSound = sound(DynamicLoadObject(default.ModeSwitchSoundRef, class'sound'));
	
	if ( default.SkinRefs.Length > 0 )  {
		if ( default.Skins.Length < default.SkinRefs.Length )
			default.Skins.Length = default.SkinRefs.Length;
		
		for ( i = 0; i < default.SkinRefs.Length; i++ )  {
			if ( default.SkinRefs[i] != "" )
				default.Skins[i] = Material(DynamicLoadObject(default.SkinRefs[i], class'Material'));
		}
	}

	if ( UM_BaseWeapon(Inv) != None )  {
		if ( default.Mesh != None )
			UM_BaseWeapon(Inv).LinkMesh(default.Mesh);
		if ( default.HudImage != None )
			UM_BaseWeapon(Inv).HudImage = default.HudImage;
		if ( default.SelectedHudImage != None )
			UM_BaseWeapon(Inv).SelectedHudImage = default.SelectedHudImage;
		if ( default.SelectSound != None )
			UM_BaseWeapon(Inv).SelectSound = default.SelectSound;
		if ( default.ModeSwitchSound != None )
			UM_BaseWeapon(Inv).ModeSwitchSound = default.ModeSwitchSound;
		
		if ( default.Skins.Length > 0 )  {
			if ( UM_BaseWeapon(Inv).Skins.Length < default.Skins.Length )
				UM_BaseWeapon(Inv).Skins.Length = default.Skins.Length;
			
			for ( i = 0; i < default.Skins.Length; i++ )  {
				if ( default.Skins[i] != None )
					UM_BaseWeapon(Inv).Skins[i] = default.Skins[i];
			}
		}
	}
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	default.ReferenceCount--;
	log("UnloadAssets RefCount after: " @ default.ReferenceCount);

	if ( default.Mesh != None )
		UpdateDefaultMesh(None);
	if ( default.HudImage != None )
		default.HudImage = None;
	if ( default.SelectedHudImage != None )
		default.SelectedHudImage = None;
	if ( default.SelectSound != None )
		default.SelectSound = None;
	if ( default.ModeSwitchSound != None )
		default.ModeSwitchSound = None;
	if ( default.Skins.Length > 0 )
		default.Skins.Length = 0;
	
	default.bAssetsLoaded = False;

	Return default.ReferenceCount == 0;
}
//[end]

simulated event PostBeginPlay()
{
	if ( !default.bAssetsLoaded )
		PreloadAssets(self, true);

	// Weapon will handle FireMode instantiation
	Super(BaseKFWeapon).PostBeginPlay();

	// client code next
	if ( Level.NetMode == NM_DedicatedServer )
		Return;

	if ( !bHasScope )
		KFScopeDetail = KF_None;

	InitFOV();
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

// Added Mode var for the future multi-reload weapons
//simulated function ClientRequestAutoReload(byte Mode)
simulated function ClientRequestAutoReload()
{
	if ( AutoReloadRequestsNum > 0 )  {
		AutoReloadRequestsNum = 0;
		//Calling server function
		ReloadMeNow();
		Return;
	}
	++AutoReloadRequestsNum;
}

simulated function DryFire(byte Mode)
{
	//Dry fire sound
	if ( bModeZeroCanDryFire )
		PlayOwnedSound(FireMode[Mode].NoAmmoSound, SLOT_None, FireMode[Mode].TransientSoundVolume,,,, false);
	
	//Bots and other AI
	if ( AIController(Instigator.Controller) != None )
		ReloadMeNow();
	else if ( bAllowAutoReload )
		ClientRequestAutoReload();
		//ClientRequestAutoReload(Mode);
}

simulated function Fire(float F){}

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
function bool HandlePickupQuery( pickup Item )
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
        UMWA.NetUpdateTime = Level.TimeSeconds - 1;
        ++UMWA.FlashCount;
        UMWA.ThirdPersonEffects();
    }
}

simulated function ZeroFlashCount(int Mode)
{
    local	UM_BaseWeaponAttachment		UMWA;
	
	UMWA = UM_BaseWeaponAttachment(ThirdPersonActor);
	if ( UMWA != None )  {
        UMWA.FiringMode = Mode;
        UMWA.NetUpdateTime = Level.TimeSeconds - 1;
        UMWA.FlashCount = 0;
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

simulated function bool ConsumeAmmo( int Mode, float Load, optional bool bAmountNeededIsMax )
{
	local	Inventory	Inv;
	local	bool		bOutOfAmmo;
	local	KFWeapon	KFWeap;

	if ( Super(Weapon).ConsumeAmmo(Mode, Load, bAmountNeededIsMax) )  {
		if ( Load > 0.0 && (Mode == 0 || bReduceMagAmmoOnSecondaryFire) )  {
			MagAmmoRemaining -= int(Load); // Big thanks to Poosh for this fix
			if ( MagAmmoRemaining < 0 )
				MagAmmoRemaining = 0;
		}

		NetUpdateTime = Level.TimeSeconds - 1;

		if ( FireMode[Mode].AmmoPerFire > 0 && InventoryGroup > 0 && 
			 !bMeleeWeapon && bConsumesPhysicalAmmo &&
			 (Ammo[0] == None || FireMode[0] == None || FireMode[0].AmmoPerFire <= 0 || 
				 Ammo[0].AmmoAmount < FireMode[0].AmmoPerFire) &&
			 (Ammo[1] == None || FireMode[1] == None || FireMode[1].AmmoPerFire <= 0 || 
				 Ammo[1].AmmoAmount < FireMode[1].AmmoPerFire) )  
		{
			bOutOfAmmo = True;

			for ( Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory )  {
				KFWeap = KFWeapon(Inv);

				if ( Inv.InventoryGroup > 0 && KFWeap != None && 
					 !KFWeap.bMeleeWeapon && KFWeap.bConsumesPhysicalAmmo &&
					 ( (KFWeap.Ammo[0] != None && KFWeap.FireMode[0] != None && 
						 KFWeap.FireMode[0].AmmoPerFire > 0 && 
						 KFWeap.Ammo[0].AmmoAmount >= KFWeap.FireMode[0].AmmoPerFire) ||
					 (KFWeap.Ammo[1] != None && KFWeap.FireMode[1] != None && 
						 KFWeap.FireMode[1].AmmoPerFire > 0 && 
						 KFWeap.Ammo[1].AmmoAmount >= KFWeap.FireMode[1].AmmoPerFire)) )
				{
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

//[block] Copied from Engine/Weapon.uc with some optimizations
simulated function bool ReadyToFire(int Mode)
{
	local int	alt;

	if ( Mode == 0 )
		alt = 1;
	else
		alt = 0;

	if ( (FireMode[alt] != None && FireMode[alt] != FireMode[Mode] 
			&& FireMode[alt].bModeExclusive && FireMode[alt].bIsFiring) 
		 || !FireMode[Mode].AllowFire()
		 || FireMode[Mode].NextFireTime > (Level.TimeSeconds + FireMode[Mode].PreFireTime) )
		Return False;

	Return True;
}

// Copied from Weapon.uc with some changes
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
//[end]

simulated function ActuallyFinishReloading()
{
   bDoSingleReload = False;
   bReloadEffectDone = False;
   bIsReloading = False;
   ClientFinishReloading();
}

simulated function ClientFinishReloading()
{
	if ( Level.NetMode != NM_DedicatedServer )  {
		bIsReloading = False;
		PlayIdle();
		if ( Instigator.PendingWeapon != None && Instigator.PendingWeapon != self )
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

	// Only server-side code next
	if ( Level.NetMode == NM_Client || Instigator == None || 
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
				
				if ( Role == ROLE_Authority )
					AddReloadedAmmo();

				if ( MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) || 
					 !bHoldToReload || bDoSingleReload )
					ActuallyFinishReloading();
				else if ( Level.NetMode != NM_Client )
					Instigator.SetAnimAction(WeaponReloadAnim);
			}
		}
		else if ( bIsReloading && !bReloadEffectDone && 
				 (ReloadTimer - Level.TimeSeconds) >= (ReloadRate / 2) )  {
			bReloadEffectDone = True;
			ClientReloadEffects();
		}
	}
}
//[end]

// Add the ammo for this reload
function AddReloadedAmmo()
{
	if ( bHoldToReload )  {
		if ( AmmoAmount(0) > 0 )
			++MagAmmoRemaining;
	}
	else  {
		if ( AmmoAmount(0) >= MagCapacity )
			MagAmmoRemaining = MagCapacity;
		else
			MagAmmoRemaining = AmmoAmount(0);
		
		ClientForceKFAmmoUpdate(MagAmmoRemaining, AmmoAmount(0));
	}
}

simulated function ClientForceAmmoUpdate(int Mode, int NewAmount)
{
	//log(self$" ClientForceAmmoUpdate mode "$Mode$" newamount "$NewAmount);
	if ( bNoAmmoInstances )
		AmmoCharge[Mode] = NewAmount;
	else if ( Ammo[Mode] != None )
		Ammo[Mode].AmmoAmount = NewAmount;
}

simulated function ClientForceKFAmmoUpdate(int NewMagAmmoRemaining, int TotalAmmoRemaining)
{
	//log(self$" ClientForceKFAmmoUpdate NewMagAmmoRemaining "$NewMagAmmoRemaining$" TotalAmmoRemaining "$TotalAmmoRemaining);
	ClientForceAmmoUpdate(0, TotalAmmoRemaining);
}

//[block] Copied from KFWeapon with some changes
function bool AllowReload()
{
	local	int		Mode;
	
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

	//Firing
	for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
		if ( FireMode[Mode] == None )
			Continue;
		else if ( FireMode[Mode].bModeExclusive && FireMode[Mode].bIsFiring )
			Return False;
	}
	
	//Bots Reloading
	if ( (KFInvasionBot(Instigator.Controller) != None || KFFriendlyAI(Instigator.Controller) != None) &&
		 !bIsReloading && MagAmmoRemaining < MagCapacity && AmmoAmount(0) > MagAmmoRemaining)
		Return True;
	
	if ( bIsReloading || MagAmmoRemaining >= MagCapacity ||
		 ClientState == WS_BringUp || ClientState == WS_PutDown ||
		 AmmoAmount(0) <= MagAmmoRemaining ||
		 (FireMode[0].NextFireTime - Level.TimeSeconds) > 0.1 )
		Return False;
	
	Return True;
}
//[end]

exec function ReloadMeNow()
{
	local	int		Mode;
	local	float	ReloadMulti;

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
	
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && 
		 KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
	
	if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus && 
		 default.TacticalReloadRate > 0.0 )
		ReloadRate = default.TacticalReloadRate / ReloadMulti;
	else
		ReloadRate = default.ReloadRate / ReloadMulti;
	ReloadTimer = Level.TimeSeconds + ReloadRate;
	
	if ( bHoldToReload )
		NumLoadedThisReload = 0;
	else if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus )
		MagAmmoRemaining = TacticalReloadCapacityBonus;
	else
		MagAmmoRemaining = 0;
	
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
	local	int		Mode;
	local	float	ReloadMulti;

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
			if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && 
				 KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
				ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
			else
				ReloadMulti = 1.0;
			
			if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus && 
				 default.TacticalReloadAnimRate > 0.0 )
				ReloadAnimRate = default.TacticalReloadAnimRate * ReloadMulti;
			else
				ReloadAnimRate = default.ReloadAnimRate * ReloadMulti;
			
			AnimStopLooping();
			if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus && 
				 HasAnim(TacticalReloadAnim) )
				PlayAnim(TacticalReloadAnim, ReloadAnimRate, 0.1);
			else if ( HasAnim(ReloadAnim) )
				PlayAnim(ReloadAnim, ReloadAnimRate, 0.1);
		}
	}
}

simulated function ClientReloadEffects(){}

// Interrupt the reload for single bullet insert weapons
simulated function bool InterruptReload()
{
	if ( bAllowInterruptReload && bIsReloading )  {
		ServerInterruptReload();
		
		//ToDo: ��� ���??? ����� ����������� ��� ��� �� �������.
		//if ( Level.NetMode != NM_StandAlone && 
			// (Level.NetMode != NM_ListenServer || !Instigator.IsLocallyControlled()) )
		if ( Level.NetMode != NM_DedicatedServer )
			ClientInterruptReload();

		Return True;
	}
	else
		Return False;
}

simulated function ServerInterruptReload()
{
	bDoSingleReload = False;
	bReloadEffectDone = False;
	bIsReloading = False;
}

// Server forces the reload to be cancelled
simulated function ClientInterruptReload()
{
	bIsReloading = False;
	PlayIdle();
}

// From KFWeapon.uc
simulated function Timer()
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
				if ( KFPawn(Instigator) != None )
					KFPawn(Instigator).WeaponDown();
			}
			else
	 			PlayIdle();

			ClientState = WS_ReadyToFire;
		}
		else  {
			if ( FlashLight != None )
				Tacshine.Destroy();
			
			ClientState = WS_Hidden;
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
    if ( ClientState == WS_Hidden || ClientGrenadeState == GN_BringUp || 
		 KFPawn(Instigator).bIsQuickHealing > 0 )  {
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
	else
		OldWeapon = None;
}

// From KFWeapon.uc
simulated function bool PutDown()
{
	local	int		Mode;
	local	float	NewPutDownAnimRate;

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
					
				if ( FireMode[Mode].NextFireTime > (Level.TimeSeconds + FireMode[Mode].FireRate * (1.f - MinReloadPct)))
					DownDelay = FMax(DownDelay, (FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate * (1.f - MinReloadPct)));
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
		else  {
			if ( ClientGrenadeState == GN_TempDown )
			   SetTimer(QuickPutDownTime, false);
			else
			   SetTimer(PutDownTime, false);
		}
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
	OldWeapon = None;
	
	Return True; // return false if preventing weapon switch
}

//[block] Client function from Weapon.uc
simulated event ClientStartFire(int Mode)
{
	if ( Pawn(Owner).Controller.IsInState('GameEnded') 
		 || Pawn(Owner).Controller.IsInState('RoundEnded') )
		Return;
	
	if ( Role < ROLE_Authority )  {
		if ( StartFire(Mode) )
			ServerStartFire(Mode);
	}
	else
		StartFire(Mode);
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

//[block] Server functions from Weapon.uc
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
		ClientForceAmmoUpdate(Mode, AmmoAmount(Mode));
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
//[end]

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
function AccuracyUpdate(float Velocity){}

// Overwrited to add bonus bullet in MagCapacity if MagAmmoRemaining >= TacticalReloadCapacityBonus
function UpdateMagCapacity(PlayerReplicationInfo PRI)
{
	local	float		NewMagCapacity;
	
	if ( default.MagCapacity > 1 )  {
		if ( KFPlayerReplicationInfo(PRI) != None && KFPlayerReplicationInfo(PRI).ClientVeteranSkill != None )
			NewMagCapacity = float(default.MagCapacity) * KFPlayerReplicationInfo(PRI).ClientVeteranSkill.Static.GetMagCapacityMod(KFPlayerReplicationInfo(PRI), self);
		else
			NewMagCapacity = float(default.MagCapacity);
		
		if ( bHasTacticalReload && MagAmmoRemaining >= TacticalReloadCapacityBonus )
			NewMagCapacity += float(TacticalReloadCapacityBonus);
		
		// Need to use calculation like this because MagCapacity has always replicated to the clients
		MagCapacity = int(NewMagCapacity);
	}
}

function AttachToPawn(Pawn P)
{
	local	name	LeftHandBone;
	
	Instigator = P;
	if ( AttachmentClass != None )  {
		if ( ThirdPersonActor == None )  {
			ThirdPersonActor = Spawn(AttachmentClass, Owner);
			
			if ( ThirdPersonActor != None )
				InventoryAttachment(ThirdPersonActor).InitFor(self);
		}
		else
			ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
		
		LeftHandBone = P.GetWeaponBoneFor(self);
		if ( LeftHandBone == '' )  {
			ThirdPersonActor.SetLocation(P.Location);
			ThirdPersonActor.SetBase(P);
		}
		else
			P.AttachToBone(ThirdPersonActor, LeftHandBone);
	}
}

function DetachFromPawn(Pawn P)
{
	if ( ThirdPersonActor != None )  {
		ThirdPersonActor.Destroy();
		ThirdPersonActor = None;
	}
	P.AmbientSound = None;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local	Inventory			I;
	local	class<KFWeapon>		SW;
	local	int					SWAmmo, SWMagAmmoRemaining;
	
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
	
	Super(Weapon).GiveTo(Other, Pickup);
	
	if ( SWAmmo > 0 )
		AddAmmo(Clamp(SWAmmo, 0, MaxAmmo(0)), 0);
}

function DropFrom(vector StartLocation)
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
		if ( Instigator.Health > 0 )  {
			SW = Class<UM_BaseWeaponPickup>(PickupClass).default.SingleWeaponClass;
			if ( SW != None )  {
				KFW = KFWeapon( Spawn(SW, Owner) );
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
	else if ( Owner != None )
		Direction = vector(Owner.Rotation);

	if ( PickupClass != None )
		Pickup = Spawn(PickupClass,,, StartLocation);
	
	if ( Pickup != None )  {
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity + (Direction * 100);
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
     bAllowInterruptReload=True
	 bAllowAutoReload=True
	 bHasTacticalReload=False
	 TacticalReloadCapacityBonus=1
	 ModeSwitchSoundRef="Inf_Weapons_Foley.stg44.stg44_firemodeswitch01"
     ModeSwitchSoundVolume=2.200000
	 IdleAimAnim="Idle_Iron"
}