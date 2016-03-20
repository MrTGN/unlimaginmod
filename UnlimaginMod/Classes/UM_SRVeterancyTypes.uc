// Written by .:..: (2009)
// Base class of all server veterancy types
class UM_SRVeterancyTypes extends KFVeterancyTypes
	Abstract;

//========================================================================
//[block] Variables

var()	localized	string			CustomLevelInfo;
var()	localized	array<string>	SRLevelEffects; // Added in ver 5.00, dynamic array for level effects.
var()				byte			NumRequirements;

// Veterancy Equipment
struct	EquipmentData
{
	var		string		ClassName;
	var		int			MinLevel;	// Equipment will be added starting from this Skill Level. 0 - No restrictions.
	var		int			MaxLevel;	// Equipment will be removed after this Skill Level. 0 - No restrictions.
};

var		array< EquipmentData >		StandardEquipment;
var		array< EquipmentData >		AdditionalEquipment;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// Can be used to add in custom stats.
static function AddCustomStats( UM_ClientRepInfoLink Other );

// Return the level of perk that is available, 0 = perk is n/a.
static function byte PerkIsAvailable( UM_ClientRepInfoLink StatOther )
{
	local byte i;

	// Check which level it fits in to.
	for( i = 0; i < StatOther.MaximumLevel; ++i )  {
		if ( !LevelIsFinished(StatOther, i) )
			Return Clamp(i, StatOther.MinimumLevel, StatOther.MaximumLevel);
	}
	
	Return StatOther.MaximumLevel;
}

// Return the number of different requirements this level has.
static function byte GetRequirementCount( UM_ClientRepInfoLink StatOther, byte CurLevel )
{
	if ( CurLevel == StatOther.MaximumLevel )
		Return 0;
	
	Return default.NumRequirements;
}

// Return 0-1 % of how much of the progress is done to gain this perk (for menu GUI).
static function float GetTotalProgress( UM_ClientRepInfoLink StatOther, byte CurLevel )
{
	local byte i,rc,Minimum;
	local int R,V,NegReq;
	local float RV;

	if ( CurLevel == StatOther.MaximumLevel )
		Return 1.f;
	
	if ( StatOther.bMinimalRequirements )  {
		Minimum = 0;
		CurLevel = Max((CurLevel - StatOther.MinimumLevel), 0);
	}
	else 
		Minimum = StatOther.MinimumLevel;

	rc = GetRequirementCount(StatOther,CurLevel);
	
	for( i = 0; i < rc; ++i )  {
		V = GetPerkProgressInt(StatOther, R, CurLevel, i);
		R *= StatOther.RequirementScaling;
		if ( CurLevel > Minimum )  {
			GetPerkProgressInt(StatOther, NegReq, (CurLevel - 1), i);
			NegReq *= StatOther.RequirementScaling;
			R -= NegReq;
			V -= NegReq;
		}
		
		if( R <= 0 ) // Avoid division by zero error.
			RV += 1.f;
		else 
			RV += FClamp((float(V) / (float(R))), 0.f, 1.f);
	}
	Return RV/float(rc);
}

// Return True if this level is earned.
static function bool LevelIsFinished( UM_ClientRepInfoLink StatOther, byte CurLevel )
{
	local byte i,rc;
	local int R,V;

	if ( CurLevel == StatOther.MaximumLevel )
		Return False;
	
	if ( StatOther.bMinimalRequirements )
		CurLevel = Max((CurLevel - StatOther.MinimumLevel), 0);
	
	rc = GetRequirementCount(StatOther,CurLevel);
	
	for( i = 0; i < rc; ++i )  {
		V = GetPerkProgressInt(StatOther, R, CurLevel, i);
		R *= StatOther.RequirementScaling;
		if ( R > V )
			Return False;
	}
	
	Return True;
}

