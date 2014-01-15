//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ClusterHandGrenade
//	Parent class:	 UM_BaseProjectile_HandGrenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.10.2012 6:07
//================================================================================
class UM_ClusterHandGrenade extends UM_BaseProjectile_HandGrenade;



defaultproperties
{
     bIgnoreSameClassProj=True
	 //Sounds
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.NadeBase.Nade_Explode4"
	 //Damage
     Damage=50.000000
     DamageRadius=100.000000
	 //IgnoreVictims
	 IgnoreVictims(0)="UM_ClusterGrenadeProj"
	 //Shrapnel
	 ShrapnelClass=Class'UnlimaginMod.UM_ClusterGrenadeProj'
	 MaxShrapnelAmount=8
	 MinShrapnelAmount=5
}