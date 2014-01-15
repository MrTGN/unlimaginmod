//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_TrenchgunAttachment
//	Parent class:	 UM_BaseShotgunAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 10:13
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_TrenchgunAttachment extends UM_BaseShotgunAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdKar'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShotgunShellSpewer'))
     MovementAnims(0)="JogF_Shotgun"
     MovementAnims(1)="JogB_Shotgun"
     MovementAnims(2)="JogL_Shotgun"
     MovementAnims(3)="JogR_Shotgun"
     TurnLeftAnim="TurnL_Shotgun"
     TurnRightAnim="TurnR_Shotgun"
     CrouchAnims(0)="CHwalkF_Shotgun"
     CrouchAnims(1)="CHwalkB_Shotgun"
     CrouchAnims(2)="CHwalkL_Shotgun"
     CrouchAnims(3)="CHwalkR_Shotgun"
     WalkAnims(0)="WalkF_Shotgun"
     WalkAnims(1)="WalkB_Shotgun"
     WalkAnims(2)="WalkL_Shotgun"
     WalkAnims(3)="WalkR_Shotgun"
     CrouchTurnRightAnim="CH_TurnR_Shotgun"
     CrouchTurnLeftAnim="CH_TurnL_Shotgun"
     IdleCrouchAnim="CHIdle_Shotgun"
     IdleWeaponAnim="Idle_Shotgun"
     IdleRestAnim="Idle_Shotgun"
     IdleChatAnim="Idle_Shotgun"
     IdleHeavyAnim="Idle_Shotgun"
     IdleRifleAnim="Idle_Shotgun"
     FireAnims(0)="Fire_Shotgun"
     FireAnims(1)="Fire_Shotgun"
     FireAnims(2)="Fire_Shotgun"
     FireAnims(3)="Fire_Shotgun"
     FireAltAnims(0)="Fire_Shotgun"
     FireAltAnims(1)="Fire_Shotgun"
     FireAltAnims(2)="Fire_Shotgun"
     FireAltAnims(3)="Fire_Shotgun"
     FireCrouchAnims(0)="CHFire_Shotgun"
     FireCrouchAnims(1)="CHFire_Shotgun"
     FireCrouchAnims(2)="CHFire_Shotgun"
     FireCrouchAnims(3)="CHFire_Shotgun"
     FireCrouchAltAnims(0)="CHFire_Shotgun"
     FireCrouchAltAnims(1)="CHFire_Shotgun"
     FireCrouchAltAnims(2)="CHFire_Shotgun"
     FireCrouchAltAnims(3)="CHFire_Shotgun"
     HitAnims(0)="HitF_Shotgun"
     HitAnims(1)="HitB_Shotgun"
     HitAnims(2)="HitL_Shotgun"
     HitAnims(3)="HitR_Shotgun"
     PostFireBlendStandAnim="Blend_Shotgun"
     PostFireBlendCrouchAnim="CHBlend_Shotgun"
     MeshRef="KF_Weapons3rd5_Trip.TrenchGun_3rd"
}
