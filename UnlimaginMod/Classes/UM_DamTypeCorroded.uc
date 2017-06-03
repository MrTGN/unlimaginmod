/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DamTypeCorroded
	Creation date:	 03.06.2017 14:27
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
class UM_DamTypeCorroded extends UM_BaseDamageType
	Abstract;

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	return Default.PawnDamageEffect;
}

defaultproperties
{
     DeathString="%o was dissolved by %k's."
     FemaleSuicide="%o dissolved in slime."
     MaleSuicide="%o dissolved in slime."
     FlashFog=(X=450.000000,Y=700.000000,Z=230.000000)
}
