//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_SVDLLI extends UM_BaseSniperRifle;

#exec OBJ LOAD FILE="SVDLLI_A.ukx"

var()	name				ReloadShortAnim;
var()	float				ReloadShortRate;
var		color				ChargeColor;
var		float				Range;
var		float				LastRangingTime;

var()	Material			ZoomMat;
var()	Sound				ZoomSound;
var		bool				bArrowRemoved;

var()	int					lenseMaterialID;		// used since material id's seem to change alot

var()	float				scopePortalFOVHigh;		// The FOV to zoom the scope portal by.
var()	float				scopePortalFOV;			// The FOV to zoom the scope portal by.
var()	vector				XoffsetScoped;
var()	vector				XoffsetHighDetail;

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
var()	int					scopePitch;			// Tweaks the pitch of the scope firing angle
var()	int					scopeYaw;			// Tweaks the yaw of the scope firing angle
var()	int					scopePitchHigh;		// Tweaks the pitch of the scope firing angle high detail scope
var()	int					scopeYawHigh;		// Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var		ScriptedTexture		ScopeScriptedTexture;		// Scripted texture for 3d scopes
var		Shader				ScopeScriptedShader;		// The shader that combines the scripted texture with the sight overlay
var		Material			ScriptedTextureFallback;	// The texture to render if the users system doesn't support shaders

// new scope vars
var		Combiner			ScriptedScopeCombiner;
var		Combiner			ScriptedScopeStatic;
var		texture				TexturedScopeTexture;
var		bool				bInitializedScope;		// Set to true when the scope has been initialized

//[block] Dynamic Loading Vars
var		string	ZoomMatRef;
var		string	ScriptedTextureFallbackRef;
//[end]
var		float	OriginalMouseSensitivity;
var		float	ZoomRatio;

replication
{
	reliable if(Role < ROLE_Authority)
		ServerChangeScopePortalFOV;
}

//[block] Dynamic Loading
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	super.PreloadAssets(Inv, bSkipRefCount);

	if ( default.ZoomMatRef != "" && default.ZoomMat == None )
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
	
	if ( default.ScriptedTextureFallbackRef != "" && default.ScriptedTextureFallback == None )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));
	
	if ( OperationY_SVDLLI(Inv) != None )
	{
		if ( default.ZoomMat != None && OperationY_SVDLLI(Inv).ZoomMat == None )
			OperationY_SVDLLI(Inv).ZoomMat = default.ZoomMat;
		
		if ( default.ScriptedTextureFallback != None && OperationY_SVDLLI(Inv).ScriptedTextureFallback == None )
			OperationY_SVDLLI(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
	}
}

static function bool UnloadAssets()
{
	if ( default.ZoomMat != None )
		default.ZoomMat = None;
	
	if ( default.ScriptedTextureFallback != None )
		default.ScriptedTextureFallback = None;

	Return Super.UnloadAssets();
}
//[end]

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

exec function pfov(int thisFOV)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePortalFOV = thisFOV;
}

exec function pPitch(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePitch = num;
	scopePitchHigh = num;
}

exec function pYaw(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopeYaw = num;
	scopeYawHigh = num;
}

simulated exec function TexSize(int i, int j)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	ScopeScriptedTexture.SetSize(i, j);
}

simulated function bool ShouldDrawPortal()
{
	if( bAimingRifle )
		return true;
	else
		return false;
}

simulated event PostBeginPlay()
{
	//[block] Saving original mouse sensitivity and writing zoom level to ItemName
	local PlayerController Player;
	
	Player = Level.GetLocalPlayerController();
	if ( Player != None )
		OriginalMouseSensitivity = Player.GetMouseSensitivity();
	
	ItemName = default.ItemName $ " [1.6x Zoom]";
	//[end]
	Super.PostBeginPlay();

    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

	UpdateScopeMode();
}

simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
	{
		if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			//bPlayerFOVZooms = false;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetScoped;
			}

			if( ScopeScriptedTexture == none )
			{
				ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}

			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
			ScopeScriptedTexture.SetSize(512,512);
			ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
				ScriptedScopeCombiner.Material1 = Texture'SVDLLI_A.SVDLLI_T.PSO1Scope';
				ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
				ScriptedScopeCombiner.CombineOperation = CO_Multiply;
				ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
				ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
			}

			if( ScriptedScopeStatic == none )
			{
				// Construct the Combiner
				ScriptedScopeStatic = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeStatic.Material1 = Texture'SVDLLI_A.SVDLLI_T.PSO1Scope2';
	            ScriptedScopeStatic.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeStatic.CombineOperation = CO_Add;
	            ScriptedScopeStatic.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeStatic.Material2 = ScriptedScopeCombiner;
	        }

			
			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeStatic;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

			bInitializedScope = true;
		}
		else if( KFScopeDetail == KF_ModelScopeHigh )
		{
			scopePortalFOV = scopePortalFOVHigh;
			ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
			}

			if( ScopeScriptedTexture == none )
			{
				ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}
			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
			ScopeScriptedTexture.SetSize(1024,1024);
			ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
				ScriptedScopeCombiner.Material1 = Texture'SVDLLI_A.SVDLLI_T.PSO1Scope';
				ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
				ScriptedScopeCombiner.CombineOperation = CO_Multiply;
				ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
				ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
			}

			if( ScriptedScopeStatic == none )
			{
				// Construct the Combiner
				ScriptedScopeStatic = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeStatic.Material1 = Texture'SVDLLI_A.SVDLLI_T.PSO1Scope2';
	            ScriptedScopeStatic.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeStatic.CombineOperation = CO_Add;
	            ScriptedScopeStatic.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeStatic.Material2 = ScriptedScopeCombiner;
	        }

						
			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeStatic;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

			bInitializedScope = true;
		}
		else if (KFScopeDetail == KF_TextureScope)
		{
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			PlayerViewOffset.X = default.PlayerViewOffset.X;

			bInitializedScope = true;
		}
	}
}

simulated event RenderTexture(ScriptedTexture Tex)
{
	local rotator RollMod;

	RollMod = Instigator.GetViewRotation();

	if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
		Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
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

//[block] Rewrited ZoomIn and ZoomOut
/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
	local PlayerController Player;
	
    super(BaseKFWeapon).ZoomIn(bAnimateTransition);

	bAimingRifle = True;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(True);

	if ( Level.NetMode != NM_DedicatedServer && 
		 KFPlayerController(Instigator.Controller) != none && AimInSound != none )
		PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);

	
	//[block] Decreasing Mouse Sensitivity if needed
	Player = Level.GetLocalPlayerController();
	if ( Player != None )
	{
		if ( scopePortalFOVHigh > 0 && scopePortalFOVHigh != default.scopePortalFOVHigh )
			Player.SetSensitivity(OriginalMouseSensitivity * scopePortalFOVHigh / default.scopePortalFOVHigh);
		else if ( scopePortalFOV != default.scopePortalFOV )
			Player.SetSensitivity(OriginalMouseSensitivity * scopePortalFOV / default.scopePortalFOV);
	}
	//[end]
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
	local PlayerController Player;
	
    Super(KFWeapon).ZoomOut(bAnimateTransition);

	bAimingRifle = False;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(False);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimOutSound != none )
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
		
		KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
	
	//[block] Restoring Mouse Sensitivity if needed
	Player = Level.GetLocalPlayerController();
	if ( Player != None && Player.GetMouseSensitivity() != OriginalMouseSensitivity )
		Player.SetSensitivity(OriginalMouseSensitivity);
	//[end]
}
//[end]

/*
simulated function WeaponTick(float dt)
{
	super.WeaponTick(dt);

	if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
	{
		ForceZoomOutTime = 0;

		ZoomOut(false);

		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
} */

/**
 * Called by the native code when the interpolation of the first person weapon to the zoomed position finishes
 */
simulated event OnZoomInFinished()
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);

	if (ClientState == WS_ReadyToFire)
	{
		if (anim == IdleAnim)
		{
		PlayIdle();
		}
	}

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
		KFScopeDetail == KF_TextureScope )
	{
		KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
	}
}

simulated function bool CanZoomNow()
{
	Return (!FireMode[0].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

simulated event RenderOverlays(Canvas Canvas)
{
	local int m;
	local PlayerController PC;

	if (Instigator == None)
		return;

	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		return;

	if(!bInitializedScope && PC != none )
	{
		UpdateScopeMode();
	}

	Canvas.DrawActor(None, false, true);

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].DrawMuzzleFlash(Canvas);
		}
	}


	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
	SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	PreDrawFPWeapon();

	if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
	{
		if (ShouldDrawPortal())
		{
			if ( ScopeScriptedTexture != none )
			{
				Skins[LenseMaterialID] = ScopeScriptedShader;
				ScopeScriptedTexture.Client = Self;
				ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
			}
		}

		bDrawingFirstPerson = true;
		Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
		bDrawingFirstPerson = false;
	}
	else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;

		SetZoomBlendColor(Canvas);

		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(0, 0);
		Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
		Canvas.SetPos(Canvas.SizeX, 0);
		Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

		Canvas.Style = 255;
		Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

		Canvas.Font = Canvas.MedFont;
		Canvas.SetDrawColor(200,150,0);

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
		Canvas.DrawText(" ");

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
	}
	else
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;
		bDrawingFirstPerson = true;
		Canvas.DrawActor(self, false, false, DisplayFOV);
		bDrawingFirstPerson = false;
	}
}

