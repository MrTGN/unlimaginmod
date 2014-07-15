//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140StickyRMCNapalmGrenade
//	Parent class:	 UM_BaseProjectile_StickyRMCGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.07.2013 20:48
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140StickyRMCNapalmGrenade extends UM_BaseProjectile_StickyRMCGrenade;


defaultproperties
{
     ShrapnelClass=None
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFIncendiaryExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //Sounds
	 TransientSoundVolume=2.000000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.8,Radius=360.0,bUse3D=True)
	 ExplodeSound=(Ref="KF_GrenadeSnd.FlameNade_Explode",Vol=2.8,Radius=360.0,bUse3D=True)
	 Damage=80.000000
     DamageRadius=380.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMGL140StickyRMCNapalmGrenade'
}
