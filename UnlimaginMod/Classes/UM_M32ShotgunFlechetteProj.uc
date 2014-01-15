//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32ShotgunFlechetteProj
//	Parent class:	 NailGunProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:18
//================================================================================
class UM_M32ShotgunFlechetteProj extends NailGunProjectile;

defaultproperties
{
	bNetTemporary=True
	Bounces=4
	MaxPenetrations=3
	Speed=3300.000000
	MaxSpeed=3800.000000
	PenDamageReduction=0.720000
	Damage=15.000000
	DamageRadius=0.000000
	MomentumTransfer=60000.000000
	MyDamageType=Class'UnlimaginMod.UM_DamTypeM32Flechette'
	DrawScale=0.750000
}