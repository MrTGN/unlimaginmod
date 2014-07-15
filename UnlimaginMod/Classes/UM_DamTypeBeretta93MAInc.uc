//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeBeretta93MAInc
//	Parent class:	 UM_BaseDamType_IncendiaryBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 19:50
//================================================================================
class UM_DamTypeBeretta93MAInc extends UM_BaseDamType_IncendiaryBullet
	Abstract;

defaultproperties
{
     WeaponClass=Class'KFMod.Single'
     DeathString="%k killed %o (Dual Beretta93MA)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     FlashFog=(X=600.000000)
     KDamageImpulse=750.000000
     KDeathVel=100.000000
     VehicleDamageScaling=0.700000
}
