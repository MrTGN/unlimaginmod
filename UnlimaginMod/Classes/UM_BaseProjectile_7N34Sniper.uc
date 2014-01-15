//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_7N34Sniper
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 31.03.2013 04:07
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base class of specialized high accuracy bullet 7N34 Sniper FMJ
//					 12.7x108mm cartridge. Bullet Mass: 59.0 gram
//================================================================================
class UM_BaseProjectile_7N34Sniper extends UM_BaseProjectile_Bullet
	Abstract;

defaultproperties
{
	 BounceChance=0.850000
	 HeadShotDamageMult=2.500000
	 PenitrationEnergyReduction=0.900000
	 bBounce=True
	 //You can use this varible to set new hit sound volume and radius
	 HitSoundVolume=1.400000
	 //Ballistic
	 BallisticCoefficient=1.200000
	 BallisticRandPercent=6.000000
	 EffectiveRange=1800.000000	// meters
	 ProjectileMass=0.059000	//Kilograms
	 MuzzleVelocity=770.000000	// m/s
	 Damage=920.000000
	 MomentumTransfer=160000.000000
}
