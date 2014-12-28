/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_HuskNapalmProjectile
	Creation date:	 25.12.2014 12:44
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_HuskNapalmProjectile extends UM_BaseMonsterExplosiveProjectile;


defaultproperties
{
     //Trail
	 Trail=(xEmitterClass=Class'KFMod.FlameThrowerFlame',EmitterClass=Class'KFMod.FlameThrowerFlameB')
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.FlameImpact'
	 ExplosionDecal=Class'KFMod.FlameThrowerBurnMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 StaticMeshRef="EffectsSM.Weapons.Ger_Tracer"
	 AmbientSoundRed="KF_BaseHusk.Fire.husk_fireball_loop"
	 LightType=LT_Steady
     LightHue=45
     LightSaturation=169
     LightBrightness=90.000000
     LightRadius=16.000000
     LightCone=16
     bDynamicLight=True
     DrawScale=2.000000
     AmbientGlow=254
     bUnlit=True
	 Damage=25.000000
     DamageRadius=150.000000
	 MyDamageType=Class'KFMod.DamTypeBurned'
	 //MuzzleVelocity
	 MuzzleVelocity=50.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 TransientSoundVolume=1.500000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.8,Radius=220.0,bUse3D=True)
	 ExplodeSound=(Ref="KF_EnemiesFinalSnd.Husk.Husk_FireImpact",Vol=2.0,Radius=220.0,bUse3D=True)
}
