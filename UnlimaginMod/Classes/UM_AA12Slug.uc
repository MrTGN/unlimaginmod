//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12Slug
//	Parent class:	 ShotgunBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.12.2012 18:21
//================================================================================
class UM_AA12Slug extends ShotgunBullet;

defaultproperties
{
     DamageAtten=5.000000
     MaxPenetrations=6
     PenDamageReduction=0.900000
     HeadShotDamageMult=1.500000
	 Speed=7000.000000
     MaxSpeed=8000.000000
	 Damage=175.000000
	 MomentumTransfer=54000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeAA12Slug'
	 LifeSpan=4.000000
     DrawScale=4.000000
}
