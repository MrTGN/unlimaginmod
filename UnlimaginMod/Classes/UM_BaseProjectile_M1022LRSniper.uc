//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_M1022LRSniper
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.05.2013 01:42
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 .50 BMG or 12.7x99mm NATO
//					 Bullet diameter: .510 in (12.95 mm). Bullet Mass: 42.443g (655 gr)
//================================================================================
class UM_BaseProjectile_M1022LRSniper extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanBounce=True
	 PenetrationEnergyReduction=0.860000
	 //Ballistic
	 BallisticCoefficient=0.876000
	 BallisticRandPercent=5.000000
	 EffectiveRange=1800.000000
	 ProjectileMass=0.042443		//kilograms
	 MuzzleVelocity=920.000000	// m/s
   	 HeadShotDamageMult=2.800000
	 Damage=720.000000
	 MomentumTransfer=150000.000000
	 HitSoundVolume=1.250000
}
