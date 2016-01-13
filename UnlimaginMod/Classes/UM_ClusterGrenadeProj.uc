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


simulated event PostBeginPlay()
{	
	if ( Role == ROLE_Authority )
		ExplodeTimer = default.ExplodeTimer * (0.5 + FRand());
	
	Super(UM_BaseProjectile).PostBeginPlay();
}

defaultproperties
{
     ProjectileDiameter=30.0
	 ProjectileMass=0.200
	 bCanHurtSameTypeProjectile=False
	 //Sounds
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=350.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=350.0,bUse3D=True)
	 //ExplodeTimer
	 ExplodeTimer=2.000000
	 BallisticRandRange=(Min=0.7,Max=1.3)
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
	 //IgnoredVictims
	 IgnoredVictims(0)="UM_ClusterHandGrenade"
	 ShrapnelClass=None
}