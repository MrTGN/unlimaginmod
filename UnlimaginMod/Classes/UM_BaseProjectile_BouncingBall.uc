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
	DependsOn(UM_BaseActor)
	Abstract;


//========================================================================
//[block] Variables

var		UM_BaseActor.SoundData	PickupSound;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

// Called when projectile has lost all energy
simulated function SetNoKineticEnergy()
{
	Super(UM_BaseProjectile).SetNoKineticEnergy();
	GotoState('NoEnergy');
}

state NoEnergy
{
	
}

//[end] Functions
//====================================================================


defaultproperties
{
     ProjectileDiameter=30.0
	 BounceBonus=1.500000
	 bAutoLifeSpan=False
	 LifeSpan=120.000000
	 //[block] Ballistic performance
	 CollisionRadius=3.000000
     CollisionHeight=3.000000
	 BallisticRandRange=(Min=0.94,Max=1.06)
	 //EffectiveRange in Meters
	 EffectiveRange=300.000000
	 MaxEffectiveRange=350.000000
	 //Expansion
	 ExpansionCoefficient=1.00000	// For FMJ
	 ProjectileMass=300.0	//grams
     MuzzleVelocity=100.000000	// m/sec
	 //[end]
	 HeadShotDamageMult=1.250000
	 bBounce=True
	 bCanRicochet=True
	 bOrientToVelocity=True
	 Physics=PHYS_Projectile
	 //Trail
	 DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 DrawScale=7.000000
	 ImpactDamage=300.000000
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",Slot=SLOT_Pain,Vol=2.2,Radius=400.0,PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 bNetTemporary=False
	 ImpactDamageType=None
}
