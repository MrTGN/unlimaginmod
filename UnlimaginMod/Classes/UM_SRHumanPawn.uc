//=============================================================================
// UM_SRHumanPawn
//=============================================================================
class UM_SRHumanPawn extends KFHumanPawn;

var		float						FireSpeedModif;
var		UM_SRClientPerkRepLink		PerkLink;
var		name						LeftHandWeaponBone, RightHandWeaponBone;
var		Vector						BounceMomentum;
var		float						LowGravBounceMomentumScale, NextBounceTime, BounceDelay, BounceCheckDistance;
var		int							BounceRemaining;
var		Pawn						BounceVictim;


replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		FireSpeedModif;
}

// Extended RandRange() function analog
simulated final function float GetRandMult(
			float	MinMult, 
			float	MaxMult,
 optional	float	ExtraMultChance,
 optional	float	MaxExtraMult,
 optional	float	MinExtraMult)
{
	local	float	RandMultiplier;
	
	// Logic copied from RandRange()
	RandMultiplier = MinMult + (MaxMult - MinMult) * FRand();
	// Random multiplier scaling in range from the RandMultiplier up to the MaxScale
	if ( ExtraMultChance > 0.0 && FRand() <= ExtraMultChance )  {
		if ( MinExtraMult != 0.0 )
			RandMultiplier = MinExtraMult + (MaxExtraMult - MinExtraMult) * FRand();
		// if only MaxExtraMult variable was specified
		else
			RandMultiplier = RandMultiplier + (MaxExtraMult - RandMultiplier) * FRand();
	}
	
	Return RandMultiplier;
}

simulated final function GetViewAxes( out vector xaxis, out vector yaxis, out vector zaxis )
{
	GetAxes( GetViewRotation(), xaxis, yaxis, zaxis );
}

function VeterancyChanged()
{
	local	KFPlayerReplicationInfo		KFPRI;
	local	Class<UM_SRVeterancyTypes>	SRVT;
	
	BounceRemaining = default.BounceRemaining;
	BounceMomentum = default.BounceMomentum;
	KFPRI = KFPlayerReplicationInfo(PlayerReplicationInfo);
	if ( KFPRI != None )  {
		SRVT = Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill);
		if ( SRVT != None )
			BounceRemaining = SRVT.static.GetMaxBounce(KFPRI);
	}
	
	Super.VeterancyChanged();
}

function DoDoubleJump( bool bUpdating )
{
	PlayDoubleJump();

	if ( !bIsCrouched && !bWantsToCrouch )  {
		if ( !IsLocallyControlled() || AIController(Controller) != None )
			MultiJumpRemaining -= 1;
		
		Velocity.Z = JumpZ + MultiJumpBoost;
		SetPhysics(PHYS_Falling);
		if ( !bUpdating )
			PlayOwnedSound(GetSound(EST_DoubleJump), SLOT_Pain, GruntVolume,,80);
	}
}

function bool CanDoubleJump()
{
	Return ( MultiJumpRemaining > 0 && Physics == PHYS_Falling );
}

function bool CanMultiJump()
{
	Return ( MaxMultiJump > 0 );
}

function bool CanBounce()
{
	local	Actor		A;
	local	Vector		HitLoc, HitNorm, H, R;
	
	BounceVictim = None;
	if ( BounceRemaining > 0 && Level.TimeSeconds >= NextBounceTime )  {
		H = CollisionHeight * Vect(0.0, 0.0, 1.0);
		R = (CollisionRadius + BounceCheckDistance) * Vect(1.0, 1.0, 0.0);
		foreach TraceActors( class 'Actor', A, HitLoc, HitNorm, (Location - R), (Location + R + H), (R * 2.0 + H) )  {
			if ( A != None && A != Self && (A == Level || A.bWorldGeometry || Pawn(A) != None) )  {
				BounceVictim = Pawn(A);
				Return True;
			}
		}
	}
	
	Return False;
}

