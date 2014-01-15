//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeAA12Slug
//	Parent class:	 UM_BaseDamType_SniperRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.12.2012 19:22
//================================================================================
class UM_DamTypeAA12Slug extends UM_BaseDamType_SniperRifle
	Abstract;

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_AA12AutoShotgun'
     DeathString="%k put a bullet in %o's head."
     FemaleSuicide="%o shot herself in the head."
     MaleSuicide="%o shot himself in the head."
     KDamageImpulse=8800.000000
     KDeathVel=240.000000
     KDeathUpKick=100.000000
}