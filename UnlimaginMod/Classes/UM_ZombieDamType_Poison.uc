/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_ZombieDamType_Poison
	Creation date:	 05.01.2015 18:06
----------------------------------------------------------------------------------
	Copyright � 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright � 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright � 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_ZombieDamType_Poison extends UM_BaseMonsterDamageType
	Abstract;


defaultproperties
{
     bCheckForHeadShots=False
     DeathString="%o poisoned by %k."
     FemaleSuicide="%o was poisoned."
     MaleSuicide="%o was poisoned."
	 bArmorStops=False
     bLocationalHit=False
}
