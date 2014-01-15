//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenBenelliM4Fire
//	Parent class:	 UM_BenelliM4Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2013 18:21
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenBenelliM4Fire extends UM_BenelliM4Fire;


defaultproperties
{
     AmmoClass=Class'KFMod.GoldenBenelliAmmo'
	 ProjectileClass=Class'UnlimaginMod.UM_GoldenBenelliM4_1Buckshot'
	 //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenBenelliM4MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenBenelliM4Slug',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenBenelliM4IncBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_GoldenBenelliM4FragBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //[end]
}
