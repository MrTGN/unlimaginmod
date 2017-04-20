//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_VeterancyFirebug
//	Parent class:	 UM_VeterancyTypes
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.09.2012 20:31
//================================================================================
class UM_VeterancyFirebug extends UM_VeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_ClientRepInfoLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
		case 0:
			// FinalInt = 10000;
			FinalInt = 0;
			Break;
		case 1:
			FinalInt = 150000;
			Break;
		case 2:
			FinalInt = 600000;
			Break;
		case 3:
			FinalInt = 1350000;
			Break;
		case 4:
			FinalInt = 2400000;
			Break;
		case 5:
			FinalInt = 3750000;
			Break;
		case 6:
			FinalInt = 5400000;
			Break;
		case 7:
			FinalInt = 7350000;
			Break;
		case 8:
			FinalInt = 9600000;
			Break;
		case 9:
			FinalInt = 12150000;
			Break;
		case 10:
			FinalInt = 15000000;
			Break;
		default:
			FinalInt = (50000 * (CurLevel + 1)) + ((CurLevel - 1) * 250000 + 50000) + (50000 * CurLevel) + ((CurLevel - 2) * 250000 + 50000);
			Break;
		/*default:
			FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);*/
	}
	Return Min(StatOther.RFlameThrowerDamageStat,FinalInt);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( UM_BaseFlameThrower(Other) != None && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 100% larger fuel canister
	else if ( (MAC10MP(Other) != None || UM_MAC10MP(Other) != None || M4203AssaultRifle(Other) != None) && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.06 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 60% larger mag in MAC10

	Return 1.00;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if ( (UM_BaseFlameThrowerAmmo(Other) != None || FlameAmmo(Other) != None) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 100% larger fuel canister
	else if ( (MAC10Ammo(Other) != None || HuskGunAmmo(Other) != None || 
			TrenchgunAmmo(Other) != None || FlareRevolverAmmo(Other) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 60% larger fuel canister/MAC10 ammo/Husk gun ammo

	Return 1.00;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( (Class<UM_BaseFlameThrowerAmmo>(AmmoType) != None || AmmoType == class'FlameAmmo') 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.15 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 150% larger fuel ammo
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel >= 5 )
		Return 0.2 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 6))); // Up to 7 nades on 6 lvl
	else if ( AmmoType == class'UM_MGL140Ammo' && KFPRI.ClientVeteranSkillLevel >= 5 )
		Return 1.17; // 6 Extra Grenades for MGL140
	else if ( AmmoType == class'HuskGunAmmo' )
		Return 1.00 + (0.1 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 100% bonus
	else if ( (AmmoType == class'MAC10Ammo' || AmmoType == class'LAWAmmo' || AmmoType == class'FlareRevolverAmmo' || AmmoType == class'M203Ammo' || AmmoType == class'GoldenFlameAmmo') 
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Up to 60% larger fuel canister/MAC10/Husk gun ammo carry
	else if ( AmmoType == class'M79Ammo' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.01 + (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Up to 60% larger fuel canister/MAC10/Husk gun ammo carry
	else if ( (AmmoType == class'AA12Ammo' || AmmoType == class'ShotgunAmmo'|| 
				AmmoType == class'Hemi_Braindead_Moss12Ammo') 
				 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.25; // Level 4, 5, 6 - 25% increase in AA12/Shotgun ammo carried
	else if ( (AmmoType == class'BenelliAmmo' || AmmoType == class'KSGAmmo' ||
				 AmmoType == class'Maria_M37IthacaAmmo') 
			 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.20;
	else if ( AmmoType == class'TrenchgunAmmo' && KFPRI.ClientVeteranSkillLevel > 1 )
	{
		if ( KFPRI.ClientVeteranSkillLevel <= 4 )
			Return 1.20;
		
		Return 1.40; // Level 5, 6 - 40% increase Benelli shotgun ammo carried
	}
	else if ( AmmoType == class'UM_M32ShotgunAmmo' && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.34;
	
	Return 1.00;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( class<DamTypeBurned>(DmgType) != None || class<DamTypeFlamethrower>(DmgType) != None || 
		 class<DamTypeHuskGunProjectileImpact>(DmgType) != None || class<DamTypeFlareProjectileImpact>(DmgType) != None ||
		 Class<UM_BaseDamType_Flame>(DmgType) != None || Class<UM_BaseDamType_IncendiaryBullet>(DmgType) != None ||
		 Class<UM_BaseDamType_IncendiaryProjImpact>(DmgType) != None )
		Return float(InDamage) * (1.06 + 0.09 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); //  Up to 60% extra damage

	Return InDamage;
}

// Change effective range on FlameThrower
static function int ExtraRange(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel <= 2 )
		Return 0;
	else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
		Return 1; // 50% Longer Range

	Return 2; // 100% Longer Range
}

// New function to reduce taken damage
static function float GetHumanTakenDamageModifier( UM_PlayerReplicationInfo PRI, UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	if ( Class<UM_BaseDamType_Flame>(DamageType) != None || Class<UM_BaseDamType_IncendiaryBullet>(DamageType) != None
		 || Class<UM_BaseDamType_IncendiaryProjImpact>(DamageType) != None || class<DamTypeBurned>(DamageType) != None
		 || class<DamTypeFlamethrower>(DamageType) != None || class<DamTypeHuskGunProjectileImpact>(DamageType) != None
		 || class<DamTypeFlareProjectileImpact>(DamageType) != None )
		Return 0.5 - 0.1 * float(Min(PRI.ClientVeteranSkillLevel, 5)); // Up to 100% reduction in damage from fire
	
	Return 1.0;
}

/*
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		Return class'FlameNade'; // Grenade detonations cause enemies to catch fire

	Return Super.GetNadeType(KFPRI);
} */

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (UM_BaseFlameThrower(Other) != None || UM_MAC10MP(Other) != None ||
			MAC10MP(Other) != None ||
			Trenchgun(Other) != None || FlareRevolver(Other) != None ||
			DualFlareRevolver(Other) != None) && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.07 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 70% faster reload speed

	Return 1.00;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseFlameThrowerPickup>(Item) != None ||
		 Item == class'FlameThrowerPickup' || Item == class'MAC10Pickup' || 
		 Item == class'HuskGunPickup' || Item == class'TrenchgunPickup' || 
		 Item == class'FlareRevolverPickup' || Item == class'DualFlareRevolverPickup' ||
		 Item == class'GoldenFTPickup' )
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount on Flame Weapons

	Return 1.00;
}

static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseFlameThrowerFire(WF) != None )
		Return 1.00 - 0.04 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 40% bonus
	
	Return 1.0;
}

static function float GetShakeViewModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseFlameThrowerFire(WF) != None )
		Return 1.00 - 0.02 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 20% bonus
	
	Return 1.0;
}

static function class<DamageType> GetMAC10DamageType(KFPlayerReplicationInfo KFPRI)
{
	Return class'DamTypeMAC10MPInc';
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.1 * float(Level)));
	ReplaceText(S,"%m",GetPercentStr(0.05 * float(Level)));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	Return S;
}

