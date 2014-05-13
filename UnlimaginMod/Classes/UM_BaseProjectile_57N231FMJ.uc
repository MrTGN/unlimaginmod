//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_57N231FMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.05.2013 22:42
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 7.62X39mm Full Metal Jacket
//					 Bullet diameter: 7.92 mm (0.312 in). Bullet Mass: 7.9 g (121.92 gr)
//================================================================================
class UM_BaseProjectile_57N231FMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=7.92
	 BallisticCoefficient=0.350000
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 EffectiveRange=1400.000000
	 MaxEffectiveRange=1500.000000
	 ProjectileMass=0.007900		//kilograms
	 MuzzleVelocity=720.000000		//Meter/sec
     HeadShotDamageMult=1.100000
   	 Damage=64.000000
	 MomentumTransfer=70000.000000
	 HitSoundVolume=0.850000
}
