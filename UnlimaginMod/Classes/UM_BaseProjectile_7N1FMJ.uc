//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_7N1FMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 19:32
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 7.62x54mmR 7N1 FMJ sniper bullet 
//					 Bullet diameter: 7.92 mm (0.312 in). Bullet Mass: 9.8 g (151.24 gr)
//================================================================================
class UM_BaseProjectile_7N1FMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=7.92
	 BallisticCoefficient=0.434000
	 BallisticRandPercent=6.000000
	 EffectiveRange=1500.000000
	 MaxEffectiveRange=1600.000000
	 ProjectileMass=0.009800		//kilograms
	 MuzzleVelocity=825.000000		//Meter/sec
     PenetrationEnergyReduction=0.440000
     HeadShotDamageMult=2.300000
   	 Damage=120.000000
	 MomentumTransfer=80000.000000
	 HitSoundVolume=0.850000
}
