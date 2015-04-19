//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetFieldMedic
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
class UM_SRVetFieldMedic extends UM_SRVeterancyTypes
	Abstract;

static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
		case 0:
			// FinalInt = 500;
			FinalInt = 0;
			Break;
		case 1:
			FinalInt = 5000;
			Break;
		case 2:
			FinalInt = 15000;
			Break;
		case 3:
			FinalInt = 30000;
			Break;
		case 4:
			FinalInt = 50000;
			Break;
		case 5:
			FinalInt = 75000;
			Break;
		case 6:
			FinalInt = 105000;
			Break;
		case 7:
			FinalInt = 140000;
			Break;
		case 8:
			FinalInt = 180000;
			Break;
		case 9:
			FinalInt = 225000;
			Break;
		case 10:
			FinalInt = 275000;
			Break;
		default:
			FinalInt = (2500 * (CurLevel + 1)) + ((CurLevel - 1) * 2500) + (2500 * CurLevel) + ((CurLevel - 2) * 2500);
			Break;
		/*default:
			FinalInt = 100000+GetDoubleScaling(CurLevel,20000);*/
	}
	return Min(StatOther.RDamageHealedStat,FinalInt);
}

static function class<Grenade> GetNadeType(KFPlayerReplicationInfo KFPRI)
{
	Return class'MedicNade'; // Grenade detonations heal nearby teammates, and cause enemies to be poisoned

	Return Super.GetNadeType(KFPRI);
}

static function float GetSyringeChargeRate(KFPlayerReplicationInfo KFPRI)
{
	Return 1.25 + 0.225 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 250% more faster recharges
}

// Pawn Movement Bonus while wielding this weapon
static function float GetWeaponPawnMovementBonus( UM_PlayerReplicationInfo PRI, Weapon W )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && Syringe(W) != None )
		Return 1.00 + 0.01 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 10% bonus
	
	Return 1.0;
}

static function float GetMovementSpeedModifier(KFPlayerReplicationInfo KFPRI, KFGameReplicationInfo KFGRI)
{
	Return 1.05 + 0.025 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Moves up to 30% faster with all wepons
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( Class<UM_BaseDamType_PoisonGas>(DmgType) != None || 
			Class<UM_DamTypeAA12MedGasImpact>(DmgType) != None)
		Return float(InDamage) * (1.05 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,6))); //  Up to 65% extra damage

	Return InDamage;
}

static function float GetHealPotency(KFPlayerReplicationInfo KFPRI)
{
	Return 1.2 + 0.08 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 100% more heals
}

// On how much this human can overheal somebody
static function float GetOverhealPotency( UM_PlayerReplicationInfo PRI )
{
	Return 1.1 + 0.1 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 110% bonus
}

// Maximum Health that Human can have when he has been overhealed
static function float GetOverhealedHealthMaxModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.25 + 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 75% bonus
}

// New function to reduce taken damage
static function float GetHumanTakenDamageModifier( UM_PlayerReplicationInfo PRI, UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	if ( DamageType == class'DamTypeVomit' )  {
		// Medics don't damage themselves with the bile shooter
		if ( Aggressor == Victim )
			Return 0.0;
		else
			Return 0.95 - 0.07 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// 75% decrease in damage from Bloat's Bile
	}
	else if ( DamageType == Class'UM_ZombieDamType_Poison' )
		Return 0.95 - 0.07 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 75% reduced Bloat Bile damage
	else if ( (DamageType == Class'UM_ZombieDamType_SirenScream' || DamageType == class'SirenScreamDamage')
			 && Victim != None && Victim.ShieldStrength > 0 && PRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 - 0.04 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 40% reduce taken damage
	
	Return 1.0;
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (MP7MMedicGun(Other) != none || MP5MMedicGun(Other) != none || 
			 M7A3MMedicGun(Other) != none || KrissMMedicGun(Other) != none) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // 100% increase in MP7 Medic weapon ammo carry

	Return 1.00;
}

static function float GetAmmoPickupMod(KFPlayerReplicationInfo KFPRI, KFAmmunition Other)
{
	if ( (MP7MAmmo(Other) != none || MP5MAmmo(Other) != none || 
			 M7A3MAmmo(Other) != none || KrissMAmmo(Other) != none)
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.10 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // 100% increase in MP7 Medic weapon ammo carry

	Return 1.00;
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	if ( (Class<UM_BaseFlameThrowerAmmo>(AmmoType) != None || AmmoType == class'FlameAmmo') 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.025 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 25% larger fuel ammo
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel >= 5 )
		Return 0.2 + 0.20 * float(Min(KFPRI.ClientVeteranSkillLevel, 7)); // Up to 8 grenades on 7 lvl
	else if ( (AmmoType==class'MP7MAmmo' || AmmoType==class'MP5MAmmo' || 
				AmmoType==class'M7A3MAmmo' || AmmoType == class'KrissMAmmo')
			 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + 0.05 * float(Min(KFPRI.ClientVeteranSkillLevel, 10)); // Up to 50 increase MediGun ammo carry
	else if ( (AmmoType == class'AA12Ammo' || AmmoType == class'ShotgunAmmo'|| 
				AmmoType == class'Hemi_Braindead_Moss12Ammo') 
				 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.25; // Level 4, 5, 6 - 25% increase in AA12/Shotgun ammo carried
	else if ( (AmmoType == class'BenelliAmmo' || AmmoType == class'KSGAmmo' ||
				 AmmoType == class'TrenchgunAmmo' || AmmoType == class'Maria_M37IthacaAmmo') 
			 && KFPRI.ClientVeteranSkillLevel > 3 )
		Return 1.20;
	
	Return 1.00;
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Item == class'Vest' )
		Return 0.90 - 0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10));  // Up to 75% discount on Body Armor
	else if ( Item == class'MP7MPickup' || Item == class'MP5MPickup' || 
			 Item == class'M7A3MPickup' || Item == class'KrissMPickup' )
		Return 0.25 - 0.015 * float(Min(KFPRI.ClientVeteranSkillLevel,10));  // Up to 90% discount on Medic Gun

	Return 1.00;
}

// Reduce damage when wearing Armor
static function float GetBodyArmorDamageModifier(KFPlayerReplicationInfo KFPRI)
{
	Return 1.00 - 0.08 * float(Min(KFPRI.ClientVeteranSkillLevel,10)); // Up to 80% Better Body Armor
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(2.4 + (0.1 * float(Level))));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	ReplaceText(S,"%m",GetPercentStr(0.15+FMin(0.02 * float(Level),0.83f)));
	ReplaceText(S,"%r",GetPercentStr(FMin(0.05 * float(Level),0.65f)-0.05));
	return S;
}

