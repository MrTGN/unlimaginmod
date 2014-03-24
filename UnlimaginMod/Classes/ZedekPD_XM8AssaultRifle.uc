//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// L85 Inventory class
//=============================================================================
class ZedekPD_XM8AssaultRifle extends UM_BaseAssaultRifle
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=XM8_T.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
//#exec OBJ LOAD FILE=..\textures\ScopeShaders.utx
#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax
#exec OBJ LOAD FILE=ScopeShaders.utx

//=============================================================================
// Variables
//=============================================================================

var()		int			lenseMaterialID;		// used since material id's seem to change alot

var()		float		scopePortalFOVHigh;		// The FOV to zoom the scope portal by.
var()		float		scopePortalFOV;			// The FOV to zoom the scope portal by.
var()       vector      XoffsetScoped;
var()       vector      XoffsetHighDetail;

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
var()		int			scopePitch;				// Tweaks the pitch of the scope firing angle
var()		int			scopeYaw;				// Tweaks the yaw of the scope firing angle
var()		int			scopePitchHigh;			// Tweaks the pitch of the scope firing angle high detail scope
var()		int			scopeYawHigh;			// Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var   ScriptedTexture	ScopeScriptedTexture;   // Scripted texture for 3d scopes
var	  Shader			ScopeScriptedShader;   	// The shader that combines the scripted texture with the sight overlay
var   Material			ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var		Combiner		ScriptedScopeCombiner;
var		texture			TexturedScopeTexture;
var		bool			bInitializedScope;		// Set to true when the scope has been initialized
var()	Material		ZoomMat;

//[block] Dynamic Loading Vars
var		string	ZoomMatRef;
var		string	ScriptedTextureFallbackRef;
//[end]

//=============================================================================
// Functions
//=============================================================================

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super.PreloadAssets(Inv, bSkipRefCount);

	if ( default.ZoomMatRef != "" && default.ZoomMat == None )
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
	
	if ( default.ScriptedTextureFallbackRef != "" && default.ScriptedTextureFallback == None )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));

	if ( ZedekPD_XM8AssaultRifle(Inv) != None )
	{
		if ( default.ZoomMat != None && ZedekPD_XM8AssaultRifle(Inv).ZoomMat == None )
			ZedekPD_XM8AssaultRifle(Inv).ZoomMat = default.ZoomMat;
		
		if ( default.ScriptedTextureFallback != None && 
			 ZedekPD_XM8AssaultRifle(Inv).ScriptedTextureFallback == None )
			ZedekPD_XM8AssaultRifle(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
	}
}

static function bool UnloadAssets()
{
	if ( default.ZoomMat != None )
		default.ZoomMat = None;
	
	if ( default.ScriptedTextureFallback != None )
		default.ScriptedTextureFallback = None;

	Return super.UnloadAssets();
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

// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// if you want to limit any times the portal should/shouldn't be drawn, add them here.
// Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
//	local 	name	thisAnim;
//	local	float 	animframe;
//	local	float 	animrate;
//
//	GetAnimParams(0, thisAnim,animframe,animrate);

//	if(bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && thisAnim != 'scope_shoot_last')

    if( bAimingRifle )
		return true;
	else
		return false;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	ItemName = default.ItemName $ " [Auto]";
    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

	UpdateScopeMode();
}

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
    {
	    if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
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
	        ScopeScriptedTexture.SetSize(1024,1024);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'KF_Weapons5_Scopes_Trip_T.Scope.MilDot';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == none )
			{
	            // Construct the scope shader
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

	        bInitializedScope = true;
		}
		else if( KFScopeDetail == KF_ModelScopeHigh )
		{
			scopePortalFOV = scopePortalFOVHigh;
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOVHigh);
			//bPlayerFOVZooms = false;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
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
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'KF_Weapons5_Scopes_Trip_T.Scope.MilDot';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == none )
			{
	            // Construct the scope shader
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

            bInitializedScope = true;
		}
		else if (KFScopeDetail == KF_TextureScope)
		{
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
			PlayerViewOffset.X = default.PlayerViewOffset.X;
			//bPlayerFOVZooms = true;

			bInitializedScope = true;
		}
	}
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;

    RollMod = Instigator.GetViewRotation();
    //RollMod.Roll -= 16384;

