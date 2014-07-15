//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_FlameThrowerAttachment
//	Parent class:	 UM_BaseFlameThrowerAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 28.10.2013 08:59
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_FlameThrowerAttachment extends UM_BaseFlameThrowerAttachment;


defaultproperties
{
     bDoFiringEffects=False
     MovementAnims(0)="JogF_Flamethrower"
     MovementAnims(1)="JogB_Flamethrower"
     MovementAnims(2)="JogL_Flamethrower"
     MovementAnims(3)="JogR_Flamethrower"
     TurnLeftAnim="TurnL_Flamethrower"
     TurnRightAnim="TurnR_Flamethrower"
     CrouchAnims(0)="CHwalkF_Flamethrower"
     CrouchAnims(1)="CHwalkB_Flamethrower"
     CrouchAnims(2)="CHwalkL_Flamethrower"
     CrouchAnims(3)="CHwalkR_Flamethrower"
     WalkAnims(0)="WalkF_Flamethrower"
     WalkAnims(1)="WalkB_Flamethrower"
     WalkAnims(2)="WalkL_Flamethrower"
     WalkAnims(3)="WalkR_Flamethrower"
     CrouchTurnRightAnim="CH_TurnR_Flamethrower"
     CrouchTurnLeftAnim="CH_TurnL_Flamethrower"
     IdleCrouchAnim="CHIdle_Flamethrower"
     IdleWeaponAnim="Idle_Flamethrower"
     IdleRestAnim="Idle_Flamethrower"
     IdleChatAnim="Idle_Flamethrower"
     IdleHeavyAnim="Idle_Flamethrower"
     IdleRifleAnim="Idle_Flamethrower"
     FireAnims(0)="Fire_Flamethrower"
     FireAnims(1)="Fire_Flamethrower"
     FireAnims(2)="Fire_Flamethrower"
     FireAnims(3)="Fire_Flamethrower"
     FireAltAnims(0)="Fire_Flamethrower"
     FireAltAnims(1)="Fire_Flamethrower"
     FireAltAnims(2)="Fire_Flamethrower"
     FireAltAnims(3)="Fire_Flamethrower"
     FireCrouchAnims(0)="CHFire_Flamethrower"
     FireCrouchAnims(1)="CHFire_Flamethrower"
     FireCrouchAnims(2)="CHFire_Flamethrower"
     FireCrouchAnims(3)="CHFire_Flamethrower"
     FireCrouchAltAnims(0)="CHFire_Flamethrower"
     FireCrouchAltAnims(1)="CHFire_Flamethrower"
     FireCrouchAltAnims(2)="CHFire_Flamethrower"
     FireCrouchAltAnims(3)="CHFire_Flamethrower"
     HitAnims(0)="HitF_Flamethrower"
     HitAnims(1)="HitB_Flamethrower"
     HitAnims(2)="HitL_Flamethrower"
     HitAnims(3)="HitR_Flamethrower"
     PostFireBlendStandAnim="Blend_Flamethrower"
     PostFireBlendCrouchAnim="CHBlend_Flamethrower"
     MeshRef="KF_Weapons3rd_Trip.Flamethrower_3rd"
     WeaponAmbientScale=2.000000
}
