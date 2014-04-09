//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_BouncingBall
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.07.2013 00:47
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Metal ball for the Berserker =)
//================================================================================
class UM_BaseProjectile_BouncingBall extends UM_BaseProjectile_Bullet
	Abstract;


//========================================================================
//[block] Variables

var		float		BounceBonus;
var		SoundData	PickupSound;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

simulated function float ApplyPenitrationBonus(float EnergyLoss)
{
	Return (EnergyLoss * ExpansionCoefficient);
}

simulated function float ApplyBounceBonus(float EnergyLoss)
{
	Return (EnergyLoss * ExpansionCoefficient / BounceBonus);
}

// Called when projectile has lost all energy
simulated function LostAllEnergy()
{
	Super(UM_BaseProjectile).LostAllEnergy();
	GotoState('NoEnergy');
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	local	float			EL, CosBA;
	local	vector			HitLoc, HitNorm, TraceEnd;
	local	Material		HitMat;
	local	ESurfaceTypes	ST;
	//local	float			VelDotHitNorm;

	// Updating bullet performance before hit the wall
	// Needed because bullet lose Speed and Damage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority && Wall != None && !Wall.bStatic && !Wall.bWorldGeometry 
		&& (Mover(Wall) == None || Mover(Wall).bDamageTriggered) )
	{
		if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController(InstigatorController);
			
			Wall.TakeDamage(Damage, Instigator, Location, (MomentumTransfer * Normal(Velocity)), MyDamageType);
			HurtWall = Wall;
			if ( Instigator != None )
				MakeNoise(1.0);
		}
		Destroy();
		Return;
	}
	
	if ( !bBounce || ArrayCount(SurfaceTypeDataArray) <= 0 )
	{
		SpawnHitEffects(Location, HitNormal);
		if( Instigator != None && Level.NetMode != NM_Client )
			MakeNoise(0.3);
		
		Destroy();
		Return;
	}
	else
	{
		TraceEnd = Location + Vector(Rotation) * 20;
		Trace(HitLoc, HitNorm, TraceEnd, Location, false,, HitMat);
		if ( HitMat == None )
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMat.SurfaceType);

		CosBA = FMax((1.0 - Abs(Maths.static.CosBetweenVectors(Velocity, HitNormal))), 0.25);
		//log(self$": Cos of the BounceAngle="$CosBA);
	
		// 0.5 = Cos(60 deg)
		EL = SurfaceTypeDataArray[ST].MaxEnergyLoss * (0.5 / CosBA);
		// Updating Bullet Performance after hit the wall
					
		//Velocity = MirrorVectorByNormal(Velocity, HitNormal);
		UpdateProjectilePerformance(EL,,MirrorVectorByNormal(Velocity, HitNormal));
			
		SpawnHitEffects(Location, HitNormal);
		if( Instigator != None && Level.NetMode != NM_Client )
			MakeNoise(0.3);
	}
	
	HurtWall = None;
}

state NoEnergy
{
	Ignores HitWall;
	
	function ProcessTouch(Actor Other, vector HitLocation)
	{
		local	Inventory	Inv;
		
		if ( Pawn(Other) != None && Pawn(Other) == Instigator && 
			 Pawn(Other).Inventory != None && MyDamageType != None && 
			 Class<WeaponDamageType>(MyDamageType) != None &&
			 Class<WeaponDamageType>(MyDamageType).default.WeaponClass != None )
		{
			for( Inv = Pawn(Other).Inventory; Inv != None; Inv = Inv.Inventory )
			{
				if ( KFWeapon(Inv) != None && 
					 Inv.Class == Class<WeaponDamageType>(MyDamageType).default.WeaponClass &&
					 KFWeapon(Inv).AmmoAmount(0) < KFWeapon(Inv).MaxAmmo(0) )
				{
					KFWeapon(Inv).AddAmmo(1,0);
					if ( PickupSound.Snd != None )
						ServerPlaySoundData(PickupSound);
					Break;
				}
			}
			Destroy();
		}
	}
	
	simulated event Landed(vector HitNormal)
	{
		if ( Physics != PHYS_None )
		{
			SetPhysics(PHYS_None);
			bCollideWorld = False;
			SpawnHitEffects(Location, HitNormal);
			if( Instigator != None && Level.NetMode != NM_Client )
				MakeNoise(0.3);
		}
	}
}

//[end] Functions
//====================================================================


defaultproperties
{
     BounceBonus=5.000000
	 bAutoLifeSpan=False
	 LifeSpan=120.000000
	 //[block] Ballistic performance
	 BounceChance=1.000000
	 BallisticRandPercent=5.000000
	 //EffectiveRange in Meters
	 EffectiveRange=100.000000
	 MaxEffectiveRangeScale=1.200000
	 //Expansion
	 ExpansionCoefficient=1.00000	// For FMJ
	 ProjectileMass=0.400000	// kilograms
     MuzzleVelocity=100.000000	// m/sec
	 UpdateTimeDelay=0.100000
	 //[end]
	 HeadShotDamageMult=1.100000
	 PenitrationEnergyReduction=0.800000
	 bBounce=True
	 Physics=PHYS_Projectile
	 //Trail
	 DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 DrawScale=8.000000
	 Damage=100.000000
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",Slot=SLOT_Pain,Vol=2.2,Radius=400.0,PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 bNetTemporary=False
	 MyDamageType=None
	 CollisionRadius=3.00000
     CollisionHeight=6.000000
}