//	Rpawn = ROPawn(Instigator);
//	// Subtract roll from view while leaning - Ramm
//	if (Rpawn != none && rpawn.LeanAmount != 0)
//	{
//		RollMod.Roll += rpawn.LeanAmount;
//	}

    if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
        Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
}

function byte BestMode()
{
	return 0;
}

/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super(BaseKFWeapon).ZoomIn(bAnimateTransition);

	bAimingRifle = True;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(True);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimInSound != none )
		{
            PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
        }
	}
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(bAnimateTransition);

	bAimingRifle = False;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(False);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimOutSound != none )
		{
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
        }
        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
}

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
        // Play the iron idle anim when we're finished zooming in
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

simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
	local PlayerController PC;

    if (Instigator == None)
        return;

    // Lets avoid having to do multiple casts every tick - Ramm
	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		return;

    if(!bInitializedScope && PC != none )
	{
    	  UpdateScopeMode();
    }

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(None, false, true); // amb: Clear the z-buffer here

    for (m = 0; m < NUM_FIRE_MODES; m++)
	{
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }


    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)

 	if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
 	{
 		if (ShouldDrawPortal())
 		{
			if ( ScopeScriptedTexture != none )
			{
				Skins[LenseMaterialID] = ScopeScriptedShader;
				ScopeScriptedTexture.Client = Self;   // Need this because this can get corrupted - Ramm
				ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
			}
 		}

		bDrawingFirstPerson = true;
 	    Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
      	bDrawingFirstPerson = false;
	}
    // Added "bInIronViewCheck here. Hopefully it prevents us getting the scope overlay when not zoomed.
    // Its a bit of a band-aid solution, but it will work til we get to the root of the problem - Ramm 08/12/04
	else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;

		SetZoomBlendColor(Canvas);

		//Black-out either side of the main zoom circle.
		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(0, 0);
		Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
		Canvas.SetPos(Canvas.SizeX, 0);
		Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

		//The view through the scope itself.
		Canvas.Style = 255;
		Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

		//Draw some useful text.
		Canvas.Font = Canvas.MedFont;
		Canvas.SetDrawColor(200,150,0);

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
		Canvas.DrawText("Zoom: 3.0");

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

//=============================================================================
// Scopes
//=============================================================================

//------------------------------------------------------------------------------
// SetScopeDetail(RO) - Allow the players to change scope detail while ingame.
//	Changes are saved to the ini file.
//------------------------------------------------------------------------------
/*simulated exec function SetScopeDetail()
{
	if( !bHasScope )
		return;

	if (KFScopeDetail == KF_ModelScope)
		KFScopeDetail = KF_TextureScope;
	else if ( KFScopeDetail == KF_TextureScope)
		KFScopeDetail = KF_ModelScopeHigh;
	else if ( KFScopeDetail == KF_ModelScopeHigh)
		KFScopeDetail = KF_ModelScope;

	AdjustIngameScope();
	class'KFMod.KFWeapon'.default.KFScopeDetail = KFScopeDetail;
	class'KFMod.KFWeapon'.static.StaticSaveConfig();		// saves the new scope detail value to the ini
}*/

// Adjust a single FOV based on the current aspect ratio. Adjust FOV is the default NON-aspect ratio adjusted FOV to adjust
simulated function float CalcAspectRatioAdjustedFOV(float AdjustFOV)
{
	local KFPlayerController KFPC;
	local float ResX, ResY;
	local float AspectRatio;

	KFPC = KFPlayerController(Level.GetLocalPlayerController());

	if( KFPC == none )
	{
		return AdjustFOV;
	}

	ResX = float(GUIController(KFPC.Player.GUIController).ResX);
	ResY = float(GUIController(KFPC.Player.GUIController).ResY);
	AspectRatio = ResX / ResY;

	if ( KFPC.bUseTrueWideScreenFOV && AspectRatio >= 1.60 ) //1.6 = 16/10 which is 16:10 ratio and 16:9 comes to 1.77
	{
		return CalcFOVForAspectRatio(AdjustFOV);
	}
	else
	{
		return AdjustFOV;
	}
}

