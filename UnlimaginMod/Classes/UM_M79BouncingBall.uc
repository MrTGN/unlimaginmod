//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M79BouncingBall
//	Parent class:	 UM_BaseProjectile_BouncingBall
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.08.2013 05:59
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M79BouncingBall extends UM_BaseProjectile_BouncingBall;


defaultproperties
{
     Damage=150.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM79BouncingBall'
	 Trail=(xEmitterClass=Class'KFMod.NailGunTracer')
}
