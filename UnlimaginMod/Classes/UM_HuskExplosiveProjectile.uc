/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_HuskExplosiveProjectile
	Creation date:	 25.12.2014 12:44
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_HuskExplosiveProjectile extends UM_BaseMonsterExplosiveProjectile;


defaultproperties
{
     //Trail
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_PanzerfaustTrail',EmitterRotation=(Pitch=32768))
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 StaticMeshRef="KillingFloorStatics.LAWRocket"
	 AmbientSoundRef="KF_LAWSnd.Rocket_Propel"
     LightHue=25
     LightSaturation=100
     LightBrightness=250.000000
     LightRadius=10.000000
     DrawType=DT_StaticMesh
     DrawScale=0.500000
     bUnlit=False
	 Damage=34.000000
     DamageRadius=150.000000
	 MyDamageType=Class'KFMod.DamTypeFrag'
	 //MuzzleVelocity
	 MuzzleVelocity=48.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 TransientSoundVolume=1.500000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.8,Radius=200.0,bUse3D=True)
	 ExplodeSound=(Ref="KF_LAWSnd.Rocket_Explode",Vol=2.0,Radius=200.0,bUse3D=True)
}
