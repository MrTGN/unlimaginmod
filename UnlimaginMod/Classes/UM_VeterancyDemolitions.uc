//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_VeterancyDemolitions
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
class UM_VeterancyDemolitions extends UM_VeterancyTypes
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
	Return Min(StatOther.RExplosivesDamageStat,FinalInt);
}

static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( UM_BaseGrenadeLauncher(Other) != None )
		Return 1.00 + (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 40% faster reload speed
	else if ( LAW(Other) != None && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 60% faster reload speed LAW
	else if ( (M79GrenadeLauncher(Other) != None || M32GrenadeLauncher(Other) != None ||
			 GoldenM79GrenadeLauncher(Other) != None) && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 40% faster reload speed M4203/M79/M32
	
	Return 1.00;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( Class<UM_BaseGrenadeLauncherAmmo>(AmmoType) != None && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.0835 * float(Min(KFPRI.ClientVeteranSkillLevel,10)));
	// Up to 10 extra Grenades
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel,10)));
	// Up to 14 extra for a total of 16 Remote Explosive Devices
	else if ( AmmoType == class'PipeBombAmmo' )
		Return 3.00 + (0.5 * float(Min(KFPRI.ClientVeteranSkillLevel,10)));
	else if ( (AmmoType == class'LAWAmmo' || AmmoType == class'M203Ammo')
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 200% increase LAW/M203 ammo
	else if ( (AmmoType == class'M79Ammo' || AmmoType == class'M32Ammo' || 
				AmmoType == class'SPGrenadeAmmo')
			 && KFPRI.ClientVeteranSkillLevel > 1 )
		Return 0.90 + (0.1 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); // Level 6 - 50% increase M32/M79
 	else if ( (AmmoType == class'AA12Ammo' || AmmoType == class'ShotgunAmmo' || 
				AmmoType == class'Hemi_Braindead_Moss12Ammo') 
			 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.25; // Levels more than 3 - 25% increase in AA12/Shotgun ammo carried
	else if ( (AmmoType == class'BenelliAmmo' || AmmoType == class'KSGAmmo' ||
				 AmmoType == class'TrenchgunAmmo' || AmmoType == class'Maria_M37IthacaAmmo') 
			 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.20; // Levels more than 3  - 20% increase in Benelli/KSG/Trenchgun/M37Ithaca ammo carried
	else if ( AmmoType == class'UM_M32ShotgunAmmo' && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.34; // Levels more than 3  - 34% increase in M32Shotgun ammo carried

	Return 1.00;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( class<DamTypeFrag>(DmgType) != None || class<DamTypePipeBomb>(DmgType) != None ||
		 class<DamTypeM79Grenade>(DmgType) != None || class<DamTypeM32Grenade>(DmgType) != None ||
		 class<DamTypeM203Grenade>(DmgType) != None || class<DamTypeRocketImpact>(DmgType) != None ||
		 Class<UM_BaseDamType_Explosive>(DmgType) != None || Class<UM_BaseDamType_ExplosiveProjImpact>(DmgType) != None ||
		 class<DamTypeSPGrenade>(DmgType) != None )
		Return float(InDamage) * (1.10 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,6)))); //  Up to 70% extra damage

	Return InDamage;
}

// New function to reduce taken damage
static function float GetHumanTakenDamageModifier( UM_PlayerReplicationInfo PRI, UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	if ( class<UM_BaseDamType_ExplosiveBullets>(DamageType) != None )
		Return 0.3 - (0.05 * float(Min(PRI.ClientVeteranSkillLevel, 6)));	// After the 6 lvl no damage at all
	else if ( Class<UM_BaseDamType_Explosive>(DamageType) != None || Class<UM_BaseDamType_ExplosiveProjImpact>(DamageType) != None
			 || class<DamTypeFrag>(DamageType) != None || class<DamTypePipeBomb>(DamageType) != None
			 || class<DamTypeM79Grenade>(DamageType) != None || class<DamTypeM32Grenade>(DamageType) != None
			 || class<DamTypeM203Grenade>(DamageType) != None || class<DamTypeRocketImpact>(DamageType) != None
			 || class<DamTypeSPGrenade>(DamageType) != None )
		Return 0.9 - (0.05 * float(Min(PRI.ClientVeteranSkillLevel, 8)));	// Up to 50% reduce taken damage
	
	Return 1.0;
}