function DoBounce( bool bUpdating, float JumpModif )
{
	local	Vector		NewVel;
	local	float		MX;
	
	NextBounceTime = Level.TimeSeconds + BounceDelay * GetRandMult(0.95, 1.05);
	--BounceRemaining;
	if ( !bUpdating )
		PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
	
	//Low Gravity
	if ( PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
		JumpModif *= LowGravBounceMomentumScale;
	
	MX = default.BounceMomentum.X * JumpModif;
	NewVel = (BounceMomentum * JumpModif) >> GetViewRotation();
	NewVel.X = FClamp( (Velocity.X + NewVel.X), FMin(-MX, Velocity.X), FMax(MX, Velocity.X) );
	NewVel.Y = FClamp( (Velocity.Y + NewVel.Y), FMin(-MX, Velocity.Y), FMax(MX, Velocity.Y) );
	NewVel.Z = FClamp( (Velocity.Z + NewVel.Z), FMin(-(JumpZ * 1.25), Velocity.Z), FMax(JumpZ, Velocity.Z) );
	Velocity = NewVel;
	
	if ( BounceVictim != None )  {
		NewVel = -NewVel * FClamp((Mass / BounceVictim.Mass), 0.25, 1.25);
		if ( UM_KFMonster(BounceVictim) != None )
			UM_KFMonster(BounceVictim).PushAwayZombie(NewVel);
		else
			BounceVictim.AddVelocity(NewVel);
		
		BounceVictim = None;
	}
	
	BounceMomentum *= 0.50;
}

//Player Jumped
function bool DoJump( bool bUpdating )
{
	local	KFPlayerReplicationInfo		KFPRI;
	local	Class<UM_SRVeterancyTypes>	SRVT;
	local	float						JumpModif;
	
	// This extra jump allows a jumping or dodging pawn to jump again mid-air
    // (via thrusters). The pawn must be within +/- 100 velocity units of the
    // apex of the jump to do this special move.
	/*
    if ( !bUpdating && CanDoubleJump() && Abs(Velocity.Z) < 100 && IsLocallyControlled() )  {
		if ( PlayerController(Controller) != None )
			PlayerController(Controller).bDoubleJump = True;
        
		DoDoubleJump(bUpdating);
        MultiJumpRemaining -= 1;
        
		Return True;
    } */
	
	if ( !bIsCrouched && !bWantsToCrouch )  {
		JumpModif = 1.0 * GetRandMult(0.95, 1.05);
		KFPRI = KFPlayerReplicationInfo(PlayerReplicationInfo);
		if ( KFPRI != None )  {
			SRVT = Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill);
			if ( SRVT != None )
				JumpModif = SRVT.static.GetJumpModifier(KFPRI);
		}
		JumpZ = default.JumpZ * JumpModif;
		
		if ( Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider )  {
			NextBounceTime = Level.TimeSeconds + BounceDelay * GetRandMult(0.95, 1.05);
			// Take you out of ironsights if you jump on a non-lowgrav map
			if ( KFWeapon(Weapon) != None && PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
				KFWeapon(Weapon).ForceZoomOutTime = Level.TimeSeconds + 0.01;
			
			if ( Role == ROLE_Authority )  {
				if ( Level.Game != None && Level.Game.GameDifficulty > 2 )
					MakeNoise((0.1 * Level.Game.GameDifficulty));
				
				if ( bCountJumps && Inventory != None )
					Inventory.OwnerEvent('Jumped');
			}
			
			if ( Physics == PHYS_Spider )
				Velocity = JumpZ * Floor;
			else if ( Physics == PHYS_Ladder )
				Velocity.Z = 0;
			//else if ( bIsWalking )
				//Velocity.Z = Default.JumpZ;
			else
				Velocity.Z = JumpZ;
			
			if ( Base != None && !Base.bWorldGeometry )
				Velocity.Z += Base.Velocity.Z;
			
			SetPhysics(PHYS_Falling);
			if ( !bUpdating )
				PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
			
			Return True;
		}
		else if ( Physics == PHYS_Falling && !bUpdating && CanBounce() )  {
			DoBounce(bUpdating, JumpModif);
			Return True;
		}
	}
    
	Return False;
}

event Landed(vector HitNormal)
{
	local	KFPlayerReplicationInfo		KFPRI;
	local	Class<UM_SRVeterancyTypes>	SRVT;
	
	BounceRemaining = default.BounceRemaining;
	BounceMomentum = default.BounceMomentum;
	KFPRI = KFPlayerReplicationInfo(PlayerReplicationInfo);
	if ( KFPRI != None )  {
		SRVT = Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill);
		if ( SRVT != None )
			BounceRemaining = SRVT.static.GetMaxBounce(KFPRI);
	}
	ImpactVelocity = vect(0.0,0.0,0.0);
	TakeFallingDamage();
	if ( Health > 0 )
		PlayLanded(Velocity.Z);
		
	if ( Velocity.Z < -200 && PlayerController(Controller) != None )  {
		bJustLanded = PlayerController(Controller).bLandingShake;
		OldZ = Location.Z;
	}
	
	LastHitBy = None;
    MultiJumpRemaining = MaxMultiJump;
    if ( Health > 0 && !bHidden && (Level.TimeSeconds - SplashTime) > 0.25 )
        PlayOwnedSound(GetSound(EST_Land), SLOT_Interact, FMin(1, (-0.3 * Velocity.Z / JumpZ)));
}


