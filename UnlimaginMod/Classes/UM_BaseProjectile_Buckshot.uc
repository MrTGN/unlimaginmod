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
//	Comments:		 
//================================================================================
class UM_BaseProjectile_Buckshot extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     // Ρσωερςβσες οπξρςξε οπΰκςθχερκξε οπΰβθλξ: μΰκρθμΰλόνΰÿ δΰλόνξρςό οξλεςΰ δπξαθ οπθαλθηθςελόνξ 
     // πΰβνΰ ςΰκξμσ χθρλσ ρξςεν μεςπξβ, κΰκξε χθρλξ φελϋυ μθλλθμεςπξβ θμεες δθΰμεςπ ξςδελόνξι 
	 // δπξαθνϋ, βϋρςπελεννξι ρ μΰκρθμΰλόνξι νΰχΰλόνξι ρκξπξρςόώ 375-400 μ/ρ. 
	 // Òΰκ, δπξαό Ή 7 (2,5 μμ) λεςθς νΰ 250 μ.
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
	 Damage=100.000000
	 MomentumTransfer=70000.000000
	 HitSoundVolume=0.750000
	 DrawScale=1.900000
}
