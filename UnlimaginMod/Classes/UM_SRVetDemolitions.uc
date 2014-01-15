//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetDemolitions
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
class UM_SRVetDemolitions extends UM_SRVeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
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
	else if ( LAW(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 60% faster reload speed LAW
	else if ( (M79GrenadeLauncher(Other) != none || M32GrenadeLauncher(Other) != none ||
			 GoldenM79GrenadeLauncher(Other) != none) && KFPRI.ClientVeteranSkillLevel > 0 )
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
	if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
		 class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none ||
		 class<DamTypeM203Grenade>(DmgType) != none || class<DamTypeRocketImpact>(DmgType) != none ||
		 Class<UM_BaseDamType_Explosive>(DmgType) != None || Class<UM_BaseDamType_ExplosiveProjImpact>(DmgType) != None ||
		 class<DamTypeSPGrenade>(DmgType) != none )
		Return float(InDamage) * (1.10 + (0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,6)))); //  Up to 70% extra damage

	Return InDamage;
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( class<UM_BaseDamType_ExplosiveBullets>(DmgType) != None )
		Return float(InDamage) * (0.30 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,6))));
	else if ( class<DamTypeFrag>(DmgType) != none || class<DamTypePipeBomb>(DmgType) != none ||
		 class<DamTypeM79Grenade>(DmgType) != none || class<DamTypeM32Grenade>(DmgType) != none ||
		 class<DamTypeM203Grenade>(DmgType) != none || class<DamTypeRocketImpact>(DmgType) != none ||
		 Class<UM_BaseDamType_Explosive>(DmgType) != None || Class<UM_BaseDamType_ExplosiveProjImpact>(DmgType) != None ||
		 class<DamTypeSPGrenade>(DmgType) != none)
		Return float(InDamage) * (0.9 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel,8))));

	Return InDamage;
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
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount
	else if ( Item == class'PipeBombPickup' || Item == class'M79Pickup' || 
		 Item == class'M32Pickup' || Item == class'LAWPickup' || 
		 Item == class'M4203Pickup' || Item == class'GoldenM79Pickup' ||
		 Item == class'SPGrenadePickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on PipeBomb/M79/M32/LAW/M4203
	
	Return 1.00;
}

// Change the cost of particular ammo
static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseGrenadeLauncherPickup>(Item) != None )
		Return 1.00 - (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 40% discount
	else if ( Item == class'PipeBombPickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on PipeBomb
	else if ( (Item == class'M79Pickup' || Item == class'M32Pickup' || 
				Item == class'LAWPickup' || Item == class'M4203Pickup' ||
				Item == class'GoldenM79Pickup' || Item == class'SPGrenadePickup') 
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - (0.04 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 40% discount
	
	Return 1.00;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	local	int		ExtraAmmo;
	
	if ( KFPRI.ClientVeteranSkillLevel >= 9 )
		KFHumanPawn(P).RequiredEquipment[1] = "";	// Remove KFMod.Single (Beretta92)
	
	if ( UM_SRHumanPawn(P) != None )
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 8:
				ExtraAmmo = 6;
			case 7:
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'), ExtraAmmo, 0);
			case 6:
				ExtraAmmo = 2;
			case 5:
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("KFMod.PipeBombExplosive", GetCostScaling(KFPRI, class'PipeBombPickup'), ExtraAmmo, 0);
				Break;
		
			case 10:
			case 9:
				ExtraAmmo = 6;
				if ( KFPRI.ClientVeteranSkillLevel == 9 )
				{
					UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'), ExtraAmmo, 0);
					ExtraAmmo = 0;
				}
				else
					UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("KFMod.GoldenM79GrenadeLauncher", GetCostScaling(KFPRI, class'GoldenM79Pickup'), ExtraAmmo, 0);
				UM_SRHumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_M4203AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_M4203Pickup'), ExtraAmmo, 1);
				Break;
		}
	}
	else
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 7:
			case 8:
				KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
			case 5:
			case 6:
				KFHumanPawn(P).CreateInventoryVeterancy("KFMod.PipeBombExplosive", GetCostScaling(KFPRI, class'PipeBombPickup'));
				Break;
			
			case 9:
			case 10:
				if ( KFPRI.ClientVeteranSkillLevel == 9 )
					KFHumanPawn(P).CreateInventoryVeterancy("KFMod.M79GrenadeLauncher", GetCostScaling(KFPRI, class'M79Pickup'));
				else
					KFHumanPawn(P).CreateInventoryVeterancy("KFMod.GoldenM79GrenadeLauncher", GetCostScaling(KFPRI, class'GoldenM79Pickup'));
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_M4203AssaultRifle", GetCostScaling(KFPRI, class'UnlimaginMod.UM_M4203Pickup'));
				Break;
		}
	}
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
	return S;
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
}