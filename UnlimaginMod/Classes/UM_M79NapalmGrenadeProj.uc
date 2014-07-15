//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M79NapalmGrenadeProj
//	Parent class:	 M79GrenadeProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.07.2012 1:12
//================================================================================
class UM_M79NapalmGrenadeProj extends M79GrenadeProjectile;

#exec OBJ LOAD FILE=KF_GrenadeSnd.uax

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController  LocalPlayer;

	bHasExploded = True;
	
	// Don't explode if this is a dud
	if( bDud )
	{
		Velocity = vect(0,0,0);
		LifeSpan=1.0;
		SetPhysics(PHYS_Falling);
	}
	
	// Incendiary Effects..
	PlaySound(sound'KF_GrenadeSnd.FlameNade_Explode',,100.5*TransientSoundVolume);

	if ( EffectIsRelevant(Location,false) )
	{
		Spawn(Class'KFIncendiaryExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
		
	BlowUp(HitLocation);
	
	Destroy();
}

defaultproperties
{
     ArmDistSquared=60000.000000
     ImpactDamage=120
     Damage=100.000000
     DamageRadius=400.000000
     MyDamageType=Class'UnlimaginMod.UM_DamTypeM79NapalmGrenadeProj'
}
