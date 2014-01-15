//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Braindead_HuntingRifle extends UM_BaseBoltActSniperRifle
	config(user);

//===================================================================================
// Execs
//===================================================================================
#exec OBJ LOAD FILE=..\Textures\HuntingRifleT.utx
#exec OBJ LOAD FILE=..\Animations\HuntingRifleA.ukx
#exec OBJ LOAD FILE=..\Textures\ScopeShaders.utx
//#exec OBJ LOAD FILE="..\Animations\KF_Freaks_Trip.ukx"

//===================================================================================
// Variables
//===================================================================================
var			color			ChargeColor;
var			float			Range;
var			float			LastRangingTime;

var()		Material		ZoomMat;
var()		Sound			ZoomSound;
var			bool			bArrowRemoved;

var()		int				lenseMaterialID;		// used since material id's seem to change alot

var()		float			scopePortalFOVHigh;		// The FOV to zoom the scope portal by.
var()		float			scopePortalFOV;			// The FOV to zoom the scope portal by.
var()		vector			XoffsetScoped;
var()		vector			XoffsetHighDetail;

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
var()		int				scopePitch;				// Tweaks the pitch of the scope firing angle
var()		int				scopeYaw;				// Tweaks the yaw of the scope firing angle
var()		int				scopePitchHigh;			// Tweaks the pitch of the scope firing angle high detail scope
var()		int				scopeYawHigh;			// Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var		ScriptedTexture		ScopeScriptedTexture;   // Scripted texture for 3d scopes
var		Shader				ScopeScriptedShader;   	// The shader that combines the scripted texture with the sight overlay
var		Material			ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var		Combiner			ScriptedScopeCombiner;
var		texture				TexturedScopeTexture;
var		bool				bInitializedScope;		// Set to true when the scope has been initialized


var		float	ForceAutoZoomInTime;
var		float	OriginalMouseSensitivity;
var		float	ZoomRatio;
//[block] Dynamic Loading Vars
var		string	ZoomMatRef;
var		string	ScriptedTextureFallbackRef;
//[end]

//===================================================================================
// Functions
//===================================================================================

replication
{
	reliable if(Role < ROLE_Authority)
		ServerChangeScopePortalFOV;
}

//[block] Dynamic Loading
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	super.PreloadAssets(Inv, bSkipRefCount);

	if ( default.ZoomMat == None && default.ZoomMatRef != "" )
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
	
	if ( default.ScriptedTextureFallback == None && default.ScriptedTextureFallbackRef != "" )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));
	
	if ( Braindead_HuntingRifle(Inv) != none )
	{
		if ( Braindead_HuntingRifle(Inv).ZoomMat == None && default.ZoomMat != None )
			Braindead_HuntingRifle(Inv).ZoomMat = default.ZoomMat;
		
		if ( Braindead_HuntingRifle(Inv).ScriptedTextureFallback == None && default.ScriptedTextureFallback != None )
			Braindead_HuntingRifle(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
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
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',3);
			ItemName = default.ItemName $ " [4x Zoom]";
		}
		else if ( scopePortalFOVHigh == (default.scopePortalFOVHigh / ZoomRatio) ||
				scopePortalFOV == (default.scopePortalFOV / ZoomRatio) )
		{
			scopePortalFOVHigh = default.scopePortalFOVHigh / (ZoomRatio * ZoomRatio);
			scopePortalFOV = default.scopePortalFOV / (ZoomRatio * ZoomRatio);
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',5);
			ItemName = default.ItemName $ " [8x Zoom]";
		}
		else
		{
			scopePortalFOVHigh = default.scopePortalFOVHigh;
			scopePortalFOV = default.scopePortalFOV;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_ZoomSwitchMessage',1);
			ItemName = default.ItemName $ " [2x Zoom]";
		}
	}
	ServerChangeScopePortalFOV(scopePortalFOVHigh, scopePortalFOV);
	if ( bAimingRifle && Player != None )
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
	//[block] Saving original mouse sensitivity and writing zoom level to ItemName
	local PlayerController Player;
	
	Player = Level.GetLocalPlayerController();
	if ( Player != None )
		OriginalMouseSensitivity = Player.GetMouseSensitivity();
	
	ItemName = default.ItemName $ " [2x Zoom]";
	//[end]
	
	Super.PostBeginPlay();

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
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'HuntingRifleT.Scope.HRCross';
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
			ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
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
	        ScopeScriptedTexture.SetSize(1024,1024);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'HuntingRifleT.Scope.HRCross';
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
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
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