function name GetOffhandBoneFor(Inventory I)
{
	Return LeftHandWeaponBone;
}

function name GetWeaponBoneFor(Inventory I)
{
	Return RightHandWeaponBone;
}

// Play the pawn firing animations
simulated function StartFiringX(bool bAltFire, bool bRapid)
{
    local	name	FireAnim;
	local	float	FireAnimRate;
    local	int		AnimIndex;

    if ( HasUDamage() && (Level.TimeSeconds - LastUDamageSoundTime) > 0.25 )  {
        LastUDamageSoundTime = Level.TimeSeconds;
        PlaySound(UDamageSound, SLOT_None, (1.5 * TransientSoundVolume),, 700);
    }

    if ( Physics == PHYS_Swimming )
        Return;

    AnimIndex = Rand(4);
    if ( bAltFire )  {
        if ( bIsCrouched )
            FireAnim = FireCrouchAltAnims[AnimIndex];
        else
            FireAnim = FireAltAnims[AnimIndex];
    }
    else  {
        if ( bIsCrouched )
            FireAnim = FireCrouchAnims[AnimIndex];
        else
            FireAnim = FireAnims[AnimIndex];
    }

    AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);
	FireAnimRate = 1.0 * FireSpeedModif;
    if ( bRapid )  {
        if ( FireState != FS_Looping )  {
            LoopAnim(FireAnim, FireAnimRate, 0.0, 1);
            FireState = FS_Looping;
        }
    }
    else  {
        PlayAnim(FireAnim, FireAnimRate, 0.0, 1);
        FireState = FS_PlayOnce;
    }

    IdleTime = Level.TimeSeconds;
}


function ServerSellAmmo( Class<Ammunition> AClass );

final function bool HasWeaponClass( class<Inventory> IC )
{
	local Inventory I;
	
	for ( I = Inventory; I != None; I = I.Inventory )  {
		if ( I.Class == IC )
			Return True;
	}
	
	Return False;
}

final function UM_SRClientPerkRepLink FindStats()
{
	local LinkedReplicationInfo L;

	if ( Controller == None || Controller.PlayerReplicationInfo == None )
		Return None;
	
	for ( L = Controller.PlayerReplicationInfo.CustomReplicationInfo; L != None; L = L.NextReplicationInfo )  {
		if ( UM_SRClientPerkRepLink(L) != None )
			Return UM_SRClientPerkRepLink(L);
	}
	
	Return None;
}

