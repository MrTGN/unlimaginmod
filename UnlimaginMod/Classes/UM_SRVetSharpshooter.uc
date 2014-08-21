//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetSharpshooter
//	Parent class:	 UM_SRVeterancyTypes
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.09.2012 20:31
//================================================================================
class UM_SRVetSharpshooter extends UM_SRVeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
		case 0:
			// FinalInt = 10;
			FinalInt = 0;
			Break;
		case 1:
			FinalInt = 150;
			Break;
		case 2:
			FinalInt = 800;
			Break;
		case 3:
			FinalInt = 1950;
			Break;
		case 4:
			FinalInt = 3600;
			Break;
		case 5:
			FinalInt = 5750;
			Break;
		case 6:
			FinalInt = 8400;
			Break;
		case 7:
			FinalInt = 11550;
			Break;
		case 8:
			FinalInt = 15200;
			Break;
		case 9:
			FinalInt = 19350;
			Break;
		case 10:
			FinalInt = 24000;
			Break;
		default:
			FinalInt = (50 * (CurLevel + 1)) + ((CurLevel - 1) * 450 + 50) + (50 * CurLevel) + ((CurLevel - 2) * 450 + 50);
			Break;
		/*default:
			FinalInt = 8500+GetDoubleScaling(CurLevel,2500);*/
	}
	Return Min(StatOther.RHeadshotKillsStat,FinalInt);
}

