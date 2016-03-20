class OperationY_AUG_A1AssaultRifle extends UM_BaseAssaultRifle;

#exec OBJ LOAD FILE=AUG_A1_A.ukx

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
var		bool			bInitializedScope;		// Set to True when the scope has been initialized
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
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', True));
	
	if ( default.ScriptedTextureFallbackRef != "" && default.ScriptedTextureFallback == None )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', True));

	if ( OperationY_AUG_A1AssaultRifle(Inv) != None )
	{
		if ( default.ZoomMat != None && OperationY_AUG_A1AssaultRifle(Inv).ZoomMat == None )
			OperationY_AUG_A1AssaultRifle(Inv).ZoomMat = default.ZoomMat;
		
		if ( default.ScriptedTextureFallback != None && 
			 OperationY_AUG_A1AssaultRifle(Inv).ScriptedTextureFallback == None )
			OperationY_AUG_A1AssaultRifle(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
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

//====================================================================
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

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

    ItemName = default.ItemName $ " [Auto]";
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
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
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
	        ScopeScriptedTexture.SetSize(1024,1024);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == None )
			{
				// Construct the Combiner
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'AUG_A1_A.AUG_A1_T.AUG-A1_scope';
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
			ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
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
	            ScriptedScopeCombiner.Material1 = Texture'AUG_A1_A.AUG_A1_T.AUG-A1_scope';
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
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
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

/*
simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
	    ForceZoomOutTime = 0;

    	ZoomOut(False);

    	if( Role < ROLE_Authority)
			ServerZoomOut(False);
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

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None &&
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
		Canvas.DrawText(" "); //Canvas.DrawText("Zoom: 2.50");

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

//=============================================================================
// Scopes
//=============================================================================

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
				DisplayFOV = default.ZoomedDisplayFOV;
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
				DisplayFOV = default.ZoomedDisplayFOV;
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
					DisplayFOV = default.ZoomedDisplayFOVHigh;
				else
					DisplayFOV = default.ZoomedDisplayFOV;
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

//======================================================================

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
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		
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

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		Return AIRating;

	Return AIRating;
}

function byte BestMode()
{
	Return 0;
}
//======================================================================

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //ZoomMat=FinalBlend'AUG_A1_A.AUG_A1_T.AUG-A1_scope_FB'
	 ZoomMatRef="AUG_A1_A.AUG_A1_T.AUG-A1_scope_FB"
	 //ScriptedTextureFallback=Texture'AUG_A1_A.AUG_A1_T.alpha_lens_64x64'
	 ScriptedTextureFallbackRef="AUG_A1_A.AUG_A1_T.alpha_lens_64x64"
	 //Mesh=SkeletalMesh'AUG_A1_A.AUG_A1_mesh'
	 MeshRef="AUG_A1_A.AUG_A1_mesh"
     //Skins(0)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
	 //SkinRefs(0)="KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P"
     //Skins(1)=Combiner'AUG_A1_A.AUG_A1_T.AUG_A1_tex_1_cmb'
	 SkinRefs(1)="AUG_A1_A.AUG_A1_T.AUG_A1_tex_1_cmb"
     //Skins(2)=Combiner'AUG_A1_A.AUG_A1_T.AUG_A1_tex_2_cmb'
	 SkinRefs(2)="AUG_A1_A.AUG_A1_T.AUG_A1_tex_2_cmb"
     //Skins(3)=Combiner'AUG_A1_A.AUG_A1_T.AUG_A1_tex_3_cmb'
	 SkinRefs(3)="AUG_A1_A.AUG_A1_T.AUG_A1_tex_3_cmb"
     //Skins(4)=Texture'AUG_A1_A.AUG_A1_T.alpha_lens_64x64'
	 SkinRefs(4)="AUG_A1_A.AUG_A1_T.alpha_lens_64x64"
	 //SelectSound=Sound'AUG_A1_A.AUG_A1_SND.aug_draw'
	 SelectSoundRef="AUG_A1_A.AUG_A1_SND.aug_draw"
	 //HudImage=Texture'AUG_A1_A.AUG_A1_T.AUG_A1_Unselected'
	 HudImageRef="AUG_A1_A.AUG_A1_T.AUG_A1_Unselected"
     //SelectedHudImage=Texture'AUG_A1_A.AUG_A1_T.AUG_A1_Selected'
	 SelectedHudImageRef="AUG_A1_A.AUG_A1_T.AUG_A1_Selected"
	 //[end]
     lenseMaterialID=4
     //1.5x zoom
	 scopePortalFOVHigh=28.000000
     scopePortalFOV=28.000000
     bHasScope=True
     ZoomedDisplayFOVHigh=50.000000
     MagCapacity=42
	 TacticalReloadTime=1.950000
	 TacticalReloadAnim=(Anim="Reload",Rate=0.75,StartFrame=69.00,TweenTime=0.1)
     ReloadRate=3.900000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M7A3"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'AUG_A1_A.AUG_A1_T.trader_AUG_A1'
     PlayerIronSightFOV=42.000000
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.OperationY_AUG_A1ARFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="The AUG is an Austrian bullpup 5.56mm assault rifle, designed in the 1960s by Steyr Mannlicher GmbH & Co KG (formerly Steyr-Daimler-Puch)."
     DisplayFOV=65.000000
     Priority=170
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.OperationY_AUG_A1ARPickup'
     PlayerViewOffset=(X=15.000000,Y=12.000000,Z=-2.000000)
     BobDamping=5.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_AUG_A1ARAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="Steyr AUG A1"
}