function ServerBuyWeapon( Class<Weapon> WClass, float ItemWeight )
{
	local float Price,Weight;
	local Inventory I;

	if( !CanBuyNow() || Class<KFWeapon>(WClass)==None || Class<KFWeaponPickup>(WClass.Default.PickupClass)==None || HasWeaponClass(WClass) )
		Return;

	// Validate if allowed to buy that weapon.
	if ( PerkLink == None )
		PerkLink = FindStats();
	
	if ( PerkLink != None && !PerkLink.CanBuyPickup(Class<KFWeaponPickup>(WClass.Default.PickupClass)) )
		Return;

	Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

	if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != None )
		Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);

	Weight = Class<KFWeapon>(WClass).Default.Weight;

	if( WClass==class'DualDeagle' || WClass==class'Dual44Magnum' || WClass==class'DualMK23Pistol' || WClass.Default.DemoReplacement!=None )
	{
		if ( (WClass==class'DualDeagle' && HasWeaponClass(class'Deagle'))
		 || (WClass==class'Dual44Magnum' && HasWeaponClass(class'Magnum44Pistol'))
		 || (WClass==class'DualMK23Pistol' && HasWeaponClass(class'MK23Pistol'))
		 || (WClass.Default.DemoReplacement!=None && HasWeaponClass(WClass.Default.DemoReplacement)) )
		{
			if( WClass==class'DualDeagle' )
				Weight-=class'Deagle'.Default.Weight;
			else if( WClass==class'Dual44Magnum' )
				Weight-=class'Magnum44Pistol'.Default.Weight;
			else if( WClass==class'DualMK23Pistol' )
				Weight-=class'MK23Pistol'.Default.Weight;
			else Weight-=class<KFWeapon>(WClass.Default.DemoReplacement).Default.Weight;
			Price*=0.5f;
		}
	}
	else if( WClass==class'Single' || WClass==class'Deagle' || WClass==class'Magnum44Pistol' || WClass==class'MK23Pistol' )
	{
		if ( (WClass==class'Deagle' && HasWeaponClass(class'DualDeagle'))
		 || (WClass==class'Magnum44Pistol' && HasWeaponClass(class'Dual44Magnum'))
		 || (WClass==class'MK23Pistol' && HasWeaponClass(class'DualMK23Pistol'))
		 || (WClass==class'Dualies' && HasWeaponClass(class'Single')) )
			return; // Has the dual weapon.
	}
	else // Check for custom dual weapon mode
	{
		for ( I=Inventory; I!=None; I=I.Inventory )
			if( Weapon(I)!=None && Weapon(I).DemoReplacement==WClass )
				return;
	}

	Price = int(Price); // Truncuate price.

	if ( (Weight>0 && !CanCarry(Weight)) || PlayerReplicationInfo.Score<Price )
		Return;

	I = Spawn(WClass);
	if ( I != none )
	{
		if ( KFGameType(Level.Game) != none )
			KFGameType(Level.Game).WeaponSpawned(I);

		KFWeapon(I).UpdateMagCapacity(PlayerReplicationInfo);
		KFWeapon(I).FillToInitialAmmo();
		KFWeapon(I).SellValue = Price * 0.75;
		I.GiveTo(self);
		PlayerReplicationInfo.Score -= Price;
        ClientForceChangeWeapon(I);
    }
	else ClientMessage("Error: Weapon failed to spawn.");

	SetTraderUpdate();
}

function ServerSellWeapon( Class<Weapon> WClass )
{
	local Inventory I;
	local Weapon NewWep;
	local float Price;

	if ( !CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass)==none
		|| Class<KFWeapon>(WClass).Default.bKFNeverThrow )
	{
		SetTraderUpdate();
		Return;
	}

	for ( I = Inventory; I != none; I = I.Inventory )
	{
		if ( I.Class==WClass )
		{
			if ( KFWeapon(I) != none && KFWeapon(I).SellValue != -1 )
				Price = KFWeapon(I).SellValue;
			else
			{
				Price = (class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

				if ( KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill != none )
					Price *= KFPlayerReplicationInfo(PlayerReplicationInfo).ClientVeteranSkill.static.GetCostScaling(KFPlayerReplicationInfo(PlayerReplicationInfo), WClass.Default.PickupClass);
			}

			if ( I.Class==Class'Dualies' )
			{
				NewWep = Spawn(class'Single');
				Price*=2.f;
			}
			else if ( I.Class==Class'DualDeagle' )
				NewWep = Spawn(class'Deagle');
			else if ( I.Class==Class'Dual44Magnum' )
				NewWep = Spawn(class'Magnum44Pistol');
			else if ( I.Class==Class'DualMK23Pistol' )
				NewWep = Spawn(class'MK23Pistol');
			else if( Weapon(I).DemoReplacement!=None )
				NewWep = Spawn(Weapon(I).DemoReplacement);
			if( NewWep!=None )
			{
				Price *= 0.5f;
				NewWep.GiveTo(self);
			}

			if ( I==Weapon || I==PendingWeapon )
			{
				ClientCurrentWeaponSold();
			}

			PlayerReplicationInfo.Score += int(Price);

			I.Destroy();

			SetTraderUpdate();

			if ( KFGameType(Level.Game)!=none )
				KFGameType(Level.Game).WeaponDestroyed(WClass);
			return;
		}
	}
}

simulated function AddBlur(Float BlurDuration, float Intensity)
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )
		Super.AddBlur(BlurDuration, Intensity);
}

