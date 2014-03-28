//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ClusterGrenadeProj
//	Parent class:	 UM_BaseProjectile_HandGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 6:12
//================================================================================
class UM_ClusterGrenadeProj extends UM_BaseProjectile_HandGrenade;


simulated function SetInitialVelocity()
{
	if ( Role == ROLE_Authority && Speed > 0.0 )
    {
        bCanHitOwner = False;
		if ( PhysicsVolume.bWaterVolume && SpeedDropInWaterCoefficient > 0.0 )
			Speed *= SpeedDropInWaterCoefficient;
		
		SetRotation(RotRand());
		Velocity = Vector(Rotation) * Speed * (0.5 + FRand());
    }
}

simulated event PostBeginPlay()
{
	ExplodeTimer = default.ExplodeTimer * (0.50 + FRand());
	Super(UM_BaseProjectile).PostBeginPlay();
}

defaultproperties
{
     bIgnoreSameClassProj=True
	 //Sounds
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.Nade_Explode_1"
     ExplodeSoundsRef(1)="KF_GrenadeSnd.Nade_Explode_2"
     ExplodeSoundsRef(2)="KF_GrenadeSnd.Nade_Explode_3"
	 //ExplodeTimer
	 ExplodeTimer=2.000000
	 BallisticRandPercent=20.000000
     //MuzzleVelocity
     MuzzleVelocity=26.000000	// m/sec
	 Trail=(xEmitterClass=Class'KFTracer')
	 //Mesh
	 StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 DrawScale=5.000000
	 //Damage
     Damage=300.000000
     DamageRadius=300.000000
	 ImpactDamage=40.000000
	 ProjectileMass=0.200000
	 //IgnoreVictims
	 IgnoreVictims(0)="UM_ClusterHandGrenade"
	 ShrapnelClass=None
}