//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_UMP45MedGas
//	Parent class:	 UM_BaseProjectile_45ACPMedGas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 14:28
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_UMP45MedGas extends UM_BaseProjectile_45ACPMedGas;


defaultproperties
{
     HealBoostAmount=14
	 Damage=20.000000
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=116.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeUMP45MedGas'
}
