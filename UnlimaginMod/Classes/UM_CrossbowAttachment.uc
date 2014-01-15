//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_CrossbowAttachment
//	Parent class:	 UM_BaseSingleShotSniperRifleAttachment
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 01.11.2013 11:50
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_CrossbowAttachment extends UM_BaseSingleShotSniperRifleAttachment;


defaultproperties
{
     bDoFiringEffects=False
	 MovementAnims(0)="JogF_Crossbow"
     MovementAnims(1)="JogB_Crossbow"
     MovementAnims(2)="JogL_Crossbow"
     MovementAnims(3)="JogR_Crossbow"
     TurnLeftAnim="TurnL_Crossbow"
     TurnRightAnim="TurnR_Crossbow"
     CrouchAnims(0)="CHwalkF_Crossbow"
     CrouchAnims(1)="CHwalkB_Crossbow"
     CrouchAnims(2)="CHwalkL_Crossbow"
     CrouchAnims(3)="CHwalkR_Crossbow"
     WalkAnims(0)="WalkF_Crossbow"
     WalkAnims(1)="WalkB_Crossbow"
     WalkAnims(2)="WalkL_Crossbow"
     WalkAnims(3)="WalkR_Crossbow"
     CrouchTurnRightAnim="CH_TurnR_Crossbow"
     CrouchTurnLeftAnim="CH_TurnL_Crossbow"
     IdleCrouchAnim="CHIdle_Crossbow"
     IdleWeaponAnim="Idle_Crossbow"
     IdleRestAnim="Idle_Crossbow"
     IdleChatAnim="Idle_Crossbow"
     IdleHeavyAnim="Idle_Crossbow"
     IdleRifleAnim="Idle_Crossbow"
     FireAnims(0)="Fire_Crossbow"
     FireAnims(1)="Fire_Crossbow"
     FireAnims(2)="Fire_Crossbow"
     FireAnims(3)="Fire_Crossbow"
     FireAltAnims(0)="Fire_Crossbow"
     FireAltAnims(1)="Fire_Crossbow"
     FireAltAnims(2)="Fire_Crossbow"
     FireAltAnims(3)="Fire_Crossbow"
     FireCrouchAnims(0)="CHFire_Crossbow"
     FireCrouchAnims(1)="CHFire_Crossbow"
     FireCrouchAnims(2)="CHFire_Crossbow"
     FireCrouchAnims(3)="CHFire_Crossbow"
     FireCrouchAltAnims(0)="CHFire_Crossbow"
     FireCrouchAltAnims(1)="CHFire_Crossbow"
     FireCrouchAltAnims(2)="CHFire_Crossbow"
     FireCrouchAltAnims(3)="CHFire_Crossbow"
     HitAnims(0)="HitF_Crossbow"
     HitAnims(1)="HitB_Crossbow"
     HitAnims(2)="HitL_Crossbow"
     HitAnims(3)="HitR_Crossbow"
     PostFireBlendStandAnim="Blend_Crossbow"
     PostFireBlendCrouchAnim="CHBlend_Crossbow"
     MeshRef="KF_Weapons3rd_Trip.Crossbow_3rd"
}