simulated function DoHitCamEffects(vector HitDirection, float JarrScale, float BlurDuration, float JarDurationScale )
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )
		Super.DoHitCamEffects(HitDirection, JarrScale, BlurDuration, JarDurationScale);
}

simulated function StopHitCamEffects()
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )
		Super.StopHitCamEffects();
}

//[block] copied from KFHumanPawn to fix some bugs
simulated event TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local	KFPlayerReplicationInfo		KFPRI;
	
	//server
	if ( Role == ROLE_Authority )  {
		if ( Controller != None && Controller.bGodMode )
			Return;

		if ( KFMonster(InstigatedBy) != None )
			KFMonster(InstigatedBy).bDamagedAPlayer = True;

		// Don't allow momentum from a player shooting a player
		if ( InstigatedBy != None && KFHumanPawn(InstigatedBy) != None )
			Momentum = vect(0,0,0);
		
		//[block] Codes From KFPawn
		LastHitDamType = damageType;
		LastDamagedBy = InstigatedBy;

		Super(xPawn).TakeDamage(Damage, InstigatedBy, hitLocation, momentum, damageType);

		healthtoGive -= 5;

		KFPRI = KFPlayerReplicationInfo(PlayerReplicationInfo);

		// Just return if this wouldn't even damage us. Prevents us from catching on fire for high level perks that dont take fire damage
		if ( KFPRI != None &&  KFPRI.ClientVeteranSkill != None &&
			 KFPRI.ClientVeteranSkill.Static.ReduceDamage(KFPRI, self, KFMonster(InstigatedBy), Damage, DamageType) <= 0 )
				Return;

		if ( class<DamTypeBurned>(damageType) != None || class<DamTypeFlamethrower>(damageType) != None )
		{
			if ( TeamGame(Level.Game) != None &&
				 TeamGame(Level.Game).FriendlyFireScale == 0 &&
				 InstigatedBy != None && InstigatedBy != Self &&
				 InstigatedBy.GetTeamNum() == GetTeamNum() )
				Return;

			// Do burn damage if the damage was significant enough
			if( Damage > 2 )
			{
				// If we are already burning, and this damage is more than our current burn amount, add more burn time
				if( BurnDown > 0 && Damage > LastBurnDamage )
				{
					BurnDown = 5;
					BurnInstigator = InstigatedBy;
				}

				LastBurnDamage = Damage;

				if ( BurnDown <= 0 )
				{
					bBurnified = true;
					BurnDown = 5;
					BurnInstigator = InstigatedBy;
					SetTimer(1.5,true);
				}
			}
		}
		
		if ( Controller == None || PlayerController(Controller) == None )
			Return;

		if ( Class<DamTypeVomit>(DamageType) != None )
		{
			BileCount = 7;
			BileInstigator = InstigatedBy;
			if ( NextBileTime< Level.TimeSeconds )
				NextBileTime = Level.TimeSeconds + BileFrequency;

			if ( Level.Game != None && Level.Game.GameDifficulty >= 4.0 && 
				 KFPlayerController(Controller) != None && !KFPlayerController(Controller).bVomittedOn )
			{
				KFPlayerController(Controller).bVomittedOn = True;
				KFPlayerController(Controller).VomittedOnTime = Level.TimeSeconds;

				if ( Controller.TimerRate == 0.0 )
					Controller.SetTimer(10.0, false);
			}
		}
		else if ( Class<SirenScreamDamage>(DamageType) != None )
		{
			if ( Level.Game != None && Level.Game.GameDifficulty >= 4.0 && 
				 KFPlayerController(Controller) != None &&
				 !KFPlayerController(Controller).bScreamedAt )
			{
				KFPlayerController(Controller).bScreamedAt = true;
				KFPlayerController(Controller).ScreamTime = Level.TimeSeconds;

				if ( Controller.TimerRate == 0.0 )
					Controller.SetTimer(10.0, false);
			}
		}
		//[end] Codes From KFPawn
	}

	//Simulated Bloody Overlays
	if ( (Health - Damage) <= (HealthMax * 0.4) )
		SetOverlayMaterial(InjuredOverlay, 0, true);

	//server
	if ( Role == ROLE_Authority && Level.Game.NumPlayers > 1 
		 && Health < (HealthMax * 0.25) 
		 && (Level.TimeSeconds - LastDyingMessageTime) > DyingMessageDelay )  {
		// Tell everyone we're dying
		PlayerController(Instigator.Controller).Speech('AUTO', 6, "");
		LastDyingMessageTime = Level.TimeSeconds;
	}
}
//[end]


