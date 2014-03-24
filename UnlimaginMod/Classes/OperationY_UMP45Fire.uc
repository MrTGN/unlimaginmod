//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_UMP45Fire extends UM_BaseSMGFire;

#exec OBJ LOAD FILE=FX-G36C_v2_Snd.uax

defaultproperties
{
     bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45MedGas')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45IncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45ExpBullet')
	 ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=-1.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'UMP45_Snd.ump45_shot_mono'
	 //FireSoundRef="UMP45_Snd.ump45_shot_mono"
	 FireSoundRef="FX-G36C_v2_Snd.Fire_ST"
     //StereoFireSound=Sound'UMP45_Snd.ump45_shot_stereo'
	 //StereoFireSoundRef="UMP45_Snd.ump45_shot_stereo"
	 StereoFireSoundRef="FX-G36C_v2_Snd.Fire"
     //NoAmmoSound=Sound'UMP45_Snd.ump45_empty'
	 NoAmmoSoundRef="UMP45_Snd.ump45_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stMP'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMP5SMG'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=270
     maxHorizontalRecoilAngle=140
     //bRecoilRightOnly=True
     bPawnRapidFireAnim=True
     TransientSoundVolume=3.000000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     AmmoClass=Class'UnlimaginMod.OperationY_UMP45Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=65.000000,Y=52.000000,Z=348.000000)
     ShakeRotRate=(X=5500.000000,Y=5500.000000,Z=5500.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.500000,Y=3.000000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     ProjectileClass=Class'UnlimaginMod.UM_UMP45Bullet'
	 BotRefireRate=0.990000
     AimError=75.000000
     Spread=0.011000
	 MaxSpread=0.064000
     SpreadStyle=SS_Random
}
