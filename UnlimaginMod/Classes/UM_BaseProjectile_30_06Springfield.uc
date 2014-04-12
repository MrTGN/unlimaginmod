//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_30_06Springfield
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.08.2013 14:13
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Hornady 30-06 Springfield 180 gr SST
//					 Bullet diameter: 7.8 mm (.308 in). Bullet Mass: 11.664 g (180 gr)
//================================================================================
class UM_BaseProjectile_30_06Springfield extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanRebound=True
	 BallisticCoefficient=0.480000
	 BallisticRandPercent=7.000000
	 EffectiveRange=1200.000000
	 ExpansionCoefficient=1.600000
	 ProjectileMass=0.011664		//kilograms
	 MuzzleVelocity=860.000000		//Meter/sec
     PenetrationEnergyReduction=0.700000
     HeadShotDamageMult=1.200000
   	 Damage=140.000000
	 MomentumTransfer=130000.000000
}
