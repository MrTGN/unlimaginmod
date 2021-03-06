//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_M856Tracer
//	Parent class:	 UM_BaseProjectile_TracerBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.05.2013 22:54
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 5.56x45mm M856 Tracer
//					 Bullet diameter: 5.70 mm (0.224 in). Bullet Mass: 4.1471g (64 gr)
//================================================================================
class UM_BaseProjectile_M856Tracer extends UM_BaseProjectile_TracerBullet
	Abstract;


defaultproperties
{
     Trail=(xEmitterClass=Class'UnlimaginMod.UM_IncBulletTracer')
	 //Ballistic
	 BallisticCoefficient=0.318000
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 EffectiveRange=1200.000000
	 ProjectileMass=4.1471		//grams
	 MuzzleVelocity=880.000000		//Meter/sec
	 //Damage
	 HeadShotDamageMult=1.100000
	 ImpactDamage=40.000000
	 ImpactMomentum=28000.000000
	 HitSoundVolume=0.600000
}