simulated function AdjustIngameScope()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);

	if( !bHasScope )
		return;

	switch (KFScopeDetail)
	{
		case KF_ModelScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
			}
			break;

		case KF_TextureScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
				}
			}
			break;

		case KF_ModelScopeHigh:
			if( bAimingRifle )
			{
				if( ZoomedDisplayFOVHigh > 0 )
					DisplayFOV = default.ZoomedDisplayFOVHigh;
				else
					DisplayFOV = default.ZoomedDisplayFOV;
			}
			if ( bAimingRifle && PC.DesiredFOV == PlayerIronSightFOV )
			{
				if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
				{
					KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
				}
			}
			break;
	}

	UpdateScopeMode();
}

simulated event Destroyed()
{
	if (ScopeScriptedTexture != None)
	{
		ScopeScriptedTexture.Client = None;
		Level.ObjectPool.FreeObject(ScopeScriptedTexture);
		ScopeScriptedTexture=None;
	}

	if (ScriptedScopeCombiner != None)
	{
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
	}

	if (ScopeScriptedShader != None)
	{
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
	}

	Super.Destroyed();
}

simulated function PreTravelCleanUp()
{
	if (ScopeScriptedTexture != None)
	{
		ScopeScriptedTexture.Client = None;
		Level.ObjectPool.FreeObject(ScopeScriptedTexture);
		ScopeScriptedTexture=None;
	}

	if (ScriptedScopeCombiner != None)
	{
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
	}

	if (ScopeScriptedShader != None)
	{
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
	}
}

simulated function Notify_ShowBullets()
{
	local int AvailableAmmo;
	
	AvailableAmmo = AmmoAmount(0);

	if (AvailableAmmo == 0)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'Bullet');
	}
	else if (AvailableAmmo == 1)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'Bullet');
	}
	else
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 1.0, 'Bullet');
	}
}

simulated function Notify_HideBullets()
{
	if (MagAmmoRemaining <= 0)
	{
		SetBoneScale (1, 0.0, 'bullet1');
	}
	else if (MagAmmoRemaining <= 1)
	{
		SetBoneScale (0, 0.0, 'bullet');
	}
}

//[block] Zoom level switching
// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	DoToggle();
}

// Toggle auto/burst/semi fire
simulated function DoToggle()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player != None )
	{
		if ( ModeSwitchSound != None )
			PlayOwnedSound(ModeSwitchSound,SLOT_None,ModeSwitchSoundVolume,,,,false);
		
		if ( scopePortalFOVHigh == default.scopePortalFOVHigh || 
			scopePortalFOV == default.scopePortalFOV )
		{
			scopePortalFOVHigh = default.scopePortalFOVHigh / ZoomRatio;
			scopePortalFOV = default.scopePortalFOV / ZoomRatio;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',2);
			ItemName = default.ItemName $ " [2.5x Zoom]";
		}
		else if ( scopePortalFOVHigh == (default.scopePortalFOVHigh / ZoomRatio) ||
				scopePortalFOV == (default.scopePortalFOV / ZoomRatio) )
		{
			scopePortalFOVHigh = default.scopePortalFOVHigh / (ZoomRatio * ZoomRatio);
			scopePortalFOV = default.scopePortalFOV / (ZoomRatio * ZoomRatio);
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',4);
			ItemName = default.ItemName $ " [4.0x Zoom]";
		}
		else
		{
			scopePortalFOVHigh = default.scopePortalFOVHigh;
			scopePortalFOV = default.scopePortalFOV;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',0);
			ItemName = default.ItemName $ " [1.6x Zoom]";
		}
	}
	ServerChangeScopePortalFOV(scopePortalFOVHigh, scopePortalFOV);
	if ( Player != None && bAimingRifle )
	{
		if ( scopePortalFOVHigh > 0 )
			Player.SetSensitivity(OriginalMouseSensitivity * scopePortalFOVHigh / default.scopePortalFOVHigh);
		else
			Player.SetSensitivity(OriginalMouseSensitivity * scopePortalFOV / default.scopePortalFOV);
	}

	UpdateScopeMode();
}

