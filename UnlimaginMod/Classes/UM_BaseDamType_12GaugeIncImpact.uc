//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseDamType_12GaugeIncImpact
//	Parent class:	 UM_BaseDamType_IncendiaryProjImpact
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.06.2013 12:22
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_BaseDamType_12GaugeIncImpact extends UM_BaseDamType_IncendiaryProjImpact
	Abstract;


defaultproperties
{
     DeathString="%k killed %o (IncBullet Impact)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=2400.000000
     KDeathVel=100.000000
     KDeathUpKick=50.000000
	 HumanObliterationThreshhold=140
}