// Return 0-1 % of how much of the progress is done to gain this individual task (for menu GUI).
static function float GetPerkProgress( UM_ClientRepInfoLink StatOther, byte CurLevel, byte ReqNum, out int Numerator, out int Denominator )
{
	local byte Minimum;
	local int Reduced,Cur,Fin;

	if ( CurLevel == StatOther.MaximumLevel )  {
		Denominator = 1;
		Numerator = 1;
		Return 1.f;
	}
	
	if ( StatOther.bMinimalRequirements )  {
		Minimum = 0;
		CurLevel = Max((CurLevel - StatOther.MinimumLevel), 0);
	}
	else 
		Minimum = StatOther.MinimumLevel;
	
	Numerator = GetPerkProgressInt(StatOther, Denominator, CurLevel, ReqNum);
	Denominator *= StatOther.RequirementScaling;
	
	if ( CurLevel > Minimum )  {
		GetPerkProgressInt(StatOther, Reduced, (CurLevel - 1), ReqNum);
		Reduced *= StatOther.RequirementScaling;
		Cur = Max((Numerator - Reduced), 0);
		Fin = Max((Denominator - Reduced), 0);
	}
	else  {
		Cur = Numerator;
		Fin = Denominator;
	}
	
	if ( Fin <= 0 ) // Avoid division by zero.
		Return 1.f;
	
	Return FMin((float(Cur) / float(Fin)), 1.f);
}

