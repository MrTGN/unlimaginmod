//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Shrapnel
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 27.04.2014 17:25
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Small shrapnel ball
//================================================================================
class UM_BaseProjectile_Shrapnel extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_LeadBulletTracer')
	 bCanRebound=True
	 bAutoLifeSpan=True
	 bTrueBallistics=True
	 bInitialAcceleration=True
	 BallisticCoefficient=0.055000
	 BallisticRandRange=(Min=0.9,Max=1.1)
	 ProjectileDiameter=10.0
	 ProjectileMass=0.006000	// kilograms
	 BounceBonus=1.100000
	 ExpansionCoefficient=1.000000
	 MuzzleVelocity=120.000000	// m/sec
	 //EffectiveRange in Meters
	 EffectiveRange=1000.000000
	 MaxEffectiveRange=1200.000000
	 Damage=50.000000
	 HeadShotDamageMult=1.500000
	 MomentumTransfer=64000.000000
	 HitSoundVolume=0.700000
	 DrawScale=1.125000
}
