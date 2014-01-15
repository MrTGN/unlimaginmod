//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_MGL140TAttachment
//	Parent class:	 UM_BaseGrenadeLauncherAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 09:48
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_MGL140TAttachment extends UM_BaseGrenadeLauncherAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdNadeL'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=(),ShellEjectClasses=())
     MovementAnims(0)="JogF_M32_MGL"
     MovementAnims(1)="JogB_M32_MGL"
     MovementAnims(2)="JogL_M32_MGL"
     MovementAnims(3)="JogR_M32_MGL"
     TurnLeftAnim="TurnL_M32_MGL"
     TurnRightAnim="TurnR_M32_MGL"
     CrouchAnims(0)="CHWalkF_M32_MGL"
     CrouchAnims(1)="CHWalkB_M32_MGL"
     CrouchAnims(2)="CHWalkL_M32_MGL"
     CrouchAnims(3)="CHWalkR_M32_MGL"
     WalkAnims(0)="WalkF_M32_MGL"
     WalkAnims(1)="WalkB_M32_MGL"
     WalkAnims(2)="WalkL_M32_MGL"
     WalkAnims(3)="WalkR_M32_MGL"
     CrouchTurnRightAnim="CH_TurnR_M32_MGL"
     CrouchTurnLeftAnim="CH_TurnL_M32_MGL"
     IdleCrouchAnim="CHIdle_M32_MGL"
     IdleWeaponAnim="Idle_M32_MGL"
     IdleRestAnim="Idle_M32_MGL"
     IdleChatAnim="Idle_M32_MGL"
     IdleHeavyAnim="Idle_M32_MGL"
     IdleRifleAnim="Idle_M32_MGL"
     FireAnims(0)="Fire_M32_MGL"
     FireAnims(1)="Fire_M32_MGL"
     FireAnims(2)="Fire_M32_MGL"
     FireAnims(3)="Fire_M32_MGL"
     FireAltAnims(0)="Fire_M32_MGL"
     FireAltAnims(1)="Fire_M32_MGL"
     FireAltAnims(2)="Fire_M32_MGL"
     FireAltAnims(3)="Fire_M32_MGL"
     FireCrouchAnims(0)="CHFire_M32_MGL"
     FireCrouchAnims(1)="CHFire_M32_MGL"
     FireCrouchAnims(2)="CHFire_M32_MGL"
     FireCrouchAnims(3)="CHFire_M32_MGL"
     FireCrouchAltAnims(0)="CHFire_M32_MGL"
     FireCrouchAltAnims(1)="CHFire_M32_MGL"
     FireCrouchAltAnims(2)="CHFire_M32_MGL"
     FireCrouchAltAnims(3)="CHFire_M32_MGL"
     HitAnims(0)="HitF_M32_MGL"
     HitAnims(1)="HitB_M32_MGL"
     HitAnims(2)="HitL_M32_MGL"
     HitAnims(3)="HitR_M32_MGL"
     PostFireBlendStandAnim="Blend_M32_MGL"
     PostFireBlendCrouchAnim="CHBlend_M32_MGL"
     MeshRef="KF_Weapons3rd2_Trip.M32_MGL_3rd"
}