// Return int progress for this perk level up.
static function int GetPerkProgressInt( UM_ClientRepInfoLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
{
	FinalInt = 1;
	
	Return 1;
}
static final function int GetDoubleScaling( byte CurLevel, int InValue )
{
	CurLevel -= 6;
	
	Return (CurLevel * CurLevel * InValue);
}

// Get display info text for menu GUI
static function string GetVetInfoText( byte Level, byte Type, optional byte RequirementNum )
{
	switch( Type )  {
		case 0:
			Return Default.LevelNames[Min(Level,ArrayCount(Default.LevelNames))]; // This was left in the void of unused...
			Break;
		
		case 1:
			if ( Level >= Default.SRLevelEffects.Length )
				Return GetCustomLevelInfo(Level);
			else
				Return Default.SRLevelEffects[Level];
			Break;
		
		case 2:
			Return Default.Requirements[RequirementNum];
			Break;
	
		default:
			Return Default.VeterancyName;
			Break;
	}
}

static function string GetCustomLevelInfo( byte Level )
{
	Return Default.CustomLevelInfo;
}

static final function string GetPercentStr( float InValue )
{
	Return int(InValue * 100.f)$"%";
}

// This function is called for every weapon with and every perk every time trader menu is shown.
// If returned False on any perk, weapon is hidden from the buyable list.
static function bool AllowWeaponInTrader( class<KFWeaponPickup> Pickup, KFPlayerReplicationInfo KFPRI, byte Level )
{
	Return True;
}

static function byte PreDrawPerk( Canvas C, byte Level, out Material PerkIcon, out Material StarIcon )
{
	if ( Level > 15 )  {
		PerkIcon = Default.OnHUDGoldIcon;
		StarIcon = Class'HUDKillingFloor'.Default.VetStarGoldMaterial;
		Level-=15;
		C.SetDrawColor(64, 64, 255, C.DrawColor.A);
	}
	else if ( Level > 10 )  {
		PerkIcon = Default.OnHUDGoldIcon;
		StarIcon = Class'HUDKillingFloor'.Default.VetStarGoldMaterial;
		Level-=10;
		C.SetDrawColor(0, 255, 0, C.DrawColor.A);
	}
	else if ( Level > 5 )  {
		PerkIcon = Default.OnHUDGoldIcon;
		StarIcon = Class'HUDKillingFloor'.Default.VetStarGoldMaterial;
		Level-=5;
		C.SetDrawColor(255, 255, 255, C.DrawColor.A);
	}
	else  {
		PerkIcon = Default.OnHUDIcon;
		StarIcon = Class'HUDKillingFloor'.Default.VetStarMaterial;
		C.SetDrawColor(255, 255, 255, C.DrawColor.A);
	}
	
	Return Min(Level, 15);
}

// Standard Equipment
static function AddStandardEquipment( UM_HumanPawn Human, UM_PlayerReplicationInfo PRI )
{
	local	int		i;
	
	for ( i = 0; i < default.StandardEquipment.Length; ++i )  {
		if ( default.StandardEquipment[i].ClassName != "" )  {
			// Skip this Equipment
			if ( (default.StandardEquipment[i].MinLevel > 0 && PRI.ClientVeteranSkillLevel < default.StandardEquipment[i].MinLevel) 
				 || (default.StandardEquipment[i].MaxLevel > 0 && PRI.ClientVeteranSkillLevel > default.StandardEquipment[i].MaxLevel) )
				Continue;
			// Add Equipment to the Human Inventory
			Human.CreateInventory( default.StandardEquipment[i].ClassName );
		}
	}
}

// Additional Equipment
static function AddAdditionalEquipment( UM_HumanPawn Human, UM_PlayerReplicationInfo PRI )
{
	local	int		i;
	
	for ( i = 0; i < default.AdditionalEquipment.Length; ++i )  {
		if ( default.AdditionalEquipment[i].ClassName != "" )  {
			// Skip this Equipment
			if ( (default.AdditionalEquipment[i].MinLevel > 0 && PRI.ClientVeteranSkillLevel < default.AdditionalEquipment[i].MinLevel) 
				 || (default.AdditionalEquipment[i].MaxLevel > 0 && PRI.ClientVeteranSkillLevel > default.AdditionalEquipment[i].MaxLevel) )
				Continue;
			// Add Equipment to the Human Inventory
			Human.CreateInventory( default.AdditionalEquipment[i].ClassName );
		}
	}
}

// Perk weapon restriction
static function bool CanUseThisWeapon( UM_PlayerReplicationInfo PRI, Weapon W )
{
	Return True;
}

static function float GetMaxSlowMoCharge( UM_PlayerReplicationInfo PRI )
{
	if ( PRI.ClientVeteranSkillLevel > 6 )
		Return 0.3 * float(Min(PRI.ClientVeteranSkillLevel, 10)); // Up to 3.0 SlowMo seconds
	
	Return 0.0;
}

static function float GetSlowMoChargeRegenModifier( UM_PlayerReplicationInfo PRI )
{
	if ( PRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 + 0.025 * float(Min(PRI.ClientVeteranSkillLevel, 10));	// Up to 25% bonus for the all perks
	
	Return 1.0;
}

// On how much this human can overheal somebody
static function float GetOverhealPotency( UM_PlayerReplicationInfo PRI )
{
	Return 1.0;
}

// Maximum Health that Human can have when he has been overhealed
static function float GetOverhealedHealthMaxModifier( UM_PlayerReplicationInfo PRI )
{
	if ( PRI.ClientVeteranSkillLevel > 0 )
		Return 1.0 + 0.05 * float(Min(PRI.ClientVeteranSkillLevel, 5));	// Up to 25% bonus for the all perks
	
	Return 1.0;
}

// New function to reduce taken damage
static function float GetHumanTakenDamageModifier( UM_PlayerReplicationInfo PRI, UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	Return 1.0;
}

// Pawn Movement Bonus while wielding this weapon
static function float GetWeaponPawnMovementBonus( UM_PlayerReplicationInfo PRI, Weapon W )
{
	Return 1.0;
}

// New function for the extra jump height
static function float GetPawnJumpModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.0;
}

// The Max number this pawn can Bounce from the walls and other pawns
static function int GetPawnMaxBounce( UM_PlayerReplicationInfo PRI )
{
	Return 0;
}

// Bonus for the Pawn IntuitiveShootingRange
static function float GetIntuitiveShootingModifier( UM_PlayerReplicationInfo PRI )
{
	Return 1.0;
}

// Weapon Fire Spread
static function float GetSpreadModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	Return 1.0;
}

// Weapon Fire AimError
static function float GetAimErrorModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	Return 1.0;
}

// Weapon Fire Recoil
static function float GetRecoilModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	Return 1.0;
}

// Weapon Fire ShakeView
static function float GetShakeViewModifier( UM_PlayerReplicationInfo PRI, WeaponFire WF )
{
	Return 1.0;
}

// Projectile Penetration Bonus
static function float GetProjectilePenetrationBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	Return 1.0;
}

// Projectile Bounce Bonus
static function float GetProjectileBounceBonus( UM_PlayerReplicationInfo PRI, Class<UM_BaseProjectile> ProjClass )
{
	Return 1.0;
}

//[end] Functions
//====================================================================

defaultproperties
{
	NumRequirements=1
	StandardEquipment(0)=(ClassName="KFMod.Knife")
	StandardEquipment(1)=(ClassName="KFMod.Single")
	StandardEquipment(2)=(ClassName="UnlimaginMod.UM_Weapon_HandGrenade")
	StandardEquipment(3)=(ClassName="UnlimaginMod.UM_Syringe")
	StandardEquipment(4)=(ClassName="KFMod.Welder")
}