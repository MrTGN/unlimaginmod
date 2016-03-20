//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_G2ContenderPistol extends UM_BaseHandgun;

#exec OBJ LOAD FILE=Thompson_G2_A.ukx

var			color		ChargeColor;

var			float		Range;
var			float		LastRangingTime;

var()		Material	ZoomMat;
var()		Sound		ZoomSound;
var			bool		bArrowRemoved;

var()		int			lenseMaterialID;		// used since material id's seem to change alot

var()		float		scopePortalFOVHigh;		// The FOV to zoom the scope portal by.
var()		float		scopePortalFOV;			// The FOV to zoom the scope portal by.
var()       vector      XoffsetScoped;
var()       vector      XoffsetHighDetail;

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
var()		int			scopePitch;
var()		int			scopeYaw;
var()		int			scopePitchHigh;
var()		int			scopeYawHigh;

// 3d Scope vars
var		ScriptedTexture	ScopeScriptedTexture;
var		Shader		    ScopeScriptedShader;
var		Material		ScriptedTextureFallback;

// new scope vars
var		Combiner		ScriptedScopeCombiner;
var		texture			TexturedScopeTexture;
var		bool			bInitializedScope;


var		float	OriginalMouseSensitivity;
var		float	ZoomRatio;
//[block] Dynamic Loading Vars
var		string	ZoomMatRef;
var		string	ScriptedTextureFallbackRef;
//[end]

replication
{
	reliable if(Role < ROLE_Authority)
		ServerChangeScopePortalFOV;
}

//[block] Dynamic Loading
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super.PreloadAssets(Inv, bSkipRefCount);

	if ( default.ZoomMatRef != "" && default.ZoomMat == None )
		default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', True));
	
	if ( default.ScriptedTextureFallbackRef != "" && default.ScriptedTextureFallback == None )
		default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', True));
	
	if ( OperationY_G2ContenderPistol(Inv) != None )
	{
		if ( default.ZoomMat != None && OperationY_G2ContenderPistol(Inv).ZoomMat == None )
			OperationY_G2ContenderPistol(Inv).ZoomMat = default.ZoomMat;
		
		if ( default.ScriptedTextureFallback != None && OperationY_G2ContenderPistol(Inv).ScriptedTextureFallback == None )
			OperationY_G2ContenderPistol(Inv).ScriptedTextureFallback = default.ScriptedTextureFallback;
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
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		
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

simulated function bool ShouldDrawPortal()
{
    if( bAimingRifle )
		Return True;
	else
		Return False;
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

    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;
	UpdateScopeMode();
}

simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != None && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
    {
	    if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
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
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'Thompson_G2_A.gdcw_acog';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == None )
			{
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
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
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
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = Texture'Thompson_G2_A.gdcw_acog';
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == None )
			{
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

			bInitializedScope = True;
		}
	}
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;

    RollMod = Instigator.GetViewRotation();
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
		&& KFPlayerController(Instigator.Controller) != None && AimInSound != None)
		PlayOwnedSound(AimInSound, SLOT_Interact,,,,, False);
	
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

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != None )
	{
		if( AimOutSound != None )
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, False);

        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
	
	//[block] Restoring Mouse Sensitivity if needed
	Player = Level.GetLocalPlayerController();
	if ( Player != None && Player.GetMouseSensitivity() != OriginalMouseSensitivity )
		Player.SetSensitivity(OriginalMouseSensitivity);
	//[end]
}
//[end]

/*simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
	    ForceZoomOutTime = 0;

    	ZoomOut(False);

    	if( Role < ROLE_Authority)
			ServerZoomOut(False);
	}
}*/


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

	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		Return;

    if(!bInitializedScope && PC != None )
	{
    	  UpdateScopeMode();
    }

    Canvas.DrawActor(None, False, True);

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
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 512, 512);

		Canvas.Font = Canvas.MedFont;
		Canvas.SetDrawColor(200,150,0);

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
		Canvas.DrawText(" ");

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

simulated function AdjustIngameScope()
{
	local PlayerController PC;

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

defaultproperties
{
	 ZoomRatio=1.600000
	 //[block] Dynamic Loading vars
	 //ZoomMat=FinalBlend'Thompson_G2_A.gdcw_acog_FB'
	 ZoomMatRef="Thompson_G2_A.gdcw_acog_FB"
	 //ScriptedTextureFallback=Texture'Thompson_G2_A.alpha_lens_64x64'
	 ScriptedTextureFallbackRef="Thompson_G2_A.alpha_lens_64x64"
	 //Mesh=SkeletalMesh'Thompson_G2_A.G2ContenderMesh'
	 MeshRef="Thompson_G2_A.G2ContenderMesh"
     //Skins(0)=Combiner'Thompson_G2_A.Contender_diffuse_cmb'
	 SkinRefs(0)="Thompson_G2_A.Contender_diffuse_cmb"
     //Skins(1)=Texture'Thompson_G2_A.alpha_lens_64x64'
	 SkinRefs(1)="Thompson_G2_A.alpha_lens_64x64"
     //Skins(2)=Combiner'Thompson_G2_A.uv1024_cmb'
	 SkinRefs(2)="Thompson_G2_A.uv1024_cmb"
     //Skins(3)=Texture'KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P'
	 //SkinRefs(3)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
     //Skins(4)=Combiner'Thompson_G2_A.Bullet_cmb'
	 SkinRefs(4)="Thompson_G2_A.Bullet_cmb"
     //SelectSound=Sound'Thompson_G2_A.G2_Pickup'
	 SelectSoundRef="Thompson_G2_A.G2_Pickup"
	 //HudImage=Texture'Thompson_G2_A.g2contender_unselected'
	 HudImageRef="Thompson_G2_A.g2contender_unselected"
     //SelectedHudImage=Texture'Thompson_G2_A.g2contender_selected'
	 SelectedHudImageRef="Thompson_G2_A.g2contender_selected"
	 //[end]
	 lenseMaterialID=1
     scopePortalFOVHigh=20.000000
     scopePortalFOV=20.000000
     //PlayerIronSightFOV=12.000000
	 PlayerIronSightFOV=32.000000
     ZoomedDisplayFOVHigh=25.000000
     ZoomedDisplayFOV=25.000000
     bHasScope=True
	 ZoomTime=0.285000
	 MagCapacity=1
     ReloadRate=1.376000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
	 WeaponReloadAnim="Reload_HuntingShotgun"
     Weight=3.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
	 PutDownAnim="PutDown"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
	 SleeveNum=3
     TraderInfoTexture=Texture'Thompson_G2_A.g2contender_trader'
     bIsTier2Weapon=True
     FireModeClass(0)=Class'UnlimaginMod.OperationY_G2ContenderFire'
     FireModeClass(1)=Class'KFMod.NoFire'
	 PutDownAnimRate=1.000000
     AIRating=0.550000
     CurrentRating=0.550000
     Description="Thompson G2 Contender is a Break-action single-shot pistol with 14 inch barrel."
     DisplayFOV=55.000000
     Priority=124
     InventoryGroup=2
     GroupOffset=14
     PickupClass=Class'UnlimaginMod.OperationY_G2ContenderPickup'
     PlayerViewOffset=(X=13.000000,Y=14.000000,Z=-5.500000)
     BobDamping=4.500000
     AttachmentClass=Class'UnlimaginMod.OperationY_G2ContenderAttachment'
     ItemName="Thompson G2 Contender"
}
