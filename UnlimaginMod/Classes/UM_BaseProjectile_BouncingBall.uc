//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_BouncingBall
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.07.2013 00:47
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Metal ball for the Berserker =)
//================================================================================
class UM_BaseProjectile_BouncingBall extends UM_BaseProjectile_Bullet
	Abstract;


//========================================================================
//[block] Variables

var		SoundData	PickupSound;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

// Called when projectile has lost all energy
simulated function ZeroProjectileEnergy()
{
	Super(UM_BaseProjectile).ZeroProjectileEnergy();
	GotoState('NoEnergy');
}

state NoEnergy
{
	Ignores HitWall;
	
	simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
	{
		local	Inventory	Inv;
		
		if ( Role == ROLE_Authority && Pawn(A) != None && Pawn(A) == Instigator && 
			 Pawn(A).Inventory != None && MyDamageType != None && 
			 Class<WeaponDamageType>(MyDamageType) != None &&
			 Class<WeaponDamageType>(MyDamageType).default.WeaponClass != None )
		{
			for( Inv = Pawn(A).Inventory; Inv != None; Inv = Inv.Inventory )
			{
				if ( KFWeapon(Inv) != None && 
					 Inv.Class == Class<WeaponDamageType>(MyDamageType).default.WeaponClass &&
					 KFWeapon(Inv).AmmoAmount(0) < KFWeapon(Inv).MaxAmmo(0) )  {
					KFWeapon(Inv).AddAmmo(1,0);
					if ( PickupSound.Snd != None )
						PlaySound(PickupSound.Snd, PickupSound.Slot, PickupSound.Vol, PickupSound.bNoOverride, PickupSound.Radius, GetRandPitch(PickupSound.PitchRange), PickupSound.bUse3D);
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
     ProjectileDiameter=60.0
	 BounceBonus=1.500000
	 bAutoLifeSpan=False
	 LifeSpan=120.000000
	 //[block] Ballistic performance
	 BallisticRandRange=(Min=0.94,Max=1.06)
	 //EffectiveRange in Meters
	 EffectiveRange=100.000000
	 MaxEffectiveRange=150.000000
	 //Expansion
	 ExpansionCoefficient=1.00000	// For FMJ
	 ProjectileMass=0.400000	// kilograms
     MuzzleVelocity=100.000000	// m/sec
	 UpdateTimeDelay=0.100000
	 //[end]
	 HeadShotDamageMult=1.100000
	 bBounce=True
	 bCanRebound=True
	 bOrientToVelocity=True
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
