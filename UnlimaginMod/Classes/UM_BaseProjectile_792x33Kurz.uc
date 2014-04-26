//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_792x33Kurz
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.06.2013 14:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 7.92x33mm Kurz Ball
//					 Bullet diameter: 8.2 mm (0.32 in). Bullet Mass: 8.1 g (125 gr)
//================================================================================
class UM_BaseProjectile_792x33Kurz extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.2
	 BallisticCoefficient=0.345000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=1300.000000
	 MaxEffectiveRange=1400.000000
	 ProjectileMass=0.008100		//kilograms
	 MuzzleVelocity=685.000000		//Meter/sec
     PenetrationEnergyReduction=0.400000
     HeadShotDamageMult=1.100000
   	 Damage=66.000000
	 MomentumTransfer=70000.000000
	 HitSoundVolume=0.850000
}
