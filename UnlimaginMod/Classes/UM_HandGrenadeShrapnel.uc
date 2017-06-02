//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_HandGrenadeShrapnel
//	Parent class:	 UM_BaseProjectile_Shrapnel
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 27.04.2014 18:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_HandGrenadeShrapnel extends UM_BaseProjectile_Shrapnel;


defaultproperties
{
     BallisticCoefficient=0.049000
	 // EffectiveRange in Meters
	 EffectiveRange=900.000000
	 MaxEffectiveRange=1000.000000
	 ProjectileDiameter=9.0
	 ProjectileMass=5.0	// grams
	 ExpansionCoefficient=1.050000
	 MuzzleVelocity=100.000000	// m/sec
	 Damage=40.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeHandGrenadeShrapnel'
	 MomentumTransfer=60000.000000
	 HitSoundVolume=0.650000
	 DrawScale=1.080000
}
