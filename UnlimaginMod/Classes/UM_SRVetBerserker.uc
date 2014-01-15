//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetBerserker
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
class UM_SRVetBerserker extends UM_SRVeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
		case 0:
			// FinalInt = 10000;
			FinalInt = 0;
			break;
		case 1:
			FinalInt = 150000;
			break;
		case 2:
			FinalInt = 600000;
			break;
		case 3:
			FinalInt = 1350000;
			break;
		case 4:
			FinalInt = 2400000;
			break;
		case 5:
			FinalInt = 3750000;
			break;
		case 6:
			FinalInt = 5400000;
			break;
		case 7:
			FinalInt = 7350000;
			break;
		case 8:
			FinalInt = 9600000;
			break;
		case 9:
			FinalInt = 12150000;
			break;
		case 10:
			FinalInt = 15000000;
			break;
		default:
			FinalInt = (50000 * (CurLevel + 1)) + ((CurLevel - 1) * 250000 + 50000) + (50000 * CurLevel) + ((CurLevel - 2) * 250000 + 50000);
			break;
		/*default:
			FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);*/
	}
	Return Min(StatOther.RMeleeDamageStat,FinalInt);
}

// ExtraAmmo added by TGN
static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( AmmoType == class'CrossbuzzsawAmmo' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 + (0.1 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)));

	Return 1.0;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	local float ret;

	if( class<KFWeaponDamageType>(DmgType) != none && class<KFWeaponDamageType>(DmgType).default.bIsMeleeDamage )
	{
		if ( KFPRI.ClientVeteranSkillLevel == 0 )
			ret = float(InDamage) * 1.10;
		// Up to 100% increase in Melee Damage
		else
			ret = float(InDamage) * (1.0 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 5))));
	}
	else
		ret = InDamage;

	Return ret;
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if ( (KFMeleeGun(Other) != none || Crossbuzzsaw(Other) != none)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 40% melee FireSpeed

	Return 1.00;
}

static function float GetJumpModifier(KFPlayerReplicationInfo KFPRI)
{
	Return 1.00 + (0.025 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 25% extra jump height
}

static function int GetMaxBounce(KFPlayerReplicationInfo KFPRI)
{
	Return Min(KFPRI.ClientVeteranSkillLevel, 3); // Can bounce if SkillLevel > 0
}

static function float GetMeleeMovementSpeedModifier(KFPlayerReplicationInfo KFPRI)
{
	Return 0.00 + 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 40% increase in movement speed while wielding Melee Weapon
}

static function int ReduceDamage(KFPlayerReplicationInfo KFPRI, KFPawn Injured, Pawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( DmgType == class'Fell' )
		Return float(InDamage) * (1.00 - (0.075 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)))); // Up to 75% reduced Damage by falling
	else if ( DmgType == class'DamTypeVomit' )
		Return float(InDamage) * (1.00 - 0.09 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 90% reduced Bloat Bile damage
	else if ( DmgType == class'DamTypeBurned' && KFHumanPawn(Injured).ShieldStrength > 0 )
		Return float(InDamage) * (1.00 - (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)))); // Up to 30% reduced husk fire damage

	Return float(InDamage) * (1.00 - (0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)))); // Up to 50% reduced all Damage
}

// Added in Balance Round 1(returned false then, by accident, fixed in Balance Round 2)
static function bool CanMeleeStun()
{
	Return True;
}

static function bool CanBeGrabbed(KFPlayerReplicationInfo KFPRI, KFMonster Other)
{
	if ( Other.IsA('ZombieClot') )
		Return !Other.IsA('ZombieClot');
	else if ( Other.IsA('UM_ZombieClot') )
		Return !Other.IsA('UM_ZombieClot');
	else if ( Other.IsA('UM_ZombieStalker'))
		Return !Other.IsA('UM_ZombieStalker');
}

