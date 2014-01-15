//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_HK417Attachment extends UM_BaseSniperRifleAttachment;

defaultproperties
{
     FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
	 MovementAnims(0)="JogF_SCAR"
     MovementAnims(1)="JogB_SCAR"
     MovementAnims(2)="JogL_SCAR"
     MovementAnims(3)="JogR_SCAR"
     TurnLeftAnim="TurnL_SCAR"
     TurnRightAnim="TurnR_SCAR"
     CrouchAnims(0)="CHWalkF_SCAR"
     CrouchAnims(1)="CHWalkB_SCAR"
     CrouchAnims(2)="CHWalkL_SCAR"
     CrouchAnims(3)="CHWalkR_SCAR"
     WalkAnims(0)="WalkF_SCAR"
     WalkAnims(1)="WalkB_SCAR"
     WalkAnims(2)="WalkL_SCAR"
     WalkAnims(3)="WalkR_SCAR"
     CrouchTurnRightAnim="CH_TurnR_SCAR"
     CrouchTurnLeftAnim="CH_TurnL_SCAR"
     IdleCrouchAnim="CHIdle_SCAR"
     IdleWeaponAnim="Idle_SCAR"
     IdleRestAnim="Idle_SCAR"
     IdleChatAnim="Idle_SCAR"
     IdleHeavyAnim="Idle_SCAR"
     IdleRifleAnim="Idle_SCAR"
     FireAnims(0)="Fire_SCAR"
     FireAnims(1)="Fire_SCAR"
     FireAnims(2)="Fire_SCAR"
     FireAnims(3)="Fire_SCAR"
     FireAltAnims(0)="Fire_SCAR"
     FireAltAnims(1)="Fire_SCAR"
     FireAltAnims(2)="Fire_SCAR"
     FireAltAnims(3)="Fire_SCAR"
     FireCrouchAnims(0)="CHFire_SCAR"
     FireCrouchAnims(1)="CHFire_SCAR"
     FireCrouchAnims(2)="CHFire_SCAR"
     FireCrouchAnims(3)="CHFire_SCAR"
     FireCrouchAltAnims(0)="CHFire_SCAR"
     FireCrouchAltAnims(1)="CHFire_SCAR"
     FireCrouchAltAnims(2)="CHFire_SCAR"
     FireCrouchAltAnims(3)="CHFire_SCAR"
     HitAnims(0)="HitF_SCAR"
     HitAnims(1)="HitB_SCAR"
     HitAnims(2)="HitL_SCAR"
     HitAnims(3)="HitR_SCAR"
     PostFireBlendStandAnim="Blend_SCAR"
     PostFireBlendCrouchAnim="CHBlend_SCAR"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     //Mesh=SkeletalMesh'HK417_A.HK417_3rd'
	 MeshRef="HK417_A.HK417_3rd"
	 DrawScale=0.6
}