// ExtraAmmo added by TGN
static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( Class<UM_BaseAutomaticSniperRifleAmmo>(AmmoType) != None )
		Return 1.20 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 50% increase in ammo carried
	else if ( Class<UM_BaseBattleRifleAmmo>(AmmoType) != None )
		Return 1.20 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 50% increase in ammo carried
	else if ( Class<UM_BaseHandgunAmmo>(AmmoType) != None ||
			 AmmoType == class'WinchesterAmmo' ||
			 AmmoType == class'SPSniperAmmo' )
		Return 1.20 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 50% increase in ammo carried
	else if ( Class<UM_BaseSniperRifleAmmo>(AmmoType) != None )
		Return 1.10 + (0.15 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 100% increase in ammo carried
	else if ( AmmoType == class'CrossbowAmmo' || AmmoType == class'M99Ammo' || 
		 AmmoType == class'Braindead_HuntingRifleAmmo' || AmmoType == class'M14EBRAmmo' ||
		 AmmoType == class'OperationY_SVDLLIAmmo' || AmmoType == class'OperationY_V94Ammo' ||
		 AmmoType == class'OperationY_HK417Ammo' || AmmoType == class'OperationY_VSSDTAmmo' ||
		 AmmoType == class'OperationY_G2ContenderAmmo' || AmmoType == class'OperationY_M82A1LLIAmmo' ||
		 AmmoType == class'OperationY_L96AWPLLIAmmo' )
		Return 1.10 + (0.15 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 100% increase in sniper & crossbow ammo carried
	else if ( (AmmoType == class'AA12Ammo' || AmmoType == class'ShotgunAmmo') 
				 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.25; // Level 4, 5, 6 - 25% increase in AA12/Shotgun ammo carried
	else if ( (AmmoType == class'BenelliAmmo' || AmmoType == class'KSGAmmo' ||
				 AmmoType == class'TrenchgunAmmo') && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.20;

	Return 1.00;
}

static function float GetHeadShotDamMulti(KFPlayerReplicationInfo KFPRI, KFPawn P, class<DamageType> DmgType)
{
	local float ret;

	if ( Class<UM_BaseDamType_SniperRifle>(DmgType) != None || 
		 Class<UM_BaseDamType_BattleRifle>(DmgType) != None ||
		 Class<UM_BaseDamType_Handgun>(DmgType) != None )
		ret = 1.06 + (0.09 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // 60% increase damage
	else if ( DmgType == class'DamTypeCrossbow' || DmgType == class'DamTypeCrossbowHeadShot' ||
		 DmgType == class'DamTypeWinchester' || DmgType == class'DamTypeDeagle' ||
		 DmgType == class'DamTypeDualDeagle' || DmgType == class'DamTypeM14EBR' ||
		 DmgType == class'DamTypeMagnum44Pistol' || DmgType == class'DamTypeDual44Magnum' ||
		 DmgType == class'DamTypeMK23Pistol' || DmgType == class'DamTypeDualMK23Pistol' ||
		 DmgType == class'DamTypeM99SniperRifle' || DmgType == class'DamTypeM99HeadShot' ||
		 DmgType == class'DamTypeDualies' || DmgType == class'DamTypeSPSniper' )
		ret = 1.06 + (0.09 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // 60% increase in Crossbow/Winchester/Handcannon damage
	else
		ret = 1.0; // Fix for oversight

	Return ret * (1.05 + (0.09 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // 50% increase in Headshot Damage
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	if ( UM_BaseAutomaticSniperRifleFire(Other) != None ||
		 UM_BaseBattleRifleFire(Other) != None ||
		 UM_BaseHandgunFire(Other) != None ||
		 UM_BaseSniperRifleFire(Other) != None )
		Recoil = 0.90 - (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 80% recoil reduction with Crossbow/Winchester/Handcannon
	else if ( Crossbow(Other.Weapon) != none || Winchester(Other.Weapon) != none ||
		 Single(Other.Weapon) != none || Dualies(Other.Weapon) != none ||
		 Deagle(Other.Weapon) != none || DualDeagle(Other.Weapon) != none ||
		 M14EBRBattleRifle(Other.Weapon) != none || M99SniperRifle(Other.Weapon) != none ||
		 Magnum44Pistol(Other.Weapon) != none || Dual44Magnum(Other.Weapon) != none ||
		 MK23Pistol(Other.Weapon) != none || DualMK23Pistol(Other.Weapon) != none ||
		 UM_MK23Pistol(Other.Weapon) != none ||
		 UM_DualMK23Pistol(Other.Weapon) != none || Braindead_HuntingRifle(Other.Weapon) != none ||
		 UM_M99SniperRifle(Other.Weapon) != none || UM_Crossbow(Other.Weapon) != none ||
		 OperationY_SVDLLI(Other.Weapon) != none || OperationY_V94SniperRifle(Other.Weapon) != none ||
		 OperationY_HK417BattleRifle(Other.Weapon) != none || 
		 Whisky_ColtM1911Pistol(Other.Weapon) != none ||
		 OperationY_VSSDT(Other.Weapon) != none || OperationY_G2ContenderPistol(Other.Weapon) != none ||
		 SPSniperRifle(Other.Weapon) != none )
		Recoil = 0.90 - (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 80% recoil reduction with Crossbow/Winchester/Handcannon
	else
		Recoil = 1.00;

	Return Recoil;
}

// Modify fire speed
static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if ( (UM_BaseBoltActSniperRifle(Other) != None ||
			Winchester(Other) != none || Crossbow(Other) != none ||
			M99SniperRifle(Other) != none || Braindead_HuntingRifle(Other) != none ||
			UM_M99SniperRifle(Other) != none || UM_Crossbow(Other) != none ||
			OperationY_G2ContenderPistol(Other) != none || SPSniperRifle(Other) != none)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster fire rate with Winchester

	Return 1.00;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (UM_BaseAutomaticSniperRifle(Other) != None ||
			 UM_BaseBattleRifle(Other) != None ||
			 UM_BaseHandgun(Other) != None ||
			 UM_BaseSniperRifle(Other) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		 Return 1.00 + (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster reload with Crossbow/Winchester/Handcannon
	else if ( (Crossbow(Other) != none || Winchester(Other) != none ||
			 Single(Other) != none || Dualies(Other) != none ||
			 Deagle(Other) != none || DualDeagle(Other) != none ||
			 MK23Pistol(Other) != none || DualMK23Pistol(Other) != none ||
			 M14EBRBattleRifle(Other) != none || Magnum44Pistol(Other) != none ||
			 Dual44Magnum(Other) != none || UM_MK23Pistol(Other) != none ||
			 UM_DualMK23Pistol(Other) != none || Braindead_HuntingRifle(Other) != none ||
			 UM_M99SniperRifle(Other) != none || UM_Crossbow(Other) != none ||
			 OperationY_SVDLLI(Other) != none || OperationY_V94SniperRifle(Other) != none ||
			 OperationY_HK417BattleRifle(Other) != none || 
			 Whisky_ColtM1911Pistol(Other) != none ||
			 OperationY_VSSDT(Other) != none || OperationY_G2ContenderPistol(Other) != none ||
			 SPSniperRifle(Other) != none)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster reload with Crossbow/Winchester/Handcannon

	Return 1.00;
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel > 1 )
		Return (3 * Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 30 Zed Time Extensions

	Return 0;
}

// Get nades type.
/*static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		return class'UM_StunGrenade'; // Cluster Grenade

	return super.GetNadeType(KFPRI);
}*/

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseAutomaticSniperRiflePickup>(Item) != None || 
		 Class<UM_BaseBattleRiflePickup>(Item) != None ||
		 Class<UM_BaseHandgunPickup>(Item) != None ||
		 Class<UM_BaseSniperRiflePickup>(Item) != None )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount
	else if ( Item == class'DeaglePickup' || Item == class'DualDeaglePickup' ||
		 Item == class'MK23Pickup' || Item == class'DualMK23Pickup' ||
		 Item == class'Magnum44Pickup' || Item == class'Dual44MagnumPickup' ||
		 Item == class'M14EBRPickup' || Item == class'M99Pickup' ||
		 Item == class'Braindead_HuntingRiflePickup' || Item == class'SinglePickup' ||
		 Item == class'DualiesPickup' || Item == class'CrossbowPickup' ||
		 Item == class'UM_MK23Pickup' || Item == class'UM_DualMK23Pickup' ||
		 Item == class'OperationY_SVDLLIPickup' || Item == class'OperationY_V94Pickup' ||
		 Item == class'OperationY_HK417Pickup' || Item == class'Whisky_ColtM1911Pickup' ||
		 Item == class'OperationY_VSSDTPickup' || Item == class'OperationY_G2ContenderPickup' ||
		 Item == class'OperationY_M82A1LLIPickup' || Item == class'OperationY_L96AWPLLIPickup' ||
		 Item == class'Maria_Cz75LaserPickup' || Item == class'SPSniperPickup' || 
		 Item == class'GoldenDeaglePickup' || Item == class'GoldenDualDeaglePickup' ||
		 Item == class'WinchesterPickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on Handcannon/Dual Handcannons/EBR/44 Magnum(s)

	Return 1.00;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( (Class<UM_BaseAutomaticSniperRiflePickup>(Item) != None || 
		 Class<UM_BaseBattleRiflePickup>(Item) != None ||
		 Class<UM_BaseHandgunPickup>(Item) != None ||
		 Class<UM_BaseSniperRiflePickup>(Item) != None) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 60% discount on ammo
	else if ( (Item == class'CrossbowPickup' || Item == class'M99Pickup' ||
			Item == class'OperationY_SVDLLIPickup' || Item == class'OperationY_V94Pickup' ||
			Item == class'OperationY_HK417Pickup' || Item == class'OperationY_VSSDTPickup' ||
			Item == class'OperationY_G2ContenderPickup' || Item == Class'M14EBRPickup' ||
			Item == class'OperationY_M82A1LLIPickup' || Item == class'WinchesterPickup')
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 60% discount on ammo

	Return 1.00;
}

static function float GetSpreadModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.00 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 50% bonus
	
	Return 1.0;
}

static function float GetAimErrorModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.00 - (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 70% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.000 - (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 70% bonus
	
	Return 1.0;
}

static function float GetShakeViewModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.000 - (0.025 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 25% bonus
	
	Return 1.0;
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	local	int		ExtraAmmo;
	
	if ( KFPRI.ClientVeteranSkillLevel >= 7 )
		KFHumanPawn(P).RequiredEquipment[1] = "";	// Remove KFMod.Single (Beretta92)
	
	if ( UM_HumanPawn(P) != None )
	{
		switch ( KFPRI.ClientVeteranSkillLevel )
		{
			case 8:
				ExtraAmmo = 2 * class'Winchester'.default.MagCapacity;
			case 7:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_WinchesterM1894Rifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_WinchesterM1894Pickup'), ExtraAmmo, 0);
			case 6:
				ExtraAmmo = 3 * class'UM_MK23Pistol'.default.MagCapacity;
			case 5:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_MK23Pistol", GetCostScaling(KFPRI, class'UnlimaginMod.UM_MK23Pickup'), ExtraAmmo, 0);
				Break;
			
			case 10:
				ExtraAmmo = 6;
			case 9:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_Crossbow", GetCostScaling(KFPRI, class'UnlimaginMod.UM_CrossbowPickup'), ExtraAmmo, 0);
				ExtraAmmo = 3 * class'UM_MK23Pistol'.default.MagCapacity;
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_MK23Pistol", GetCostScaling(KFPRI, class'UnlimaginMod.UM_MK23Pickup'), ExtraAmmo, 0);
				Break;
		}
	}
	else
	{
		switch ( KFPRI.ClientVeteranSkillLevel )
		{
			case 7:
			case 8:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_WinchesterM1894Rifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_WinchesterM1894Pickup'));
			case 5:
			case 6:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_MK23Pistol", GetCostScaling(KFPRI, class'UnlimaginMod.UM_MK23Pickup'));
				Break;
			
			case 10:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_Crossbow", GetCostScaling(KFPRI, class'UnlimaginMod.UM_CrossbowPickup'));
			case 9:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_MK23Pistol", GetCostScaling(KFPRI, class'UnlimaginMod.UM_MK23Pickup'));
				Break;
		}
	}
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr((1.1 + (0.05 * float(Level)))));
	ReplaceText(S,"%p",GetPercentStr(0.1 * float(Level)));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	return S;
}

defaultproperties
{
	PerkIndex=2

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_SharpShooter'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_SharpShooter_Gold'
	VeterancyName="Sharpshooter"
	Requirements[0]="Get %x headshot kills with Pistols, Rifle, Crossbow, M14, or M99"

	SRLevelEffects(0)="5% more damage with Pistols, Rifle, Crossbow, M14, and M99|5% extra Headshot damage with all weapons|10% discount on Handcannon/M14"
	SRLevelEffects(1)="10% more damage with Pistols, Rifle, Crossbow, M14, and M99|25% less recoil with Pistols, Rifle, Crossbow, M14, and M99|10% faster reload with Pistols, Rifle, Crossbow, M14, and M99|10% extra headshot damage|20% discount on Handcannon/44 Magnum/M14/M99"
	SRLevelEffects(2)="15% more damage with Pistols, Rifle, Crossbow, M14, and M99|50% less recoil with Pistols, Rifle, Crossbow, M14, and M99|20% faster reload with Pistols, Rifle, Crossbow, M14, and M99|20% extra headshot damage|30% discount on Handcannon/44 Magnum/M14/M99"
	SRLevelEffects(3)="20% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|30% faster reload with Pistols, Rifle, Crossbow, M14, and M99|30% extra headshot damage|40% discount on Handcannon/44 Magnum/M14/M99"
	SRLevelEffects(4)="30% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|40% faster reload with Pistols, Rifle, Crossbow, M14, and M99|40% extra headshot damage|50% discount on Handcannon/44 Magnum/M14/M99"
	SRLevelEffects(5)="50% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|50% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|60% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Lever Action Rifle"
	SRLevelEffects(6)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
	SRLevelEffects(7)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
	SRLevelEffects(8)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
	SRLevelEffects(9)="60% more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|60% faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|70% discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
	
	CustomLevelInfo="%s more damage with Pistols, Rifle, Crossbow, M14, and M99|75% less recoil with Pistols, Rifle, Crossbow, M14, and M99|%p faster reload with Pistols, Rifle, Crossbow, M14, and M99|50% extra headshot damage|%d discount on Handcannon/44 Magnum/M14/M99|Spawn with a Crossbow"
}