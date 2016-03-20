//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140Fire
//	Parent class:	 UM_BaseGrenadeLauncherFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 04:05
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140Fire extends UM_BaseGrenadeLauncherFire;


function PostSpawnProjectile(Projectile P)
{
    if ( P != None && UM_BaseProjectile_StickyRMCGrenade(P) != None &&
		 Weapon != None && UM_MGL140Tactical(Weapon) != None )
		UM_MGL140Tactical(Weapon).AddRMCProjectiles(P);
	
	Super(BaseProjectileFire).PostSpawnProjectile(P);
}

function float MaxRange()
{
    Return 3000;
}

defaultproperties
{
     bChangeProjByPerk=True
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_MGL140StickyRMCNapalmGrenade')
	 // X - pointing from the observer to the screen (length)
	 // Y - horizontal axis (width)
	 // Z - vertical axis (height)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stNadeL'
	 ShellEjectBones(0)=
	 ShellEjectEmitterClasses(0)=None
	 //[end]
	 ProjSpawnOffsets(0)=(X=2.000000,Y=2.000000,Z=-6.000000)
	 EffectiveRange=3000.000000
     maxVerticalRecoilAngle=200
     maxHorizontalRecoilAngle=50
     FireAimedAnims(0)=(Anim="Iron_Fire",Rate=1.000000)
     FireSoundRef="KF_M32Snd.M32_Fire"
     StereoFireSoundRef="KF_M32Snd.M32_FireST"
     NoAmmoSoundRef="KF_M79Snd.M79_DryFire"
     ProjPerFire=1
     bWaitForRelease=True
     TransientSoundVolume=1.850000
     FireForce="AssaultRifleFire"
     FireRate=0.330000
     AmmoClass=Class'UnlimaginMod.UM_MGL140Ammo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'UnlimaginMod.UM_MGL140StickyRMCGrenade'
     BotRefireRate=1.800000
     AimError=60.000000
     Spread=0.016000
	 MaxSpread=0.016000
}
