//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_9x19P_FHST147JHP
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.08.2013 18:25
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 9x19mm Parabellum Federal HST JHP +P
//					 Bullet diameter: 9.01 mm (0.355 in). Bullet Mass: 9.5254 g (147 gr)
//================================================================================
class UM_BaseProjectile_9x19P_FHST147JHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.01
	 BallisticCoefficient=0.218000
	 BallisticRandRange=(Min=0.955,Max=1.045)
	 EffectiveRange=750.000000
	 MaxEffectiveRange=800.000000
	 ExpansionCoefficient=2.008000
	 ProjectileMass=0.009520		//kilograms
	 MuzzleVelocity=350.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 Damage=40.000000
	 MomentumTransfer=25000.000000
	 HitSoundVolume=0.600000
}
