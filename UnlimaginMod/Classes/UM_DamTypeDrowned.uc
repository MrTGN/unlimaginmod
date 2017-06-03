/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DamTypeDrowned
	Creation date:	 03.06.2017 14:24
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
class UM_DamTypeDrowned extends UM_BaseDamageType
	Abstract;

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	Return default.PawnDamageEffect;
}

defaultproperties
{
	 DeathString="%o forgot to come up for air."
     FemaleSuicide="%o forgot to come up for air."
     MaleSuicide="%o forgot to come up for air."
     FlashFog=(X=312.500000,Y=468.750000,Z=468.750000)
}
