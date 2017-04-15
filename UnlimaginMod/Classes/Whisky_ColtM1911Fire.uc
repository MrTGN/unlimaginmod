//=============================================================================
// Whisky_ColtM1911Fire
//=============================================================================
class Whisky_ColtM1911Fire extends UM_BaseHandgunFire;


defaultproperties
{
	 bChangeProjByPerk=True
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_ColtM1911IncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_ColtM1911ExpBullet')
	 //
	 ProjSpawnOffsets(0)=(X=1.000000,Y=-8.000000,Z=2.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=SoundGroup'KF_9MMSnd.9mm_Fire'
	 FireSoundRef="IJCWeaponPackSoundsW2.MK23.MK23FireMono"
	 //FireSound=Sound'IJCWeaponPackSoundsW2.MK23.MK23FireMono'
	 StereoFireSoundRef="IJCWeaponPackSoundsW2.Fal.MK23Fire"
	 //StereoFireSound=Sound'IJCWeaponPackSoundsW2.Fal.MK23Fire'
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stMP'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectHandCannon'
	 //[end]
	 EmptyAnim=(Anim="Idle_Empty",Rate=1.500000)
     EmptyFireAnims(0)=(Anim="Fire_Last",Rate=1.500000)
	 FireAnims(0)=(Rate=1.500000)
	 FireAimedAnims(0)=(Rate=1.500000)
	 // Recoil
	 RecoilRate=0.1
	 RecoilUpRot=(Min=260,Max=320)
	 RecoilLeftChance=0.5
     RecoilLeftRot=(Min=54,Max=86)
	 RecoilRightRot=(Min=56,Max=90)

     bRandomPitchFireSound=True
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=2.600000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.175000
     AmmoClass=Class'UnlimaginMod.Whisky_ColtM1911Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=76.000000,Y=72.000000,Z=320.000000)
     ShakeRotRate=(X=12000.000000,Y=12000.000000,Z=10000.000000)
     ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.600000,Y=3.000000,Z=8.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
	 ProjectileClass=Class'UnlimaginMod.UM_ColtM1911Bullet'
     BotRefireRate=0.350000
     AimError=56.000000
     Spread=0.012000
	 MaxSpread=0.050000
     SpreadStyle=SS_Random
}
