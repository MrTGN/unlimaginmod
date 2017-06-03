/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DamTypeFell
	Creation date:	 03.06.2017 14:29
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
class UM_DamTypeFell extends UM_BaseDamageType
	Abstract;


defaultproperties
{
     DeathString="%k pushed %o over the edge."
     FemaleSuicide="%o left a small crater"
     MaleSuicide="%o left a small crater"
     bCausedByWorld=True
     GibModifier=2.000000
     GibPerterbation=0.500000
}
