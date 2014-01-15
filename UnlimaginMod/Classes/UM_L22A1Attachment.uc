//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_L22A1Attachment
//	Parent class:	 UM_BaseAssaultRifleAttachment
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.10.2013 09:31
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_L22A1Attachment extends UM_BaseAssaultRifleAttachment;


defaultproperties
{
     FireModeEffects[0]=(FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
	 MovementAnims(0)="JogF_Bullpup"
     MovementAnims(1)="JogB_Bullpup"
     MovementAnims(2)="JogL_Bullpup"
     MovementAnims(3)="JogR_Bullpup"
     TurnLeftAnim="TurnL_Bullpup"
     TurnRightAnim="TurnR_Bullpup"
     CrouchAnims(0)="CHwalkF_BullPup"
     CrouchAnims(1)="CHwalkB_BullPup"
     CrouchAnims(2)="CHwalkL_BullPup"
     CrouchAnims(3)="CHwalkR_BullPup"
     WalkAnims(0)="WalkF_Bullpup"
     WalkAnims(1)="WalkB_Bullpup"
     WalkAnims(2)="WalkL_Bullpup"
     WalkAnims(3)="WalkR_Bullpup"
     AirAnims(0)="JumpF_Mid"
     AirAnims(1)="JumpF_Mid"
     AirAnims(2)="JumpL_Mid"
     AirAnims(3)="JumpR_Mid"
     TakeoffAnims(0)="JumpF_Takeoff"
     TakeoffAnims(1)="JumpF_Takeoff"
     TakeoffAnims(2)="JumpL_Takeoff"
     TakeoffAnims(3)="JumpR_Takeoff"
     LandAnims(0)="JumpF_Land"
     LandAnims(1)="JumpF_Land"
     LandAnims(2)="JumpL_Land"
     LandAnims(3)="JumpR_Land"
     DoubleJumpAnims(0)="DoubleJumpF"
     DoubleJumpAnims(1)="DoubleJumpB"
     DoubleJumpAnims(2)="DoubleJumpL"
     DoubleJumpAnims(3)="DoubleJumpR"
     DodgeAnims(0)="JumpF_Takeoff"
     DodgeAnims(1)="JumpF_Takeoff"
     DodgeAnims(2)="JumpL_Takeoff"
     DodgeAnims(3)="JumpR_Takeoff"
     AirStillAnim="JumpF_Mid"
     TakeoffStillAnim="JumpF_Takeoff"
	 CrouchTurnRightAnim="CH_TurnR_Bullpup"
	 CrouchTurnLeftAnim="CH_TurnL_Bullpup"
     IdleCrouchAnim="CHIdle_BullPup"
     IdleSwimAnim="Swim_Tread"
     IdleWeaponAnim="Idle_Bullpup"
     IdleRestAnim="Idle_Bullpup"
     IdleChatAnim="Idle_Bullpup"
     WallDodgeAnims(0)="WallDodgeF"
     WallDodgeAnims(1)="WallDodgeB"
     WallDodgeAnims(2)="WallDodgeL"
     WallDodgeAnims(3)="WallDodgeR"
     IdleHeavyAnim="Idle_Bullpup"
     IdleRifleAnim="Idle_Bullpup"
     FireAnims(0)="Fire_Bullpup"
     FireAnims(1)="Fire_Bullpup"
     FireAnims(2)="Fire_Bullpup"
     FireAnims(3)="Fire_Bullpup"
     FireAltAnims(0)="Fire_Bullpup"
     FireAltAnims(1)="Fire_Bullpup"
     FireAltAnims(2)="Fire_Bullpup"
     FireAltAnims(3)="Fire_Bullpup"
     FireCrouchAnims(0)="CHFire_BullPup"
     FireCrouchAnims(1)="CHFire_BullPup"
     FireCrouchAnims(2)="CHFire_BullPup"
     FireCrouchAnims(3)="CHFire_BullPup"
     FireCrouchAltAnims(0)="CHFire_BullPup"
     FireCrouchAltAnims(1)="CHFire_BullPup"
     FireCrouchAltAnims(2)="CHFire_BullPup"
     FireCrouchAltAnims(3)="CHFire_BullPup"
     HitAnims(0)="HitF_Bullpup"
     HitAnims(1)="HitB_Bullpup"
     HitAnims(2)="HitL_Bullpup"
     HitAnims(3)="HitR_Bullpup"
     PostFireBlendStandAnim="Blend_Bullpup"
     PostFireBlendCrouchAnim="CHBlend_Bullpup"
	 bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
     MeshRef="KF_Weapons3rd_Trip.BullPup_3rd"
}
