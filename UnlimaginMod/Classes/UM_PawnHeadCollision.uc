/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_PawnHeadCollision
	Creation date:	 02.12.2014 13:13
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_PawnHeadCollision extends UM_BallisticCollision;


defaultproperties
{
     // if ImpactStrength < 6.2 standard 19x9mm bullet can penetrate this area
	 // ImpactStrength * ProjectileCrossSectionalArea = Energy to penetrate this area
	 ImpactStrength=5.5
}
