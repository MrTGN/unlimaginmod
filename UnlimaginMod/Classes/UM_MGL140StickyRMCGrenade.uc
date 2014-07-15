//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140StickyRMCGrenade
//	Parent class:	 UM_BaseProjectile_StickyRMCGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 05:35
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140StickyRMCGrenade extends UM_BaseProjectile_StickyRMCGrenade;


defaultproperties
{
     BallisticCoefficient=0.150000
	 MuzzleVelocity=75.000000	//m/s
	 Damage=280.000000
	 DamageRadius=330.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMGL140StickyRMCGrenade'
}
