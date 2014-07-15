//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12MedGasBullet
//	Parent class:	 LAWProj
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.11.2012 22:04
//================================================================================
class UM_AA12MedGasBullet extends LAWProj;

var		xEmitter		xEmitterTrail;
var		class<Emitter>	ExplosionEmitter;
var		float			ExplosionSoundVolume;

var()	float			HeadShotDamageMult;

var()   int     HealBoostAmount;// How much we heal a player by default with the medic nade

var     int     TotalHeals;     // The total number of times this nade has healed (or hurt enemies)
var()   int     MaxHeals;       // The total number of times this nade will heal (or hurt enemies) until its done healing
var     float   NextHealTime;   // The next time that this nade will heal friendlies or hurt enemies
var()   float   HealInterval;   // How often to do healing

var		string	SuccessfulHealMessage;

var 	int		MaxNumberOfPlayers;

var     bool    bNeedToPlayEffects; // Whether or not effects have been played yet

replication
{
    reliable if (Role==ROLE_Authority)
        bNeedToPlayEffects;
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	Super(Projectile).HitWall(HitNormal,Wall);
}

simulated event PostNetReceive()
{
	if( bHidden && !bDisintegrated )
	{
		Disintegrate(Location, vect(0,0,1));
	}
	
	if( !bHasExploded && bNeedToPlayEffects )
    {
        bNeedToPlayEffects = false;
        Explode(Location, vect(0,0,1));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	bHasExploded = True;
	SetPhysics(PHYS_None);
	BlowUp(HitLocation);

	PlaySound(ExplosionSound,,ExplosionSoundVolume);
	
	if( Role == ROLE_Authority )
	{
        bNeedToPlayEffects = true;
        AmbientSound=Sound'Inf_WeaponsTwo.smoke_loop';
	}
	
	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(ExplosionEmitter,,, HitLocation + HitNormal, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}
	
	if ( StaticMesh != None )
		SetStaticMesh(None);
	
	//if( Role < ROLE_Authority )
		//Destroy();
}

simulated event PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( !PhysicsVolume.bWaterVolume )
		{
			xEmitterTrail = Spawn(class'KFTracer',self);
			xEmitterTrail.Lifespan = Lifespan;
		}
	}
	
	OrigLoc = Location;
	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity = 0.6 * Velocity;
	}

	Super(Projectile).PostBeginPlay();
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	if( damageType == class'SirenScreamDamage')
		Disintegrate(HitLocation, vect(0,0,1));
	else
		Explode(HitLocation, vect(0,0,0));
}

simulated function Destroyed()
{
	if ( xEmitterTrail != none )
	{
		xEmitterTrail.mRegen=False;
		xEmitterTrail.SetPhysics(PHYS_None);
		xEmitterTrail.GotoState('');
	}

	if ( SmokeTrail != None )
		SmokeTrail.HandleOwnerDestroyed();

	if( !bHasExploded && !bHidden )
		Explode(Location,vect(0,0,1));

	if( bHidden && !bDisintegrated )
		Disintegrate(Location,vect(0,0,1));

	Super(ROBallisticProjectile).Destroyed();
}

