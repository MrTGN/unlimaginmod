//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_45ACP_FHST230JHP
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 16.08.2013 04:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 .45 ACP Federal HST P45HST1 +P JHP
//					 Bullet diameter: .452 in (11.5 mm). Bullet Mass: 230 gr (14.904 g)
//================================================================================
class UM_BaseProjectile_45ACP_FHST230JHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=11.5
	 BallisticCoefficient=0.162000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=700.000000
	 MaxEffectiveRange=800.000000
	 ExpansionCoefficient=1.984500
	 ProjectileMass=14.904		//grams
	 MuzzleVelocity=285.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 ImpactDamage=52.000000
	 ImpactMomentum=33000.000000
	 HitSoundVolume=0.710000
}