//------------------------------------------------------------------------------
// AdjustIngameScope(RO) - Takes the changes to the ScopeDetail variable and
//	sets the scope to the new detail mode. Called when the player switches the
//	scope setting ingame, or when the scope setting is changed from the menu
//------------------------------------------------------------------------------
simulated function AdjustIngameScope()
{
	local PlayerController PC;

    // Lets avoid having to do multiple casts every tick - Ramm
	PC = PlayerController(Instigator.Controller);

	if( !bHasScope )
		return;

	switch (KFScopeDetail)
	{
		case KF_ModelScope:
			if( bAimingRifle )
				DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
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
				DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
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
				{
					DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOVHigh);
				}
				else
				{
					DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
				}
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

	// Make any chagned to the scope setup
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

state PendingClientWeaponSet
{
    simulated event Timer()
    {
        if ( Pawn(Owner) != None && !bIsReloading )
        {
            ClientWeaponSet(bPendingSwitch);
        }

        if ( IsInState('PendingClientWeaponSet') )
        {
			SetTimer(0.1, false);
		}
    }

    simulated event BeginState()
    {
        SetTimer(0.1, false);
    }

    simulated event EndState()
    {
    }
}

//========================================================

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player != None )
	{
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSoundData(ModeSwitchSound);
		
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		// Case - semi fire
		if ( !FireMode[0].bWaitForRelease )
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.ZedekPD_XM8SwitchMessage',1);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.ZedekPD_XM8SwitchMessage',0);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease);
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

function bool RecommendRangedAttack()
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
     //[block] Dynamic Loading Vars
	 ZoomMatRef="KF_Weapons5_Scopes_Trip_T.M99.MilDotFinalBlend"
     ScriptedTextureFallbackRef="XM8_T.lens_cmb"
	 //Mesh=SkeletalMesh'XM8_A.XM8'
	 MeshRef="XM8_A.XM8"
     //Skins(0)=Texture'XM8_T.foregrip'
	 SkinRefs(0)="XM8_T.foregrip"
     //Skins(2)=Texture'XM8_T.Receiver'
	 SkinRefs(2)="XM8_T.Receiver"
     //Skins(3)=Texture'XM8_T.Scope'
	 SkinRefs(3)="XM8_T.Scope"
	 //SelectSound=Sound'XM8_Snd.xm8_select'
	 SelectSoundRef="XM8_Snd.xm8_select"
	 //HudImage=Texture'XM8_T.select_uns'
	 HudImageRef="XM8_T.select_uns"
     //SelectedHudImage=Texture'XM8_T.select_sel'
	 SelectedHudImageRef="XM8_T.select_sel"
	 //[end]
	 lenseMaterialID=5
	 //scopePortalFOVHigh=19.200000
     //scopePortalFOV=19.200000
	 //2.75x zoom
	 scopePortalFOVHigh=16.000000
     scopePortalFOV=16.000000
     bHasScope=True
     ZoomedDisplayFOVHigh=18.000000
     MagCapacity=30
     ReloadRate=1.966667
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_SCAR"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'XM8_T.traderpic'
     //PlayerIronSightFOV=48.000000
	 PlayerIronSightFOV=44.000000
     ZoomedDisplayFOV=18.000000
     FireModeClass(0)=Class'UnlimaginMod.ZedekPD_XM8Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A compact XM8 military rifle. Comes with two firing modes to affect the accuracy of the weapon."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=70
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.ZedekPD_XM8Pickup'
     PlayerViewOffset=(X=20.000000,Y=21.500000,Z=-9.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.ZedekPD_XM8Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="XM8 Assault Rifle"
     TransientSoundVolume=1.250000
}
