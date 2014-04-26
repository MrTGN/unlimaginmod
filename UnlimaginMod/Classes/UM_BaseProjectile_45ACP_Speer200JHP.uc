//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_45ACP_Speer200JHP
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.04.2013 21:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 .45ACP Speer Gold Dot JHP +P
//					 Bullet diameter: .452 in (11.5 mm). Bullet Mass: 200 gr (13 g)
//================================================================================
class UM_BaseProjectile_45ACP_Speer200JHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=11.5
	 BallisticCoefficient=0.140000
	 BallisticRandRange=(Min=0.955,Max=1.045)
	 EffectiveRange=720.000000
	 MaxEffectiveRange=800.000000
	 ExpansionCoefficient=1.745000
	 ProjectileMass=0.013000		//kilograms
	 MuzzleVelocity=330.000000		//Meter/sec
     PenetrationEnergyReduction=0.250000
     HeadShotDamageMult=1.250000
   	 Damage=43.000000
	 MomentumTransfer=31000.000000
	 HitSoundVolume=0.700000
}
