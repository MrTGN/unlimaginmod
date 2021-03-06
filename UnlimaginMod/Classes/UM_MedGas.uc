//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_MedGas
//	Parent class:	 UM_BaseProjectile_Gas
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.06.2013 21:03
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_MedGas extends UM_BaseProjectile_Gas;


//========================================================================
//[block] Variables

var		bool		bTimerSet;

var		AvoidMarker				FearMarker;
var		Class<AvoidMarker>		FearMarkerClass;

var		bool		bCanOverheal;
var		int			HealBoostAmount;	// How much we heal a player by default with the medic nade
var		int			MaxHeals;			// The total number of times this nade will heal (or hurt enemies) until its done healing
var		float		MoneyPerHealedHealth;

var		float		HealInterval;		// How often to do healing
var		string		SuccessfulHealMessage;

// Simulation of gas diffusion
var		float		MaxDamageRadiusScale;	// Maximun scale of DamageRadius
var		float		MinEfficiencyCoefficient;	// Minimum scale of Damage and HealBoostAmount

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( FearMarkerClass != None )  {
		FearMarker = Spawn(FearMarkerClass, self);
		if ( FearMarker != None )  {
			FearMarker.SetBase(self);
			FearMarker.SetCollisionSize((DamageRadius * 1.05), (DamageRadius * 1.05));
    		FearMarker.StartleBots();
		}
	}
	
	if ( UM_GameReplicationInfo(Level.GRI) != None )  {
		if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 2.0 )
			MoneyPerHealedHealth *= 1.8;
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 4.0 )
			MoneyPerHealedHealth *= 1.5;
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 5.0 )
			MoneyPerHealedHealth *= 1.2;
	}
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )  {
		bTimerSet = True;
		SetTimer(HealInterval, True);
	}
}

// Heal Or Hurt Pawns in Radius
function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local	Pawn					Victim;
	local	float					DamageScale, Dist;
	local	vector					Dir;
	local	int						i;
	local	array<Pawn>				CheckedPawns;
	local	bool					bAlreadyChecked;

	if ( bHurtEntry || DamageAmount <= 0.0 )
		Return;

	bHurtEntry = True;

	// Check Only Pawns
	foreach CollidingActors( Class'Pawn', Victim, DamageRadius, HitLocation )  {
		if ( Vehicle(Victim) != None )
			Victim = Vehicle(Victim).Driver;
		
		if ( Victim == None || Victim.bDeleteMe || Victim.bHidden || !Victim.bCanBeDamaged || Victim.Health < 1 )
			Continue;
		
		// Resets to the default values
		bAlreadyChecked = False;
		// Check CheckedPawns array
		for ( i = 0; i < CheckedPawns.Length; ++i )  {
			// comparison by object
			if ( CheckedPawns[i] == Victim )  {
				bAlreadyChecked = True;
				Break;
			}
		}
		// Ignore already Checked Pawns
		if ( bAlreadyChecked )
			Continue;
		
		CheckedPawns[CheckedPawns.Length] = Victim;
		// Heal
		if ( Victim.GetTeamNum() == InstigatorTeamNum )  {
			if ( HealBoostAmount < 1 || !FastTrace( Victim.Location, HitLocation ) )
				Continue;
			// Heal Victim
			if ( UM_HumanPawn(Victim) != None )
				UM_HumanPawn(Victim).Heal( HealBoostAmount, bCanOverheal, UM_HumanPawn(Instigator), MoneyPerHealedHealth );
			else
				Victim.Health = Min((Victim.Health + HealBoostAmount), int(Victim.MaxHealth));
		}
		// Damage
		else  {
			// Skip this iteration
			if ( DamageAmount <= 0.0 || !FastTrace( Victim.Location, HitLocation ) )
				Continue;
			
			Dir = Victim.Location - HitLocation;
			Dist = VSize(Dir);
			Dir = Dir / Dist; // Normalization
			DamageScale = FMax( (1.0 - FMax((Dist - Victim.CollisionRadius), 0.0) / DamageRadius), 0.0 );
			i = Round(DamageScale * DamageAmount);
			if ( i < 1 )
				Continue;

			// Damage Victim
			Victim.TakeDamage( i, Instigator,
				(Victim.Location - (Victim.CollisionHeight + Victim.CollisionRadius) * 0.5 * Dir),
				(Momentum * DamageScale * Dir), DamageType );
		}
	}

	bHurtEntry = False;
}

event Timer()
{
	if ( MaxHeals < 1 )  {
		Destroy();
		Return;
	}
	
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
	DamageRadius = FMin( (default.DamageRadius * MaxDamageRadiusScale), (DamageRadius * 1.05) );
	Damage = FMax( (default.Damage * MinEfficiencyCoefficient), (Damage * 0.9) );
	HealBoostAmount = Max( Round(float(default.HealBoostAmount) * MinEfficiencyCoefficient), Round(float(HealBoostAmount) * 0.9) );
	--MaxHeals;
	if ( MaxHeals < 1 )
		Destroy();
}

simulated event Destroyed()
{
	if ( FearMarker != None )
		FearMarker.Destroy();
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================



defaultproperties
{
	 bCanOverheal=False
	 MoneyPerHealedHealth=0.6
	 MomentumTransfer=0.0
	 bInitialAcceleration=False
	 SpeedDropScale=0.780000
	 MaxDamageRadiusScale=1.500000
	 MinEfficiencyCoefficient=0.250000
	 FearMarkerClass=Class'AvoidMarker'
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=0.000000
	 EffectiveRange=0.000000
	 HealBoostAmount=14
     MaxHeals=8
     HealInterval=0.500000
     SuccessfulHealMessage="You healed "
	 Damage=16.0
	 DamageRadius=120.0
     GasCloudEmitterClass=Class'UnlimaginMod.UM_MedGasCloud'
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_MedGasTrail',EmitterRotation=(Pitch=32768))
	 //DrawType=DT_StaticMesh
	 //StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 //DrawScale=20.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMedGas'
	 LifeSpan=4.000000
}
