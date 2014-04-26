//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_338ScenarGB488HPBT
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.06.2013 00:14
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 .338 Lapua Magnum Very-low-drag (VLD) Scenar GB488 
//					 hollow-point boat-tail bullet (HPBT)
//					 Bullet diameter: 8.58 mm (0.338 in). Bullet Mass: 16.20 g (250 gr)
//================================================================================
class UM_BaseProjectile_338ScenarGB488HPBT extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.58
	 BallisticCoefficient=0.631000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=1300.000000
	 MaxEffectiveRange=1400.000000
	 ExpansionCoefficient=1.600000
	 ProjectileMass=0.016200		//kilograms
	 MuzzleVelocity=910.000000		//Meter/sec
     PenetrationEnergyReduction=0.600000
	 HeadShotDamageMult=2.500000
   	 Damage=220.000000
	 MomentumTransfer=50000.000000
	 HitSoundVolume=0.800000
}