function float GetAIRating()
{
	local AIController B;

	B = AIController(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

function byte BestMode()
{
	return 0;
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

	if( Level.NetMode != NM_DedicatedServer 
		&& KFPlayerController(Instigator.Controller) != none && AimInSound != none)
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
	
    super.ZoomOut(bAnimateTransition);

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

simulated function WeaponTick(float dt)
{
	if( bAimingRifle && ForceZoomOutTime > 0.000000 && FireMode[0].AllowFire() )
		ForceAutoZoomInTime = ForceZoomOutTime - 0.4 + FireMode[0].default.FireRate / KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetFireSpeedMod(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), FireMode[0].Weapon);

	super.WeaponTick(dt);

	if( ForceAutoZoomInTime > 0.000000 && (Level.TimeSeconds - ForceAutoZoomInTime) > 0.000000 
		 && CanZoomNow() )
	{
		ForceAutoZoomInTime = 0;
		IronSightZoomIn();
	}
}

// Force the weapon out of iron sights shortly after firing so the textured
// scope gets the same disadvantage as the 3d scope
/*
simulated function bool StartFire(int Mode)
{
    if( super.StartFire(Mode) )
    {
        ForceZoomOutTime = Level.TimeSeconds + 0.4;
        Return True;
    }

    Return False;
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
		Canvas.DrawText("Zoom: 2.50");

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
//		return;
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

//PutDown() code from KFWeapon
simulated function bool PutDown()
{
	local int Mode;

	InterruptReload();

	if ( bIsReloading )
		return false;
	
	// Clear ForceAutoZoomInTime if PutDown
	if ( ForceAutoZoomInTime > 0.000000 )
		ForceAutoZoomInTime = 0.000000;

	if( bAimingRifle )
	{
		ZoomOut(False);
	}

	// From Weapon.uc
	if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
	{
		if ( (Instigator.PendingWeapon != None) && !Instigator.PendingWeapon.bForceSwitch )
		{
			for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
			{
		    	// if _RO_
				if( FireMode[Mode] == none )
					continue;
				// End _RO_

				if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
					return false;
				if ( FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].FireRate*(1.f - MinReloadPct))
					DownDelay = FMax(DownDelay, FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate*(1.f - MinReloadPct));
			}
		}

		if (Instigator.IsLocallyControlled())
		{
			for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
			{
		    	// if _RO_
				if( FireMode[Mode] == none )
					continue;
				// End _RO_

				if ( FireMode[Mode].bIsFiring )
					ClientStopFire(Mode);
			}

            if (  DownDelay <= 0  || KFPawn(Instigator).bIsQuickHealing > 0)
            {
				if ( ClientState == WS_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
					TweenAnim(SelectAnim,PutDownTime);
				else if ( HasAnim(PutDownAnim) )
				{
					if( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0)
                    {
                       PlayAnim(PutDownAnim, PutDownAnimRate * (PutDownTime/QuickPutDownTime), 0.0);
                	}
                	else
                	{
                	   PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                	}

				}
			}
        }
		ClientState = WS_PutDown;
		if ( Level.GRI.bFastWeaponSwitching )
			DownDelay = 0;
		if ( DownDelay > 0 )
		{
			SetTimer(DownDelay, false);
		}
		else
		{
			if( ClientGrenadeState == GN_TempDown )
			{
			   SetTimer(QuickPutDownTime, false);
			}
			else
			{
			   SetTimer(PutDownTime, false);
			}
		}
	}
	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		// if _RO_
		if( FireMode[Mode] == none )
			continue;
		// End _RO_

		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
	}
	Instigator.AmbientSound = None;
	OldWeapon = None;
	return true; // return false if preventing weapon switch
}

defaultproperties
{
     //[block] Zoom level switching def vars
     ZoomRatio=2.000000
	 //[end]
	 //[block] Dynamic Loading vars
	 ZoomMat=FinalBlend'HuntingRifleT.Scope.RifleCrossFinal'
	 //ZoomMatRef="HuntingRifleT.Scope.RifleCrossFinal"
	 ScriptedTextureFallback=Combiner'KF_Weapons_Trip_T.Rifles.CBLens_cmb'
	 //ScriptedTextureFallbackRef="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
     //Mesh=SkeletalMesh'HuntingRifleA.hunt_rifle'
	 MeshRef="HuntingRifleA.hunt_rifle"
     //Skins(0)=Combiner'HuntingRifleT.HR_Final'
	 SkinRefs(0)="HuntingRifleT.HR_Final"
	 //SelectSound=Sound'KF_PumpSGSnd.SG_Select'
	 SelectSoundRef="KF_PumpSGSnd.SG_Select"
	 //HudImage=Texture'HuntingRifleT.HUD.HR_Unselected'
	 HudImageRef="HuntingRifleT.HUD.HR_Unselected"
     //SelectedHudImage=Texture'HuntingRifleT.HUD.HR_selected'
	 SelectedHudImageRef="HuntingRifleT.HUD.HR_selected"
	 //[end]
     lenseMaterialID=2
     scopePortalFOVHigh=16.000000
     scopePortalFOV=16.000000
     ZoomedDisplayFOVHigh=40.000000
     bHasScope=True
     MagCapacity=10
     ReloadRate=4.108000
	 //72.5
	 TacticalReloadRate=2.590000
     ReloadAnim="Reload"
     ReloadAnimRate=1.120000
     WeaponReloadAnim="Reload_M14"
     Weight=7.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'HuntingRifleT.HUD.huntingrifle_Trader'
     PlayerIronSightFOV=32.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.Braindead_HuntingRifleFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="A recreational hunting weapon, featuring a firing trigger and a powerful integrated scope. "
     DisplayFOV=65.000000
     Priority=10
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.Braindead_HuntingRiflePickup'
     PlayerViewOffset=(X=15.000000,Y=16.000000,Z=-4.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Braindead_HuntingRifleAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="Remington 700"
}
