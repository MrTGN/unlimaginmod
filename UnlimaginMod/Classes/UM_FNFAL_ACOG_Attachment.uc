//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_FNFAL_ACOG_Attachment
//	Parent class:	 UM_BaseAssaultRifleAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 09:01
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_FNFAL_ACOG_Attachment extends UM_BaseAssaultRifleAttachment;


defaultproperties
{
	 FireModeEffects[0]=(FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("Shell_eject"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_AA12"
     MovementAnims(1)="JogB_AA12"
     MovementAnims(2)="JogL_AA12"
     MovementAnims(3)="JogR_AA12"
     TurnLeftAnim="TurnL_AA12"
     TurnRightAnim="TurnR_AA12"
     CrouchAnims(0)="CHWalkF_AA12"
     CrouchAnims(1)="CHWalkB_AA12"
     CrouchAnims(2)="CHWalkL_AA12"
     CrouchAnims(3)="CHWalkR_AA12"
     WalkAnims(0)="WalkF_AA12"
     WalkAnims(1)="WalkB_AA12"
     WalkAnims(2)="WalkL_AA12"
     WalkAnims(3)="WalkR_AA12"
     CrouchTurnRightAnim="CH_TurnR_AA12"
     CrouchTurnLeftAnim="CH_TurnL_AA12"
     IdleCrouchAnim="CHIdle_AA12"
     IdleWeaponAnim="Idle_AA12"
     IdleRestAnim="Idle_AA12"
     IdleChatAnim="Idle_AA12"
     IdleHeavyAnim="Idle_AA12"
     IdleRifleAnim="Idle_AA12"
     FireAnims(0)="Fire_AA12"
     FireAnims(1)="Fire_AA12"
     FireAnims(2)="Fire_AA12"
     FireAnims(3)="Fire_AA12"
     FireAltAnims(0)="Fire_AA12"
     FireAltAnims(1)="Fire_AA12"
     FireAltAnims(2)="Fire_AA12"
     FireAltAnims(3)="Fire_AA12"
     FireCrouchAnims(0)="CHFire_AA12"
     FireCrouchAnims(1)="CHFire_AA12"
     FireCrouchAnims(2)="CHFire_AA12"
     FireCrouchAnims(3)="CHFire_AA12"
     FireCrouchAltAnims(0)="CHFire_AA12"
     FireCrouchAltAnims(1)="CHFire_AA12"
     FireCrouchAltAnims(2)="CHFire_AA12"
     FireCrouchAltAnims(3)="CHFire_AA12"
     HitAnims(0)="HitF_AA12"
     HitAnims(1)="HitB_AA12"
     HitAnims(2)="HitL_AA12"
     HitAnims(3)="HitR_AA12"
     PostFireBlendStandAnim="Blend_AA12"
     PostFireBlendCrouchAnim="CHBlend_AA12"
     MeshRef="KF_Weapons3rd4_Trip.Fal_Acog_3rd"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
