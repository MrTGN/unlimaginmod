//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeThompsonM4A1Bullet
//	Parent class:	 UM_BaseDamType_SMG
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 19:01
//================================================================================
class UM_DamTypeThompsonM4A1Bullet extends UM_BaseDamType_SMG
	Abstract;


defaultproperties
{
	 WeaponClass=Class'UnlimaginMod.UM_ThompsonM4A1SMG'
     DeathString="%k killed %o (Thompson M4A1 SMG)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=1860.000000
     KDeathVel=125.000000
     KDeathUpKick=10.000000
}