// Set number times Zed Time can be extended
static function int ZedTimeExtensions(KFPlayerReplicationInfo KFPRI)
{
	if ( KFPRI.ClientVeteranSkillLevel > 0 )
		Return (5 * Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 50 Zed Time Extensions
	
	Return 0;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'ChainsawPickup' || Item == class'KatanaPickup' ||
		 Item == class'ClaymoreSwordPickup' || Item == class'CrossbuzzsawPickup' ||
		 Item == class'ScythePickup' || Item == class'GoldenKatanaPickup' || 
		 Item == class'MachetePickup' || Item == class'AxePickup' || 
		 Item == class'DwarfAxePickup' || Item == class'Whisky_HammerPickup' || 
		 Item == class'GoldenChainsawPickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on Melee Weapons
	
	Return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'CrossbuzzsawPickup' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - (0.06 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 60% discount on ammo

	Return 1.00;
}

// Give Extra Items as default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	if ( KFPRI.ClientVeteranSkillLevel >= 5 )
		KFHumanPawn(P).RequiredEquipment[0] = ""; //Knife
	
	if ( KFPRI.ClientVeteranSkillLevel >= 6 )
		P.ShieldStrength = 100;
	
	switch( KFPRI.ClientVeteranSkillLevel )
	{
		case 5:
		case 6:
			KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Machete", GetCostScaling(KFPRI, class'MachetePickup'));
			Break;
		
		case 7:
		case 8:
			KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Axe", GetCostScaling(KFPRI, class'AxePickup'));
			Break;
		
		case 9:
			KFHumanPawn(P).CreateInventoryVeterancy("KFMod.Katana", GetCostScaling(KFPRI, class'KatanaPickup'));
			Break;
		
		case 10:
			KFHumanPawn(P).CreateInventoryVeterancy("KFMod.GoldenKatana", GetCostScaling(KFPRI, class'GoldenKatanaPickup'));
			Break;
	}
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.05 * float(Level)-0.05));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	ReplaceText(S,"%r",GetPercentStr(0.7 + 0.05*float(Level)));
	ReplaceText(S,"%l",GetPercentStr(FMin(0.05*float(Level),0.65f)));
	return S;
}

defaultproperties
{
	PerkIndex=4

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Berserker'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Berserker_Gold'
	VeterancyName="Berserker"
	Requirements(0)="Deal %x damage with melee weapons"

	SRLevelEffects(0)="10% extra melee damage|5% faster melee movement|10% less damage from Bloat Bile|10% discount on Katana/Chainsaw/Sword|Can't be grabbed by Clots"
	SRLevelEffects(1)="20% extra melee damage|5% faster melee attacks|10% faster melee movement|25% less damage from Bloat Bile|5% resistance to all damage|20% discount on Katana/Chainsaw/Sword|Can't be grabbed by Clots"
	SRLevelEffects(2)="40% extra melee damage|10% faster melee attacks|15% faster melee movement|35% less damage from Bloat Bile|10% resistance to all damage|30% discount on Katana/Chainsaw/Sword|Can't be grabbed by Clots|Zed-Time can be extended by killing an enemy while in slow motion"
	SRLevelEffects(3)="60% extra melee damage|10% faster melee attacks|20% faster melee movement|50% less damage from Bloat Bile|15% resistance to all damage|40% discount on Katana/Chainsaw/Sword|Can't be grabbed by Clots|Up to 2 Zed-Time Extensions"
	SRLevelEffects(4)="80% extra melee damage|15% faster melee attacks|20% faster melee movement|65% less damage from Bloat Bile|20% resistance to all damage|50% discount on Katana/Chainsaw/Sword|Can't be grabbed by Clots|Up to 3 Zed-Time Extensions"
	SRLevelEffects(5)="100% extra melee damage|20% faster melee attacks|20% faster melee movement|75% less damage from Bloat Bile|30% resistance to all damage|60% discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
	SRLevelEffects(6)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
	SRLevelEffects(7)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
	SRLevelEffects(8)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
	SRLevelEffects(9)="100% extra melee damage|25% faster melee attacks|30% faster melee movement|80% less damage from Bloat Bile|40% resistance to all damage|70% discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
	
	CustomLevelInfo="%r extra melee damage|%s faster melee attacks|20% faster melee movement|80% less damage from Bloat Bile|%l resistance to all damage|%d discount on Katana/Chainsaw/Sword|Spawn with a Chainsaw and Body Armor|Can't be grabbed by Clots|Up to 4 Zed-Time Extensions"
}