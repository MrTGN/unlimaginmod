//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetCommando
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
class UM_SRVetCommando extends UM_SRVeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
	case 0:
		// if( ReqNum==0 )
			// FinalInt = 5;
		// else
			// FinalInt = 5000;
		if( ReqNum==0 )
			FinalInt = 0;
		else
			FinalInt = 0;
		Break;
	case 1:
		if( ReqNum==0 )
			FinalInt = 50;
		else
			FinalInt = 50000;
		Break;
	case 2:
		if( ReqNum==0 )
			FinalInt = 400;
		else
			FinalInt = 400000;
		Break;
	case 3:
		if( ReqNum==0 )
			FinalInt = 1050;
		else
			FinalInt = 1050000;
		Break;
	case 4:
		if( ReqNum==0 )
			FinalInt = 2000;
		else
			FinalInt = 2000000;
		Break;
	case 5:
		if( ReqNum==0 )
			FinalInt = 3250;
		else
			FinalInt = 3250000;
		Break;
	case 6:
		if( ReqNum==0 )
			FinalInt = 4800;
		else
			FinalInt = 4800000;
		Break;
	case 7:
		if( ReqNum==0 )
			FinalInt = 6650;
		else
			FinalInt = 6650000;
		Break;
	case 8:
		if( ReqNum==0 )
			FinalInt = 8800;
		else
			FinalInt = 8800000;
		Break;
	case 9:
		if( ReqNum==0 )
			FinalInt = 11250;
		else
			FinalInt = 11250000;
		Break;
	case 10:
		if( ReqNum==0 )
			FinalInt = 14000;
		else
			FinalInt = 14000000;
		Break;
	default:
		if( ReqNum==0 )
			FinalInt = (50 * (CurLevel + 1)) + ((CurLevel - 1) * 250 - 50) + (50 * CurLevel) + ((CurLevel - 2) * 250 - 50);
		else
			FinalInt = (50000 * (CurLevel + 1)) + ((CurLevel - 1) * 250000 - 50000) + (50000 * CurLevel) + ((CurLevel - 2) * 250000 - 50000);
		Break;
	/*default:
		if( ReqNum==0 )
			FinalInt = 3600+GetDoubleScaling(CurLevel,350);
		else FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);*/
	}
	if( ReqNum==0 )
		Return Min(StatOther.RStalkerKillsStat,FinalInt);
	
	Return Min(StatOther.RBullpupDamageStat,FinalInt);
}

// Display enemy health bars
static function SpecialHUDInfo(KFPlayerReplicationInfo KFPRI, Canvas C)
{
	local	KFMonster			KFEnemy;
	local	HUDKillingFloor		HKF;
	local	float				MaxDistance;

	if ( KFPRI.ClientVeteranSkillLevel > 0 )  {
		HKF = HUDKillingFloor(C.ViewPort.Actor.myHUD);
		if ( HKF == None || Pawn(C.ViewPort.Actor.ViewTarget) == None 
			 || Pawn(C.ViewPort.Actor.ViewTarget).Health <= 0 )
			Return;

		MaxDistance = 120.0 * Min(KFPRI.ClientVeteranSkillLevel, 10); // Up to 1200 units
		
		foreach C.ViewPort.Actor.VisibleCollidingActors( class'KFMonster', KFEnemy, MaxDistance, C.ViewPort.Actor.CalcViewLocation )
		{
			if ( KFEnemy.Health > 0 && !KFEnemy.Cloaked() )
				HKF.DrawHealthBar(C, KFEnemy, KFEnemy.Health, KFEnemy.HealthMax , 50.0);
		}
	}
}

static function bool ShowStalkers(KFPlayerReplicationInfo KFPRI)
{
	Return True;
}

