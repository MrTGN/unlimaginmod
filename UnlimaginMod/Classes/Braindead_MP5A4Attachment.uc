//=============================================================================
// MP5MAttachment
//=============================================================================
// MP5 medic gun third person attachment class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5A4Attachment extends UM_BaseSMGAttachment;

var		Actor		TacShine;
var		Effects		TacShineCorona;
var		bool		bBeamEnabled;

// Prevents tracers from spawning if player is using the flashlight function of the 9mm
simulated event ThirdPersonEffects()
{
	if( FiringMode==1 )
		Return;
	Super.ThirdPersonEffects();
}

simulated event Destroyed()
{
	if ( TacShineCorona != None )
		TacShineCorona.Destroy();
	if ( TacShine != None )
		TacShine.Destroy();
	Super.Destroyed();
}

simulated function UpdateTacBeam( float Dist )
{
	local vector Sc;

	if( !bBeamEnabled )
	{
		if (TacShine == None )
		{
			TacShine = Spawn(Class'Single'.Default.TacShineClass,Owner,,,);
			AttachToBone(TacShine,'FlashLight');
			TacShine.RemoteRole = ROLE_None;
		}
		else TacShine.bHidden = False;
		if (TacShineCorona == None )
		{
			TacShineCorona = Spawn(class 'KFTacLightCorona',Owner,,,);
			AttachToBone(TacShineCorona,'FlashLight');
			TacShineCorona.RemoteRole = ROLE_None;
		}
		TacShineCorona.bHidden = False;
		bBeamEnabled = True;
	}
	Sc = TacShine.DrawScale3D;
	Sc.Y = FClamp(Dist/90.f,0.02,1.f);
	if( TacShine.DrawScale3D!=Sc )
		TacShine.SetDrawScale3D(Sc);
}

simulated function TacBeamGone()
{
	if( bBeamEnabled )
	{
		if (TacShine!=None )
			TacShine.bHidden = True;
		if (TacShineCorona!=None )
			TacShineCorona.bHidden = True;
		bBeamEnabled = False;
	}
}

defaultproperties
{
	 // Default effects for the FireMode 0
	 // These dynamic arrays must be declared using 
	 // the single line syntax: StructProperty=( DynamicArray=(Value, Value) )
	 FireModeEffects[0]=(MuzzleBones=("tip"),FlashClasses=(Class'ROEffects.MuzzleFlash3rdMP'),SmokeClasses=(Class'UnlimaginMod.UM_BaseMuzzleSmoke3rd'),ShellEjectBones=("Shell_eject"),ShellEjectClasses=(Class'KFMod.KFShellSpewer'))
     MovementAnims(0)="JogF_MP5"
     MovementAnims(1)="JogB_MP5"
     MovementAnims(2)="JogL_MP5"
     MovementAnims(3)="JogR_MP5"
     TurnLeftAnim="TurnL_MP5"
     TurnRightAnim="TurnR_MP5"
     CrouchAnims(0)="CHWalkF_MP5"
     CrouchAnims(1)="CHWalkB_MP5"
     CrouchAnims(2)="CHWalkL_MP5"
     CrouchAnims(3)="CHWalkR_MP5"
     WalkAnims(0)="WalkF_MP5"
     WalkAnims(1)="WalkB_MP5"
     WalkAnims(2)="WalkL_MP5"
     WalkAnims(3)="WalkR_MP5"
     CrouchTurnRightAnim="CH_TurnR_MP5"
     CrouchTurnLeftAnim="CH_TurnL_MP5"
     IdleCrouchAnim="CHIdle_MP5"
     IdleWeaponAnim="Idle_MP5"
     IdleRestAnim="Idle_MP5"
     IdleChatAnim="Idle_MP5"
     IdleHeavyAnim="Idle_MP5"
     IdleRifleAnim="Idle_MP5"
     FireAnims(0)="Fire_MP5"
     FireAnims(1)="Fire_MP5"
     FireAnims(2)="Fire_MP5"
     FireAnims(3)="Fire_MP5"
     FireAltAnims(0)="Fire_MP5"
     FireAltAnims(1)="Fire_MP5"
     FireAltAnims(2)="Fire_MP5"
     FireAltAnims(3)="Fire_MP5"
     FireCrouchAnims(0)="CHFire_MP5"
     FireCrouchAnims(1)="CHFire_MP5"
     FireCrouchAnims(2)="CHFire_MP5"
     FireCrouchAnims(3)="CHFire_MP5"
     FireCrouchAltAnims(0)="CHFire_MP5"
     FireCrouchAltAnims(1)="CHFire_MP5"
     FireCrouchAltAnims(2)="CHFire_MP5"
     FireCrouchAltAnims(3)="CHFire_MP5"
     HitAnims(0)="HitF_MP5"
     HitAnims(1)="HitB_MP5"
     HitAnims(2)="HitL_MP5"
     HitAnims(3)="HitR_MP5"
     PostFireBlendStandAnim="Blend_MP5"
     PostFireBlendCrouchAnim="CHBlend_MP5"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     LightType=LT_Pulse
     LightRadius=0.000000
     CullDistance=5000.000000
     //Mesh=SkeletalMesh'BD_FL_MP5_A.MP5_FL_3rd'
	 MeshRef="BD_FL_MP5_A.MP5_FL_3rd"
}
