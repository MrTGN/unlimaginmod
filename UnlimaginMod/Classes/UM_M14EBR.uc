//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M14EBR
//	Parent class:	 UM_BaseBattleRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.06.2013 00:52
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M14EBR extends UM_BaseBattleRifle
	config(user);


//========================================================================
//[block] Variables

var         LaserDot                    Spot;                       // The first person laser site dot
var			Class<LaserDot>				SpotEffectClass;
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location

var         bool                        bLaserActive;               // The laser site is active

var         LaserBeamEffect             Beam;                       // Third person laser beam effect
var			Class<LaserBeamEffect>		BeamEffectClass;

var()		class<InventoryAttachment>	LaserAttachmentClass;      // First person laser attachment class
var 		Actor 						LaserAttachment;           // First person laser attachment

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if(Role < ROLE_Authority)
		ServerSetLaserActive, UM_ServerChangeFireMode;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	ItemName = default.ItemName $ " [Auto]";
	if ( Role == ROLE_Authority && Beam == None )
		Beam = Spawn(BeamEffectClass);
}

simulated function Destroyed()
{
	if ( Spot != None )
		Spot.Destroy();

	if ( Beam != None )
		Beam.Destroy();

	if ( LaserAttachment != None )
		LaserAttachment.Destroy();

	Super.Destroyed();
}

simulated function WeaponTick(float dt)
{
	local Vector StartTrace, EndTrace, X,Y,Z;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local vector MyEndBeamEffect;
	local coords C;

	Super.WeaponTick(dt);

	if( Role == ROLE_Authority && Beam != None )
	{
		if( bIsReloading && WeaponAttachment(ThirdPersonActor) != None )
		{
			C = WeaponAttachment(ThirdPersonActor).GetBoneCoords('tip');
			X = C.XAxis;
			Y = C.YAxis;
			Z = C.ZAxis;
		}
		else
		{
			GetViewAxes(X,Y,Z);
		}

		// the to-hit trace always starts right in front of the eye
		StartTrace = Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;

		EndTrace = StartTrace + 65535 * X;

		Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		if ( Other != None && Other != Instigator && Other.Base != Instigator )
			MyEndBeamEffect = HitLocation;
		else
			MyEndBeamEffect = EndTrace;

		Beam.EndBeamEffect = MyEndBeamEffect;
		Beam.EffectHitNormal = HitNormal;
	}
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	Super.BringUp(PrevWeapon);

	if ( Role == ROLE_Authority && Beam == None )
		Beam = Spawn(BeamEffectClass);
	
	if ( bLaserActive )
		TurnOnLaser();
}

simulated function DetachFromPawn(Pawn P)
{
	TurnOffLaser();

	Super.DetachFromPawn(P);

	if ( Beam != None )
		Beam.Destroy();
}

