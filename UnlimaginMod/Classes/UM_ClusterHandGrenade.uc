//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ClusterHandGrenade
//	Parent class:	 UM_BaseProjectile_HandGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 6:07
//================================================================================
class UM_ClusterHandGrenade extends UM_BaseProjectile_HandGrenade;



defaultproperties
{
     bCanHurtSameTypeProjectile=False
	 //Sounds
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.6,Radius=300.0,bUse3D=True)
	 ExplosionSound=(Ref="KF_GrenadeSnd.NadeBase.Nade_Explode4",Vol=1.6,Radius=300.0,bUse3D=True)
	 //Damage
     Damage=50.000000
     DamageRadius=100.000000
	 //IgnoredVictims
	 IgnoredVictims(0)="UM_ClusterGrenadeProj"
	 //Shrapnel
	 ShrapnelClass=Class'UnlimaginMod.UM_ClusterGrenadeProj'
	 ShrapnelAmount=(Min=6,Max=8)
}