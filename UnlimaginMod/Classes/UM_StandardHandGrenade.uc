//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_StandardHandGrenade
//	Parent class:	 UM_BaseProjectile_HandGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 15.05.2013 02:27
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_StandardHandGrenade extends UM_BaseProjectile_HandGrenade;



defaultproperties
{
	 //Shrapnel
	 ShrapnelClass=Class'UnlimaginMod.UM_HandGrenadeShrapnel'
	 ShrapnelAmount=(Min=8,Max=10)
	 //Sounds
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.HandGrenade.HG_Explode",Vol=2.0,Radius=400.0,bUse3D=True)
}