static function float GetStalkerViewDistanceMulti(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
		Return (0.15 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)));	// Up to 1.5 * 800 unreal units
	
	Return 0.0625; // 25%
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (UM_BaseAssaultRifle(Other) != None ||
			 UM_BasePDW(Other) != None ||
			 UM_BaseSMG(Other) != None ) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 50% more MagCapacity 
	else if ( (Bullpup(Other) != none || AK47AssaultRifle(Other) != none || 
			 SCARMK17AssaultRifle(Other) != none || M4AssaultRifle(Other) != none || 
			 FNFAL_ACOG_AssaultRifle(Other) != none || M4203AssaultRifle(Other) != none ||
			 UM_FNFAL_ACOG_AssaultRifle(Other) != none || MAC10MP(Other) != none ||
			 MKb42AssaultRifle(Other) != none || ThompsonSMG(Other) != none ||
			 FluX_G36CAssaultRifle(Other) != none || Maria_M16A4_IronSight(Other) != none ||
			 Maria_M16A4_Aimpoint(Other) != none || GoldenAK47AssaultRifle(Other) != none ||
			 JSullivan_L85A2AssaultRifle(Other) != none || Braindead_MP5A4SMG(Other) != none ||
			 Braindead_MP5K_Dual(Other) != none || Braindead_MP5SD(Other) != none ||
			 Exod_BlueStahli_XMV850Minigun(Other) != none || Exod_PooSH_StingerMinigun(Other) != none ||
			 ZedekPD_Type19PDW(Other) != none || ZedekPD_XM8AssaultRifle(Other) != none ||
			 OperationY_UMP45SMG(Other) != none || OperationY_PKM(Other) != none ||
			 ThompsonDrumSMG(Other) != none || SPThompsonSMG(Other) != none)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 50% more MagCapacity 

	Return 1.00;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if ( (UM_BaseAssaultRifleAmmo(Other) != None || UM_BaseMachineGunAmmo(Other) != None ||
			 UM_BasePDWAmmo(Other) != None || UM_BaseSMGAmmo(Other) != None) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)));
	else if ( (BullpupAmmo(Other) != none || AK47Ammo(Other) != none || 
			 SCARMK17Ammo(Other) != none || M4Ammo(Other) != none || 
			 FNFALAmmo(Other) != none || MAC10Ammo(Other) != none ||
			 MKb42Ammo(Other) != none || ThompsonAmmo(Other) != none ||
			 FluX_G36CAmmo(Other) != none || JSullivan_L85A2Ammo(Other) != none ||
			 Maria_M16A4Ammo(Other) != none || Braindead_MP5A4Ammo(Other) != none ||
			 Braindead_MP5KAmmo(Other) != none || Exod_BlueStahli_XMV850Ammo(Other) != none ||
			 Exod_PooSH_StingerMinigunAmmo(Other) != none || ZedekPD_Type19Ammo(Other) != none ||
			 ZedekPD_XM8Ammo(Other) != none || OperationY_UMP45Ammo(Other) != none ||
			 OperationY_PKMAmmo(Other) != none || ThompsonDrumAmmo(Other) != none || 
			 SPThompsonAmmo(Other) != none || OperationY_VALDTAmmo(Other) != none) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)));
	
	Return 1.00;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( (Class<UM_BaseAssaultRifleAmmo>(AmmoType) != None || 
			 Class<UM_BaseMachineGunAmmo>(AmmoType) != None || 
			 Class<UM_BasePDWAmmo>(AmmoType) != None || 
			 Class<UM_BaseSMGAmmo>(AmmoType) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 0.00 + (1.0 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // 25% increase ammo carry
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel >= 5 )
		Return 0.2 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 6))); // Up to 7 nades on 6 lvl
	else if ( AmmoType == class'M203Ammo' && KFPRI.ClientVeteranSkillLevel > 6 )
		Return 0.40 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 40% increase M203 ammo
	else if ( (AmmoType == class'BullpupAmmo' || AmmoType == class'AK47Ammo' || 
				AmmoType == class'M4Ammo' || AmmoType == class'M4203Ammo' || 
				AmmoType == class'MAC10Ammo' || AmmoType == class'ThompsonAmmo' ||
				AmmoType == class'MKb42Ammo' || 
				AmmoType == class'Maria_M16A4Ammo' || 
				AmmoType == class'Exod_BlueStahli_XMV850Ammo' ||
				AmmoType == class'Exod_PooSH_StingerMinigunAmmo' ||
				AmmoType == class'Braindead_MP5KAmmo' ||
				AmmoType == class'ThompsonDrumAmmo' || AmmoType == class'SPThompsonAmmo' ||
				AmmoType == class'OperationY_VALDTAmmo' || AmmoType == class'GoldenAK47Ammo')
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // 25% increase in assault rifle ammo carry
	else if ( (AmmoType == class'JSullivan_L85A2Ammo' ||
				AmmoType == class'ZedekPD_XM8Ammo' ||
				AmmoType == class'FluX_G36CAmmo')
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // Up to 40% more ammo
	else if ( (AmmoType == class'SCARMK17Ammo' ||
				AmmoType == class'Braindead_MP5SDAmmo' ||
				AmmoType == class'Braindead_MP5A4Ammo' ||
				AmmoType == class'ZedekPD_Type19Ammo') 
				 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // 20% increase in assault rifle ammo carry
	else if ( AmmoType == class'FNFALAmmo'
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 6))); // 30% increase in assault rifle ammo carry
	else if ( AmmoType == class'OperationY_UMP45Ammo'
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.07 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // 35% increase in assault rifle ammo carry
	else if  ( (AmmoType == class'OperationY_PKMAmmo' ||
				AmmoType == class'OperationY_AUG_A1ARAmmo')
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))); // 50% increase in PKM ammo carry 
		
	Return 1.00;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn DamageTaker, int InDamage, class<DamageType> DmgType)
{
	if ( Class<UM_BaseDamType_SMG>(DmgType) != None || 
		 Class<UM_BaseDamType_AssaultRifle>(DmgType) != None || 
		 Class<UM_BaseDamType_MachineGun>(DmgType) != None ||
		 class<UM_BaseDamType_PDW>(DmgType) != None ||
		 DmgType == class'DamTypeBullpup' || DmgType == class'DamTypeAK47AssaultRifle' || 
		 DmgType == class'DamTypeSCARMK17AssaultRifle' || DmgType == class'DamTypeM4AssaultRifle' || 
		 DmgType == class'DamTypeFNFALAssaultRifle' || DmgType == class'DamTypeM4203AssaultRifle' || 
		 DmgType == class'DamTypeMKb42AssaultRifle' || DmgType == class'DamTypeThompson' ||
		 DmgType == class'DamTypeThompsonDrum' || DmgType == class'DamTypeSPThompson' )
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
			return float(InDamage) * 1.05;
		
		return float(InDamage) * (1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // Up to 50% increase in Damage with Bullpup
	}
	
	return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	if ( UM_BaseAssaultRifleFire(Other) != None ||
		 UM_BasePDWFire(Other) != None ||
		 UM_BaseSMGFire(Other) != None ||
		 Bullpup(Other.Weapon) != none || AK47AssaultRifle(Other.Weapon) != none || 
		 SCARMK17AssaultRifle(Other.Weapon) != none || M4AssaultRifle(Other.Weapon) != none || 
		 FNFAL_ACOG_AssaultRifle(Other.Weapon) != none || M4203AssaultRifle(Other.Weapon) != none ||
		 UM_FNFAL_ACOG_AssaultRifle(Other.Weapon) != none || 
		 MAC10MP(Other.Weapon) != none || MKb42AssaultRifle(Other.Weapon) != none || 
		 ThompsonSMG(Other.Weapon) != none || Maria_M16A4_Aimpoint(Other.Weapon) != none || 
		 Maria_M16A4_IronSight(Other.Weapon) != none || FluX_G36CAssaultRifle(Other.Weapon) != none ||
		 GoldenAK47AssaultRifle(Other.Weapon) != none || JSullivan_L85A2AssaultRifle(Other.Weapon) != none ||
		 Braindead_MP5A4SMG(Other.Weapon) != none || Braindead_MP5K_Dual(Other.Weapon) != none || 
		 Braindead_MP5SD(Other.Weapon) != none || Exod_BlueStahli_XMV850Minigun(Other.Weapon) != none || 
		 Exod_PooSH_StingerMinigun(Other.Weapon) != none || ZedekPD_Type19PDW(Other.Weapon) != none || 
		 ZedekPD_XM8AssaultRifle(Other.Weapon) != none || OperationY_UMP45SMG(Other.Weapon) != none  ||
		 OperationY_PKM(Other.Weapon) != none || ThompsonDrumSMG(Other.Weapon) != none ||
		 SPThompsonSMG(Other.Weapon) != none )
		Recoil = 0.95 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,8))); // Up to 45% recoil reduction
	else
		Recoil = 1.00;

	Return Recoil;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( UM_BaseSMG(Other) != None ||
		 UM_M4AssaultRifle(Other) != none ||
		 M4AssaultRifle(Other) != none ||
		 MAC10MP(Other) != none || FNFAL_ACOG_AssaultRifle(Other) != none || 
		 UM_FNFAL_ACOG_AssaultRifle(Other) != none ||
		 Braindead_MP5A4SMG(Other) != none || Braindead_MP5K_Dual(Other) != none || 
		 Braindead_MP5SD(Other) != none || OperationY_UMP45SMG(Other) != none )
		Return 1.10 + (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster reload speed on Bonus weapons (SMG, M4, etc.)

	Return 1.05 + (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 45% faster reload speed on all other weapons
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
	Return 10 + (5 * Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 60 Zed Time Extensions
}

/*
// Get nades type.
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		return class'UM_StickySensorHandGrenade'; // Sticky Grenade

	return super.GetNadeType(KFPRI);
} */

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseAssaultRiflePickup>(Item) != None || 
		 Class<UM_BaseMachineGunPickup>(Item) != None || 
		 Class<UM_BasePDWPickup>(Item) != None || 
		 Class<UM_BaseSMGPickup>(Item) != None )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount
	else if ( Item == class'BullpupPickup' || Item == class'AK47Pickup' || 
		 Item == class'SCARMK17Pickup' || Item == class'M4Pickup' || 
		 Item == class'FNFAL_ACOG_Pickup' ||
		 Item == class'MAC10Pickup' || Item == class'MKb42Pickup' || 
		 Item == class'ThompsonPickup' || Item == class'Maria_M16A4_AimpointPickup' ||
		 Item == class'Maria_M16A4_IronSightPickup' || Item == class'FluX_G36CPickup' ||
		 Item == class'GoldenAK47Pickup' || Item == class'JSullivan_L85A2Pickup' ||
		 Item == class'Braindead_MP5A4Pickup' || Item == class'Braindead_MP5K_DualPickup' ||
		 Item == class'Braindead_MP5SDPickup' || Item == class'Exod_BlueStahli_XMV850Pickup' ||
		 Item == class'Exod_PooSH_StingerMinigunPickup' || Item == class'ZedekPD_Type19Pickup' ||
		 Item == class'ZedekPD_XM8Pickup' || Item == class'OperationY_UMP45Pickup' ||
		 Item == class'OperationY_PKMPickup' || Item == class'OperationY_UMP45EOTechPickup' ||
		 Item == class'ThompsonDrumPickup' || Item == class'SPThompsonPickup' ||
		 Item == class'OperationY_VALDTPickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on Assault Rifles
	else if ( Item == class'M4203Pickup' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 50% discount on M4203
	
	Return 1.00;
}

static function float GetSpreadModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 
		 && (UM_BaseAssaultRifleFire(WF) != None 
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None 
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - (0.025 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 25% bonus
	
	Return 1.0;
}

static function float GetAimErrorModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 50% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 40% bonus
	
	Return 1.0;
}

static function float GetShakeViewModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	if ( KFPRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - (0.02 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 20% bonus
	
	Return 1.0;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	local	int		ExtraAmmo;
	
	if ( UM_SRHumanPawn(P) != None )
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 6:
				ExtraAmmo = 2 * class'Braindead_MP5A4SMG'.default.MagCapacity * (1.00 + 0.05 * 6);
			case 5:
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.Braindead_MP5A4SMG", GetCostScaling(KFPRI, class'UnlimaginMod.Braindead_MP5A4Pickup'), ExtraAmmo, 0);
				Break;
			
			case 8:
				ExtraAmmo = 2 * class'UM_M4AssaultRifle'.default.MagCapacity * (1.00 + 0.05 * 8);
			case 7:
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_M4AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_M4Pickup'), ExtraAmmo, 0);
				Break;
			
			case 9:
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_AK47AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_AK47Pickup'));
				Break;
			
			case 10:
				ExtraAmmo = 2 * class'UM_GoldenAK47AssaultRifle'.default.MagCapacity * (1.00 + 0.05 * 10);
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_GoldenAK47AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_GoldenAK47Pickup'), ExtraAmmo, 0);
				Break;
		}
	}
	else
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 5:
			case 6:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.Braindead_MP5A4SMG", GetCostScaling(KFPRI, class'UnlimaginMod.Braindead_MP5A4Pickup'));
				Break;
			
			case 7:
			case 8:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_M4AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_M4Pickup'));
				Break;
			
			case 9:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_AK47AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_AK47Pickup'));
				Break;
			
			case 10:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_GoldenAK47AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_GoldenAK47Pickup'));
				Break;
		}
	}
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.05 * float(Level)+0.05));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	ReplaceText(S,"%z",string(Level-2));
	ReplaceText(S,"%r",GetPercentStr(FMin(0.05 * float(Level)+0.1,1.f)));
	return S;
}

