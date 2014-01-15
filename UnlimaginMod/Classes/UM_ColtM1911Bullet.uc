//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ColtM1911Bullet
//	Parent class:	 UM_BaseProjectile_45ACP_FHST230JHP
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.06.2013 23:41
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ColtM1911Bullet extends UM_BaseProjectile_45ACP_FHST230JHP;


defaultproperties
{
     MuzzleVelocity=275.000000		//Meter/sec
	 Damage=50.000000
	 MyDamageType=Class'UnlimaginMod.Whisky_DamTypeColtM1911Pistol'
}
