//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Buckshot
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.04.2013 19:38
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
     // Ρσωερςβσες οπξρςξε οπΰκςθχερκξε οπΰβθλξ: μΰκρθμΰλόνΰÿ δΰλόνξρςό οξλεςΰ δπξαθ οπθαλθηθςελόνξ 
     // πΰβνΰ ςΰκξμσ χθρλσ ρξςεν μεςπξβ, κΰκξε χθρλξ φελϋυ μθλλθμεςπξβ θμεες δθΰμεςπ ξςδελόνξι 
	 // δπξαθνϋ, βϋρςπελεννξι ρ μΰκρθμΰλόνξι νΰχΰλόνξι ρκξπξρςόώ 375-400 μ/ρ. 
	 // Òΰκ, δπξαό Ή 7 (2,5 μμ) λεςθς νΰ 250 μ.
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
