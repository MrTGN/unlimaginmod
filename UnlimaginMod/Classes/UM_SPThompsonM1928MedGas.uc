//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_SPThompsonM1928MedGas
//	Parent class:	 UM_BaseProjectile_45ACPMedGas
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 17.08.2013 14:20
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_SPThompsonM1928MedGas extends UM_BaseProjectile_45ACPMedGas;


defaultproperties
{
     HealBoostAmount=13
	 Damage=19.000000
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=80.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeSPThompsonM1928MedGas'
}