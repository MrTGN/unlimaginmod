//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SRVetSupportSpec
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
class UM_SRVetSupportSpec extends UM_SRVeterancyTypes
	Abstract;


static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	switch( CurLevel )
	{
		case 0:
			// if( ReqNum==0 )
				// FinalInt = 100;
			// else
				// FinalInt = 5000;
			if( ReqNum==0 )
				FinalInt = 0;
			else
				FinalInt = 0;
			Break;
		case 1:
			if( ReqNum==0 )
				FinalInt = 1000;
			else
				FinalInt = 50000;
			Break;
		case 2:
			if( ReqNum==0 )
				FinalInt = 25000;
			else
				FinalInt = 400000;
			Break;
		case 3:
			if( ReqNum==0 )
				FinalInt = 72000;
			else
				FinalInt = 1050000;
			Break;
		case 4:
			if( ReqNum==0 )
				FinalInt = 142000;
			else
				FinalInt = 2000000;
			Break;
		case 5:
			if( ReqNum==0 )
				FinalInt = 235000;
			else
				FinalInt = 3250000;
			Break;
		case 6:
			if( ReqNum==0 )
				FinalInt = 351000;
			else
				FinalInt = 4800000;
			Break;
		case 7:
			if( ReqNum==0 )
				FinalInt = 490000;
			else
				FinalInt = 6650000;
			Break;
		case 8:
			if( ReqNum==0 )
				FinalInt = 652000;
			else
				FinalInt = 8800000;
			Break;
		case 9:
			if( ReqNum==0 )
				FinalInt = 837000;
			else
				FinalInt = 11250000;
			Break;
		case 10:
			if( ReqNum==0 )
				FinalInt = 1045000;
			else
				FinalInt = 14000000;
			Break;
		default:
			if( ReqNum==0 )
				FinalInt = (22500 * CurLevel) + ((CurLevel - 2) * 500) + (22500 * (CurLevel - 1)) + ((CurLevel - 3) * 500);
			else
				FinalInt = (50000 * (CurLevel + 1)) + ((CurLevel - 1) * 250000 - 50000) + (50000 * CurLevel) + ((CurLevel - 2) * 250000 - 50000);
			Break;
		/* default:
			if( ReqNum==0 )
				FinalInt = 370000+GetDoubleScaling(CurLevel,35000);
			else FinalInt = 5500000+GetDoubleScaling(CurLevel,500000);
			Break; */
	}
	if( ReqNum==0 )
		return Min(StatOther.RWeldingPointsStat,FinalInt);
	return Min(StatOther.RShotgunDamageStat,FinalInt);
}