defaultproperties
{
	PerkIndex=5

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Firebug'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Firebug_Gold'
	VeterancyName="Firebug"
	Requirements(0)="Deal %x damage with the Flamethrower"

	SRLevelEffects(0)="5% extra flame weapon damage|50% resistance to fire|10% discount on the Flamethrower"
	SRLevelEffects(1)="10% extra flame weapon damage|10% faster Flamethrower reload|10% more flame weapon ammo|60% resistance to fire|20% discount on flame weapons"
	SRLevelEffects(2)="20% extra flame weapon damage|20% faster Flamethrower reload|20% more flame weapon ammo|70% resistance to fire|30% discount on flame weapons"
	SRLevelEffects(3)="30% extra flame weapon damage|30% faster Flamethrower reload|30% more flame weapon ammo|80% resistance to fire|50% extra Flamethrower range|Grenades set enemies on fire|40% discount on flame weapons"
	SRLevelEffects(4)="40% extra flame weapon damage|40% faster Flamethrower reload|40% more flame weapon ammo|90% resistance to fire|50% extra Flamethrower range|Grenades set enemies on fire|50% discount on flame weapons"
	SRLevelEffects(5)="50% extra flame weapon damage|50% faster Flamethrower reload|50% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|60% discount on flame weapons|Spawn with a Flamethrower"
	SRLevelEffects(6)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
	SRLevelEffects(7)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
	SRLevelEffects(8)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
	SRLevelEffects(9)="60% extra flame weapon damage|60% faster Flamethrower reload|60% more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|70% discount on flame weapons|Spawn with a Flamethrower and Body Armor"
	
	CustomLevelInfo="%s extra flame weapon damage|%m faster Flamethrower reload|%s more flame weapon ammo|100% resistance to fire|100% extra Flamethrower range|Grenades set enemies on fire|%d discount on flame weapons|Spawn with a Flamethrower and Body Armor"
	
	// StandardEquipment
	StandardEquipment(1)=(ClassName="KFMod.Single",MaxLevel=5)
	// AdditionalEquipment
	//AdditionalEquipment(0)=(ClassName="UnlimaginMod.UM_MAC10MP",MinLevel=5,MaxLevel=7)
	AdditionalEquipment(0)=(ClassName="UnlimaginMod.UM_MAC10MP",MaxLevel=7)
	AdditionalEquipment(1)=(ClassName="KFMod.FlareRevolver",MinLevel=6)
	AdditionalEquipment(2)=(ClassName="UnlimaginMod.UM_FlameThrower",MinLevel=8,MaxLevel=9)
	AdditionalEquipment(3)=(ClassName="UnlimaginMod.UM_GoldenFlameThrower",MinLevel=10)
}