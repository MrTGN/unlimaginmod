//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ThompsonM4A1SMGAttachment
//	Parent class:	 UM_BaseSMGAttachment
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 28.10.2013 10:11
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_ThompsonM4A1SMGAttachment extends UM_BaseSMGAttachment;


defaultproperties
{
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_Thompson"
     MovementAnims(1)="JogB_Thompson"
     MovementAnims(2)="JogL_Thompson"
     MovementAnims(3)="JogR_Thompson"
     TurnLeftAnim="TurnL_Thompson"
     TurnRightAnim="TurnR_Thompson"
     CrouchAnims(0)="CHWalkF_Thompson"
     CrouchAnims(1)="CHWalkB_Thompson"
     CrouchAnims(2)="CHWalkL_Thompson"
     CrouchAnims(3)="CHWalkR_Thompson"
     WalkAnims(0)="WalkF_Thompson"
     WalkAnims(1)="WalkB_Thompson"
     WalkAnims(2)="WalkL_Thompson"
     WalkAnims(3)="WalkR_Thompson"
     CrouchTurnRightAnim="CH_TurnR_Thompson"
     CrouchTurnLeftAnim="CH_TurnL_Thompson"
     IdleCrouchAnim="CHIdle_Thompson"
     IdleWeaponAnim="Idle_Thompson"
     IdleRestAnim="Idle_Thompson"
     IdleChatAnim="Idle_Thompson"
     IdleHeavyAnim="Idle_Thompson"
     IdleRifleAnim="Idle_Thompson"
     FireAnims(0)="Fire_Thompson"
     FireAnims(1)="Fire_Thompson"
     FireAnims(2)="Fire_Thompson"
     FireAnims(3)="Fire_Thompson"
     FireAltAnims(0)="Fire_Thompson"
     FireAltAnims(1)="Fire_Thompson"
     FireAltAnims(2)="Fire_Thompson"
     FireAltAnims(3)="Fire_Thompson"
     FireCrouchAnims(0)="CHFire_Thompson"
     FireCrouchAnims(1)="CHFire_Thompson"
     FireCrouchAnims(2)="CHFire_Thompson"
     FireCrouchAnims(3)="CHFire_Thompson"
     FireCrouchAltAnims(0)="CHFire_Thompson"
     FireCrouchAltAnims(1)="CHFire_Thompson"
     FireCrouchAltAnims(2)="CHFire_Thompson"
     FireCrouchAltAnims(3)="CHFire_Thompson"
     HitAnims(0)="HitF_Thompson"
     HitAnims(1)="HitB_Thompson"
     HitAnims(2)="HitL_Thompson"
     HitAnims(3)="HitR_Thompson"
     PostFireBlendStandAnim="Blend_Thompson"
     PostFireBlendCrouchAnim="CHBlend_Thompson"
     MeshRef="KF_Weapons3rd_IJC.thompson_3rd"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
}
