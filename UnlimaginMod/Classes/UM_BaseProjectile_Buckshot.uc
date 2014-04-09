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
//	Comments:		 Pellet diameter: .36" (9.1 mm). Pellet weight: 68 grains (4.4063 grams).
//					 7-8 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_Buckshot extends UM_BaseProjectile_Bullet
	Abstract;

simulated function float ApplyPenitrationBonus(float EnergyLoss)
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
		Return (EnergyLoss * ExpansionCoefficient / (KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.static.GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo),default.PenitrationEnergyReduction) / default.PenitrationEnergyReduction));
	else
		Return (EnergyLoss * ExpansionCoefficient);
}

defaultproperties
{
     // ﾑ��褥�糒褪 ������� ��瑕�顆褥��� ��珞齏�: �瑕�韲琿���� 萵������� ���褪� 蓿�礪 ��鞦�韈頸褄��� 
     // �珞�� �瑕��� �頌�� ���褊 �褪���, �瑕�� �頌�� �褄�� �齏�韲褪��� 韲裹� 蒻瑟褪� ��蒟����� 
	 // 蓿�礪��, 糺���褄褊��� � �瑕�韲琿���� �璞琿���� ��������� 375-400 �/�. 
	 // ﾒ瑕, 蓿�磬 ｹ 7 (2,5 ��) �褪頸 �� 250 �.
     BallisticCoefficient=0.050000
	 BallisticRandPercent=8.000000
	 EffectiveRange=910.000000
	 MaxEffectiveRangeScale=1.000000
	 ProjectileMass=0.037454
	 MuzzleVelocity=380.000000
     PenitrationEnergyReduction=0.720000
     HeadShotDamageMult=1.500000
	 // Damage for 7 pellets
	 Damage=40.000000
	 MomentumTransfer=60000.000000
	 HitSoundVolume=0.650000
	 DrawScale=1.080000
}
