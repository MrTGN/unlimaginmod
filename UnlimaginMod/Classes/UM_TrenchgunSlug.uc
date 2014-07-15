//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_TrenchgunSlug
//	Parent class:	 UM_AA12Slug
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.12.2012 19:31
//================================================================================
class UM_TrenchgunSlug extends UM_AA12Slug;

defaultproperties
{
     MaxPenetrations=7
     PenDamageReduction=0.940000
	 Speed=8000.000000
     MaxSpeed=9000.000000
	 Damage=230.000000
	 MomentumTransfer=56000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeTrenchgunSlug'
}
