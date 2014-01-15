//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M14EBRAttachment
//	Parent class:	 UM_BaseBattleRifleAttachment
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.10.2013 09:36
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M14EBRAttachment extends UM_BaseBattleRifleAttachment;


defaultproperties
{
	 FireModeEffects[0]=(FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_M14"
     MovementAnims(1)="JogB_M14"
     MovementAnims(2)="JogL_M14"
     MovementAnims(3)="JogR_M14"
     TurnLeftAnim="TurnL_M14"
     TurnRightAnim="TurnR_M14"
     CrouchAnims(0)="CHWalkF_M14"
     CrouchAnims(1)="CHWalkB_M14"
     CrouchAnims(2)="CHWalkL_M14"
     CrouchAnims(3)="CHWalkR_M14"
     WalkAnims(0)="WalkF_M14"
     WalkAnims(1)="WalkB_M14"
     WalkAnims(2)="WalkL_M14"
     WalkAnims(3)="WalkR_M14"
     CrouchTurnRightAnim="CH_TurnR_M14"
     CrouchTurnLeftAnim="CH_TurnL_M14"
     IdleCrouchAnim="CHIdle_M14"
     IdleWeaponAnim="Idle_M14"
     IdleRestAnim="Idle_M14"
     IdleChatAnim="Idle_M14"
     IdleHeavyAnim="Idle_M14"
     IdleRifleAnim="Idle_M14"
     FireAnims(0)="Fire_M14"
     FireAnims(1)="Fire_M14"
     FireAnims(2)="Fire_M14"
     FireAnims(3)="Fire_M14"
     FireAltAnims(0)="Fire_M14"
     FireAltAnims(1)="Fire_M14"
     FireAltAnims(2)="Fire_M14"
     FireAltAnims(3)="Fire_M14"
     FireCrouchAnims(0)="CHFire_M14"
     FireCrouchAnims(1)="CHFire_M14"
     FireCrouchAnims(2)="CHFire_M14"
     FireCrouchAnims(3)="CHFire_M14"
     FireCrouchAltAnims(0)="CHFire_M14"
     FireCrouchAltAnims(1)="CHFire_M14"
     FireCrouchAltAnims(2)="CHFire_M14"
     FireCrouchAltAnims(3)="CHFire_M14"
     HitAnims(0)="HitF_M14"
     HitAnims(1)="HitB_M14"
     HitAnims(2)="HitL_M14"
     HitAnims(3)="HitR_M14"
     PostFireBlendStandAnim="Blend_M14"
     PostFireBlendCrouchAnim="CHBlend_M14"
     MeshRef="KF_Weapons3rd2_Trip.M14_EBR_3rd"
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