static function float GetMagCapacityMod(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( UM_AA12AutoShotgun(Other) != none && KFPRI.ClientVeteranSkillLevel > 0 )
		Return (1.00 + 0.06 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // Up to 60% larger fuel canister
	
	Return 1.00;
}

//Reload Speed added by TGN
static function float GetReloadSpeedModifier(KFPlayerReplicationInfo KFPRI, KFWeapon Other)
{
	if ( (UM_BaseShotgun(Other) != None || 
			BenelliShotgun(Other) != none || Shotgun(Other) != none || 
			 Trenchgun(Other) != none || UM_M32Shotgun(Other) != none ||
			 GoldenBenelliShotgun(Other) != none || Hemi_Braindead_Moss12Shotgun(Other) != none ||
			 Maria_M37IthacaShotgun(Other) != none || BoomStick(Other) != none ) 
		 && KFPRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.03 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 30% faster BenelliShotgun/Shotgun/BoomStick reload speed
	
	Return 1.00;
}

static function int AddCarryMaxWeight(KFPlayerReplicationInfo KFPRI)
{
	Return Min(KFPRI.ClientVeteranSkillLevel,10);
}

static function float GetWeldSpeedModifier(KFPlayerReplicationInfo KFPRI)
{
	Return 1.10 + (0.19 * float(Min(KFPRI.ClientVeteranSkillLevel,10))); // 200% increase in speed
}

static function float AddExtraAmmoFor(KFPlayerReplicationInfo KFPRI, Class<Ammunition> AmmoType)
{
	//Bonuses by base-classes
	if ( Class<UM_BaseMagShotgunAmmo>(AmmoType) != None )
		Return 1.00 + (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel,5)));
	else if ( Class<UM_BaseShotgunAmmo>(AmmoType) != None )
		Return 1.00 + (0.08 * float(Min(KFPRI.ClientVeteranSkillLevel,5)));
	// Up to 6 extra Grenades
	else if ( AmmoType == class'FragAmmo' && KFPRI.ClientVeteranSkillLevel > 1 )
		Return 0.8 + (0.20 * float(Min(KFPRI.ClientVeteranSkillLevel,6)));
	else if ( (AmmoType == class'ShotgunAmmo' || AmmoType == class'DBShotgunAmmo' || 
				 AmmoType == class'NailGunAmmo' || AmmoType == class'UM_M32ShotgunAmmo' ||
				 AmmoType == class'Hemi_Braindead_Moss12Ammo' || 
				 AmmoType == class'Maria_M37IthacaAmmo' ||
				 AmmoType == class'MrQuebec_HekuT_Spas12Ammo') 
			 && KFPRI.ClientVeteranSkillLevel > 0 )
	{
		if ( KFPRI.ClientVeteranSkillLevel <= 2 )
			Return 1.125;
		else if ( KFPRI.ClientVeteranSkillLevel <= 4 )
			Return 1.250;
		else if ( KFPRI.ClientVeteranSkillLevel == 5 )
			Return 1.375;
		
		Return 1.50; // Level 6 - 50% increase in shotgun ammo carried
	}
	else if ( (AmmoType == class'AA12Ammo' || AmmoType == class'KSGAmmo' || 
				AmmoType == class'GoldenAA12Ammo') 
			 && KFPRI.ClientVeteranSkillLevel > 1 )
	{
		if ( KFPRI.ClientVeteranSkillLevel <= 4 )
			Return 1.25;
		
		Return 1.50; // Level 5, 6 - 50% increase in AA12/KSG ammo carried
	}
	else if ( (AmmoType == class'BenelliAmmo' || AmmoType == class'TrenchgunAmmo' ||
				AmmoType == class'OperationY_ProtectaAmmo' ||
				AmmoType == class'GoldenBenelliAmmo' || AmmoType == class'SPShotgunAmmo') 
			 && KFPRI.ClientVeteranSkillLevel > 1 )
	{
		if ( KFPRI.ClientVeteranSkillLevel <= 4 )
			Return 1.20;
		
		Return 1.40; // Level 5, 6 - 40% increase Benelli shotgun ammo carried
	}

	Return 1.00;
}

static function int AddDamage(KFPlayerReplicationInfo KFPRI, KFMonster Injured, KFPawn Instigator, int InDamage, class<DamageType> DmgType)
{
	if ( Class<UM_BaseDamType_Shotgun>(DmgType) != None ||
		 Class<UM_BaseDamType_Shrapnel>(DmgType) != None ||
		 DmgType == class'DamTypeShotgun' || DmgType == class'DamTypeDBShotgun' ||
		 DmgType == class'DamTypeAA12Shotgun' || DmgType == class'DamTypeBenelli' ||
		 DmgType == class'DamTypeKSGShotgun' || DmgType == class'DamTypeNailgun' || 
		 DmgType == class'DamTypeSPShotgun' )
		Return float(InDamage) * (1.06 + (0.09 * float(Min(KFPRI.ClientVeteranSkillLevel,6)))); // Up to 60% more damage with Shotguns or shrapnel

	Return InDamage;
}

