//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_HandGrenadeWithTungstenShrapnel
//	Parent class:	 UM_BaseProjectile_HandGrenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 21.11.2012 22:46
//================================================================================
class UM_HandGrenadeWithTungstenShrapnel extends UM_BaseProjectile_HandGrenade;


defaultproperties
{
	 //Shrapnel
	 ShrapnelClass=Class'UnlimaginMod.UM_TungstenShrapnel'
	 ShrapnelAmount=(Min=20,Max=25)
	 //Sounds
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=390.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.HandGrenade.HG_Explode",Vol=2.0,Radius=390.0,bUse3D=True)
	 //Damage
	 Damage=300.000000
     DamageRadius=300.000000
}
