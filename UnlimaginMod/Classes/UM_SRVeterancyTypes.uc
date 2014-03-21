// Written by .:..: (2009)
// Base class of all server veterancy types
class UM_SRVeterancyTypes extends KFVeterancyTypes
	Abstract;

var() localized string CustomLevelInfo;
var() localized array<string> SRLevelEffects; // Added in ver 5.00, dynamic array for level effects.
var() byte NumRequirements;

// Can be used to add in custom stats.
static function AddCustomStats( UM_SRClientPerkRepLink Other );

// Return the level of perk that is available, 0 = perk is n/a.
static function byte PerkIsAvailable( UM_SRClientPerkRepLink StatOther )
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
static function byte GetRequirementCount( UM_SRClientPerkRepLink StatOther, byte CurLevel )
{
	if ( CurLevel == StatOther.MaximumLevel )
		Return 0;
	
	Return default.NumRequirements;
}

// Return 0-1 % of how much of the progress is done to gain this perk (for menu GUI).
static function float GetTotalProgress( UM_SRClientPerkRepLink StatOther, byte CurLevel )
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
	return RV/float(rc);
}

// Return true if this level is earned.
static function bool LevelIsFinished( UM_SRClientPerkRepLink StatOther, byte CurLevel )
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
static function float GetPerkProgress( UM_SRClientPerkRepLink StatOther, byte CurLevel, byte ReqNum, out int Numerator, out int Denominator )
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
static function int GetPerkProgressInt( UM_SRClientPerkRepLink StatOther, out int FinalInt, byte CurLevel, byte ReqNum )
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
// If returned false on any perk, weapon is hidden from the buyable list.
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

// New function for the extra jump height
static function float GetJumpModifier(KFPlayerReplicationInfo KFPRI)
{
	Return 1.0;
}

static function int GetMaxBounce(KFPlayerReplicationInfo KFPRI)
{
	Return 0;
}

static function float GetSpreadModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	Return 1.0;
}

static function float GetAimErrorModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	Return 1.0;
}

static function float GetRecoilModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	Return 1.0;
}

static function float GetShakeViewModifier( KFPlayerReplicationInfo KFPRI, WeaponFire WF )
{
	Return 1.0;
}


defaultproperties
{
	NumRequirements=1
}