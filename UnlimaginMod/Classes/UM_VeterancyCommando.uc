//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_VeterancyCommando
//	Parent class:	 UM_VeterancyTypes
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 30.09.2012 20:31
//================================================================================
class UM_VeterancyCommando extends UM_VeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_ClientRepInfoLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
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
		Return 0.15 * float(Min(KFPRI.ClientVeteranSkillLevel, 10));	// Up to 1.5 * 800 unreal units
	
	Return 0.0625; // 25%
}

// Pawn Movement Bonus while wielding this weapon
static function float GetWeaponPawnMovementBonus( UM_PlayerReplicationInfo PRI, Weapon W )
{
	if ( PRI.ClientVeteranSkillLevel > 0 &&
		 (UM_BaseAssaultRifle(W) != None || UM_BasePDW(W) != None || UM_BaseSMG(W) != None) )
		Return 1.00 + 0.01 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 10% bonus
	
	Return 1.0;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (UM_BaseAssaultRifle(Other) != None ||
			 UM_BasePDW(Other) != None ||
			 UM_BaseSMG(Other) != None ) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 50% more MagCapacity 
	else if ( (Bullpup(Other) != None || AK47AssaultRifle(Other) != None || 
			 SCARMK17AssaultRifle(Other) != None || M4AssaultRifle(Other) != None || 
			 FNFAL_ACOG_AssaultRifle(Other) != None || M4203AssaultRifle(Other) != None ||
			 UM_FNFAL_ACOG_AssaultRifle(Other) != None || MAC10MP(Other) != None ||
			 MKb42AssaultRifle(Other) != None || ThompsonSMG(Other) != None ||
			 FluX_G36CAssaultRifle(Other) != None || Maria_M16A4_IronSight(Other) != None ||
			 Maria_M16A4_Aimpoint(Other) != None || GoldenAK47AssaultRifle(Other) != None ||
			 JSullivan_L85A2AssaultRifle(Other) != None || Braindead_MP5A4SMG(Other) != None ||
			 Braindead_MP5K_Dual(Other) != None || Braindead_MP5SD(Other) != None ||
			 Exod_BlueStahli_XMV850Minigun(Other) != None || Exod_PooSH_StingerMinigun(Other) != None ||
			 ZedekPD_Type19PDW(Other) != None || ZedekPD_XM8AssaultRifle(Other) != None ||
			 OperationY_UMP45SMG(Other) != None || OperationY_PKM(Other) != None ||
			 ThompsonDrumSMG(Other) != None || SPThompsonSMG(Other) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 50% more MagCapacity 

	Return 1.00;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if ( (UM_BaseAssaultRifleAmmo(Other) != None || UM_BaseMachineGunAmmo(Other) != None ||
			 UM_BasePDWAmmo(Other) != None || UM_BaseSMGAmmo(Other) != None) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10));
	else if ( (BullpupAmmo(Other) != None || AK47Ammo(Other) != None || 
			 SCARMK17Ammo(Other) != None || M4Ammo(Other) != None || 
			 FNFALAmmo(Other) != None || MAC10Ammo(Other) != None ||
			 MKb42Ammo(Other) != None || ThompsonAmmo(Other) != None ||
			 FluX_G36CAmmo(Other) != None || JSullivan_L85A2Ammo(Other) != None ||
			 Maria_M16A4Ammo(Other) != None || Braindead_MP5A4Ammo(Other) != None ||
			 Braindead_MP5KAmmo(Other) != None || Exod_BlueStahli_XMV850Ammo(Other) != None ||
			 Exod_PooSH_StingerMinigunAmmo(Other) != None || ZedekPD_Type19Ammo(Other) != None ||
			 ZedekPD_XM8Ammo(Other) != None || OperationY_UMP45Ammo(Other) != None ||
			 OperationY_PKMAmmo(Other) != None || ThompsonDrumAmmo(Other) != None || 
			 SPThompsonAmmo(Other) != None || OperationY_VALDTAmmo(Other) != None) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10));
	
	Return 1.00;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( (Class<UM_BaseAssaultRifleAmmo>(AmmoType) != None || 
			 Class<UM_BaseMachineGunAmmo>(AmmoType) != None || 
			 Class<UM_BasePDWAmmo>(AmmoType) != None || 
			 Class<UM_BaseSMGAmmo>(AmmoType) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 0.00 + 1.0 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // 25% increase ammo carry
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel >= 5 )
		Return 0.2 + 0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 6)); // Up to 7 nades on 6 lvl
	else if ( AmmoType == class'M203Ammo' && KFPRI.ClientVeteranSkillLevel > 6 )
		Return 0.40 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 40% increase M203 ammo
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
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // 25% increase in assault rifle ammo carry
	else if ( (AmmoType == class'JSullivan_L85A2Ammo' ||
				AmmoType == class'ZedekPD_XM8Ammo' ||
				AmmoType == class'FluX_G36CAmmo')
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.08 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // Up to 40% more ammo
	else if ( (AmmoType == class'SCARMK17Ammo' ||
				AmmoType == class'Braindead_MP5SDAmmo' ||
				AmmoType == class'Braindead_MP5A4Ammo' ||
				AmmoType == class'ZedekPD_Type19Ammo') 
				 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // 20% increase in assault rifle ammo carry
	else if ( AmmoType == class'FNFALAmmo'
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 6)); // 30% increase in assault rifle ammo carry
	else if ( AmmoType == class'OperationY_UMP45Ammo'
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.07 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // 35% increase in assault rifle ammo carry
	else if  ( (AmmoType == class'OperationY_PKMAmmo' ||
				AmmoType == class'OperationY_AUG_A1ARAmmo')
			&& KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)); // 50% increase in PKM ammo carry 
		
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
			Return float(InDamage) * 1.05;
		
		Return float(InDamage) * (1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel, 5)))); // Up to 50% increase in Damage with Bullpup
	}
	
	Return InDamage;
}

