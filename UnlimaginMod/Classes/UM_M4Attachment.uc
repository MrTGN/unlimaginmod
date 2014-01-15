//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_M4Attachment
//	Parent class:	 UM_BaseAssaultRifleAttachment
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 28.10.2013 09:38
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_M4Attachment extends UM_BaseAssaultRifleAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("Shell_eject"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_M4"
     MovementAnims(1)="JogB_M4"
     MovementAnims(2)="JogL_M4"
     MovementAnims(3)="JogR_M4"
     TurnLeftAnim="TurnL_M4"
     TurnRightAnim="TurnR_M4"
     CrouchAnims(0)="CHWalkF_M4"
     CrouchAnims(1)="CHWalkB_M4"
     CrouchAnims(2)="CHWalkL_M4"
     CrouchAnims(3)="CHWalkR_M4"
     WalkAnims(0)="WalkF_M4"
     WalkAnims(1)="WalkB_M4"
     WalkAnims(2)="WalkL_M4"
     WalkAnims(3)="WalkR_M4"
     CrouchTurnRightAnim="CH_TurnR_M4"
     CrouchTurnLeftAnim="CH_TurnL_M4"
     IdleCrouchAnim="CHIdle_M4"
     IdleWeaponAnim="Idle_M4"
     IdleRestAnim="Idle_M4"
     IdleChatAnim="Idle_M4"
     IdleHeavyAnim="Idle_M4"
     IdleRifleAnim="Idle_M4"
     FireAnims(0)="Fire_M4"
     FireAnims(1)="Fire_M4"
     FireAnims(2)="Fire_M4"
     FireAnims(3)="Fire_M4"
     FireAltAnims(0)="Fire_M4"
     FireAltAnims(1)="Fire_M4"
     FireAltAnims(2)="Fire_M4"
     FireAltAnims(3)="Fire_M4"
     FireCrouchAnims(0)="CHFire_M4"
     FireCrouchAnims(1)="CHFire_M4"
     FireCrouchAnims(2)="CHFire_M4"
     FireCrouchAnims(3)="CHFire_M4"
     FireCrouchAltAnims(0)="CHFire_M4"
     FireCrouchAltAnims(1)="CHFire_M4"
     FireCrouchAltAnims(2)="CHFire_M4"
     FireCrouchAltAnims(3)="CHFire_M4"
     HitAnims(0)="HitF_M4"
     HitAnims(1)="HitB_M4"
     HitAnims(2)="HitL_M4"
     HitAnims(3)="HitR_M4"
     PostFireBlendStandAnim="Blend_M4"
     PostFireBlendCrouchAnim="CHBlend_M4"
     MeshRef="KF_Weapons3rd3_Trip.M4_3rd"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
