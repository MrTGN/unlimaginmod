//=============================================================================
// UnlimaginMod - Maria_Cz75Laser
// Copyright (C) 2012
// - Maria
//=============================================================================
class Maria_Cz75Laser extends UM_BaseHandgun
	config(user);

#exec OBJ LOAD FILE=Cz75Laser_A.ukx
#exec OBJ LOAD FILE=Cz75Laser_SM.usx
#exec OBJ LOAD FILE=Cz75Laser_T.utx

var         LaserDot                    Spot;                       // The first person laser site dot
var			Class<LaserDot>				SpotEffectClass;
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location

var         bool                        bLaserActive;               // The laser site is active

var         LaserBeamEffect             Beam;                       // Third person laser beam effect
var			Class<LaserBeamEffect>		BeamEffectClass;

var()		class<InventoryAttachment>	LaserAttachmentClass;      // First person laser attachment class
var 		Actor 						LaserAttachment;           // First person laser attachment

replication
{
	reliable if(Role < ROLE_Authority)
		ServerSetLaserActive;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Role == ROLE_Authority && Beam == None )
		Beam = Spawn(BeamEffectClass);
}

simulated function Destroyed()
{
	if (Spot != None)
		Spot.Destroy();

	if (Beam != None)
		Beam.Destroy();

	if (LaserAttachment != None)
		LaserAttachment.Destroy();

	super.Destroyed();
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

simulated function DoToggle()
{
	if( Instigator.IsLocallyControlled() )
	{
		if ( ModeSwitchSound != None )
			PlayOwnedSound(ModeSwitchSound,SLOT_None,ModeSwitchSoundVolume,,,,false);
		
		if ( Role < ROLE_Authority )
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
}

simulated function TurnOffLaser(optional bool bPutDown)
{
	if ( Maria_Cz75LaserFire(FireMode[0]) != None )
		Maria_Cz75LaserFire(FireMode[0]).default.AimError = Maria_Cz75LaserFire(FireMode[0]).default.AimErrorWithOutLaser;
	
	if( Instigator.IsLocallyControlled() )
	{
		if( Role < ROLE_Authority )
			ServerSetLaserActive(False);

		if ( !bPutDown )
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
	if ( Maria_Cz75LaserFire(FireMode[0]) != None )
		Maria_Cz75LaserFire(FireMode[0]).default.AimError = Maria_Cz75LaserFire(FireMode[0]).default.AimErrorWithLaser;
	
	if ( Instigator.IsLocallyControlled() )
	{
		if ( Role < ROLE_Authority )
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
		return;

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

		if (Other != None && Other != Instigator && Other.Base != Instigator )
		{
			EndBeamEffect = HitLocation;
		}
		else
		{
			EndBeamEffect = EndTrace;
		}

		Spot.SetLocation(EndBeamEffect - X*SpotProjectorPullback);

		if(  Pawn(Other) != none )
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

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'Cz75Laser_A.Cz75Laser'
	 MeshRef="Cz75Laser_A.Cz75Laser"
     //Skins(0)=Combiner'Cz75Laser_T.cz75_b_cmb'
	 SkinRefs(0)="Cz75Laser_T.cz75_b_cmb"
     //Skins(2)=Texture'Cz75Laser_T.cz75_mag'
	 SkinRefs(2)="Cz75Laser_T.cz75_mag"
     //Skins(3)=Texture'Cz75Laser_T.cz75_laser'
	 SkinRefs(3)="Cz75Laser_T.cz75_laser"
	 //SelectSound=Sound'KF_9MMSnd.9mm_Select'
	 SelectSoundRef="KF_9MMSnd.9mm_Select"
	 //HudImage=Texture'Cz75Laser_T.ui.Cz75Laser_Unselected'
	 HudImageRef="Cz75Laser_T.ui.Cz75Laser_Unselected"
     //SelectedHudImage=Texture'Cz75Laser_T.ui.Cz75Laser_Selected'
	 SelectedHudImageRef="Cz75Laser_T.ui.Cz75Laser_Selected"
	 //[end]
	 bLaserActive=False
	 SpotProjectorPullback=1.000000
     LaserAttachmentClass=Class'KFMod.LaserAttachmentFirstPerson'
	 BeamEffectClass=Class'KFMod.LaserBeamEffect'
	 SpotEffectClass=Class'KFMod.LaserDot'
     FirstPersonFlashlightOffset=(X=-20.000000,Y=-22.000000,Z=8.000000)
     MagCapacity=16
     ReloadRate=2.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Single9mm"
     ModeSwitchAnim="LightOn"
     Weight=1.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'Cz75Laser_T.ui.Trader_Cz75Laser'
     ZoomedDisplayFOV=60.000000
     FireModeClass(0)=Class'UnlimaginMod.Maria_Cz75LaserFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.250000
     CurrentRating=0.250000
     bShowChargingBar=True
     Description="Cz75 9x19mm Parabellum with Laser Pointer"
     DisplayFOV=70.000000
     Priority=65
     InventoryGroup=2
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.Maria_Cz75LaserPickup'
     PlayerViewOffset=(X=20.000000,Y=25.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Maria_Cz75LaserAttachment'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="Cz75 Laser"
}
