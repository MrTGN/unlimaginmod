//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// G36C Fire class
// Made by FluX
// http://www.fluxiserver.co.uk
//===================================================================================
class FluX_G36CFire extends UM_BaseAssaultRifleFire;

#exec OBJ LOAD FILE=UMP45_Snd.uax

simulated function bool AllowFire()
{
	if(FluX_G36CAssaultRifle(Weapon).bIsToggling)
		Return False;
		
	Return Super.AllowFire();
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSoundRef="FX-G36C_v2_Snd.Fire_ST"
	 FireSoundRef="UMP45_Snd.ump45_shot_mono"
     //StereoFireSoundRef="FX-G36C_v2_Snd.Fire"
	 StereoFireSoundRef="UMP45_Snd.ump45_shot_stereo"
     NoAmmoSoundRef="FX-G36C_v2_Snd.DryFire"
	 //[end]
	 // Fire Effects
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 //Animations
	 FireAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=232
     maxHorizontalRecoilAngle=124
     bRecoilRightOnly=True
     bRandomPitchFireSound=False
     bPawnRapidFireAnim=True
     TransientSoundVolume=3.800000
     TransientSoundRadius=250.000000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.080000
     AmmoClass=Class'UnlimaginMod.FluX_G36CAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=60.000000,Y=55.000000,Z=340.000000)
     ShakeRotRate=(X=5500.000000,Y=5500.000000,Z=5500.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_G36CBullet'
     BotRefireRate=0.990000
     AimError=76.000000
     Spread=0.008000
	 MaxSpread=0.061000
     SpreadStyle=SS_Random
}
