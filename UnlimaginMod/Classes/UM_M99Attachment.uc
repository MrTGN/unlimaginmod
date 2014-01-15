//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_M99Attachment
//	Parent class:	 UM_BaseSingleShotSniperRifleAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 09:44
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_M99Attachment extends UM_BaseSingleShotSniperRifleAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdPTRD'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_M4203"
     MovementAnims(1)="JogB_M4203"
     MovementAnims(2)="JogL_M4203"
     MovementAnims(3)="JogR_M4203"
     TurnLeftAnim="TurnL_M4203"
     TurnRightAnim="TurnR_M4203"
     CrouchAnims(0)="CHWalkF_M4203"
     CrouchAnims(1)="CHWalkB_M4203"
     CrouchAnims(2)="CHWalkL_M4203"
     CrouchAnims(3)="CHWalkR_M4203"
     WalkAnims(0)="WalkF_M4203"
     WalkAnims(1)="WalkB_M4203"
     WalkAnims(2)="WalkL_M4203"
     WalkAnims(3)="WalkR_M4203"
     CrouchTurnRightAnim="CH_TurnR_M4203"
     CrouchTurnLeftAnim="CH_TurnL_M4203"
     IdleCrouchAnim="CHIdle_M4203"
     IdleWeaponAnim="Idle_M4203"
     IdleRestAnim="Idle_M4203"
     IdleChatAnim="Idle_M4203"
     IdleHeavyAnim="Idle_M4203"
     IdleRifleAnim="Idle_M4203"
     FireAnims(0)="Fire_M99"
     FireAnims(1)="Fire_M99"
     FireAnims(2)="Fire_M99"
     FireAnims(3)="Fire_M99"
     FireAltAnims(0)="Fire_M99"
     FireAltAnims(1)="Fire_M99"
     FireAltAnims(2)="Fire_M99"
     FireAltAnims(3)="Fire_M99"
     FireCrouchAnims(0)="CHFire_M99"
     FireCrouchAnims(1)="CHFire_M99"
     FireCrouchAnims(2)="CHFire_M99"
     FireCrouchAnims(3)="CHFire_M99"
     FireCrouchAltAnims(0)="CHFire_M99"
     FireCrouchAltAnims(1)="CHFire_M99"
     FireCrouchAltAnims(2)="CHFire_M99"
     FireCrouchAltAnims(3)="CHFire_M99"
     HitAnims(0)="HitF_M4203"
     HitAnims(1)="HitB_M4203"
     HitAnims(2)="HitL_M4203"
     HitAnims(3)="HitR_M4203"
     PostFireBlendStandAnim="Blend_M4203"
     PostFireBlendCrouchAnim="CHBlend_M4203"
     MeshRef="KF_Weapons3rd4_Trip.M99_Sniper_3rd"
     CullDistance=5000.000000
}
