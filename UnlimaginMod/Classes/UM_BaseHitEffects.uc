//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseHitEffects
//	Parent class:	 UM_BaseEffect
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 28.03.2013 08:15
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 ROHitEffect copy with some enhancements
//================================================================================
class UM_BaseHitEffects extends UM_BaseEffect
	Abstract;


//========================================================================
//[block] Variables

struct HitEffectData
{
	var	class<ProjectedDecal>	HitDecal;
	var	class<Emitter>			HitEffect;
	var	sound					HitSound;
	var	float					HitSoundVolume;
	var	float					HitSoundRadius;
};

var()	HitEffectData			HitEffects[20];

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

simulated function PlayHitEffects(
 optional	ESurfaceTypes	SurfaceType, 
 optional	float			NewHitSoundVolume, 
 optional	float			NewHitSoundRadius )
{
	local	Vector		HitLoc, HitNormal;
	local	Material	HitMat;

	if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low )  {
		//Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[ST].Effect$" Particle Effect = "$HitEffects[ST].ParticleEffect$" TempEffect = "$HitEffects[ST].TempEffect);
		//log("
		Trace(HitLoc, HitNormal, (Location + Vector(Rotation) * 20.0), Location, False,, HitMat);
		
		if ( SurfaceType == EST_Default || SurfaceType >= ArrayCount(HitEffects) )  {
			if ( HitMat != None )
				SurfaceType = ESurfaceTypes(HitMat.SurfaceType);
			else
				SurfaceType = EST_Default;
		}

		//Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[SurfaceType].Effect$" Particle Effect = "$HitEffects[SurfaceType].ParticleEffect$" TempEffect = "$HitEffects[SurfaceType].TempEffect);

		if ( HitEffects[SurfaceType].HitDecal != None )
			Spawn(HitEffects[SurfaceType].HitDecal, self,, Location, Rotation);

		if ( HitEffects[SurfaceType].HitSound != None )  {
			if ( NewHitSoundVolume <= 0.0 )  {
				if ( HitEffects[SurfaceType].HitSoundVolume > 0.0 )
					NewHitSoundVolume = HitEffects[SurfaceType].HitSoundVolume;
				else
					NewHitSoundVolume = TransientSoundVolume;
			}
			
			if ( NewHitSoundRadius <= 0.0 )  {
				if ( HitEffects[SurfaceType].HitSoundRadius > 0.0 )
					NewHitSoundRadius = HitEffects[SurfaceType].HitSoundRadius;
				else
					NewHitSoundRadius = TransientSoundRadius;
			}
			
			if ( NewHitSoundVolume > 0.0 )
				PlaySound(HitEffects[SurfaceType].HitSound, SLOT_None, NewHitSoundVolume, False, NewHitSoundRadius,, True);
		}

		if ( HitEffects[SurfaceType].HitEffect != None )  {
			if ( HitLoc != vect(0,0,0) )
				Spawn(HitEffects[SurfaceType].HitEffect,,, HitLoc, Rotator(HitNormal));
			else
				Spawn(HitEffects[SurfaceType].HitEffect,,, Location, Rotation);
		}
	}
	
	if ( Class'UM_GlobalData'.default.ActorPool != None )  {
		//Log("Saving to the ActorPool.",Name);
		Class'UM_GlobalData'.default.ActorPool.FreeActor(self);
	}
	else {
		//Log("Destroying.",Name);
		Destroy();
	}
}

//[end] Functions
//====================================================================


defaultproperties
{
	 TransientSoundVolume=1.250000
	 TransientSoundRadius=200.000000
}