function ExtendedCreateInventoryVeterancy(
			string	InventoryClassName, 
			float	SellValueScale, 
 optional	int		AddExtraAmmo,
 optional	int		FireModeNum)
{
	local Inventory			Inv;
	local class<Inventory>	InventoryClass;

	InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
	
	if( InventoryClass != None && FindInventoryType(InventoryClass) == None )
	{
		Inv = Spawn(InventoryClass);
		if( Inv != none )
		{
			Inv.GiveTo(self);
			
			if ( Inv != None )
				Inv.PickupFunction(self);
			
			if ( KFGameType(Level.Game) != none )
				KFGameType(Level.Game).WeaponSpawned(Inv);
			
			if ( KFWeapon(Inv) != none )
			{
				KFWeapon(Inv).SellValue = float(class<KFWeaponPickup>(InventoryClass.default.PickupClass).default.Cost) * SellValueScale * 0.75;
				
				if ( AddExtraAmmo > 0 )
				{
					if ( FireModeNum <= 0 )
						FireModeNum = 0;
					else
						FireModeNum = 1;
					
					if ( KFWeapon(Inv).AmmoAmount(FireModeNum) < KFWeapon(Inv).MaxAmmo(FireModeNum) )
					{
						if ( AddExtraAmmo > (KFWeapon(Inv).MaxAmmo(FireModeNum) - KFWeapon(Inv).AmmoAmount(FireModeNum)) )
							AddExtraAmmo = KFWeapon(Inv).MaxAmmo(FireModeNum) - KFWeapon(Inv).AmmoAmount(FireModeNum);
						
						KFWeapon(Inv).AddAmmo(AddExtraAmmo, FireModeNum);
					}
				}
			}
		}
	}
}

function bool CanCarry( float Weight )
{
	if ( Weight <= 0 )
		Return True;

	Return ( (CurrentWeight + Weight) <= MaxCarryWeight );
}

function ThrowGrenade()
{
	local	Inventory	Inv;

	if ( AllowGrenadeTossing() )  {
		for ( Inv = Inventory; Inv != None; Inv = Inv.Inventory )  {
			if ( Frag(Inv) != None && Frag(Inv).HasAmmo() && !bThrowingNade
				 && KFWeapon(Weapon) != None 
				 && (!KFWeapon(Weapon).bIsReloading || KFWeapon(Weapon).InterruptReload())
				 && (Weapon.GetFireMode(0).NextFireTime - Level.TimeSeconds) <= 0.1 )  {
				KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
				Weapon.PutDown();
				break;
			}
		}
	}
}

function WeaponDown()
{
    local	Inventory	Inv;

    for( Inv = Inventory; Inv != None; Inv = Inv.Inventory )  {
        if ( Frag(Inv) != None && Frag(Inv).HasAmmo() )  {
            SecondaryItem = Frag(Inv);
            Frag(Inv).StartThrow();
        }
    }
}

simulated function ThrowGrenadeFinished()
{
	SecondaryItem = None;
	KFWeapon(Weapon).ClientGrenadeState = GN_BringUp;
	Weapon.BringUp();
	bThrowingNade = false;
}

exec function SwitchToLastWeapon()
{
    if ( Weapon != None && Weapon.OldWeapon != None )  {
        PendingWeapon = Weapon.OldWeapon;
        Weapon.PutDown();
    }
}



defaultproperties
{
     BounceRemaining=0
	 BounceCheckDistance=9.000000
	 BounceMomentum=(X=380.000000,Z=140.000000)
	 LowGravBounceMomentumScale=2.000000
	 BounceDelay=0.200000
	 LeftHandWeaponBone="WeaponL_Bone"
     RightHandWeaponBone="WeaponR_Bone"
	 RequiredEquipment(0)="KFMod.Knife"
     RequiredEquipment(1)="KFMod.Single"
     RequiredEquipment(2)="UnlimaginMod.UM_Weapon_HandGrenade"
     RequiredEquipment(3)="KFMod.Syringe"
     RequiredEquipment(4)="KFMod.Welder"
}