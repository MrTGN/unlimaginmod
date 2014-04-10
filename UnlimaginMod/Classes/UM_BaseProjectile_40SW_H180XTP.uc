//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_40SW_H180XTP
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.08.2013 20:11
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Hornady 40 S&W 180 gr XTP
//					 Bullet diameter: 10 mm (.4 in). Bullet Mass: 11.664 g (180 gr)
//================================================================================
class UM_BaseProjectile_40SW_H180XTP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.164000
	 BallisticRandPercent=7.000000
	 EffectiveRange=860.000000
	 ExpansionCoefficient=1.760000
	 ProjectileMass=0.011664		//kilograms
	 // Barrel > 4"
	 MuzzleVelocity=295.000000		//Meter/sec
     PenetrationEnergyReduction=0.25000
     HeadShotDamageMult=1.250000
   	 Damage=42.500000
	 MomentumTransfer=30500.000000
	 HitSoundVolume=0.700000
}
