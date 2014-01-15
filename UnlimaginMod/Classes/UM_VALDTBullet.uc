//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_VALDTBullet
//	Parent class:	 UM_BaseProjectile_SP5FMJ
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 04.07.2013 16:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_VALDTBullet extends UM_BaseProjectile_SP5FMJ;


defaultproperties
{
     MuzzleVelocity=295.000000		//Meter/sec
     HeadShotDamageMult=1.200000
   	 Damage=65.000000
	 MyDamageType=Class'UnlimaginMod.OperationY_DamTypeVALDT'
}
