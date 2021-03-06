//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_Explosive
//	Parent class:	 UM_BaseWeaponDamageType
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.02.2013 03:13
//================================================================================
class UM_BaseDamType_Explosive extends UM_BaseWeaponDamageType
	Abstract;


static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';
	if( VictimHealth <= 0 )
		HitEffects[1] = class'KFHitFlame';
	else if ( FRand() < 0.8 )
		HitEffects[1] = class'KFHitFlame';
}


defaultproperties
{
     bIsExplosive=True
     DeathString="%o filled %k's body with shrapnel."
     FemaleSuicide="%o blew up."
     MaleSuicide="%o blew up."
     bThrowRagdoll=True
     bExtraMomentumZ=True
     DamageThreshold=1
     KDamageImpulse=2500.000000
     KDeathVel=300.000000
     KDeathUpKick=200.000000
	 DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
	 HumanObliterationThreshhold=150
}
