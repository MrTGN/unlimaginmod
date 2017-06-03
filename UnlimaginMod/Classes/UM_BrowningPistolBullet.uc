//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BrowningPistolBullet
//	Parent class:	 UM_BaseProjectile_40SW_H180XTP
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.08.2013 20:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BrowningPistolBullet extends UM_BaseProjectile_40SW_H180XTP;


defaultproperties
{
     MuzzleVelocity=300.000000		//Meter/sec
	 ImpactDamage=44.0
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeBrowningPistol'
}
