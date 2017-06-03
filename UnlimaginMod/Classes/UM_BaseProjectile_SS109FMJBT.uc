//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_SS109FMJBT
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 01:33
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 5.56x45mm NATO SS109 FMJBT
//					 Bullet diameter: 5.70 mm (0.224 in). Bullet Mass: 4.0175g (62 gr)
//================================================================================
class UM_BaseProjectile_SS109FMJBT extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=5.7
	 BallisticCoefficient=0.308000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=1100.000000
	 MaxEffectiveRange=1200.000000
	 ProjectileMass=4.0175		//grams
	 MuzzleVelocity=940.000000		//Meter/sec
     HeadShotDamageMult=1.100000
   	 ImpactDamage=45.000000
	 ImpactMomentum=28000.000000
	 HitSoundVolume=0.600000
}
