//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BouncingGrenadeShrapnel
//	Parent class:	 NailGunProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.11.2012 22:35
//================================================================================
class UM_BouncingGrenadeShrapnel extends NailGunProjectile;

simulated singular event HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

    SetRotation(rotator(Normal(Velocity)));
    SetPhysics(PHYS_Falling);
	
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

        Velocity = 0.89 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;

    	if ( !Level.bDropDetail && (Level.NetMode != NM_DedicatedServer))
    	{
            Spawn(class'ROEffects.ROBulletHitMetalEffect',,,Location, rotator(hitnormal));
    	}

        Return;
    }
    else
    {
    	if (ImpactEffect != None && (Level.NetMode != NM_DedicatedServer))
    	{
            Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
    	}
        SetPhysics(PHYS_None);
        LifeSpan = 5.0;
    }
	
	bBounce = false;
	if (Trail != None)
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
        //Trail.mRegenRange[0] = 0.0;//trail.mRegenRange[0] * 0.6;
        //Trail.mRegenRange[1] = 0.0;//trail.mRegenRange[1] * 0.6;
    }
}

defaultproperties
{
     bNetTemporary=True
	 StaticMesh=StaticMesh'EffectsSM.Weapons.Vlad_9000_Nail'
	 Bounces=8
	 MaxPenetrations=6
	 Speed=3800.000000
     MaxSpeed=4400.000000
	 Damage=34.000000
	 PenDamageReduction=0.750000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeBouncingGrenadeShrapnel'
	 DrawScale=0.500000
	 LifeSpan=15.000000
}