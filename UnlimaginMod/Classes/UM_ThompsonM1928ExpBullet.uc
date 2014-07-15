//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM1928ExpBullet
//	Parent class:	 UM_ThompsonM4A1ExpBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.08.2013 21:06
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM1928ExpBullet extends UM_ThompsonM4A1ExpBullet;


defaultproperties
{
     MuzzleVelocity=310.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM1928ExpImpact'
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM1928ExpBullet'
}
