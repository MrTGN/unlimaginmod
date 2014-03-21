//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_CrossbowFire
//	Parent class:	 UM_BaseSingleShotSniperRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 11:33
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_CrossbowFire extends UM_BaseSingleShotSniperRifleFire;


defaultproperties
{
     bDoFiringEffects=False
	 EffectiveRange=2500.000000
     maxVerticalRecoilAngle=200
     maxHorizontalRecoilAngle=50
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_XbowSnd.Xbow_Fire"
     NoAmmoSoundRef="KF_XbowSnd.Xbow_DryFire"
     ProjPerFire=1
     ProjSpawnOffset=(Y=0.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireForce="AssaultRifleFire"
     FireRate=1.800000
     AmmoClass=Class'KFMod.CrossbowAmmo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'UnlimaginMod.UM_CrossbowArrow'
     BotRefireRate=1.800000
     AimError=16.000000
     Spread=0.010000
	 MaxSpread=0.020000
     SpreadStyle=SS_Random
}