defaultproperties
{
	PerkIndex=0

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Medic'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Medic_Gold'
	VeterancyName="Field Medic"
	Requirements[0]="Heal %x HP on your teammates"

	SRLevelEffects(0)="10% faster Syringe recharge|10% more potent medical injections|10% less damage from Bloat Bile|10% discount on Body Armor|85% discount on MP7M Medic Gun"
	SRLevelEffects(1)="25% faster Syringe recharge|25% more potent medical injections|25% less damage from Bloat Bile|20% larger MP7M Medic Gun clip|10% better Body Armor|20% discount on Body Armor|87% discount on MP7M Medic Gun"
	SRLevelEffects(2)="50% faster Syringe recharge|25% more potent medical injections|50% less damage from Bloat Bile|5% faster movement speed|40% larger MP7M Medic Gun clip|20% better Body Armor|30% discount on Body Armor|89% discount on MP7M Medic Guns"
	SRLevelEffects(3)="75% faster Syringe recharge|50% more potent medical injections|50% less damage from Bloat Bile|10% faster movement speed|60% larger MP7M Medic Gun clip|30% better Body Armor|40% discount on Body Armor|91% discount on MP7M Medic Guns"
	SRLevelEffects(4)="100% faster Syringe recharge|50% more potent medical injections|50% less damage from Bloat Bile|15% faster movement speed|80% larger MP7M Medic Gun clip|40% better Body Armor|50% discount on Body Armor|93% discount on MP7M Medic Guns"
	SRLevelEffects(5)="150% faster Syringe recharge|50% more potent medical injections|75% less damage from Bloat Bile|20% faster movement speed|100% larger MP7M Medic Gun clip|50% better Body Armor|60% discount on Body Armor|95% discount on MP7M Medic Guns|Spawn with Body Armor"
	SRLevelEffects(6)="200% faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|25% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|70% discount on Body Armor||97% discount on MP7M Medic Guns| Spawn with Body Armor and Medic Gun"
	SRLevelEffects(7)="200% faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|25% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|70% discount on Body Armor||97% discount on MP7M Medic Guns| Spawn with Body Armor and Medic Gun"
	SRLevelEffects(8)="200% faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|25% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|70% discount on Body Armor||97% discount on MP7M Medic Guns| Spawn with Body Armor and Medic Gun"
	SRLevelEffects(9)="200% faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|25% faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|70% discount on Body Armor||97% discount on MP7M Medic Guns| Spawn with Body Armor and Medic Gun"
	
	CustomLevelInfo="%s faster Syringe recharge|75% more potent medical injections|75% less damage from Bloat Bile|%r faster movement speed|100% larger MP7M Medic Gun clip|75% better Body Armor|%d discount on Body Armor||%m discount on MP7M Medic Guns| Spawn with Body Armor and Medic Gun"
	
	// AdditionalEquipment
	AdditionalEquipment(0)=(ClassName="KFMod.MP7MMedicGun",MinLevel=5,MaxLevel=6)
	AdditionalEquipment(1)=(ClassName="KFMod.MP5MMedicGun",MinLevel=7,MaxLevel=8)
	AdditionalEquipment(2)=(ClassName="KFMod.M7A3MMedicGun",MinLevel=9)
}