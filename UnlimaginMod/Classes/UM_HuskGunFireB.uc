//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_HuskGunFireB
//	Parent class:	 HuskGunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.08.2012 20:03
//================================================================================
class UM_HuskGunFireB extends HuskGunFire;

defaultproperties
{
     AmbientFireSoundRadius=500.000000
     MaxChargeTime=3.000000
     EffectiveRange=5000.000000
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=250
     ProjPerFire=1
     ProjSpawnOffset=(X=50.000000,Y=10.000000,Z=-20.000000)
     bFireOnRelease=True
     bWaitForRelease=True
     FireRate=0.750000
     AmmoClass=Class'KFMod.HuskGunAmmo'
     AimError=42.000000
     Spread=0.015000
}
