//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_AK47Attachment
//	Parent class:	 UM_BaseAssaultRifleAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 08:48
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_AK47Attachment extends UM_BaseAssaultRifleAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_AK47"
     MovementAnims(1)="JogB_AK47"
     MovementAnims(2)="JogL_AK47"
     MovementAnims(3)="JogR_AK47"
     TurnLeftAnim="TurnL_AK47"
     TurnRightAnim="TurnR_AK47"
     CrouchAnims(0)="CHWalkF_AK47"
     CrouchAnims(1)="CHWalkB_AK47"
     CrouchAnims(2)="CHWalkL_AK47"
     CrouchAnims(3)="CHWalkR_AK47"
     WalkAnims(0)="WalkF_AK47"
     WalkAnims(1)="WalkB_AK47"
     WalkAnims(2)="WalkL_AK47"
     WalkAnims(3)="WalkR_AK47"
     CrouchTurnRightAnim="CH_TurnR_AK47"
     CrouchTurnLeftAnim="CH_TurnL_AK47"
     IdleCrouchAnim="CHIdle_AK47"
     IdleWeaponAnim="Idle_AK47"
     IdleRestAnim="Idle_AK47"
     IdleChatAnim="Idle_AK47"
     IdleHeavyAnim="Idle_AK47"
     IdleRifleAnim="Idle_AK47"
     FireAnims(0)="Fire_AK47"
     FireAnims(1)="Fire_AK47"
     FireAnims(2)="Fire_AK47"
     FireAnims(3)="Fire_AK47"
     FireAltAnims(0)="Fire_AK47"
     FireAltAnims(1)="Fire_AK47"
     FireAltAnims(2)="Fire_AK47"
     FireAltAnims(3)="Fire_AK47"
     FireCrouchAnims(0)="CHFire_AK47"
     FireCrouchAnims(1)="CHFire_AK47"
     FireCrouchAnims(2)="CHFire_AK47"
     FireCrouchAnims(3)="CHFire_AK47"
     FireCrouchAltAnims(0)="CHFire_AK47"
     FireCrouchAltAnims(1)="CHFire_AK47"
     FireCrouchAltAnims(2)="CHFire_AK47"
     FireCrouchAltAnims(3)="CHFire_AK47"
     HitAnims(0)="HitF_AK47"
     HitAnims(1)="HitB_AK47"
     HitAnims(2)="HitL_AK47"
     HitAnims(3)="HitR_AK47"
     PostFireBlendStandAnim="Blend_AK47"
     PostFireBlendCrouchAnim="CHBlend_AK47"
     MeshRef="KF_Weapons3rd_Trip.AK47_3rd"
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
