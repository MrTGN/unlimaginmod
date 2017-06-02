//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ElementalBullet
//	Parent class:	 UM_BaseExplosiveProjectile
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
class UM_BaseProjectile_ElementalBullet extends UM_BaseExplosiveProjectile
	Abstract;

//========================================================================
//[block] Variables

var		bool		bCanDisintegrate;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		bCanDisintegrate;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if ( Role == ROLE_Authority )
		bCanDisintegrate = FRand() <= DisintegrationChance;
}

simulated event Landed( vector HitNormal )
{
	Super(UM_BaseProjectile).Landed(HitNormal);
	if ( IsArmed() )
		Explode((Location + ExploWallOut * HitNormal), HitNormal);
}

// TakeDamage must be simulated because it is a bNetTemporary actor
simulated event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	local	int		i;

	if ( EventInstigator == None || Damage < 1 )
		Return;
	
	if ( Instigator == None || EventInstigator == Instigator || EventInstigator.GetTeamNum() != Instigator.GetTeamNum()
		 || (UM_GameReplicationInfo(Level.GRI) != None && UM_GameReplicationInfo(Level.GRI).FriendlyFireScale > 0.0) )  {
		// Disintegrate this Projectile instead of simple detonation
		for ( i = 0; i < DisintegrationDamageTypes.Length; ++i )  {
			if ( DamageType == DisintegrationDamageTypes[i] )  {
				if ( bCanDisintegrate )
					Disintegrate(HitLocation, Vector(Rotation));
				
				Return;
			}
		}
		
		Explode(HitLocation, Vector(Rotation));
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
     bAutoLifeSpan=True
	 bArmed=True
	 bCanHurtSameTypeProjectile=False
	 ShrapnelClass=None
	 bCanDisintegrate=True
	 // Explosion camera shakes
	 ShakeRadiusScale=2.000000
	 MaxEpicenterShakeScale=1.250000
	 ShakeRotMag=(X=500.000000,Y=500.000000,Z=500.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeOffsetTime=3.500000
	 //Disintegration
	 DisintegrationChance=0.600000
	 DisintegrationDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrationDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrationDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
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
	 //Speed Must be 0.00 because we use MuzzleVelocity
	 Speed=0.000000
	 MaxSpeed=0.000000
	 //MuzzleVelocity
	 MuzzleVelocity=100.000000	// m/sec
	 BallisticRandRange=(Min=0.98,Max=1.02)
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 MaxEffectiveRange=600.000000
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
	 bReplicateMovement=True
	 bUpdateSimulatedPosition=False
	 bNetNotify=True
	 //Light
	 AmbientGlow=30		// Ambient brightness, or 255=pulsing.
	 bUnlit=True		// Lights don't affect actor.
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bCanRicochet=False
	 bOrientToVelocity=True
	 //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 // Style for rendering sprites, meshes.
	 Style=STY_Alpha
	 // Whether to apply ambient attenuation.
	 bFullVolume=True
	 DrawScale=1.000000
}
