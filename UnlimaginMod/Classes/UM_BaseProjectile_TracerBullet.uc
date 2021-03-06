//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_TracerBullet
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 03.06.2013 21:21
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_TracerBullet extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     HeadShotDamageMult=1.100000
	 ImpactDamage=30.000000
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_IncBulletTracer')
	 LightType=LT_Steady
     LightHue=255
     LightSaturation=64
     LightBrightness=255.000000
     LightRadius=16.000000
     LightCone=16
     bDynamicLight=True
     DrawScale=1.000000
     AmbientGlow=254
     bUnlit=True
}