static function float ModifyRecoilSpread(KFPlayerReplicationInfo KFPRI, WeaponFire Other, out float Recoil)
{
	if ( UM_BaseAssaultRifleFire(Other) != None ||
		 UM_BasePDWFire(Other) != None ||
		 UM_BaseSMGFire(Other) != None ||
		 Bullpup(Other.Weapon) != None || AK47AssaultRifle(Other.Weapon) != None || 
		 SCARMK17AssaultRifle(Other.Weapon) != None || M4AssaultRifle(Other.Weapon) != None || 
		 FNFAL_ACOG_AssaultRifle(Other.Weapon) != None || M4203AssaultRifle(Other.Weapon) != None ||
		 UM_FNFAL_ACOG_AssaultRifle(Other.Weapon) != None || 
		 MAC10MP(Other.Weapon) != None || MKb42AssaultRifle(Other.Weapon) != None || 
		 ThompsonSMG(Other.Weapon) != None || Maria_M16A4_Aimpoint(Other.Weapon) != None || 
		 Maria_M16A4_IronSight(Other.Weapon) != None || FluX_G36CAssaultRifle(Other.Weapon) != None ||
		 GoldenAK47AssaultRifle(Other.Weapon) != None || JSullivan_L85A2AssaultRifle(Other.Weapon) != None ||
		 Braindead_MP5A4SMG(Other.Weapon) != None || Braindead_MP5K_Dual(Other.Weapon) != None || 
		 Braindead_MP5SD(Other.Weapon) != None || Exod_BlueStahli_XMV850Minigun(Other.Weapon) != None || 
		 Exod_PooSH_StingerMinigun(Other.Weapon) != None || ZedekPD_Type19PDW(Other.Weapon) != None || 
		 ZedekPD_XM8AssaultRifle(Other.Weapon) != None || OperationY_UMP45SMG(Other.Weapon) != None  ||
		 OperationY_PKM(Other.Weapon) != None || ThompsonDrumSMG(Other.Weapon) != None ||
		 SPThompsonSMG(Other.Weapon) != None )
		Recoil = 0.95 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,8))); // Up to 45% recoil reduction
	else
		Recoil = 1.00;

	Return Recoil;
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( UM_BaseSMG(Other) != None ||
		 UM_M4AssaultRifle(Other) != None ||
		 M4AssaultRifle(Other) != None ||
		 MAC10MP(Other) != None || FNFAL_ACOG_AssaultRifle(Other) != None || 
		 UM_FNFAL_ACOG_AssaultRifle(Other) != None ||
		 Braindead_MP5A4SMG(Other) != None || Braindead_MP5K_Dual(Other) != None || 
		 Braindead_MP5SD(Other) != None || OperationY_UMP45SMG(Other) != None )
		Return 1.10 + (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 70% faster reload speed on Bonus weapons (SMG, M4, etc.)

	Return 1.05 + 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 45% faster reload speed on all other weapons
}

// Set number times Zed Time can be extended
static function float GetMaxSlowMoCharge( UM_PlayerReplicationInfo PRI )
{
	Return 5.0 + 2.0 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 25 Zed Time Extensions
}

static function float GetSlowMoChargeRegenModifier( UM_PlayerReplicationInfo PRI )
{
	if ( PRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 + 0.10 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 100% bonus
	
	Return 1.0;
}

/*
// Get nades type.
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		Return class'UM_StickySensorHandGrenade'; // Sticky Grenade

	Return super.GetNadeType(KFPRI);
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
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount on Assault Rifles
	else if ( Item == class'M4203Pickup' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 50% discount on M4203
	
	Return 1.00;
}

static function float GetSpreadModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 
		 && (UM_BaseAssaultRifleFire(WF) != None 
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None 
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - 0.025 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 25% bonus
	
	Return 1.0;
}

static function float GetAimErrorModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 50% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - 0.04 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 40% bonus
	
	Return 1.0;
}

static function float GetShakeViewModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0
		 && (UM_BaseAssaultRifleFire(WF) != None
			 || UM_BaseMachineGunFire(WF) != None
			 || UM_BasePDWFire(WF) != None
			 || UM_BaseSMGFire(WF) != None) )
		Return 1.000 - 0.02 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 20% bonus
	
	Return 1.0;
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.05 * float(Level)+0.05));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	ReplaceText(S,"%z",string(Level-2));
	ReplaceText(S,"%r",GetPercentStr(FMin(0.05 * float(Level)+0.1,1.f)));
	Return S;
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
	
	// StandardEquipment
	StandardEquipment(1)=(ClassName="KFMod.Single",MaxLevel=4)
	// AdditionalEquipment
     //AdditionalEquipment(0)=(ClassName="UnlimaginMod.Braindead_MP5A4SMG",MinLevel=5,MaxLevel=6)
	AdditionalEquipment(0)=(ClassName="UnlimaginMod.Braindead_MP5A4SMG",MaxLevel=6)
	AdditionalEquipment(1)=(ClassName="UnlimaginMod.UM_M4AssaultRifle",MinLevel=7,MaxLevel=8)
	AdditionalEquipment(2)=(ClassName="UnlimaginMod.UM_AK47AssaultRifle",MinLevel=9,MaxLevel=9)
	AdditionalEquipment(3)=(ClassName="UnlimaginMod.UM_GoldenAK47AssaultRifle",MinLevel=10)
}