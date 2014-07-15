//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_45ACPIncendiaryImpact
//	Parent class:	 UM_BaseDamType_IncendiaryProjImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.06.2013 20:18
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseDamType_45ACPIncendiaryImpact extends UM_BaseDamType_IncendiaryProjImpact
	Abstract;


defaultproperties
{
     DeathString="%k killed %o (45ACP Incendiary Bullet)."
     FemaleSuicide="%o burn up."
     MaleSuicide="%o burn up."
     KDamageImpulse=2000.000000
     KDeathVel=100.000000
     KDeathUpKick=10.000000
	 HumanObliterationThreshhold=120
}
