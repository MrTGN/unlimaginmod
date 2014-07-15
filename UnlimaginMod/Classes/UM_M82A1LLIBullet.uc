//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M82A1LLIBullet
//	Parent class:	 UM_BaseProjectile_M1022LRSniper
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.06.2013 22:06
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M82A1LLIBullet extends UM_BaseProjectile_M1022LRSniper;


defaultproperties
{
     HeadShotDamageType=Class'UnlimaginMod.OperationY_DamTypeM82A1LLIHeadShot'
     MyDamageType=Class'UnlimaginMod.OperationY_DamTypeM82A1LLI'
	 MuzzleVelocity=850.000000	// m/s
}
