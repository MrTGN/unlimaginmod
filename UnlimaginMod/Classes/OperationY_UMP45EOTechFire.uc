//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_UMP45EOTechFire extends OperationY_UMP45Fire;

defaultproperties
{
	 bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45EOTechMedGas')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45EOTechIncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_UMP45EOTechExpBullet')
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-4.000000,Z=-1.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_shot'
     //NoAmmoSound=Sound'UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_empty'
	 //StereoFireSound=Sound'UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_shot'
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip_LLIePLLIeHb"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="SE_LLIePLLIeHb"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectUMP45EOTech'
	 //[end]
     maxVerticalRecoilAngle=260
     maxHorizontalRecoilAngle=130
     bPawnRapidFireAnim=True
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     ShakeRotMag=(X=64.000000,Y=50.000000,Z=345.000000)
     ShakeRotRate=(X=5500.000000,Y=5500.000000,Z=5500.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.400000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_UMP45EOTechBullet'
     BotRefireRate=0.990000
     AimError=62.000000
}
