//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_Melee
//	Parent class:	 DamTypeMelee
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 02.03.2013 20:16
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseDamType_Melee extends DamTypeMelee
	Abstract;

defaultproperties
{
     HeadShotDamageMult=1.150000
     bIsMeleeDamage=True
     DeathString="%o was beat down by %k."
     FemaleSuicide="%o beat herself down."
     MaleSuicide="%o beat himself down."
     bRagdollBullet=True
     bBulletHit=True
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     LowGoreDamageEmitter=Class'ROEffects.ROBloodPuffNoGore'
     LowDetailEmitter=Class'ROEffects.ROBloodPuffSmall'
     FlashFog=(X=600.000000)
     KDamageImpulse=2000.000000
     KDeathVel=100.000000
     KDeathUpKick=25.000000
}
