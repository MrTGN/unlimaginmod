//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_M118LRBTHP
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 16:42
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 7.62x51mm NATO M118 Long Range BTHP
//					 Bullet diameter: 7.82 mm (0.308 in). Bullet Mass: 11.34 g (175 gr)
//================================================================================
class UM_BaseProjectile_M118LRBTHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=7.82
	 BallisticCoefficient=0.513000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=1520.000000
	 MaxEffectiveRange=1600.000000
	 ExpansionCoefficient=1.500000
	 ProjectileMass=0.011340		//kilograms
	 MuzzleVelocity=780.000000		//Meter/sec
     HeadShotDamageMult=1.100000
   	 Damage=120.000000
	 MomentumTransfer=80000.000000
	 HitSoundVolume=0.850000
}
