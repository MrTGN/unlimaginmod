//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// L85A2 by J.Sullivan and Peter Adamson
//===================================================================================
class JSullivan_L85A2AssaultRifle extends UM_BaseAssaultRifle;

//===================================================================================
// Execs
//===================================================================================

//#exec OBJ LOAD FILE="..\textures\ScopeShaders.utx"
#exec OBJ LOAD FILE=..\Textures\ScopeShaders.utx
//#exec OBJ LOAD FILE="..\textures\JS_L85A2_T.utx"
#exec OBJ LOAD FILE=..\Textures\JS_L85A2_T.utx
#exec OBJ LOAD FILE=..\Animations\JS_L85A2_A.ukx

var color ChargeColor;

var float Range;
var float LastRangingTime;

var() Material ZoomMat;

//===================================================================================
// Variables
//===================================================================================

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
var   ScriptedTexture   ScopeScriptedTexture;   // Scripted texture for 3d scopes
var	  Shader		    ScopeScriptedShader;   	// The shader that combines the scripted texture with the sight overlay
var   Material          ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var     Combiner            ScriptedScopeCombiner;

var     texture             TexturedScopeTexture;

var	    bool				bInitializedScope;		// Set to True when the scope has been initialized
//var     float               ForceZoomOutTime;

//[block] Dynamic Loading Vars
var		string	ZoomMatRef;
var		string	ScriptedTextureFallbackRef;
//[end]


replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

//===================================================================================
// Functions
//===================================================================================

//===========================================
// Used for debugging the weapons and scopes- Ramm
//===========================================

// Commented out for the release build

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super.PreloadAssets(Inv, bSkipRefCount);

	if ( default.ZoomMatRef != "" && default.ZoomMat == None )
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', True));
	
	if ( default.ScriptedTextureFallbackRef != "" && default.ScriptedTextureFallback == None )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', True));

	if ( JSullivan_L85A2AssaultRifle(Inv) != None )
	{
		if ( default.ScriptedTextureFallback != None && JSullivan_L85A2AssaultRifle(Inv).ZoomMat == None )
			JSullivan_L85A2AssaultRifle(Inv).ZoomMat = default.ZoomMat;
		
		if ( default.ScriptedTextureFallback != None && JSullivan_L85A2AssaultRifle(Inv).ScriptedTextureFallback == None )
			JSullivan_L85A2AssaultRifle(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
	}
}

static function bool UnloadAssets()
{
	if ( default.ScriptedTextureFallback != None )
		default.ZoomMat = None;
	
	if ( default.ScriptedTextureFallback != None )
		default.ScriptedTextureFallback = None;

	Return Super.UnloadAssets();
}

exec function pfov(int thisFOV)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		Return;

	scopePortalFOV = thisFOV;
}

exec function pPitch(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		Return;

	scopePitch = num;
	scopePitchHigh = num;
}

exec function pYaw(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		Return;

	scopeYaw = num;
	scopeYawHigh = num;
}

simulated exec function TexSize(int i, int j)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		Return;

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
		Return True;
	else
		Return False;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

	UpdateScopeMode();
}

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != None && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
    {
	    if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
			//bPlayerFOVZooms = False;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetScoped;
			}

			if( ScopeScriptedTexture == None )
			{
	        	ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}

	        ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
	        ScopeScriptedTexture.SetSize(512,512);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == None )
			{
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'JS_L85A2_T.Susat_Scope';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == None )
			{
	            // Construct the scope shader
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

	        bInitializedScope = True;
		}
		else if( KFScopeDetail == KF_ModelScopeHigh )
		{
			scopePortalFOV = scopePortalFOVHigh;
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOVHigh);
			//bPlayerFOVZooms = False;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
			}

			if( ScopeScriptedTexture == None )
			{
	        	ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
	        }
			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
	        ScopeScriptedTexture.SetSize(1024,1024);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == None )
			{
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'JS_L85A2_T.Susat_Scope';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == None )
			{
	            // Construct the scope shader
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

            bInitializedScope = True;
		}
		else if (KFScopeDetail == KF_TextureScope)
		{
			ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
			PlayerViewOffset.X = default.PlayerViewOffset.X;
			//bPlayerFOVZooms = True;

			bInitializedScope = True;
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
//	if (Rpawn != None && rpawn.LeanAmount != 0)
//	{
//		RollMod.Roll += rpawn.LeanAmount;
//	}

    if(Owner != None && Instigator != None && Tex != None && Tex.Client != None)
        Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
}


