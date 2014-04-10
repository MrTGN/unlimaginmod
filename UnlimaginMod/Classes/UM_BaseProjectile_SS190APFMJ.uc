//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_SS190APFMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 16:18
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 FN 5.7x28mm SS190 AP FMJ
//					 Bullet diameter: 5.7 mm (0.224 in). Bullet Mass: 31 gr (2 g)
//================================================================================
class UM_BaseProjectile_SS190APFMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.154000
	 BallisticRandPercent=6.000000
	 EffectiveRange=800.000000
	 ProjectileMass=0.002000		//kilograms
	 MuzzleVelocity=710.000000		//Meter/sec
     PenetrationEnergyReduction=0.200000
     HeadShotDamageMult=1.100000
   	 Damage=40.000000
	 MomentumTransfer=25000.000000
	 HitSoundVolume=0.500000
}
