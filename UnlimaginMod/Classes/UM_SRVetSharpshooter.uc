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

static function int GetPerkProgressInt( UM_ClientRepInfoLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
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
	else if ( Crossbow(Other.Weapon) != None || Winchester(Other.Weapon) != None ||
		 Single(Other.Weapon) != None || Dualies(Other.Weapon) != None ||
		 Deagle(Other.Weapon) != None || DualDeagle(Other.Weapon) != None ||
		 M14EBRBattleRifle(Other.Weapon) != None || M99SniperRifle(Other.Weapon) != None ||
		 Magnum44Pistol(Other.Weapon) != None || Dual44Magnum(Other.Weapon) != None ||
		 MK23Pistol(Other.Weapon) != None || DualMK23Pistol(Other.Weapon) != None ||
		 UM_MK23Pistol(Other.Weapon) != None ||
		 UM_DualMK23Pistol(Other.Weapon) != None || Braindead_HuntingRifle(Other.Weapon) != None ||
		 UM_M99SniperRifle(Other.Weapon) != None || UM_Crossbow(Other.Weapon) != None ||
		 OperationY_SVDLLI(Other.Weapon) != None || OperationY_V94SniperRifle(Other.Weapon) != None ||
		 OperationY_HK417BattleRifle(Other.Weapon) != None || 
		 Whisky_ColtM1911Pistol(Other.Weapon) != None ||
		 OperationY_VSSDT(Other.Weapon) != None || OperationY_G2ContenderPistol(Other.Weapon) != None ||
		 SPSniperRifle(Other.Weapon) != None )
		Recoil = 0.90 - (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 80% recoil reduction with Crossbow/Winchester/Handcannon
	else
		Recoil = 1.00;

	Return Recoil;
}

// Modify fire speed
static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if ( (UM_BaseBoltActSniperRifle(Other) != None ||
			Winchester(Other) != None || Crossbow(Other) != None ||
			M99SniperRifle(Other) != None || Braindead_HuntingRifle(Other) != None ||
			UM_M99SniperRifle(Other) != None || UM_Crossbow(Other) != None ||
			OperationY_G2ContenderPistol(Other) != None || SPSniperRifle(Other) != None)
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
	else if ( (Crossbow(Other) != None || Winchester(Other) != None ||
			 Single(Other) != None || Dualies(Other) != None ||
			 Deagle(Other) != None || DualDeagle(Other) != None ||
			 MK23Pistol(Other) != None || DualMK23Pistol(Other) != None ||
			 M14EBRBattleRifle(Other) != None || Magnum44Pistol(Other) != None ||
			 Dual44Magnum(Other) != None || UM_MK23Pistol(Other) != None ||
			 UM_DualMK23Pistol(Other) != None || Braindead_HuntingRifle(Other) != None ||
			 UM_M99SniperRifle(Other) != None || UM_Crossbow(Other) != None ||
			 OperationY_SVDLLI(Other) != None || OperationY_V94SniperRifle(Other) != None ||
			 OperationY_HK417BattleRifle(Other) != None || 
			 Whisky_ColtM1911Pistol(Other) != None ||
			 OperationY_VSSDT(Other) != None || OperationY_G2ContenderPistol(Other) != None ||
			 SPSniperRifle(Other) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster reload with Crossbow/Winchester/Handcannon

	Return 1.00;
}

// Set number times Zed Time can be extended
static function float GetMaxSlowMoCharge( UM_PlayerReplicationInfo PRI )
{
	Return 5.0 + 1.0 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 15 SlowMo seconds
}

// Get nades type.
/*static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		Return class'UM_StunGrenade'; // Cluster Grenade

	Return super.GetNadeType(KFPRI);
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

// Pawn Movement Bonus while wielding this weapon
static function float GetWeaponPawnMovementBonus( UM_PlayerReplicationInfo PRI, Weapon W )
{
	if ( PRI.ClientVeteranSkillLevel > 0 &&
		 (UM_BaseHandgun(W) != None || UM_BaseSniperRifle(W) != None 
		  || UM_BaseBattleRifle(W) != None || UM_BaseAutomaticSniperRifle(W) != None) )
		Return 1.00 + 0.01 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 10% bonus
	
	Return 1.0;
}

// Bonus for the Pawn IntuitiveShootingRange
static function float GetIntuitiveShootingModifier( UM_PlayerReplicationInfo PRI )
{
	if ( PRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 + 0.025 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 25% IntuitiveShootingRange bonus
	
	Return 1.0;
}

static function float GetSpreadModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.0 - 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 50% bonus
	
	Return 1.0;
}

static function float GetAimErrorModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.0 - 0.07 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 70% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.0 - 0.07 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 70% bonus
	
	Return 1.0;
}

static function float GetShakeViewModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAutomaticSniperRifleFire(WF) != None
			 || UM_BaseBattleRifleFire(WF) != None 
			 || UM_BaseHandgunFire(WF) != None
			 || UM_BaseSniperRifleFire(WF) != None) )
		Return 1.0 - 0.025 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 25% bonus
	
	Return 1.0;
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr((1.1 + (0.05 * float(Level)))));
	ReplaceText(S,"%p",GetPercentStr(0.1 * float(Level)));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	Return S;
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
	
	// StandardEquipment
	StandardEquipment(1)=(ClassName="KFMod.Single",MaxLevel=6)
	// AdditionalEquipment
	AdditionalEquipment(0)=(ClassName="UnlimaginMod.UM_WinchesterM1894Rifle",MinLevel=5,MaxLevel=7)
	AdditionalEquipment(1)=(ClassName="UnlimaginMod.UM_MK23Pistol",MinLevel=7)
	AdditionalEquipment(2)=(ClassName="UnlimaginMod.UM_Crossbow",MinLevel=8)
}