/*
// Get nades type.
static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 3 )
		Return class'UM_ClusterHandGrenade'; // Cluster Grenade

	Return super.GetNadeType(KFPRI);
} */

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseGrenadeLauncherPickup>(Item) != None )
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount
	else if ( Item == class'PipeBombPickup' || Item == class'M79Pickup' || 
		 Item == class'M32Pickup' || Item == class'LAWPickup' || 
		 Item == class'M4203Pickup' || Item == class'GoldenM79Pickup' ||
		 Item == class'SPGrenadePickup' )
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount on PipeBomb/M79/M32/LAW/M4203
	
	Return 1.00;
}

// Change the cost of particular ammo
static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseGrenadeLauncherPickup>(Item) != None )
		Return 1.00 - 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 40% discount
	else if ( Item == class'PipeBombPickup' )
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount on PipeBomb
	else if ( (Item == class'M79Pickup' || Item == class'M32Pickup' || 
				Item == class'LAWPickup' || Item == class'M4203Pickup' ||
				Item == class'GoldenM79Pickup' || Item == class'SPGrenadePickup') 
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 40% discount
	
	Return 1.00;
}

static function float GetAimErrorModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseGrenadeLauncherFire(WF) != None )
		Return 1.00 - 0.04 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 40% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseGrenadeLauncherFire(WF) != None )
		Return 1.00 - 0.02 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 20% bonus
	
	Return 1.0;
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.1 * float(Level)));
	ReplaceText(S,"%r",GetPercentStr(FMin(0.25f+0.05*float(Level),0.95f)));
	ReplaceText(S,"%d",GetPercentStr(0.75+FMin(0.03 * float(Level),0.24f)));
	ReplaceText(S,"%x",string(2+Level));
	ReplaceText(S,"%y",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	Return S;
}

defaultproperties
{
	PerkIndex=6

	OnHUDIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition_Gold'
	VeterancyName="Demolitions"
	Requirements(0)="Deal %x damage with the Explosives"

	SRLevelEffects(0)="5% extra Explosives damage|25% resistance to Explosives|10% discount on Explosives|75% off Remote Explosives"
	SRLevelEffects(1)="10% extra Explosives damage|30% resistance to Explosives|20% increase in grenade capacity|Can carry 3 Remote Explosives|20% discount on Explosives|78% off Remote Explosives"
	SRLevelEffects(2)="20% extra Explosives damage|35% resistance to Explosives|40% increase in grenade capacity|Can carry 4 Remote Explosives|30% discount on Explosives|81% off Remote Explosives"
	SRLevelEffects(3)="30% extra Explosives damage|40% resistance to Explosives|60% increase in grenade capacity|Can carry 5 Remote Explosives|40% discount on Explosives|84% off Remote Explosives"
	SRLevelEffects(4)="40% extra Explosives damage|45% resistance to Explosives|80% increase in grenade capacity|Can carry 6 Remote Explosives|50% discount on Explosives|87% off Remote Explosives"
	SRLevelEffects(5)="50% extra Explosives damage|50% resistance to Explosives|100% increase in grenade capacity|Can carry 7 Remote Explosives|60% discount on Explosives|90% off Remote Explosives|Spawn with a Pipe Bomb"
	SRLevelEffects(6)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|93% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
	SRLevelEffects(7)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|93% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
	SRLevelEffects(8)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|93% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
	SRLevelEffects(9)="60% extra Explosives damage|55% resistance to Explosives|120% increase in grenade capacity|Can carry 8 Remote Explosives|70% discount on Explosives|93% off Remote Explosives|Spawn with an M79 and Pipe Bomb"
	
	CustomLevelInfo="%s extra Explosives damage|%r resistance to Explosives|120% increase in grenade capacity|Can carry %x Remote Explosives|%y discount on Explosives|%d off Remote Explosives|Spawn with an M79 and Pipe Bomb"
	
	// StandardEquipment
	StandardEquipment(1)=(ClassName="KFMod.Single",MaxLevel=7)
	// AdditionalEquipment
	//AdditionalEquipment(0)=(ClassName="KFMod.M79GrenadeLauncher",MinLevel=5,MaxLevel=7)
	AdditionalEquipment(0)=(ClassName="KFMod.M79GrenadeLauncher",MaxLevel=7)
	AdditionalEquipment(1)=(ClassName="KFMod.PipeBombExplosive",MinLevel=6,MaxLevel=9)
	AdditionalEquipment(2)=(ClassName="UnlimaginMod.UM_M4203AssaultRifle",MinLevel=8)
	AdditionalEquipment(3)=(ClassName="KFMod.GoldenM79GrenadeLauncher",MinLevel=10)
}