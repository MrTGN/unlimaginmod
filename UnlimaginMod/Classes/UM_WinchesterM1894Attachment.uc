//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WinchesterM1894Attachment
//	Parent class:	 UM_BaseBoltActSniperRifleAttachment
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.10.2013 10:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_WinchesterM1894Attachment extends UM_BaseBoltActSniperRifleAttachment;


defaultproperties
{
     FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdSTG'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_Winchester"
     MovementAnims(1)="JogB_Winchester"
     MovementAnims(2)="JogL_Winchester"
     MovementAnims(3)="JogR_Winchester"
     TurnLeftAnim="TurnL_Winchester"
     TurnRightAnim="TurnR_Winchester"
     CrouchAnims(0)="CHwalkF_Winchester"
     CrouchAnims(1)="CHwalkB_Winchester"
     CrouchAnims(2)="CHwalkL_Winchester"
     CrouchAnims(3)="CHwalkR_Winchester"
     WalkAnims(0)="WalkF_Winchester"
     WalkAnims(1)="WalkB_Winchester"
     WalkAnims(2)="WalkL_Winchester"
     WalkAnims(3)="WalkR_Winchester"
     CrouchTurnRightAnim="CH_TurnR_Winchester"
     CrouchTurnLeftAnim="CH_TurnL_Winchester"
     IdleCrouchAnim="CHIdle_Winchester"
     IdleWeaponAnim="Idle_Winchester"
     IdleRestAnim="Idle_Winchester"
     IdleChatAnim="Idle_Winchester"
     IdleHeavyAnim="Idle_Winchester"
     IdleRifleAnim="Idle_Winchester"
     FireAnims(0)="Fire_Winchester"
     FireAnims(1)="Fire_Winchester"
     FireAnims(2)="Fire_Winchester"
     FireAnims(3)="Fire_Winchester"
     FireAltAnims(0)="Fire_Winchester"
     FireAltAnims(1)="Fire_Winchester"
     FireAltAnims(2)="Fire_Winchester"
     FireAltAnims(3)="Fire_Winchester"
     FireCrouchAnims(0)="CHFire_Winchester"
     FireCrouchAnims(1)="CHFire_Winchester"
     FireCrouchAnims(2)="CHFire_Winchester"
     FireCrouchAnims(3)="CHFire_Winchester"
     FireCrouchAltAnims(0)="CHFire_Winchester"
     FireCrouchAltAnims(1)="CHFire_Winchester"
     FireCrouchAltAnims(2)="CHFire_Winchester"
     FireCrouchAltAnims(3)="CHFire_Winchester"
     HitAnims(0)="HitF_Winchester"
     HitAnims(1)="HitB_Winchester"
     HitAnims(2)="HitL_Winchester"
     HitAnims(3)="HitR_Winchester"
     PostFireBlendStandAnim="Blend_Winchester"
     PostFireBlendCrouchAnim="CHBlend_Winchester"
     bHeavy=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
     MeshRef="KF_Weapons3rd_Trip.Winchester_3rd"
}