// Reduce Penetration damage with Shotgun slower
static function float GetShotgunPenetrationDamageMulti(KFPlayerReplicationInfo KFPRI, float DefaultPenDamageReduction)
{
	local float PenDamageInverse;

	PenDamageInverse = 1.0 - FMax(0,DefaultPenDamageReduction);

	if ( KFPRI.ClientVeteranSkillLevel == 0 )
		Return DefaultPenDamageReduction + (PenDamageInverse / 10.0);

	Return DefaultPenDamageReduction + ((PenDamageInverse / 5.5555) * float(Min(KFPRI.ClientVeteranSkillLevel, 5)));
}

// Change the cost of particular items
static function float GetCostScaling(KFPlayerReplicationInfo KFPRI, class<Pickup> Item)
{
	if ( Class<UM_BaseShotgunPickup>(Item) != None ||
		 Item == class'ShotgunPickup' || Item == class'BoomstickPickup' ||
		 Item == class'AA12Pickup' || Item == class'BenelliPickup' || 
		 Item == class'KSGPickup' || Item == class'NailGunPickup' || 
		 Item == class'TrenchgunPickup' || 
		 Item == class'UM_M32ShotgunPickup' ||
		 Item == class'GoldenBenelliPickup' ||
		 Item == class'Maria_M37IthacaPickup' ||
		 Item == class'Hemi_Braindead_Moss12Pickup' ||
		 Item == class'OperationY_ProtectaPickup' ||
		 Item == class'SPShotgunPickup' || Item == class'GoldenAA12Pickup' )
		Return 0.90 - (0.065 * float(Min(KFPRI.ClientVeteranSkillLevel, 10))); // Up to 75% discount on Shotguns

	Return 1.00;
}

static function float GetAimErrorModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseShotgunFire(WF) != None )
		Return 1.00 - (0.04 * float(Min(PRI.ClientVeteranSkillLevel, 10))); // Up to 40% bonus
	
	Return 1.0;
}

static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	if ( PRI.ClientVeteranSkillLevel > 0 && UM_BaseShotgunFire(WF) != None )
		Return 1.00 - (0.02 * float(Min(PRI.ClientVeteranSkillLevel, 10))); // Up to 20% bonus
	
	Return 1.0;
}

// Projectile Penetration Bonus
static function float GetProjectilePenetrationBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	if ( Class<UM_BaseProjectile_Buckshot>(ProjClass) != None || Class<UM_BaseProjectile_Shrapnel>(ProjClass) != None )
		Return 2.0 + float(Min(PRI.ClientVeteranSkillLevel, 6));	// Up to 800% bonus
	
	Return 1.0;
}

// Projectile Bounce Bonus
static function float GetProjectileBounceBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	if ( Class<UM_BaseProjectile_Buckshot>(ProjClass) != None && PRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.03 * float(Min(PRI.ClientVeteranSkillLevel, 10)));	// Up to 30% bonus
	else if ( Class<UM_BaseProjectile_Shrapnel>(ProjClass) != None && PRI.ClientVeteranSkillLevel > 0 )
		Return 1.00 + (0.05 * float(Min(PRI.ClientVeteranSkillLevel, 10)));	// Up to 50% bonus
	
	Return 1.0;
}

