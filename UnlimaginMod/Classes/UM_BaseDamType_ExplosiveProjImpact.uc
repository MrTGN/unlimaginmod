//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_ExplosiveProjImpact
//	Parent class:	 UM_BaseDamType_ElementalProjImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.02.2013 04:15
//================================================================================
class UM_BaseDamType_ExplosiveProjImpact extends UM_BaseDamType_ElementalProjImpact
	Abstract;

/*
static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';
	if( VictimHealth <= 0 )
		HitEffects[1] = class'KFHitFlame';
	else if ( FRand() < 0.8 )
		HitEffects[1] = class'KFHitFlame';
} */


defaultproperties
{
     DeathString="%k killed %o (Explosive Projectile)."
     FemaleSuicide="%o blew up."
     MaleSuicide="%o blew up."
	 KDamageImpulse=2250.000000
     KDeathVel=115.000000
     KDeathUpKick=5.000000
	 HumanObliterationThreshhold=120
}
