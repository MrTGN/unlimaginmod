//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGFire
//	Parent class:	 UM_BaseMagShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2012 6:50
//================================================================================
class UM_KSGFire extends UM_BaseMagShotgunFire;

var		class<Projectile>	SecondProjectileClass;
var		int					AltProjPerFire;
var		float				AltSpread;

function UpdateFireProperties( Class<UM_SRVeterancyTypes> SRVT )
{
	local	byte	DefPerkIndex;
	
	MaxSpread = default.MaxSpread;
	AimError = default.AimError;
	if ( UM_KSGShotgun(Weapon) != None && UM_KSGShotgun(Weapon).bWideSpread )  {
		ProjectileClass = default.SecondProjectileClass;
		ProjPerFire = default.AltProjPerFire;
		Spread = default.AltSpread;
	}
	else  {
		ProjectileClass = default.ProjectileClass;
		ProjPerFire = default.ProjPerFire;
		Spread = default.Spread;
	}
	
	//[block] Switching ProjectileClass, ProjPerFire and Spread by Perk Index
	if ( SRVT != None && bChangeProjByPerk )  {
		// Assign default.PerkIndex
		DefPerkIndex = SRVT.default.PerkIndex;
		if ( UM_KSGShotgun(Weapon) != None && UM_KSGShotgun(Weapon).bWideSpread )  {
			// Checking and assigning ProjectileClass
			if ( PerkProjsInfo[DefPerkIndex].SecondPerkProjClass != None )
				ProjectileClass = PerkProjsInfo[DefPerkIndex].SecondPerkProjClass;
			
			// Checking and assigning ProjPerFire
			if ( PerkProjsInfo[DefPerkIndex].SecondPerkProjPerFire > 0 )
				ProjPerFire = PerkProjsInfo[DefPerkIndex].SecondPerkProjPerFire;
			
			// Checking and assigning Spread
			if ( PerkProjsInfo[DefPerkIndex].SecondPerkProjSpread > 0.0 )
				Spread = PerkProjsInfo[DefPerkIndex].SecondPerkProjSpread;
			
			// Checking and assigning MaxSpread
			if ( PerkProjsInfo[DefPerkIndex].SecondPerkProjMaxSpread > 0.0 )
				MaxSpread = PerkProjsInfo[DefPerkIndex].SecondPerkProjMaxSpread;
		}
		else  {
			// Checking and assigning ProjectileClass
			if ( PerkProjsInfo[DefPerkIndex].PerkProjClass != None )
				ProjectileClass = PerkProjsInfo[DefPerkIndex].PerkProjClass;
			
			// Checking and assigning ProjPerFire
			if ( PerkProjsInfo[DefPerkIndex].PerkProjPerFire > 0 )
				ProjPerFire = PerkProjsInfo[DefPerkIndex].PerkProjPerFire;
			
			// Checking and assigning Spread
			if ( PerkProjsInfo[DefPerkIndex].PerkProjSpread > 0.0 )
				Spread = PerkProjsInfo[DefPerkIndex].PerkProjSpread;
			
			// Checking and assigning MaxSpread
			if ( PerkProjsInfo[DefPerkIndex].PerkProjMaxSpread > 0.0 )
				MaxSpread = PerkProjsInfo[DefPerkIndex].PerkProjMaxSpread;
		}
	}
	//[end]
	
	// Updating Spread and AimError. Needed for the crouched and Aiming bonuses.
	Spread = UpdateSpread(Spread);
	AimError = GetAimError();
}

defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'KFMod.KSGShellEject'
	 //[end]
     KickMomentum=(X=-85.000000,Z=14.000000)
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=500
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_KSGSnd.KSG_Fire_M"
     StereoFireSoundRef="KF_KSGSnd.KSG_Fire_S"
     NoAmmoSoundRef="KF_AA12Snd.AA12_DryFire"
     ProjPerFire=7
	 AltProjPerFire=21
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.820000
     AmmoClass=Class'KFMod.KSGAmmo'
     ShakeRotMag=(X=55.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12000.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.500000,Y=2.500000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_KSG_000Buckshot'
	 SecondProjectileClass=Class'UnlimaginMod.UM_KSG_4Buckshot'
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_KSGMedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.014000,SecondPerkProjClass=Class'UnlimaginMod.UM_KSGMedGasBulletB',SecondPerkProjPerFire=1,SecondPerkProjSpread=0.014000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_KSGSlug',PerkProjPerFire=1,PerkProjSpread=0.014000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_KSGIncBullet',PerkProjPerFire=1,PerkProjSpread=0.014000,SecondPerkProjClass=Class'UnlimaginMod.UM_KSGIncBulletB',SecondPerkProjPerFire=4,SecondPerkProjSpread=800.000000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_KSGFragBullet',PerkProjPerFire=1,PerkProjSpread=0.014000,SecondPerkProjClass=Class'UnlimaginMod.UM_KSGFragBulletB',SecondPerkProjPerFire=4,SecondPerkProjSpread=800.000000)
     BotRefireRate=0.250000
     AimError=76.000000
	 Spread=1000.000000
	 AltSpread=2400.000000
}
