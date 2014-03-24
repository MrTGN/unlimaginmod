//=============================================================================
 //AUG A1 Fire
//=============================================================================
class OperationY_AUG_A1ARFire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'AUG_A1_A.AUG_A1_SND.aug_fire'
	 FireSoundRef="AUG_A1_A.AUG_A1_SND.aug_fire"
     //NoAmmoSound=Sound'AUG_A1_A.AUG_A1_SND.aug_empty'
	 NoAmmoSoundRef="AUG_A1_A.AUG_A1_SND.aug_empty"
	 //[end]
	 //[block] Fire Effects
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=-3.000000)
	 FireAimedAnims(0)=(Anim="Fire",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=242
     maxHorizontalRecoilAngle=85
     bPawnRapidFireAnim=True
     TransientSoundVolume=2.250000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.080000
     AmmoClass=Class'UnlimaginMod.OperationY_AUG_A1ARAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=72.000000,Y=72.000000,Z=345.000000)
     ShakeRotRate=(X=6800.000000,Y=6800.000000,Z=6800.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.400000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
	 ProjectileClass=Class'UnlimaginMod.UM_AUG_A1ARBullet'
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     AimError=62.000000
     Spread=0.009000
	 MaxSpread=0.053000
     SpreadStyle=SS_Random
}
