//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MedGas
//	Parent class:	 UM_BaseProjectile_Gas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.06.2013 21:03
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
	
	if ( FearMarkerClass != None )
	{
		FearMarker = Spawn(FearMarkerClass, self);
		if ( FearMarker != None )
		{
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
		SetTimer(HealInterval, True);
		bTimerSet = True;
	}
}

// Heal Or Hurt Pawns in Radius
function HealOrHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local	Pawn					Victim;
	local	float					DamageScale, Dist;
	local	vector					Dir;
	local	int						i;
	local	array<Pawn>				CheckedPawns;
	local	bool					bAlreadyChecked;

	if ( bHurtEntry )
		Return;

	bHurtEntry = True;

	// Check Only Pawns
	foreach CollidingActors( Class'Pawn', Victim, DamageRadius, HitLocation )  {
		if ( Victim != None && !Victim.bDeleteMe && Victim != Hurtwall && Victim.Health > 0 )  {
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
			
			if ( UM_HumanPawn(Victim) != None )  {
				// Skip this iteration
				if ( HealBoostAmount < 1 || (Instigator != None && Instigator.GetTeamNum() != UM_HumanPawn(Victim).GetTeamNum()) )
					Continue;
				
				UM_HumanPawn(Victim).Heal( HealBoostAmount, bCanOverheal, UM_HumanPawn(Instigator), MoneyPerHealedHealth );
			}
			else if ( KFMonster(Victim) != None )  {
				// Skip this iteration
				if ( DamageAmount <= 0.0 )
					Continue;
				
				Dir = Victim.Location - HitLocation;
				Dist = FMax(VSize(Dir), 1.0);
				Dir /= Dist;
				// DamageScale
				DamageScale = (1.0 - FMax(((Dist - Victim.CollisionRadius) / DamageRadius), 0.0)) * KFMonster(Victim).GetExposureTo(Location + 15.0 * -Normal(PhysicsVolume.Gravity));
				if ( DamageScale > 0.0 )  {
					Victim.TakeDamage
					(
						(DamageScale * DamageAmount),
						Instigator, 
						(Victim.Location - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * Dir),
						(DamageScale * Momentum * Dir),
						DamageType
					);
				}
			}
			else if ( Vehicle(Victim) != None && DamageAmount > 0.0 )  {
				if ( Instigator == None || Instigator.Controller == None )
					Victim.SetDelayedDamageInstigatorController( InstigatorController );
				Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			}
        }
	}

	bHurtEntry = false;
}

event Timer()
{
	if ( MaxHeals > 0 )  {
		--MaxHeals;
		HealOrHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
		DamageRadius = FMin( (default.DamageRadius * MaxDamageRadiusScale), (DamageRadius * 1.05) );
		Damage = FMax( (default.Damage * MinEfficiencyCoefficient), (Damage * 0.9) );
		HealBoostAmount = Max( Round(float(default.HealBoostAmount) * MinEfficiencyCoefficient), Round(float(HealBoostAmount) * 0.9) );
		//if ( FearMarker != None )
			//FearMarker.SetCollisionSize(DamageRadius, DamageRadius);
	}
	else
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
	 Damage=16.000000
	 DamageRadius=120.000000
     GasCloudEmitterClass=Class'UnlimaginMod.UM_MedGasCloud'
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_MedGasTrail',EmitterRotation=(Pitch=32768))
	 //DrawType=DT_StaticMesh
	 //StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 //DrawScale=20.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMedGas'
	 LifeSpan=4.000000
}
