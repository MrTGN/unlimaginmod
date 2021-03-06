//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_GoldenAA12Fire
//	Parent class:	 UM_AA12Fire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.10.2013 17:52
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_GoldenAA12Fire extends UM_AA12Fire;


defaultproperties
{
     AmmoClass=Class'KFMod.GoldenAA12Ammo'
	 ProjectileClass=Class'UnlimaginMod.UM_GoldenAA12_00Buckshot'
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenAA12MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenAA12Slug',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenAA12IncBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenAA12FragBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
}
