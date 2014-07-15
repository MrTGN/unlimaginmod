//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM1928IncBullet
//	Parent class:	 UM_ThompsonM4A1IncBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.07.2013 17:43
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM1928IncBullet extends UM_ThompsonM4A1IncBullet;


defaultproperties
{
	 MuzzleVelocity=310.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM1928IncImpact'
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM1928IncBullet'
}
