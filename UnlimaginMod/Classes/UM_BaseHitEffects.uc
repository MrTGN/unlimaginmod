//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseHitEffects
//	Parent class:	 UM_BaseEffect
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.03.2013 08:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 ROHitEffect copy with some enhancements
//================================================================================
class UM_BaseHitEffects extends UM_BaseEffect
	Abstract;


//========================================================================
//[block] Variables

struct HitEffectData
{
	var		class<ProjectedDecal>	HitDecal;
	var		class<Emitter>			HitEffect;
	var		sound					HitSound;
	var		float					HitSoundVolume;
	var		float					HitSoundRadius;
};

var()	HitEffectData		HitEffects[20];
var		float				DefaultHitSoundVolume;
var		float				DefaultHitSoundRadius;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

simulated function PlayHitEffects(
 optional	ESurfaceTypes	SurfaceType, 
 optional	ESurfaceTypes	SoundSurfaceType, 
 optional	float			NewHitSoundVolume, 
 optional	float			NewHitSoundRadius,
 optional	Sound			NewHitSound )
{
	local vector	HitLoc, HitNormal, TraceEnd;
	local Material	HitMat;

	if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low )  {
		//Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[ST].Effect$" Particle Effect = "$HitEffects[ST].ParticleEffect$" TempEffect = "$HitEffects[ST].TempEffect);
		//log("
		TraceEnd = Location + Vector(Rotation) * 20;
		Trace(HitLoc, HitNormal, TraceEnd, Location, false,, HitMat);
		
		if ( SurfaceType < ArrayCount(HitEffects) )  {
			if ( SurfaceType == EST_Default && HitMat != None )
				SurfaceType = ESurfaceTypes(HitMat.SurfaceType);
		}
		else  {
			if ( HitMat != None )
				SurfaceType = ESurfaceTypes(HitMat.SurfaceType);
			else
				SurfaceType = EST_Default;
		}
		
		if ( SoundSurfaceType == EST_Default || SoundSurfaceType >= ArrayCount(HitEffects) )
			SoundSurfaceType = SurfaceType;

		//Level.Game.Broadcast(self, "HitMat = " $HitMat.SurfaceType$" Effect = "$HitEffects[SurfaceType].Effect$" Particle Effect = "$HitEffects[SurfaceType].ParticleEffect$" TempEffect = "$HitEffects[SurfaceType].TempEffect);

		if ( HitEffects[SurfaceType].HitDecal != None )
			Spawn(HitEffects[SurfaceType].HitDecal, self,, Location, Rotation);

		if ( HitEffects[SoundSurfaceType].HitSound != None || NewHitSound != None )  {
			if ( NewHitSound == None )
				NewHitSound = HitEffects[SoundSurfaceType].HitSound;
			
			if ( NewHitSoundVolume <= 0.0 )  {
				if ( HitEffects[SoundSurfaceType].HitSoundVolume > 0.0 )
					NewHitSoundVolume = HitEffects[SoundSurfaceType].HitSoundVolume;
				else
					NewHitSoundVolume = DefaultHitSoundVolume;
			}
			
			if ( NewHitSoundRadius <= 0.0 )  {
				if ( HitEffects[SoundSurfaceType].HitSoundRadius > 0.0 )
					NewHitSoundRadius = HitEffects[SoundSurfaceType].HitSoundRadius;
				else
					NewHitSoundRadius = DefaultHitSoundRadius;
			}
			
			if ( NewHitSoundVolume > 0.0 )
				PlaySound(NewHitSound, SLOT_None, NewHitSoundVolume, false, NewHitSoundRadius);
		}

		if ( HitEffects[SurfaceType].HitEffect != None )  {
			if ( HitLoc != vect(0,0,0) )
				Spawn(HitEffects[SurfaceType].HitEffect,,, HitLoc, rotator(HitNormal));
			else
				Spawn(HitEffects[SurfaceType].HitEffect,,, Location, Rotation);
		}
	}
	
	if ( Class'UM_AData'.default.ActorPool != None )  {
		//Log("Saving to the ActorPool.",Name);
		Class'UM_AData'.default.ActorPool.FreeActor(self);
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
	 DefaultHitSoundVolume=1.000000
     DefaultHitSoundRadius=200.000000
}
