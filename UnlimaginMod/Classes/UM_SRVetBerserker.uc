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

	if ( DmgType == Class'UM_DamTypeM79BouncingBall' || (class<KFWeaponDamageType>(DmgType) != None && class<KFWeaponDamageType>(DmgType).default.bIsMeleeDamage) )  {
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

// Maximum Health that Human can have when he has been overhealed
static function float GetOverhealedHealthMaxModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.5 + 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 100% bonus
}

static function float GetFireSpeedMod(KFPlayerReplicationInfo KFPRI, Weapon Other)
{
	if ( (KFMeleeGun(Other) != None || Crossbuzzsaw(Other) != None)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.04 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 40% melee FireSpeed

	Return 1.00;
}

static function float GetPawnJumpModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.00 + 0.025 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 25% extra jump height
}

static function int GetPawnMaxBounce( UM_PlayerReplicationInfo PRI )
{
	Return Min(PRI.ClientVeteranSkillLevel, 5); // Can bounce if SkillLevel > 0
}

// Pawn Movement Bonus while wielding this weapon
static function float GetWeaponPawnMovementBonus( UM_PlayerReplicationInfo PRI, Weapon W )
{
	if ( KFWeapon(W) != None && KFWeapon(W).bSpeedMeUp )
		Return 1.05 + 0.035 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 40% increase in movement speed while wielding Melee Weapon
	
	Return 1.0;
}

// New function to reduce taken damage
static function float GetHumanTakenDamageModifier( UM_PlayerReplicationInfo PRI, UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	if ( DamageType == Class'Fell' )
		Return 1.0 - 0.095 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 95% reduced Damage by falling
	else if ( DamageType == class'DamTypeVomit' )
		Return 1.0 - 0.09 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 90% reduced Bloat Bile damage
	else if ( DamageType == Class'UM_ZombieDamType_Poison' )
		Return 1.0 - 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 50% reduced Bloat Bile damage
	
	Return 1.0 - 0.06 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 65% reduced Bloat Bile damage
}

// Added in Balance Round 1(returned False then, by accident, fixed in Balance Round 2)
static function bool CanMeleeStun()
{
	Return True;
}

static function bool CanBeGrabbed(KFPlayerReplicationInfo KFPRI, KFMonster Other)
{
	Return False;
}

// Set number times Zed Time can be extended
static function float GetMaxSlowMoCharge( UM_PlayerReplicationInfo PRI )
{
	Return 5.0 + 1.5 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 20 SlowMo seconds
}

static function float GetSlowMoChargeRegenModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.25 + 0.125 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 150% bonus
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
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 75% discount on Melee Weapons
	
	Return 1.0;
}

static function float GetAmmoCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'CrossbuzzsawPickup' && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 - 0.06 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 60% discount on ammo

	Return 1.00;
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.05 * float(Level)-0.05));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	ReplaceText(S,"%r",GetPercentStr(0.7 + 0.05*float(Level)));
	ReplaceText(S,"%l",GetPercentStr(FMin(0.05*float(Level),0.65f)));
	Return S;
}

// Projectile Penetration Bonus
static function float GetProjectilePenetrationBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	if ( Class<UM_BaseProjectile_BouncingBall>(ProjClass) != None )
		Return 2.0 + float(Min(PRI.ClientVeteranSkillLevel, 8));	// Up to 1000% bonus
	
	Return 1.0;
}

// Projectile Bounce Bonus
static function float GetProjectileBounceBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	if ( Class<UM_BaseProjectile_BouncingBall>(ProjClass) != None && PRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 50% bonus
	
	Return 1.0;
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
	
	// StandardEquipment
	//StandardEquipment(0)=(ClassName="KFMod.Knife",MaxLevel=4)
	// AdditionalEquipment
	//AdditionalEquipment(0)=(ClassName="KFMod.Machete",MinLevel=5,MaxLevel=6)
	AdditionalEquipment(0)=(ClassName="KFMod.Machete",MaxLevel=6)
	AdditionalEquipment(1)=(ClassName="KFMod.Axe",MinLevel=7,MaxLevel=8)
	AdditionalEquipment(2)=(ClassName="KFMod.Katana",MinLevel=9,MaxLevel=9)
	AdditionalEquipment(3)=(ClassName="KFMod.GoldenKatana",MinLevel=10)
}