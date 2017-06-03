//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_IncendiaryProjectile
//	Parent class:	 UM_BaseDamType_Flame
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.02.2013 03:54
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// 	Comments:		 
//================================================================================
class UM_BaseDamType_IncendiaryProjectile extends UM_BaseDamType_Flame
	Abstract;

defaultproperties
{
     DeathString="%k killed %o (Incendiary Projectile)."
     FemaleSuicide="%o blew up."
     MaleSuicide="%o blew up."
}
