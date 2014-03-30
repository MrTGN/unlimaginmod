//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ElementalBullet
//	Parent class:	 UM_BaseElementalProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.05.2013 00:59
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ElementalBullet extends UM_BaseElementalProjectile
	Abstract;

//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// Called when the projectile loses some of it's energy
simulated function ChangeOtherProjectilePerformance(float NewScale)
{
	ImpactDamage *= NewScale;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local	Vector		TempHitLocation, HitNormal, X, TraceEnd;
	local	array<int>	HitPoints;
	local	Pawn		Victim;
	
	// Don't let it hit this player, or blow up on another player
	// Don't collide with bullet whip attachments
	// Don't allow hits on poeple on the same team
	if ( Instigator == None || Other == None || Other == Instigator ||
		 Other.Base == Instigator || !Other.bBlockHitPointTraces )
		Return;

	// KFBulletWhipAttachment/ROBulletWhipAttachment - Collision for projectiles whip sounds. We need to do a HitPointTrace.
	if ( KFBulletWhipAttachment(Other) != None || ROBulletWhipAttachment(Other) != None )  {
		TraceEnd = HitLocation + (MaxEffectiveRange * Vector(Rotation));
		Victim = Pawn(Instigator.HitPointTrace(TempHitLocation, HitNormal, TraceEnd, HitPoints, HitLocation,, 1));
		if ( HitPoints.Length < 1 )
			Return;
	}
	// ExtendedZCollision - Killing Floor hack for large zombies.
	else if ( ExtendedZCollision(Other) != None )
		Victim = Pawn(Other.Owner);
	else
		Victim = Pawn(Other);
	
	// Do not damage a friendly Pawn
	if ( Victim == None || Victim.bDeleteMe
		 || (Instigator != Victim && TeamGame(Level.Game) != None
			 && TeamGame(Level.Game).FriendlyFireScale <= 0.0
			 && Instigator.GetTeamNum() == Victim.GetTeamNum()) )
		Return;
	
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority && ImpactDamageType != None && ImpactDamage > 0.0 )  {
		X = Normal(Velocity);
		if ( KFPawn(Victim) != None )
			KFPawn(Victim).ProcessLocationalDamage(Damage, Instigator, TempHitLocation, (MomentumTransfer * X), MyDamageType, HitPoints);
        else  {
            if ( Victim.IsHeadShot(HitLocation, X, 1.0) )
                Victim.TakeDamage((ImpactDamage * HeadShotImpactDamageMult), Instigator, HitLocation, (ImpactMomentumTransfer * Normal(Velocity)), ImpactDamageType);
            else
                Victim.TakeDamage(ImpactDamage, Instigator, HitLocation, (ImpactMomentumTransfer * Normal(Velocity)), ImpactDamageType);
        }
    }
	
	Explode(HitLocation, Normal(HitLocation - Other.Location));
}

simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
	Explode(Location, HitNormal);
}

//[end] Functions
//====================================================================

defaultproperties
{
     bIgnoreSameClassProj=True
	 ShrapnelClass=None
	 // Explosion camera shakes
	 ShakeRadiusScale=2.200000
	 MaxEpicenterShakeScale=1.500000
	 ShakeRotMag=(X=500.000000,Y=500.000000,Z=500.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeOffsetTime=3.500000
	 //Disintegration
	 DisintegrateChance=0.600000
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 // Ballistic calculator: http://www.ada.ru/guns/ballistic/bc/BC_pejsa.htm
	 //[block] From ROBallisticProjectile class
	 BallisticCoefficient=0.300000
     bTrueBallistics=True
     bInitialAcceleration=True
     SpeedFudgeScale=1.000000
     MinFudgeScale=0.025000
     InitialAccelerationTime=0.100000
     TossZ=0.000000
	 //[end]
	 //Speed Must be 0.00 becuse we use MuzzleVelocity
	 Speed=0.000000
	 MaxSpeed=0.000000
	 //MuzzleVelocity
	 MuzzleVelocity=100.000000	// m/sec
	 //BallisticRandPercent
	 BallisticRandPercent=2.000000
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 MaxEffectiveRangeScale=1.200000
	 bBounce=False
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 //HitEffects
	 //You can use this varible to set new hit sound volume and radius
	 //HitSoundVolume=1.000000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //Damage
	 ImpactDamage=100.000000
	 ImpactMomentumTransfer=30000.000000
	 Damage=100.000000
	 DamageRadius=30.000000
	 MomentumTransfer=50000.000000
	 CullDistance=3200.000000
	 //Replication
	 bNetTemporary=True
	 bReplicateInstigator=True
     bNetInitialRotation=True
	 //Light
	 AmbientGlow=30		// Ambient brightness, or 255=pulsing.
	 bUnlit=True		// Lights don't affect actor.
	 //Collision
	 CollisionRadius=0.000000
     CollisionHeight=0.000000
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
	 //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=8.000000
	 // Style for rendering sprites, meshes.
	 Style=STY_Alpha
	 // Whether to apply ambient attenuation.
	 bFullVolume=True
	 DrawScale=1.000000
}
