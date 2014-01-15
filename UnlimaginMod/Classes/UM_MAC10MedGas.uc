//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10MedGas
//	Parent class:	 UM_BaseProjectile_45ACPMedGas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 14:25
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MAC10MedGas extends UM_BaseProjectile_45ACPMedGas;


defaultproperties
{
     HealBoostAmount=13
	 Damage=18.500000
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=95.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMAC10MedGas'
}