simulated function BlowUp(vector HitLocation)
{
	HealOrHurt(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}

function HealOrHurt(float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
	local actor Victims;
	local float damageScale, dist;
	local vector dirs;
	local int NumKilled;
	local KFMonster KFMonsterVictim;
	local Pawn P;
	local KFPawn KFP;
	local array<Pawn> CheckedPawns;
	local int i;
	local bool bAlreadyChecked;
	// Healing
	local KFPlayerReplicationInfo PRI;
	local int MedicReward;
	local float HealSum; // for modifying based on perks
	local int PlayersHealed;

	if ( bHurtEntry )
		Return;

    NextHealTime = Level.TimeSeconds + HealInterval;

	bHurtEntry = true;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
		 && ExtendedZCollision(Victims)==None )
		{
			if( (Instigator==None || Instigator.Health<=0) && KFPawn(Victims)!=None )
				Continue;

			dirs = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dirs));
			dirs = dirs/dist;
			damageScale = 1.0;

			if ( Instigator == None || Instigator.Controller == None )
			{
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			}

			P = Pawn(Victims);

			if( P != none )
			{
		        for (i = 0; i < CheckedPawns.Length; i++)
				{
		        	if (CheckedPawns[i] == P)
					{
						bAlreadyChecked = true;
						break;
					}
				}

				if( bAlreadyChecked )
				{
					bAlreadyChecked = false;
					P = none;
					continue;
				}

                KFMonsterVictim = KFMonster(Victims);

    			if( KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
    			{
                    KFMonsterVictim = none;
    			}

                KFP = KFPawn(Victims);

                if( KFMonsterVictim != none )
                {
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }
                else if( KFP != none )
                {
				    damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }

				CheckedPawns[CheckedPawns.Length] = P;

				if ( damageScale <= 0)
				{
					P = none;
					continue;
				}
				else
				{
					//Victims = P;
					P = none;
				}
			}
			else
			{
                continue;
			}

            if( KFP == none )
            {
    			//log(Level.TimeSeconds@"Hurting "$Victims$" for "$(damageScale * DamageAmount)$" damage");

    			if( Pawn(Victims) != none && Pawn(Victims).Health > 0 )
    			{
                    Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius)
        			 * dirs,(damageScale * Momentum * dirs),DamageType);

        			if( Role == ROLE_Authority && KFMonsterVictim != none && KFMonsterVictim.Health <= 0 )
                    {
                        NumKilled++;
                    }
                }
			}
			else
			{
                if( Instigator != none && KFP.Health > 0 && KFP.Health < KFP.HealthMax )
                {
					PlayersHealed += 1;
            		MedicReward = HealBoostAmount;

            		PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

            		if ( PRI != none && PRI.ClientVeteranSkill != none )
            		{
            			MedicReward *= PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);
            		}

                    HealSum = MedicReward;

            		if ( (KFP.Health + KFP.healthToGive + MedicReward) > KFP.HealthMax )
            		{
                        MedicReward = KFP.HealthMax - (KFP.Health + KFP.healthToGive);
            			if ( MedicReward < 0 )
            			{
            				MedicReward = 0;
            			}
            		}

                    //log(Level.TimeSeconds@"Healing "$KFP$" for "$HealSum$" base healamount "$HealBoostAmount$" health");
                    KFP.GiveHealth(HealSum, KFP.HealthMax);

             		if ( PRI != None )
            		{
            			if ( MedicReward > 0 && KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements) != none )
            			{
            				KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).AddDamageHealed(MedicReward, false, true);
            			}

                        // Give the medic reward money as a percentage of how much of the person's health they healed
            			MedicReward = int((FMin(float(MedicReward),KFP.HealthMax)/KFP.HealthMax) * 60);

            			PRI.Score += MedicReward;
            			PRI.ThreeSecondScore += MedicReward;

            			PRI.Team.Score += MedicReward;

            			if ( KFHumanPawn(Instigator) != none )
            			{
            				KFHumanPawn(Instigator).AlphaAmount = 255;
            			}

                        if( PlayerController(Instigator.Controller) != none )
                        {
                            PlayerController(Instigator.Controller).ClientMessage(SuccessfulHealMessage@KFP.PlayerReplicationInfo.PlayerName, 'CriticalEvent');
                        }
            		}
                }
			}

			KFP = none;
        }

		if (PlayersHealed >= MaxNumberOfPlayers)
		{
			if (PRI != none)
			{
        		KFSteamStatsAndAchievements(PRI.SteamStatsAndAchievements).HealedTeamWithMedicGrenade();
			}
		}
	}

	bHurtEntry = false;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local vector X;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPawn HitPawn;
	
	if( Physics != PHYS_None )
	{
		// Don't let it hit this player, or blow up on another player
		// Don't collide with bullet whip attachments
		// Don't allow hits on poeple on the same team
		if ( Other == none || Other == Instigator || Other.Base == Instigator ||
			KFBulletWhipAttachment(Other) != none || (KFHumanPawn(Other) != none && Instigator != none
			&& KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex) )
			Return;

		if( Role == ROLE_Authority )
		{
			if( ROBulletWhipAttachment(Other) != none )
			{
				if(!Other.Base.bDeleteMe)
				{
					Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

					if( Other == none || HitPoints.Length == 0 )
						Return;

					HitPawn = KFPawn(Other);

					if (Role == ROLE_Authority && HitPawn != none && !HitPawn.bDeleteMe)
						HitPawn.ProcessLocationalDamage(ImpactDamage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType,HitPoints);
				}
			}
			else
			{
				if (Pawn(Other) != none && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
					Pawn(Other).TakeDamage(ImpactDamage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType);
				else
					Other.TakeDamage(ImpactDamage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), ImpactDamageType);
			}
		}
		
		if ( xEmitterTrail != none )
		{
			xEmitterTrail.mRegen=False;
			xEmitterTrail.SetPhysics(PHYS_None);
			xEmitterTrail.GotoState('');
		}
		
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
	Explode(Location,HitNormal);
}

function Tick( float DeltaTime )
{
    if( Role < ROLE_Authority )
		Return;

    if( Physics == PHYS_Falling )
		SetRotation(Rotator(Normal(Velocity)));
	
	if( TotalHeals < MaxHeals && NextHealTime > 0 &&  NextHealTime < Level.TimeSeconds )
    {
        TotalHeals += 1;
        HealOrHurt(Damage,DamageRadius, MyDamageType, MomentumTransfer, Location);

        if( TotalHeals >= MaxHeals )
			AmbientSound = None;
    }
}

defaultproperties
{
     //bInitialAcceleration - if this is true and bTrueBallistics is true, the projectile will accellerate 
	 // to full speed over .1 seconds. 
	 // This prevents the problem where a just spawned projectile passes right through something without colliding
	 HealBoostAmount=10
     MaxHeals=5
     HealInterval=1.000000
     SuccessfulHealMessage="You healed "
     MaxNumberOfPlayers=4
	 HeadShotDamageMult=1.500000
	 ExplosionEmitter=Class'UnlimaginMod.UM_AA12MedGasBulletHealing'
     ExplosionSoundVolume=1.500000
     ArmDistSquared=0.000000
     ImpactDamageType=Class'UnlimaginMod.UM_DamTypeAA12MedGasImpact'
     ImpactDamage=80
	 StaticMeshRef="EffectsSM.Ger_Tracer"
	 ExplosionSound=Sound'KF_GrenadeSnd.NadeBase.Nade_Explode4'
     Speed=7000.000000
     MaxSpeed=8000.000000
     Damage=50.000000
	 DamageRadius=120.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'UnlimaginMod.UM_DamTypeAA12MedGas'
	 ExplosionDecal=Class'UnlimaginMod.UM_AA12MedGasBulletDecal'
	 DrawType=DT_StaticMesh
	 LifeSpan=3.500000
     DrawScale=4.000000
}