function float GetAIRating()
{
	local AIController B;

	B = AIController(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		Return AIRating;

	Return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

function byte BestMode()
{
	Return 0;
}

function bool RecommendRangedAttack()
{
	Return True;
}


function bool RecommendLongRangedAttack()
{
	Return True;
}

function float SuggestAttackStyle()
{
	Return -1.0;
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

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
	{
		if( AimInSound != None )
		{
            PlayOwnedSound(AimInSound, SLOT_Interact,,,,, False);
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

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
	{
		if( AimOutSound != None )
		{
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, False);
        }
        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
}

simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( ForceZoomOutTime > 0 )
    {
        if( bAimingRifle )
        {
    	    if( Level.TimeSeconds - ForceZoomOutTime > 0 )
    	    {
                ForceZoomOutTime = 0;

            	ZoomOut(False);

            	if( Role < ROLE_Authority)
        			ServerZoomOut(False);
    		}
		}
		else
		{
            ForceZoomOutTime = 0;
		}
	}
}

// Force the weapon out of iron sights shortly after firing so the textured
// scope gets the same disadvantage as the 3d scope



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

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None &&
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
        Return;

    // Lets avoid having to do multiple casts every tick - Ramm
	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		Return;

    if(!bInitializedScope && PC != None )
	{
    	  UpdateScopeMode();
    }

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(None, False, True); // amb: Clear the z-buffer here

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

 	if(bAimingRifle && PC != None && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
 	{
 		if (ShouldDrawPortal())
 		{
			if ( ScopeScriptedTexture != None )
			{
				Skins[LenseMaterialID] = ScopeScriptedShader;
				ScopeScriptedTexture.Client = Self;   // Need this because this can get corrupted - Ramm
				ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
			}
 		}

		bDrawingFirstPerson = True;
 	    Canvas.DrawBoundActor(self, False, False,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
      	bDrawingFirstPerson = False;
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
		Canvas.DrawText("Zoom: 2.50");

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
	}
 	else
 	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;
		bDrawingFirstPerson = True;
		Canvas.DrawActor(self, False, False, DisplayFOV);
		bDrawingFirstPerson = False;
 	}
}

//===================================================================================
// Scopes
//===================================================================================

//------------------------------------------------------------------------------
// SetScopeDetail(RO) - Allow the players to change scope detail while ingame.
//	Changes are saved to the ini file.
//------------------------------------------------------------------------------
//simulated exec function SetScopeDetail()
//{
//	if( !bHasScope )
//		Return;
//
//	if (KFScopeDetail == KF_ModelScope)
//		KFScopeDetail = KF_TextureScope;
//	else if ( KFScopeDetail == KF_TextureScope)
//		KFScopeDetail = KF_ModelScopeHigh;
//	else if ( KFScopeDetail == KF_ModelScopeHigh)
//		KFScopeDetail = KF_ModelScope;
//
//	AdjustIngameScope();
//	class'KFMod.KFWeapon'.default.KFScopeDetail = KFScopeDetail;
//	class'KFMod.KFWeapon'.static.StaticSaveConfig();		// saves the new scope detail value to the ini
//}

// Adjust a single FOV based on the current aspect ratio. Adjust FOV is the default NON-aspect ratio adjusted FOV to adjust
simulated function float CalcAspectRatioAdjustedFOV(float AdjustFOV)
{
	local KFPlayerController KFPC;
	local float ResX, ResY;
	local float AspectRatio;

	KFPC = KFPlayerController(Level.GetLocalPlayerController());

	if( KFPC == None )
	{
		Return AdjustFOV;
	}

	ResX = float(GUIController(KFPC.Player.GUIController).ResX);
	ResY = float(GUIController(KFPC.Player.GUIController).ResY);
	AspectRatio = ResX / ResY;

	if ( KFPC.bUseTrueWideScreenFOV && AspectRatio >= 1.60 ) //1.6 = 16/10 which is 16:10 ratio and 16:9 comes to 1.77
	{
		Return CalcFOVForAspectRatio(AdjustFOV);
	}
	else
	{
		Return AdjustFOV;
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
		Return;

	switch (KFScopeDetail)
	{
		case KF_ModelScope:
			if( bAimingRifle )
				DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
			if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
			{
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
            	{
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
			}
			Break;

		case KF_TextureScope:
			if( bAimingRifle )
				DisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOV);
			if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
			{
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
            	{
            		KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
            	}
			}
			Break;

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
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
            	{
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
            	}
			}
			Break;
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
// Interesting reference to material 2
    if (ScriptedScopeCombiner != None)
    {
		ScriptedScopeCombiner.Material2 = None; 
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = None;
    }

    if (ScopeScriptedShader != None)
    {
		ScopeScriptedShader.Diffuse = None;
		ScopeScriptedShader.SelfIllumination = None;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = None;
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
		ScriptedScopeCombiner.Material2 = None;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = None;
    }

    if (ScopeScriptedShader != None)
    {
		ScopeScriptedShader.Diffuse = None;
		ScopeScriptedShader.SelfIllumination = None;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = None;
    }
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
	local PlayerController Player;
	
	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		// Case - burst fire
		if ( FireMode[0].bWaitForRelease && JSullivan_L85A2Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Semi-Auto
			FireMode[0].bWaitForRelease = FireMode[0].bWaitForRelease;
			JSullivan_L85A2Fire(FireMode[0]).bSetToBurst = !JSullivan_L85A2Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',2);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		// Case - semi fire
		else if ( FireMode[0].bWaitForRelease && !JSullivan_L85A2Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Auto
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			JSullivan_L85A2Fire(FireMode[0]).bSetToBurst = JSullivan_L85A2Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			// Switching to burst
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			JSullivan_L85A2Fire(FireMode[0]).bSetToBurst = !JSullivan_L85A2Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease, JSullivan_L85A2Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease, bool bNewSetToBurst)
{
	FireMode[0].bWaitForRelease = bNewWaitForRelease;
	JSullivan_L85A2Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

exec function SwitchModes()
{
	DoToggle();
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //ZoomMatRef="JS_L85A2_T.Susat_Scope"
	 ZoomMat=Texture'JS_L85A2_T.Susat_Scope'
	 ScriptedTextureFallbackRef="KF_Weapons_Trip_T.CBLens_cmb"
	 Mesh=SkeletalMesh'JS_L85A2_A.L85A2_Weapon'
	 //MeshRef="JS_L85A2_A.L85A2_Weapon"
     Skins(1)=Texture'JS_L85A2_T.l85a1_diffuse_04'
     Skins(2)=Texture'JS_L85A2_T.susat_diffuse_01'
	 //SkinRefs(1)="JS_L85A2_T.l85a1_diffuse_04"
	 //SkinRefs(2)="JS_L85A2_T.susat_diffuse_01"
	 SelectSound=Sound'KF_9MMSnd.9mm_Select'
	 //SelectSoundRef="KF_9MMSnd.9mm_Select"
	 HudImage=Texture'JS_L85A2_T.L85A2_Unselected'
	 //HudImageRef="JS_L85A2_T.L85A2_Unselected"
	 SelectedHudImage=Texture'JS_L85A2_T.L85A2_Selected'
	 //SelectedHudImageRef="JS_L85A2_T.L85A2_Selected"
	 //[end]
     lenseMaterialID=3
	 //2.5x zoom
     //scopePortalFOVHigh=19.200000
     //scopePortalFOV=19.200000
	 //2.75x zoom
	 scopePortalFOVHigh=16.000000
     scopePortalFOV=16.000000
     FirstPersonFlashlightOffset=(X=-20.000000,Y=-22.000000,Z=8.000000)
     bHasScope=True
     ZoomedDisplayFOVHigh=32.000000
     MagCapacity=30
     ReloadRate=3.233000
	 TacticalReloadTime=1.600000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'JS_L85A2_T.L85A2_Trader'
     bIsTier3Weapon=True
     //PlayerIronSightFOV=48.000000
	 PlayerIronSightFOV=44.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.JSullivan_L85A2Fire'
	 FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.000000
     BringUpTime=0.900000
     AIRating=0.250000
     CurrentRating=0.250000
     bShowChargingBar=True
     Description="Standard issue British Assault Rifle"
     DisplayFOV=70.000000
     Priority=100
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.JSullivan_L85A2Pickup'
     PlayerViewOffset=(X=20.000000,Y=25.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.JSullivan_L85A2Attachment'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="L85A2 (SUSAT)"
}
