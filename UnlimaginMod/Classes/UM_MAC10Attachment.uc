//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_MAC10Attachment
//	Parent class:	 UM_BaseSMGAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 09:45
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_MAC10Attachment extends UM_BaseSMGAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("Shell_eject"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_Mac10"
     MovementAnims(1)="JogB_Mac10"
     MovementAnims(2)="JogL_Mac10"
     MovementAnims(3)="JogR_Mac10"
     TurnLeftAnim="TurnL_Mac10"
     TurnRightAnim="TurnR_Mac10"
     CrouchAnims(0)="CHWalkF_Mac10"
     CrouchAnims(1)="CHWalkB_Mac10"
     CrouchAnims(2)="CHWalkL_Mac10"
     CrouchAnims(3)="CHWalkR_Mac10"
     WalkAnims(0)="WalkF_Mac10"
     WalkAnims(1)="WalkB_Mac10"
     WalkAnims(2)="WalkL_Mac10"
     WalkAnims(3)="WalkR_Mac10"
     CrouchTurnRightAnim="CH_TurnR_Mac10"
     CrouchTurnLeftAnim="CH_TurnL_Mac10"
     IdleCrouchAnim="CHIdle_Mac10"
     IdleWeaponAnim="Idle_Mac10"
     IdleRestAnim="Idle_Mac10"
     IdleChatAnim="Idle_Mac10"
     IdleHeavyAnim="Idle_Mac10"
     IdleRifleAnim="Idle_Mac10"
     FireAnims(0)="Fire_Mac10"
     FireAnims(1)="Fire_Mac10"
     FireAnims(2)="Fire_Mac10"
     FireAnims(3)="Fire_Mac10"
     FireAltAnims(0)="IS_Fire_Mac10"
     FireAltAnims(1)="IS_Fire_Mac10"
     FireAltAnims(2)="IS_Fire_Mac10"
     FireAltAnims(3)="IS_Fire_Mac10"
     FireCrouchAnims(0)="CHFire_Mac10"
     FireCrouchAnims(1)="CHFire_Mac10"
     FireCrouchAnims(2)="CHFire_Mac10"
     FireCrouchAnims(3)="CHFire_Mac10"
     FireCrouchAltAnims(0)="CHFire_Mac10"
     FireCrouchAltAnims(1)="CHFire_Mac10"
     FireCrouchAltAnims(2)="CHFire_Mac10"
     FireCrouchAltAnims(3)="CHFire_Mac10"
     HitAnims(0)="HitF_Mac10"
     HitAnims(1)="HitB_Mac10"
     HitAnims(2)="HitL_Mac10"
     HitAnims(3)="HitR_Mac10"
     PostFireBlendStandAnim="Blend_Mac10"
     PostFireBlendCrouchAnim="CHBlend_Mac10"
     MeshRef="KF_Weapons3rd2_Trip.mac10_3rd"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