defaultproperties
{
	PerkIndex=3

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Commando'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Commando_Gold'
	VeterancyName="Commando"
	Requirements[0]="Kill %x Stalkers with Assault/Battle Rifles"
	Requirements[1]="Deal %x damage with Assault/Battle Rifles"
	NumRequirements=2

	SRLevelEffects(0)="5% more damage with Assault/Battle Rifles|5% less recoil with Assault/Battle Rifles|5% faster reload with all weapons|10% discount on Assault/Battle Rifles|Can see cloaked Stalkers from 4 meters"
	SRLevelEffects(1)="10% more damage with Assault/Battle Rifles|10% less recoil with Assault/Battle Rifles|10% larger Assault/Battle Rifles clip|10% faster reload with all weapons|20% discount on Assault/Battle Rifles|Can see cloaked Stalkers from 8m|Can see enemy health from 4m"
	SRLevelEffects(2)="20% more damage with Assault/Battle Rifles|15% less recoil with Assault/Battle Rifles|20% larger Assault/Battle Rifles clip|15% faster reload with all weapons|30% discount on Assault/Battle Rifles|Can see cloaked Stalkers from 10m|Can see enemy health from 7m"
	SRLevelEffects(3)="30% more damage with Assault/Battle Rifles|20% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|20% faster reload with all weapons|40% discount on Assault/Battle Rifles|Can see cloaked Stalkers from 12m|Can see enemy health from 10m|Zed-Time can be extended by killing an enemy while in slow motion"
	SRLevelEffects(4)="40% more damage with Assault/Battle Rifles|30% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|25% faster reload with all weapons|50% discount on Assault/Battle Rifles|Can see cloaked Stalkers from 14m|Can see enemy health from 13m|Up to 2 Zed-Time Extensions"
	SRLevelEffects(5)="50% more damage with Assault/Battle Rifles|30% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|30% faster reload with all weapons|60% discount on Assault/Battle Rifles|Spawn with a Bullpup|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 3 Zed-Time Extensions"
	SRLevelEffects(6)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
	SRLevelEffects(7)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
	SRLevelEffects(8)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
	SRLevelEffects(9)="50% more damage with Assault/Battle Rifles|40% less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|35% faster reload with all weapons|70% discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to 4 Zed-Time Extensions"
	
	CustomLevelInfo="50% more damage with Assault/Battle Rifles|%r less recoil with Assault/Battle Rifles|25% larger Assault/Battle Rifles clip|%s faster reload with all weapons|%d discount on Assault/Battle Rifles|Spawn with an AK47|Can see cloaked Stalkers from 16m|Can see enemy health from 16m|Up to %z Zed-Time Extensions"
}