// Set the new Zoom level on the server
function ServerChangeScopePortalFOV(float New_scopePortalFOVHigh, float New_scopePortalFOV)
{
	scopePortalFOVHigh = New_scopePortalFOVHigh;
	scopePortalFOV = New_scopePortalFOV;
}

exec function SwitchModes()
{
	DoToggle();
}
//[end]

defaultproperties
{
	 ZoomRatio=1.600000
	 //[block] Dynamic Loading Vars
	 //ZoomMat=FinalBlend'SVDLLI_A.SVDLLI_T.PSO1ScopeFinalBlend'
	 ZoomMatRef="SVDLLI_A.SVDLLI_T.PSO1ScopeFinalBlend"
	 //ScriptedTextureFallback=Texture'SVDLLI_A.SVDLLI_T.AlphaLens'
	 ScriptedTextureFallbackRef="SVDLLI_A.SVDLLI_T.AlphaLens"
	 //Mesh=SkeletalMesh'SVDLLI_A.SVDLLI_mesh'
	 MeshRef="SVDLLI_A.SVDLLI_mesh"
     //Skins(0)=Combiner'SVDLLI_A.SVDLLI_T.SVDLLI_tex_1_cmb'
	 SkinRefs(0)="SVDLLI_A.SVDLLI_T.SVDLLI_tex_1_cmb"
     // Убрал текстуры рук Skins(1) -- TGN
	 //Skins(1)=Texture'KF_Weapons5_Trip_T.First_Sleeves.Steampunk_DJ_Scully_First_Person_Sleeves'
     //Skins(2)=Combiner'SVDLLI_A.SVDLLI_T.SVDLLI_tex_2_cmb'
	 SkinRefs(2)="SVDLLI_A.SVDLLI_T.SVDLLI_tex_2_cmb"
     //Skins(3)=Combiner'SVDLLI_A.SVDLLI_T.SVDLLI_tex_3_cmb'
	 SkinRefs(3)="SVDLLI_A.SVDLLI_T.SVDLLI_tex_3_cmb"
     //Skins(4)=Texture'SVDLLI_A.SVDLLI_T.AlphaLens'
	 SkinRefs(4)="SVDLLI_A.SVDLLI_T.AlphaLens"
     //Skins(5)=Combiner'SVDLLI_A.SVDLLI_T.SVDLLI_tex_4_cmb'
	 SkinRefs(5)="SVDLLI_A.SVDLLI_T.SVDLLI_tex_4_cmb"
	 //SelectSound=Sound'SVDLLI_A.SVDLLI_Snd.SVDLLI_select'
	 SelectSoundRef="SVDLLI_A.SVDLLI_Snd.SVDLLI_select"
	 //HudImage=Texture'SVDLLI_A.SVDLLI_T.SVDLLI_Unselected'
	 HudImageRef="SVDLLI_A.SVDLLI_T.SVDLLI_Unselected"
     //SelectedHudImage=Texture'SVDLLI_A.SVDLLI_T.SVDLLI_selected'
	 SelectedHudImageRef="SVDLLI_A.SVDLLI_T.SVDLLI_selected"
	 //[end]
	 TacticalReloadAnim="Reload_Short"
     TacticalReloadRate=4.000000
     lenseMaterialID=4
     scopePortalFOVHigh=20.000000
     scopePortalFOV=20.000000
	 //scopePortalFOVHigh=15.000000
     //scopePortalFOV=15.000000
     bHasScope=True
     ZoomedDisplayFOVHigh=28.000000
     MagCapacity=10
     ReloadRate=5.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'SVDLLI_A.SVDLLI_T.SVDLLI_Trader'
     PlayerIronSightFOV=32.000000
	 //PlayerIronSightFOV=24.000000
     ZoomedDisplayFOV=28.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_SVDLLIFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     BringUpTime=0.930000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="The Dragunov sniper rifle is a semi-automatic sniper rifle chambered in 7.62x54mmR and developed in the Soviet Union."
     DisplayFOV=65.000000
     Priority=190
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.OperationY_SVDLLIPickup'
     //PlayerViewOffset=(X=6.000000,Y=22.000000,Z=-12.000000)
	 PlayerViewOffset=(X=6.000000,Y=22.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_SVDLLIAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="SVD"
}
