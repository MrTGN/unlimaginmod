class Exod_PooSH_StingerMinigunAttachment extends UM_BaseMachineGunAttachment;

#exec OBJ LOAD FILE=Stinger_A.ukx
#exec OBJ LOAD FILE=Stinger_Snd.uax
#exec OBJ LOAD FILE=Stinger_SM.usx
#exec OBJ LOAD FILE=Stinger_T.utx

var		int		FlashPitch, FlashYaw;
var		float	FlashOffset;

defaultproperties
{
     FlashPitch=1024
     FlashOffset=42.000000
	 bAttachSmokeEmitter=False
	 bAttachFlashEmitter=False
	 bHasSecondFireMode=True
	 // Default effects for the FireMode 0
	 // These dynamic arrays must be declared using 
	 // the single line syntax: StructProperty=( DynamicArray=(Value, Value) )
	 FireModeEffects[0]=(MuzzleBones=("b_gun_barrel"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("b_gun_ammo"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     FireModeEffects[1]=(MuzzleBones=("b_gun_barrel"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("b_gun_ammo"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
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
     bHeavy=True
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
     //Mesh=SkeletalMesh'Stinger_A.SK_WP_Stinger_3P_Mid'
	 MeshRef="Stinger_A.SK_WP_Stinger_3P_Mid"
}
