//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieCrawler
//	Parent class:	 UM_BaseMonster_Crawler
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:08
//================================================================================
class UM_ZombieCrawler extends UM_BaseMonster_Crawler;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	// Randomizing PounceSpeed
	if ( Level.Game != None && !bDiffAdjusted )
		PounceSpeed *= Lerp( FRand(), 0.9, 1.1 );
	
	Super.PostBeginPlay();
	
	// Server only next
	if ( Role < ROLE_Authority )
		Return;
	
	if ( FRand() <= PoisonousChance )  {
		bPoisonous = True;
		CurrentDamtype = PoisonDamageType;
		PoisonDamageRandRange.Min *= DifficultyDamageModifer();
		PoisonDamageRandRange.Max *= DifficultyDamageModifer();
		SetOverlayMaterial(PoisonousMaterial, 1800.0, False); // 30 minutes
	}
	else
		CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( bPoisonous )
		MenuName = "Poisonous" @ MenuName;
}

function bool DoPounce()
{
	if ( bZapped || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || 
		 VSize(Location - Controller.Target.Location) > (MeleeRange * 5) )
		Return False;

	bPouncing = True;
	Velocity = Normal(Controller.Target.Location - Location) * PounceSpeed;
	Velocity.Z = JumpZ;
	SetPhysics(PHYS_Falling);
	ZombieSpringAnim();
	
	Return True;
}

simulated function ZombieSpringAnim()
{
	SetAnimAction('ZombieSpring');
}

event Landed(vector HitNormal)
{
	Super.Landed(HitNormal);
	bPouncing = False;
}

event Bump(actor Other)
{
	// TODO: is there a better way
	if ( bPouncing && KFHumanPawn(Other) != None )  {
		if ( bPoisonous )
			KFHumanPawn(Other).TakeDamage( Lerp(FRand(), PoisonDamageRandRange.Min, PoisonDamageRandRange.Max), self, Location, Velocity, PoisonDamageType );
		else if ( CurrentDamtype != None )
			KFHumanPawn(Other).TakeDamage( (MeleeDamage * Lerp(FRand(), 0.95, 1.05)), self, Location, Velocity, CurrentDamtype );
		else
			KFHumanPawn(Other).TakeDamage( (MeleeDamage * Lerp(FRand(), 0.95, 1.05)), self, Location, Velocity, ZombieDamType[Rand(ArrayCount(ZombieDamType))] );
		//TODO - move this to humanpawn.takedamage? Also see KFMonster.MeleeDamageTarget
		if ( KFHumanPawn(Other).Health <= 0 )
			KFHumanPawn(Other).SpawnGibs(Rotation, 1);
		//After impact, there'll be no momentum for further bumps
		bPouncing = True;
	}
}

// Blend his attacks so he can hit you in mid air.
simulated function int DoAnimAction( name AnimName )
{
    if ( AnimName == 'InAir_Attack1' || AnimName == 'InAir_Attack2' )
	{
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.0, 1);
		Return 1;
	}

    if ( AnimName == 'HitF' )
	{
		AnimBlendParams(1, 1.0, 0.0,, NeckBone);
		PlayAnim(AnimName,, 0.0, 1);
		Return 1;
	}

	if ( AnimName == 'ZombieSpring' )
	{
        PlayAnim(AnimName,,0.02);
        Return 0;
	}

	Return Super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == '' )
		Return;

	if ( NewAction == 'DoorBash' )  {
		if ( bPoisonous )
			CurrentDamtype = PoisonDamageType;
		else
			CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
	}
	else if ( NewAction == 'Claw' )  {
		if ( bPoisonous )
			CurrentDamtype = PoisonDamageType;
		else
			CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
		if ( Physics == PHYS_Falling )
			NewAction = MeleeAirAnims[Rand(ArrayCount(MeleeAirAnims))];
		else
			NewAction = MeleeAnims[Rand(ArrayCount(MeleeAnims))];
	}
	
	ExpectingChannel = DoAnimAction(NewAction);

	if ( AnimNeedsWait(NewAction) )
		bWaitForAnim = True;
	else
		bWaitForAnim = False;

	if ( Level.NetMode != NM_Client )  {
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
	}
}

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'ZombieSpring' || TestAnim == 'DoorBash' )
        Return True;

    Return True;
}

function bool FlipOver()
{
	Return False;
}


static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.crawler_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.crawler_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.crawler_diff');
	// PoisonousSkins
	myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.siren.siren_scream_energy');
	myLevel.AddPrecacheMaterial(Combiner'kf_fx_trip_t.siren.siren_scream_cmb');
	//myLevel.AddPrecacheMaterial(FinalBlend'kf_fx_trip_t.siren.siren_scream_fb');
}

defaultproperties
{
     EventClasses(0)="UnlimaginMod.UM_ZombieCrawler"
     EventClasses(1)="UnlimaginMod.UM_ZombieCrawler"
     //EventClasses(2)="UnlimaginMod.UM_ZombieCrawler_HALLOWEEN"
	 EventClasses(2)="UnlimaginMod.UM_ZombieCrawler"
     //EventClasses(3)="UnlimaginMod.UM_ZombieCrawler_XMas"
	 EventClasses(3)="UnlimaginMod.UM_ZombieCrawler"
     DetachedArmClass=Class'KFChar.SeveredArmCrawler'
     DetachedLegClass=Class'KFChar.SeveredLegCrawler'
     DetachedHeadClass=Class'KFChar.SeveredHeadCrawler'
	 ControllerClass=Class'UnlimaginMod.UM_ZombieCrawlerController'
}
