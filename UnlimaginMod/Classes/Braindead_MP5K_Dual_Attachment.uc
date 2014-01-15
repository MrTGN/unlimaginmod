class Braindead_MP5K_Dual_Attachment extends UM_BaseSMGAttachment;


defaultproperties
{
	 // Default effects for the FireMode 0
	 // These dynamic arrays must be declared using 
	 // the single line syntax: StructProperty=( DynamicArray=(Value, Value) )
	 bHasSecondMesh=True
	 FireModeEffects[0]=(MeshNums=(MN_One,MN_Two),MuzzleBones=("tip","tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP',Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd',Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("Shell_eject","Shell_eject"),ShellEjectClasses=(Class'KFMod.KFShellSpewer',Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_Dual9mm"
     MovementAnims(1)="JogB_Dual9mm"
     MovementAnims(2)="JogL_Dual9mm"
     MovementAnims(3)="JogR_Dual9mm"
     TurnLeftAnim="TurnL_Dual9mm"
     TurnRightAnim="TurnR_Dual9mm"
     CrouchAnims(0)="CHwalkF_Dual9mm"
     CrouchAnims(1)="CHwalkB_Dual9mm"
     CrouchAnims(2)="CHwalkL_Dual9mm"
     CrouchAnims(3)="CHwalkR_Dual9mm"
     WalkAnims(0)="WalkF_Dual9mm"
     WalkAnims(1)="WalkB_Dual9mm"
     WalkAnims(2)="WalkL_Dual9mm"
     WalkAnims(3)="WalkR_Dual9mm"
     CrouchTurnRightAnim="CH_TurnR_Dual9mm"
     CrouchTurnLeftAnim="CH_TurnL_Dual9mm"
     IdleCrouchAnim="CHIdle_Dual9mm"
     IdleWeaponAnim="Idle_Dual9mm"
     IdleRestAnim="Idle_Dual9mm"
     IdleChatAnim="Idle_Dual9mm"
     IdleHeavyAnim="Idle_Dual9mm"
     IdleRifleAnim="Idle_Dual9mm"
     FireAnims(0)="DualiesAttackRight"
     FireAnims(1)="DualiesAttackRight"
     FireAnims(2)="DualiesAttackRight"
     FireAnims(3)="DualiesAttackRight"
     FireAltAnims(0)="DualiesAttackLeft"
     FireAltAnims(1)="DualiesAttackLeft"
     FireAltAnims(2)="DualiesAttackLeft"
     FireAltAnims(3)="DualiesAttackLeft"
     FireCrouchAnims(0)="CHDualiesAttackRight"
     FireCrouchAnims(1)="CHDualiesAttackRight"
     FireCrouchAnims(2)="CHDualiesAttackRight"
     FireCrouchAnims(3)="CHDualiesAttackRight"
     FireCrouchAltAnims(0)="CHDualiesAttackLeft"
     FireCrouchAltAnims(1)="CHDualiesAttackLeft"
     FireCrouchAltAnims(2)="CHDualiesAttackLeft"
     FireCrouchAltAnims(3)="CHDualiesAttackLeft"
     HitAnims(0)="HitF_Dual9mmm"
     HitAnims(1)="HitB_Dual9mm"
     HitAnims(2)="HitL_Dual9mm"
     HitAnims(3)="HitR_Dual9mm"
     PostFireBlendStandAnim="Blend_Dual9mm"
     PostFireBlendCrouchAnim="CHBlend_Dual9mm"
     //Mesh=SkeletalMesh'BD_FL_MP5_A.MP5K'
	 MeshRef="BD_FL_MP5_A.MP5K"
}