// Give Extra Items as Default
static function AddDefaultInventory(KFPlayerReplicationInfo KFPRI, Pawn P)
{
	local	int		ExtraAmmo;
	
	if ( UM_HumanPawn(P) != None )
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 6:
				ExtraAmmo = 12;
			case 5:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("KFMod.BoomStick", GetCostScaling(KFPRI, class'BoomStickPickup'), ExtraAmmo, 0);
				Break;
			
			case 8:
				ExtraAmmo = 12;
			case 7:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_BenelliM3Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_BenelliM3Pickup'), ExtraAmmo, 0);
				Break;
			
			case 9:
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_BenelliM4Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_BenelliM4Pickup'));
				Break;
			
			case 10:
				ExtraAmmo = 12;
				UM_HumanPawn(P).ExtendedCreateInventoryVeterancy("UnlimaginMod.UM_GoldenBenelliM4Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_GoldenBenelliM4Pickup'), ExtraAmmo, 0);
				Break;
		}
	}
	else
	{
		switch( KFPRI.ClientVeteranSkillLevel )
		{
			case 5:
			case 6:
				KFHumanPawn(P).CreateInventoryVeterancy("KFMod.BoomStick", GetCostScaling(KFPRI, class'BoomStickPickup'));
				Break;
			
			case 7:
			case 8:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_BenelliM3Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_BenelliM3Pickup'));
				Break;
			
			case 9:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_BenelliM4Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_BenelliM4Pickup'));
				Break;
			
			case 10:
				KFHumanPawn(P).CreateInventoryVeterancy("UnlimaginMod.UM_GoldenBenelliM4Shotgun", GetCostScaling(KFPRI, class'UnlimaginMod.UM_GoldenBenelliM4Pickup'));
				Break;
		}
	}
}

static function string GetCustomLevelInfo( byte Level )
{
	local string S;

	S = Default.CustomLevelInfo;
	ReplaceText(S,"%s",GetPercentStr(0.1 * float(Level)));
	ReplaceText(S,"%g",GetPercentStr(0.1*float(Level)-0.1f));
	ReplaceText(S,"%d",GetPercentStr(0.1+FMin(0.1 * float(Level),0.8f)));
	return S;
}

defaultproperties
{
	PerkIndex=1

	OnHUDIcon=Texture'KillingFloorHUD.Perks.Perk_Support'
	OnHUDGoldIcon=Texture'KillingFloor2HUD.Perk_Icons.Perk_Support_Gold'
	VeterancyName="Support Specialist"
	Requirements[0]="Weld %x door hitpoints"
	Requirements[1]="Deal %x damage with shotguns"
	NumRequirements=2

	SRLevelEffects(0)="10% more damage with Shotguns|10% better Shotgun penetration|10% faster welding/unwelding|10% discount on Shotguns"
	SRLevelEffects(1)="10% more damage with Shotguns|18% better Shotgun penetration|10% extra shotgun ammo|5% more damage with Grenades|20% increase in grenade capacity|15% increased carry weight|25% faster welding/unwelding|20% discount on Shotguns"
	SRLevelEffects(2)="20% more damage with Shotguns|36% better Shotgun penetration|20% extra shotgun ammo|10% more damage with Grenades|40% increase in grenade capacity|20% increased carry weight|50% faster welding/unwelding|30% discount on Shotguns"
	SRLevelEffects(3)="30% more damage with Shotguns|54% better Shotgun penetration|25% extra shotgun ammo|20% more damage with Grenades|60% increase in grenade capacity|25% increased carry weight|75% faster welding/unwelding|40% discount on Shotguns"
	SRLevelEffects(4)="40% more damage with Shotguns|72% better Shotgun penetration|25% extra shotgun ammo|30% more damage with Grenades|80% increase in grenade capacity|30% increased carry weight|100% faster welding/unwelding|50% discount on Shotguns"
	SRLevelEffects(5)="50% more damage with Shotguns|90% better Shotgun penetration|25% extra shotgun ammo|40% more damage with Grenades|100% increase in grenade capacity|50% increased carry weight|150% faster welding/unwelding|60% discount on Shotguns|Spawn with a Shotgun"
	SRLevelEffects(6)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
	SRLevelEffects(7)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
	SRLevelEffects(8)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"
	SRLevelEffects(9)="60% more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|50% more damage with Grenades|120% increase in grenade capacity|60% increased carry weight|150% faster welding/unwelding|70% discount on Shotguns|Spawn with a Hunting Shotgun"

	CustomLevelInfo="%s more damage with Shotguns|90% better Shotgun penetration|30% extra shotgun ammo|%g more damage with Grenades|120% increase in grenade capacity|%s increased carry weight|150% faster welding/unwelding|%d discount on Shotguns|Spawn with a Hunting Shotgun"
}