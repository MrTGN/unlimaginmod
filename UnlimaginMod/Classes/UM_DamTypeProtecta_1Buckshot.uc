//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_DamTypeProtecta_1Buckshot
//	Parent class:	 UM_BaseDamType_Shotgun
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 07.11.2013 10:38
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_DamTypeProtecta_1Buckshot extends UM_BaseDamType_Shotgun
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.OperationY_ProtectaShotgun'
     DeathString="%k killed %o (Protecta Shotgun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=9000.000000
     KDeathVel=260.000000
     KDeathUpKick=100.000000
}