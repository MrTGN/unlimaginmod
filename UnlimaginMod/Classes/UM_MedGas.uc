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

var		int			HealBoostAmount;	// How much we heal a player by default with the medic nade
var		int			TotalHeals;			// The total number of times this nade has healed (or hurt enemies)
var		int			MaxHeals;			// The total number of times this nade will heal (or hurt enemies) until its done healing

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
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( !bTimerSet )
	{
		SetTimer(HealInterval, True);
		bTimerSet = True;
	}
}

function HealOrHurt(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local	actor					Victims;
	local	float					damageScale;
	local	vector					dir;
	local	int						i, NumKilled;
	local	KFMonster				KFMonsterVictim;
	local	Pawn					P;
	local	KFPawn					KFP;
	local	array<Pawn>				CheckedPawns;
	local	bool					bAlreadyChecked;
	// Healing
	local	KFPlayerReplicationInfo	PRI;
	local	int						MedicReward, HealSum;

	if ( bHurtEntry )
		Return;

	bHurtEntry = True;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if ( Victims != self && Hurtwall != Victims && Victims.Role == ROLE_Authority && 
			 !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims) == None &&
			 Victims.Class != Class )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
				
			if( (Instigator == None || Instigator.Health <= 0) && KFPawn(Victims) != None )
				Continue;

			damageScale = 1.0;

			P = Pawn(Victims);

			if ( P != None )
			{
		        for (i = 0; i < CheckedPawns.Length; i++)
				{
		        	if ( CheckedPawns[i] == P )
					{
						bAlreadyChecked = True;
						Break;
					}
				}

				if ( bAlreadyChecked )
				{
					bAlreadyChecked = False;
					P = None;
					Continue;
				}

                if ( KFMonster(Victims) != None && KFMonster(Victims).Health > 0 )
					KFMonsterVictim = KFMonster(Victims);
				else
					KFMonsterVictim = None;

                KFP = KFPawn(Victims);

                if ( KFMonsterVictim != None )
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                else if ( KFP != None )
				    damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));

				CheckedPawns[CheckedPawns.Length] = P;

				if ( damageScale <= 0 )
				{
					P = None;
					Continue;
				}
				else
				{
					//Victims = P;
					P = none;
				}
				
				if ( KFP == None )
				{
					if ( Pawn(Victims) != None && Pawn(Victims).Health > 0 && DamageAmount > 0.0 )
					{
						Victims.TakeDamage
						(
							(damageScale * DamageAmount),
							Instigator, 
							(Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir),
							(damageScale * Momentum * dir),
							DamageType
						);
						
						if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0 )
							Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

						// Calculating number of victims
						if ( Role == ROLE_Authority && KFMonsterVictim != None && 
							 KFMonsterVictim.Health <= 0 )
							NumKilled++;
					}
				}
				else
				{
					if ( Instigator != None && KFP.Health > 0 && KFP.Health < KFP.HealthMax && HealBoostAmount > 0 )
					{
						MedicReward = HealBoostAmount;

						PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

						if ( PRI != None && PRI.ClientVeteranSkill != None )
							MedicReward *= PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);

						HealSum = MedicReward;

						if ( (KFP.Health + KFP.healthToGive + MedicReward) > KFP.HealthMax )
						{
							MedicReward = KFP.HealthMax - (KFP.Health + KFP.healthToGive);
							if ( MedicReward < 0 )
								MedicReward = 0;
						}

						KFP.GiveHealth(HealSum, KFP.HealthMax);

						if ( PRI != None )
						{
							if ( MedicReward > 0 && KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements) != None )
								KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).AddDamageHealed(MedicReward, false, true);

							// Give the medic reward money as a percentage of how much of the person's health they healed
							MedicReward = int( (FMin(float(MedicReward), KFP.HealthMax) / KFP.HealthMax) * 60 );

							PRI.Score += MedicReward;
							PRI.ThreeSecondScore += MedicReward;

							PRI.Team.Score += MedicReward;

							if ( KFHumanPawn(Instigator) != None )
								KFHumanPawn(Instigator).AlphaAmount = 255;

							if ( PlayerController(Instigator.Controller) != None )
								PlayerController(Instigator.Controller).ClientMessage(SuccessfulHealMessage@KFP.PlayerReplicationInfo.PlayerName, 'CriticalEvent');
						}
					}
				}

				KFMonsterVictim = None;
				KFP = None;
			}
        }
	}

	bHurtEntry = false;
}

simulated event Timer()
{
	DamageRadius = FMin((default.DamageRadius * MaxDamageRadiusScale), (DamageRadius * 1.05));
	Damage = FMax((default.Damage * MinEfficiencyCoefficient), (Damage * 0.9));
	HealBoostAmount = Max(int(float(default.HealBoostAmount) * MinEfficiencyCoefficient), int(float(HealBoostAmount) * 0.9));
		
	//if ( FearMarker != None )
		//FearMarker.SetCollisionSize(DamageRadius, DamageRadius);
	
	if ( Role == ROLE_Authority )
	{
		if ( TotalHeals < MaxHeals )
		{
			TotalHeals++;
			HealOrHurt(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
		}
		else
			Destroy();
	}
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
