//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Exod_BlueStahli_XMV850Fire extends UM_BaseMachineGunFire;

#exec OBJ LOAD FILE=XMV850_Snd.uax
#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax

var		bool	bWaitingForBarrelSpeed;
var		float	BarrelSpeedToStartFire;


function StartFiring()
{
	// ∆дем раскрутки ствола
	if ( Exod_BlueStahli_XMV850Minigun(Weapon).BarrelSpeed < BarrelSpeedToStartFire )
		bWaitingForBarrelSpeed = True;
	else
		Super.StartFiring();
}

event ModeTick(float dt)
{
	Super.ModeTick(dt);
	
	if ( bWaitingForBarrelSpeed && AllowFire() &&
		 Exod_BlueStahli_XMV850Minigun(Weapon).BarrelSpeed >= BarrelSpeedToStartFire )
	{
		bWaitingForBarrelSpeed = False;
		StartFiring();
	}
}

event ModeDoFire()
{
	if ( Exod_BlueStahli_XMV850Minigun(Weapon).BarrelSpeed < BarrelSpeedToStartFire )
		Return;
}

defaultproperties
{
     bHighRateOfFire=True
	 ProjSpawnOffsets(0)=(X=0.000000,Y=4.000000,Z=2.000000)
	 BarrelSpeedToStartFire=0.350000
	 //[block] Dynamic Loading Vars
	 FireEndSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_FireEnd_M"
	 //FireEndSoundRef="KF_BasePatriarch.Attack.Kev_MG_GunfireTail"
	 //FireEndStereoSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_FireEnd_S"
	 AmbientFireSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_FireLoop_M"
	 //AmbientFireSoundRef="KF_BasePatriarch.Attack.Kev_MG_GunfireLoop"
	 FireSoundRef="XMV850_Snd.XMV-Fire-1"
     StereoFireSoundRef="XMV850_Snd.XMV-Fire-1"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="ejector"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
	 FireAimedAnims(0)=(Anim="Idle",Rate=1.000000)
	 FireEndAnims(0)=(Anim="Idle",Rate=1.200000)
	 FireEndAimedAnims(0)=(Anim="Idle",Rate=1.200000)
	 FireLoopAnims(0)=(Anim="Idle",Rate=1.200000)
	 FireLoopAimedAnims(0)=(Anim="Idle",Rate=1.200000)
     RecoilRate=0.035000
     maxVerticalRecoilAngle=150
     maxHorizontalRecoilAngle=110
     bPawnRapidFireAnim=True
     TransientSoundVolume=15.000000
	 //TransientSoundRadius=500.000000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.040000
     AmmoClass=Class'UnlimaginMod.Exod_BlueStahli_XMV850Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=70.000000,Y=68.000000,Z=306.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_XMV850Bullet'
     BotRefireRate=0.990000
     AimError=60.000000
     Spread=0.024000
	 MaxSpread=0.098000
     SpreadStyle=SS_Random
}