simulated function bool PutDown()
{
	TurnOffLaser(True);
	
	if ( Beam != None )
		Beam.Destroy();

	Return Super.PutDown();
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle()
{
	local	PlayerController	Player;

	Player = Level.GetLocalPlayerController();
	if ( Player != None )
	{
		PlayOwnedSoundData(ModeSwitchSound);
		
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		if ( FireMode[0].bWaitForRelease )
		{
			bLaserActive = True;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',1);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		else
		{
			bLaserActive = False;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		
		if ( Beam != None )
			Beam.SetActive(bLaserActive);

		if ( bLaserActive )
		{
			if ( LaserAttachment == None )
			{
				LaserAttachment = Spawn(LaserAttachmentClass,,,,);
				if ( LaserAttachment != None )
					AttachToBone(LaserAttachment,'LightBone');
			}
			LaserAttachment.bHidden = False;
			if ( Spot == None )
				Spot = Spawn(SpotEffectClass, self);
		}
		else
		{
			LaserAttachment.bHidden = True;
			if ( Spot != None )
				Spot.Destroy();
		}
		
		if ( Role < ROLE_Authority )
		{
			UM_ServerChangeFireMode(FireMode[0].bWaitForRelease);
			ServerSetLaserActive(bLaserActive);
		}
	}
}

/*
// Toggle the laser on and off
simulated function ToggleLaser()
{
	if ( Instigator.IsLocallyControlled() )
	{
		if ( Role < ROLE_Authority  )
			ServerSetLaserActive(!bLaserActive);

		bLaserActive = !bLaserActive;

		if ( Beam != None )
			Beam.SetActive(bLaserActive);

		if ( bLaserActive )
		{
			if ( LaserAttachment == None )
			{
				LaserAttachment = Spawn(LaserAttachmentClass,,,,);
				if ( LaserAttachment != None )
					AttachToBone(LaserAttachment,'LightBone');
			}
			
			LaserAttachment.bHidden = False;

			if ( Spot == None )
				Spot = Spawn(SpotEffectClass, self);
		}
		else
		{
			LaserAttachment.bHidden = True;
			if ( Spot != None )
				Spot.Destroy();
		}
	}
} */

simulated function TurnOffLaser(optional bool bPutDown)
{
	if ( Instigator.IsLocallyControlled() )
	{
		if ( Role < ROLE_Authority  )
			ServerSetLaserActive(false);

		if (!bPutDown)
			bLaserActive = False;
		
		LaserAttachment.bHidden = True;

		if ( Beam != None )
			Beam.SetActive(False);

		if ( Spot != None )
			Spot.Destroy();
	}
}

simulated function TurnOnLaser()
{
	if ( Instigator.IsLocallyControlled() )
	{
		if ( Role < ROLE_Authority  )
			ServerSetLaserActive(True);

		bLaserActive = True;

		if ( Beam != None )
			Beam.SetActive(True);

		if ( LaserAttachment == None )
		{
			LaserAttachment = Spawn(LaserAttachmentClass,,,,);
			AttachToBone(LaserAttachment,'LightBone');
		}
		
		LaserAttachment.bHidden = False;

		if ( Spot == None )
			Spot = Spawn(SpotEffectClass, self);
	}
}

// Set the new fire mode on the server
function ServerSetLaserActive(bool bNewLaserActive)
{
	if ( Beam != None )
		Beam.SetActive(bNewLaserActive);

	if ( bNewLaserActive )
	{
		bLaserActive = True;
		if ( Spot == None )
			Spot = Spawn(SpotEffectClass, self);
	}
	else
	{
		bLaserActive = False;
		if ( Spot != None )
			Spot.Destroy();
	}
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
}

exec function SwitchModes()
{
	DoToggle();
}

simulated event RenderOverlays( Canvas Canvas )
{
	local int m;
	local Vector StartTrace, EndTrace;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local vector X,Y,Z;
	local coords C;

	if (Instigator == None)
		return;

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;

	if ((Hand < -1.0) || (Hand > 1.0))
		Return;

	// draw muzzleflashes/smoke for all fire modes so idle state won't
	// cause emitters to just disappear
	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].DrawMuzzleFlash(Canvas);
		}
	}

	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
	SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	// Handle drawing the laser beam dot
	if (Spot != None)
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();
		GetViewAxes(X, Y, Z);

		if( bIsReloading && Instigator.IsLocallyControlled() )
		{
			C = GetBoneCoords('LightBone');
			X = C.XAxis;
			Y = C.YAxis;
			Z = C.ZAxis;
		}

		EndTrace = StartTrace + 65535 * X;

		Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		if ( Other != None && Other != Instigator && Other.Base != Instigator )
			EndBeamEffect = HitLocation;
		else
			EndBeamEffect = EndTrace;

		Spot.SetLocation(EndBeamEffect - X*SpotProjectorPullback);

		if (  Pawn(Other) != None )
		{
			Spot.SetRotation(Rotator(X));
			Spot.SetDrawScale(Spot.default.DrawScale * 0.5);
		}
		else if( HitNormal == vect(0,0,0) )
		{
			Spot.SetRotation(Rotator(-X));
			Spot.SetDrawScale(Spot.default.DrawScale);
		}
		else
		{
			Spot.SetRotation(Rotator(-HitNormal));
			Spot.SetDrawScale(Spot.default.DrawScale);
		}
	}

	//PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)

	bDrawingFirstPerson = true;
	Canvas.DrawActor(self, false, false, DisplayFOV);
	bDrawingFirstPerson = false;
}

function bool RecommendRangedAttack()
{
	return true;
}


function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

//[end] Functions
//====================================================================


defaultproperties
{
     bLaserActive=False
	 SpotProjectorPullback=1.000000
     LaserAttachmentClass=Class'KFMod.LaserAttachmentFirstPerson'
	 BeamEffectClass=Class'KFMod.LaserBeamEffect'
	 SpotEffectClass=Class'KFMod.LaserDot'
     MagCapacity=20
     ReloadRate=3.366000
	 TacticalReloadTime=2.400000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M14"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_M14'
     bIsTier3Weapon=True
     MeshRef="KF_Weapons2_Trip.M14_EBR_Trip"
     SkinRefs(0)="KF_Weapons2_Trip_T.Rifle.M14_cmb"
     SelectSoundRef="KF_M14EBRSnd.M14EBR_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.M14_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.M14"
     PlayerIronSightFOV=60.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_M14EBRFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An M14 Enhanced Battle Rifle - Semi Auto variant. Equipped with a laser sight."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=165
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=5
     PickupClass=Class'UnlimaginMod.UM_M14EBRPickup'
     PlayerViewOffset=(X=25.000000,Y=17.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_M14EBRAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="M14 EBR"
     TransientSoundVolume=1.250000
}