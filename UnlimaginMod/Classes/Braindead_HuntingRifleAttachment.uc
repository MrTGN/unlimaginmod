class Braindead_HuntingRifleAttachment extends UM_BaseBoltActSniperRifleAttachment;

defaultproperties
{
	 // Default effects for the FireMode 0
	 // These dynamic arrays must be declared using 
	 // the single line syntax: StructProperty=( DynamicArray=(Value, Value) )
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdSTG'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("ShellPort"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="WalkF_Winchester"
     MovementAnims(1)="WalkB_Winchester"
     MovementAnims(2)="WalkL_Winchester"
     MovementAnims(3)="WalkL_Winchester"
     TurnLeftAnim="TurnL_Winchester"
     TurnRightAnim="TurnR_Winchester"
     CrouchAnims(0)="CHwalkF_Winchester"
     CrouchAnims(1)="CHwalkB_Winchester"
     CrouchAnims(2)="CHwalkL_Winchester"
     CrouchAnims(3)="CHwalkR_Winchester"
     WalkAnims(0)="WalkF_Winchester"
     WalkAnims(1)="WalkB_Winchester"
     WalkAnims(2)="WalkL_Winchester"
     WalkAnims(3)="WalkL_Winchester"
     CrouchTurnRightAnim="CH_TurnR_Winchester"
     CrouchTurnLeftAnim="CH_TurnL_Winchester"
     IdleCrouchAnim="CHIdle_Winchester"
     IdleWeaponAnim="IS_Idle_Winchester"
     IdleRestAnim="IS_Idle_Winchester"
     IdleChatAnim="IS_Idle_Winchester"
     IdleHeavyAnim="IS_Idle_Winchester"
     IdleRifleAnim="IS_Idle_Winchester"
     FireAnims(0)="Claw"
     FireAnims(1)="Claw"
     FireAnims(2)="Claw"
     FireAnims(3)="Claw"
     FireAltAnims(0)="IS_Fire_Winchester"
     FireAltAnims(1)="IS_Fire_Winchester"
     FireAltAnims(2)="IS_Fire_Winchester"
     FireAltAnims(3)="IS_Fire_Winchester"
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
     //Mesh=SkeletalMesh'HuntingRifleA.HuntingRifle3rd'
	 MeshRef="HuntingRifleA.HuntingRifle3rd"
}
