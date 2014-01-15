//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseDamType_NapalmProjectile
//	Parent class:	 UM_BaseDamType_Flame
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 26.02.2013 02:08
//================================================================================
class UM_BaseDamType_NapalmProjectile extends UM_BaseDamType_Flame
	Abstract;

defaultproperties
{
     // It is a throw Projectile
	 bThrowRagdoll=True
}