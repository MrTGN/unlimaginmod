//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieDamType_SirenScream
//	Parent class:	 UM_BaseMonsterDamageType
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 29.04.2013 12:34
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_ZombieDamType_SirenScream extends UM_BaseMonsterDamageType
	Abstract;


defaultproperties
{
     bCheckForHeadShots=False
     DeathString="%o had their ears busted by %k."
     FemaleSuicide="%o's ears popped."
     MaleSuicide="%o's ears popped."
     bArmorStops=False
     bLocationalHit=False
}
