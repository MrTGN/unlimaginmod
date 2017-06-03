/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseDamageType
	Creation date:	 03.06.2017 13:41
----------------------------------------------------------------------------------
	Copyright © 2017 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_BaseDamageType extends DamageType
	Abstract;


defaultproperties
{
	 bDirectDamage=False
	 bCheckForHeadShots=False
	 HeadShotDamageMult=1.0
	 bArmorStops=False // does regular armor provide protection against this damage
	 bInstantHit=False // done by trace hit weapon
	 bFastInstantHit=False // done by fast repeating trace hit weapon
     bLocationalHit=False
     bCausesBlood=False
     bExtraMomentumZ=False
}
