//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_Buckshot
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.04.2013 19:38
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_Buckshot extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     // ﾑ��褥�糒褪 ������� ��瑕�顆褥��� ��珞齏�: �瑕�韲琿���� 萵������� ���褪� 蓿�礪 ��鞦�韈頸褄��� 
     // �珞�� �瑕��� �頌�� ���褊 �褪���, �瑕�� �頌�� �褄�� �齏�韲褪��� 韲裹� 蒻瑟褪� ��蒟����� 
	 // 蓿�礪��, 糺���褄褊��� � �瑕�韲琿���� �璞琿���� ��������� 375-400 �/�. 
	 // ﾒ瑕, 蓿�磬 ｹ 7 (2,5 ��) �褪頸 �� 250 �.
     ProjectileDiameter=10.00
	 BallisticCoefficient=0.090000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=1400.000000
	 MaxEffectiveRange=1500.000000
	 ProjectileMass=15.0 //grams
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_LeadBulletTracer')
	 MuzzleVelocity=380.000000
     HeadShotDamageMult=1.500000
	 ImpactDamage=100.000000
	 ImpactMomentum=70000.000000
	 HitSoundVolume=0.750000
	 DrawScale=1.900000
}
