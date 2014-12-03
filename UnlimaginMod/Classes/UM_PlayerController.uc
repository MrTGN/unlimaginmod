class UM_PlayerController extends KFPlayerController;

var				bool		bUseAdvBehindview;
var transient	vector		CamPos;
var transient	rotator		CamRot;
var transient	Actor		CamActor;

var				string		SteamStatsAndAchievementsClassName;
var				string		BuyMenuClassName, MidGameMenuClassName, InputClassName;

replication
{
	reliable if ( Role == ROLE_Authority && bNetOwner )
		bUseAdvBehindview;
}

/*
simulated event PreBeginPlay()
{
	if ( Role == ROLE_Authority && SteamStatsAndAchievementsClass == None )
		SteamStatsAndAchievementsClass = Class<SteamStatsAndAchievementsBase>( DynamicLoadObject(SteamStatsAndAchievementsClassName, Class'Class', True) );
	
	Super.PreBeginPlay();
} */

//[block] Server menu functions. Function calls also replicated from the clients.
// ClientOpenMenu
event ClientOpenMenu( string Menu, optional bool bDisconnect, optional string Msg1, optional string Msg2 )
{
	if ( Player == None )
		Return;
	
	// GUIController calls UnpressButtons() after it's been activated...once active, it swallows
	// all input events, preventing GameEngine from parsing script execs commands -- rjp
	if ( !Player.GUIController.OpenMenu(Menu, Msg1, Msg2) )
		UnPressButtons();

	if ( bDisconnect )  {
		// Use delayed console command, in case the menu that was opened had bDisconnectOnOpen=True -- rjp
		if ( Player.Console != None )
			Player.Console.DelayedConsoleCommand("DISCONNECT");
		else
			ConsoleCommand("Disconnect");
	}
}

// ClientReplaceMenu
event ClientReplaceMenu( string Menu, optional bool bDisconnect, optional string Msg1, optional string Msg2 )
{
	if ( Player == None )
		Return;
	
	if ( !Player.GUIController.bActive )  {
		if ( !Player.GUIController.ReplaceMenu(Menu, Msg1, Msg2) )
			UnpressButtons();
	}
	else 
		Player.GUIController.ReplaceMenu(Menu, Msg1, Msg2);

	if ( bDisconnect )  {
		// Use delayed console command, in case the menu that was opened had bDisconnectOnOpen=True -- rjp
		if ( Player.Console != None )
			Player.Console.DelayedConsoleCommand("Disconnect");
		else
			ConsoleCommand("Disconnect");
	}
}

// ClientCloseMenu
event ClientCloseMenu( optional bool bCloseAll, optional bool bCancel )
{
	if ( Player == None )
		Return;
	
	if ( bCloseAll )
		Player.GUIController.CloseAll(bCancel, True);
	else
		Player.GUIController.CloseMenu(bCancel);
}
//[end]

// Spawn PlayerReplicationInfo on the server
function InitPlayerReplicationInfo()
{
	if ( !bDeleteMe && bIsPlayer && PlayerReplicationInfoClass != None )  {
		PlayerReplicationInfo = Spawn( PlayerReplicationInfoClass, self,, vect(0.0,0.0,0.0), rot(0,0,0) );
		if ( PlayerReplicationInfo != None )  {
			// PlayerName
			if ( PlayerReplicationInfo.PlayerName == "" )
				PlayerReplicationInfo.SetPlayerName(class'GameInfo'.Default.DefaultPlayerName);
			// bNoTeam
			PlayerReplicationInfo.bNoTeam = !Level.Game.bTeamGame;
		}
	}
}

// Spawn ChatManager on the server
function InitChatManager()
{
	local	class<PlayerChatManager>	PlayerChatClass;
	
	if ( PlayerChatType != "" )  {
		PlayerChatClass = class<PlayerChatManager>( DynamicLoadObject(PlayerChatType, class'Class') );
		if ( PlayerChatClass != None )
			ChatManager = Spawn( PlayerChatClass, self );
	}
}

simulated function PrecacheAnnouncements()
{
	if ( RewardAnnouncer != None )
		RewardAnnouncer.PrecacheAnnouncements(true);
	
	if ( StatusAnnouncer != None )
		StatusAnnouncer.PrecacheAnnouncements(false);
}

// Spawn VoiceAnnouncers on the clients
simulated function InitVoiceAnnouncers()
{
	local	class<AnnouncerVoice>	VoiceClass;
	
	// CustomRewardAnnouncerPack
	if ( CustomRewardAnnouncerPack != "" )  {
		VoiceClass = class<AnnouncerVoice>( DynamicLoadObject(CustomRewardAnnouncerPack, Class'Class') );
		RewardAnnouncer = Spawn(VoiceClass);
	}
	
	// CustomStatusAnnouncerPack
	if ( CustomStatusAnnouncerPack != "" )  {
		VoiceClass = class<AnnouncerVoice>( DynamicLoadObject(CustomStatusAnnouncerPack, Class'Class') );
		StatusAnnouncer = Spawn(VoiceClass);
	}
	
	PrecacheAnnouncements();
}

simulated function LoadComboList()
{
	local	int		c;
	
	for ( c = 0; c < ArrayCount(ComboList); ++c )  {
		if ( ComboNameList[c] != "" )  {
			ComboList[c] = Class<Combo>( DynamicLoadObject(ComboNameList[c], Class'Class') );
			if ( ComboList[c] == None )
				Break;
			MinAdrenalineCost = FMin(MinAdrenalineCost, ComboList[c].Default.AdrenalineCost);
		}
	}
}

simulated function UpdateHintManagement(bool bUseHints)
{
	if ( Level.GetLocalPlayerController() == self )  {
		if ( bUseHints )  {
			if ( HintManager == None )  {
				HintManager = Spawn(class'KFHintManager', self);
				// Still None
				if ( HintManager == None )
					Warn("Unable to spawn hint manager");
			}
		}
		else  {
			if ( HintManager != None )  {
				HintManager.Destroy();
				HintManager = None;
			}
			if ( HUDKillingFloor(myHUD) != None )
				HUDKillingFloor(myHUD).bDrawHint = False;
		}
	}
}

// Possess a pawn
function Possess(Pawn aPawn)
{
	// From KFPlayerController
	bVomittedOn = False;
	bScreamedAt = False;
	
	// Spectator
	if ( PlayerReplicationInfo.bOnlySpectator )
		Return;

	bSpawnedThisWave = True;
	ResetFOV();
	Pawn = aPawn;
	aPawn.PossessedBy(self);
	Pawn.bStasis = False;
	ResetTimeMargin();
	CleanOutSavedMoves();  // don't replay moves previous to possession

	if ( Vehicle(Pawn) != None && Vehicle(Pawn).Driver != None )
		PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;
	else
		PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;

	ServerSetHandedness(Handedness);
	ServerSetAutoTaunt(bAutoTaunt);
	Restart();

	if ( xPawn(aPawn) != None )
		xPawn(aPawn).Setup(PawnSetupRecord, True);
	
	if ( Level.NetMode != NM_DedicatedServer )
		ServerSetClassicTrans(bClassicTrans);
}

function ServerAcknowledgePossession(Pawn P, float NewHand, bool bNewAutoTaunt)
{
	ResetTimeMargin();
    AcknowledgedPawn = P;
    ServerSetHandedness(NewHand);
    ServerSetAutoTaunt(bNewAutoTaunt);
}

// Overidden to support resetting shake and blur values when you posses the pawn
function AcknowledgePossession(Pawn P)
{
	// Tell the server if we want the trader path or not
    if ( Role < ROLE_Authority )
        ServerSetWantsTraderPath(bWantsTraderPath);

	if ( P != None )  {
		StopViewShaking();
		if ( Level.NetMode != NM_DedicatedServer )
			SetBlur(0);
		if ( KFHumanPawn(P) != None && KFHumanPawn(P).KFPC != self )
            KFHumanPawn(P).KFPC = self;
	}
	
	if ( Viewport(Player) != None )  {
		AcknowledgedPawn = P;
		if ( P != None )
			P.SetBaseEyeHeight();
		ServerAcknowledgePossession(P, Handedness, bAutoTaunt);
	}
}

// unpossessed a pawn (not because pawn was killed)
function UnPossess()
{
    if ( Pawn != None )  {
        SetLocation(Pawn.Location);
        Pawn.RemoteRole = ROLE_SimulatedProxy;
        Pawn.UnPossessed();
		CleanOutSavedMoves();  // don't replay moves previous to unpossession
        if ( Viewtarget == Pawn )
            SetViewTarget(self);
    }
    Pawn = None;
    GotoState('Spectating');
}

// Optimized PostBeginPlay() version
simulated event PostBeginPlay()
{
	MaxTimeMargin = Level.MaxTimeMargin;
	MaxResponseTime = default.MaxResponseTime * Level.TimeDilation;
	
	if ( Level.NetMode != NM_Client )
		InitPlayerReplicationInfo();
	else
		SpawnDefaultHUD();
	
	FixFOV();
    SetViewDistance();
    SetViewTarget(self);  // MUST have a view target!
	LastActiveTime = Level.TimeSeconds;
	
	if ( Level.LevelEnterText != "" )
		ClientMessage(Level.LevelEnterText);
	
	if ( Level.NetMode == NM_Standalone )
        AddCheats();
	
	// Precache
	bForcePrecache = Role < ROLE_Authority;
	ForcePrecacheTime = Level.TimeSeconds + 1.2;
	
	if ( Level.Game != None )
		MapHandler = Level.Game.MaplistHandler;
	
	if ( Role == ROLE_Authority )
		InitChatManager();
	
	if ( Level.NetMode != NM_DedicatedServer )
		InitVoiceAnnouncers();
	
	LoadComboList();
	FillCameraList();
    LastKillTime = -5.0;
	
	// Spawn hint manager (if needed)
	UpdateHintManagement(bShowHints);
}

// Have cut out xPlayer class ComboList logic from PlayerTick for now
event PlayerTick( float DeltaTime )
{
	// From the KFPlayerController class
	if ( bHasDelayedSong && Player != None )
		NetPlayMusic(DelayedSongToPlay, 0.5, 0);
	
	if ( Level.GRI != None )  {
		if ( KFGameReplicationInfo(Level.GRI) != None && KFGameReplicationInfo(Level.GRI).EndGameType > 0 )
			Advertising_EnterZone("mp_lobby");
		else if ( Level.GRI.bMatchHasBegun )
			Advertising_ExitZone();
	}

	// From the PlayerController class
	if ( bForcePrecache )  {
		if ( Level.TimeSeconds > ForcePrecacheTime )  {
			bForcePrecache = False;
			Level.FillPrecacheMaterialsArray( false );
			Level.FillPrecacheStaticMeshesArray( false );
		}
	}
	else if ( !bShortConnectTimeOut )  {
		bShortConnectTimeOut = True;
		ServerShortTimeout();
	}

	if ( Pawn != AcknowledgedPawn )  {
		if ( Role < ROLE_Authority )  {
			// make sure old pawn controller is right
			if ( AcknowledgedPawn != None && AcknowledgedPawn.Controller == self )
				AcknowledgedPawn.Controller = None;
		}
		AcknowledgePossession(Pawn);
	}
	
	PlayerInput.PlayerInput(DeltaTime);
	if ( bUpdatePosition )
		ClientUpdatePosition();
	
	if ( !IsSpectating() && Pawn != None )
		Pawn.RawInput(DeltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward, aTurn, aStrafe, aUp, aLookUp);

	PlayerMove(DeltaTime);

	if ( Level.NetMode != NM_DedicatedServer && (BlurTime > 0 || ColorFadeTime > 0) )
		UpdateBlurEffect(DeltaTime);
}

// Set up the widescreen FOV values for this player
// Optimized version of the InitFOV() function
simulated function SetUpWidescreenFOV()
{
	local	Inventory	Inv;
	local	int			i;
	local	float		ResX, ResY;
	local	float		AspectRatio, NewFOV;

    ResX = float(GUIController(Player.GUIController).ResX);
    ResY = float(GUIController(Player.GUIController).ResY);
    AspectRatio = ResX / ResY;

	// 1.6 = 16/10 which is 16:10 ratio and 16:9 comes to 1.77
	if ( bUseTrueWideScreenFOV && AspectRatio >= 1.60 )  {
		/* --- Optimized NewFOV calculation ---
		OriginalAspectRatio = 4 / 3
		AspectRatio * 3.0 / 4.0 = AspectRatio / OriginalAspectRatio
		Pi / 4.0 = 90.0 * Pi / 360.0
		*/
		NewFOV = ATan((Tan(Pi / 4.0) * (AspectRatio * 3.0 / 4.0)), 1.0) * 360.0 / Pi;
		default.DefaultFOV = NewFOV;
		DefaultFOV = NewFOV;
		/*
		// 16X9
		if ( AspectRatio >= 1.70 )
			log("Detected 16X9: "$(float(GUIController(Player.GUIController).ResX) / GUIController(Player.GUIController).ResY));
		else
			log("Detected 16X10: "$(float(GUIController(Player.GUIController).ResX) / GUIController(Player.GUIController).ResY));
		*/
    }
	else  {
		//log("Detected 4X3: "$(float(GUIController(Player.GUIController).ResX) / GUIController(Player.GUIController).ResY));
		default.DefaultFOV = 90.0;
		DefaultFOV = 90.0;
	}

	// Initialize the FOV of all the weapons the player is carrying
	if ( Pawn != None )  {
		for ( Inv = Pawn.Inventory; Inv != None; Inv = Inv.Inventory )  {
			if ( KFWeapon(Inv) != None )
				KFWeapon(Inv).InitFOV();

			// Little hack to catch possible runaway loops. Gotta love those linked listed in UE2.5 - Ramm
			++i;
			if ( i > 10000 )
				Break;
		}
	}

	// Set the FOV to the default FOV
	TransitionFOV(DefaultFOV, 0.0);
}

function ShowBuyMenu( string wlTag, float maxweight )
{
	if ( Level.NetMode != NM_DedicatedServer )
		StopForceFeedback();  // jdf - no way to pause feedback
	// Open menu
	if ( BuyMenuClassName != "" )
		ClientOpenMenu(BuyMenuClassName,, wlTag, string(maxweight));
}

function ShowLobbyMenu()
{
	if ( Level.NetMode != NM_DedicatedServer )
		StopForceFeedback();  // jdf - no way to pause feedback
	
	bPendingLobbyDisplay = False;
	// Open menu
	if ( LobbyMenuClassString != "" )
		ClientOpenMenu(LobbyMenuClassString);
}

function ShowMidGameMenu(bool bPause)
{
	if ( HUDKillingFloor(MyHud).bDisplayInventory )
		HUDKillingFloor(MyHud).HideInventory();
	else  {
		// Pause if not already
		if ( Level.Pauser == None && Level.NetMode == NM_StandAlone )
			SetPause(True);

		if ( Level.NetMode != NM_DedicatedServer )
			StopForceFeedback();  // jdf - no way to pause feedback

		// Open menu
		if ( bDemoOwner )
			ClientOpenMenu(DemoMenuClass);
		else if ( LoginMenuClass != "" )
			ClientOpenMenu(LoginMenuClass);
		else 
			ClientOpenMenu(MidGameMenuClassName);
	}
}

simulated function ShowLoginMenu()
{
	if ( Pawn != None && (Pawn.Health > 0 || (Pawn.PlayerReplicationInfo != None && Pawn.PlayerReplicationInfo.bReadyToPlay)) )
		Return;
	
	if ( LobbyMenuClassString != "" && GameReplicationInfo != None )
		ClientReplaceMenu(LobbyMenuClassString);
}

function ServerSetReadyToStart()
{
	bReadyToStart = True;
}

/* InitInputSystem()
 Spawn the appropriate class of PlayerInput
 Only called for playercontrollers that belong to local players
*/
simulated event InitInputSystem()
{
	// Loading InputClass
	// Need to do this because InputClass is a config variable
	if ( InputClassName != None )
		InputClass = Class<PlayerInput>( DynamicLoadObject(InputClassName, Class'Class') );
	
	if ( InputClass == None )
		log("Warning! No InputClass to initialise!", Name);
	else if ( Role == ROLE_Authority )
		Super(PlayerController).InitInputSystem();

	// InitFOV() has been replaced by my own SetUpWidescreenFOV() function because it was a final function.
	SetUpWidescreenFOV();
	
	if ( Level.NetMode == NM_Client )
		ShowLoginMenu();

	ServerSetReadyToStart();
	bReadyToStart = True;
}

//[block] View Shakers
/* ShakeView()
Call this function to shake the player's view
shaketime = how long to roll view
RollMag = how far to roll view as it shakes
OffsetMag = max view offset
RollRate = how fast to roll view
OffsetRate = how fast to offset view
OffsetTime = how long to offset view (number of shakes)
*/
function ShakeView(
	vector shRotMag,	vector shRotRate,		float shRotTime, 
	vector shOffsetMag,	vector shOffsetRate,	float shOffsetTime )
{
    // VSizeSquared is faster than VSize
	if ( VSizeSquared(shRotMag) > VSizeSquared(ShakeRotMax) )  {
        ShakeRotMax  = shRotMag;
        ShakeRotRate = shRotRate;
        ShakeRotTime = shRotTime * vect(1.0, 1.0, 1.0);
    }

    // VSizeSquared is faster than VSize
	if ( VSizeSquared(shOffsetMag) > VSizeSquared(ShakeOffsetMax) )  {
        ShakeOffsetMax  = shOffsetMag;
        ShakeOffsetRate = shOffsetRate;
        ShakeOffsetTime = shOffsetTime * vect(1.0, 1.0, 1.0);
    }
}

function StopViewShaking()
{
	ShakeRotMax  = vect(0, 0, 0);
	ShakeRotRate = vect(0, 0, 0);
	ShakeRotTime = vect(0, 0, 0);		// It's a vector here
	ShakeOffsetMax  = vect(0, 0, 0);
	ShakeOffsetRate = vect(0, 0, 0);
	ShakeOffsetTime = vect(0, 0, 0);	// It's a vector here
}

event ShakeViewEvent(
	vector shRotMag,	vector shRotRate,		float shRotTime, 
	vector shOffsetMag,	vector shOffsetRate,	float shOffsetTime )
{
	ShakeView( shRotMag, shRotRate, shRotTime, shOffsetMag, shOffsetRate, shOffsetTime );
}

function WeaponShakeView(
	vector shRotMag,	vector shRotRate,		float shRotTime,
	vector shOffsetMag,	vector shOffsetRate,	float shOffsetTime )
{
	if ( bWeaponViewShake )
		ShakeView( (shRotMag * (1.0 - ZoomLevel)), shRotRate, shRotTime, (shOffsetMag * (1.0 - ZoomLevel)), shOffsetRate, shOffsetTime );
}
//[end]

// Old Aim function
function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int aimerror)
{
	local Actor Other;
	local float TraceRange;
	local vector HitLocation,HitNormal;

	if ( Pawn == None || !bBehindview || !bUseAdvBehindview || Vehicle(Pawn) != None )
		Return Super.AdjustAim(FiredAmmunition, projStart, aimerror);
	
	if ( FiredAmmunition.bInstantHit )
		TraceRange = 10000.f;
	else 
		TraceRange = 4000.f;

	PlayerCalcView(CamActor, CamPos, CamRot);
	foreach Pawn.TraceActors(Class'Actor', Other, HitLocation, HitNormal, (CamPos + TraceRange * vector(CamRot)), CamPos)  {
		if ( Other != Pawn && (Other == Level || Other.bBlockActors || Other.bProjTarget || Other.bWorldGeometry)
			 && KFPawn(Other) == None && KFBulletWhipAttachment(Other) == None )
			Break;
	}
	
	if ( FiredAmmunition.bInstantHit && Other != None )
		InstantWarnTarget(Other, FiredAmmunition, vector(Rotation));
	
	if ( Other != None )
		Return rotator(HitLocation - projStart);
	
	Return Rotation;
}

simulated function rotator GetViewRotation()
{
	if ( bBehindView && Pawn != None && (Vehicle(Pawn) != None || !bUseAdvBehindview) )
		Return Pawn.Rotation;
	
	Return Rotation;
}

// Returns camera location, camera rotation vector (if needed) and camera rotation (if needed)
function GetCameraPosition( 
			out	vector	CameraLoc, 
 optional	out	vector	CameraRotVect, 
 optional	out	rotator	CameraRot )
{
	if ( Vehicle(Pawn) != None ) {
		CameraLoc = Vehicle(Pawn).GetCameraLocationStart;
		CameraRot = GetViewRotation();
		CameraRotVect = vector(CameraRot);
	}
	else  {
		PlayerCalcView(CamActor, CameraLoc, CameraRot);
		CameraRotVect = vector(CameraRot);
	}
}

simulated final function bool GetShoulderCam( out vector Pos, Pawn Other )
{
	local vector HL,HN;

	if ( Vehicle(Other) != None )
		Return False;
	
	Pos = Other.Location + Other.EyePosition();
	CamPos = vect(-40, 20, 10) >> Rotation;
	
	if ( Pawn.Trace(HL, HN, (Pos + Normal(CamPos) * (VSize(CamPos) + 10.f)), Pos, false) != None )
		Pos = Pos + Normal(CamPos) * (VSize(HL - Pos) -10.f);
	else 
		Pos += CamPos;

	Return True;
}

event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
    local Pawn PTarget;

	if ( Base != None )
		SetBase(None); // This error may happen on client, causing major desync.

	if ( LastPlayerCalcView == Level.TimeSeconds && CalcViewActor != None 
		 && CalcViewActor.Location == CalcViewActorLocation )  {
		ViewActor = CalcViewActor;
		CameraLocation = CalcViewLocation;
		CameraRotation = CalcViewRotation;
		Return;
	}

	// If desired, call the pawn's own special callview
	// try the 'special' calcview. This may return false if its not applicable, and we do the usual.
	if ( Pawn != None && Pawn.bSpecialCalcView && ViewTarget == Pawn
		 && (Pawn.SpecialCalcView(ViewActor, CameraLocation, CameraRotation)) )  {
		CacheCalcView(ViewActor, CameraLocation, CameraRotation);
		Return;
	}

    if ( ViewTarget == None || ViewTarget.bDeleteMe )  {
		if ( Pawn != None && !Pawn.bDeleteMe )
			SetViewTarget(Pawn);
		else if ( RealViewTarget != None )
			SetViewTarget(RealViewTarget);
		else
			SetViewTarget(self);
    }

    ViewActor = ViewTarget;
    CameraLocation = ViewTarget.Location;

	if ( ViewTarget == Pawn )  {
		// up and behind
		if ( bBehindView )  {
			if ( !bUseAdvBehindview || !GetShoulderCam(CameraLocation, Pawn) )
				CalcBehindView( CameraLocation, CameraRotation, (CameraDist * Pawn.Default.CollisionRadius) );
			else 
				CameraRotation = Rotation;
		}
		else 
			CalcFirstPersonView( CameraLocation, CameraRotation );

		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
		Return;
    }
	
	if ( ViewTarget == self )  {
		CameraRotation = Rotation;
		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
		Return;
	}

    if ( ViewTarget.IsA('Projectile') )  {
        if ( Projectile(ViewTarget).bSpecialCalcView 
			 && Projectile(ViewTarget).SpecialCalcView(ViewActor, CameraLocation, CameraRotation, bBehindView) )  {
            CacheCalcView( ViewActor,CameraLocation,CameraRotation );
            Return;
        }

        if ( !bBehindView )  {
            CameraLocation += (ViewTarget.CollisionHeight) * vect(0,0,1);
            CameraRotation = Rotation;
    		CacheCalcView( ViewActor, CameraLocation, CameraRotation );
			Return;
        }
    }

    CameraRotation = ViewTarget.Rotation;
    PTarget = Pawn(ViewTarget);
    if ( PTarget != None )  {
        if ( Level.NetMode == NM_Client || (bDemoOwner && (Level.NetMode != NM_Standalone)) )  {
            PTarget.SetViewRotation(TargetViewRotation);
            CameraRotation = BlendedTargetViewRotation;
            PTarget.EyeHeight = TargetEyeHeight;
        }
        else if ( PTarget.IsPlayerPawn() )
            CameraRotation = PTarget.GetViewRotation();

		if ( PTarget.bSpecialCalcView 
			 && PTarget.SpectatorSpecialCalcView(self, ViewActor, CameraLocation, CameraRotation) )  {
			CacheCalcView(ViewActor, CameraLocation, CameraRotation);
			Return;
		}

        if ( !bBehindView )
            CameraLocation += PTarget.EyePosition();
    }
    
	if ( bBehindView )  {
        CameraLocation = CameraLocation + (ViewTarget.Default.CollisionHeight - ViewTarget.CollisionHeight) * vect(0,0,1);
        CalcBehindView( CameraLocation, CameraRotation, (CameraDist * ViewTarget.Default.CollisionRadius) );
    }

	CacheCalcView( ViewActor, CameraLocation, CameraRotation );
}

exec function ChangeCharacter(string newCharacter, optional string inClass)
{
	local UM_SRClientPerkRepLink S;

	S = Class'UM_SRClientPerkRepLink'.Static.FindStats(Self);
	if ( S != None )
		S.SelectedCharacter(newCharacter);
	else 
		Super.ChangeCharacter(newCharacter,inClass);
}

function SetPawnClass(string inClass, string inCharacter)
{
	if ( UM_SRStatsBase(SteamStatsAndAchievements) != None )
		UM_SRStatsBase(SteamStatsAndAchievements).ChangeCharacter(inCharacter);
	else  {
		PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(inCharacter);
		PlayerReplicationInfo.SetCharacterName(inCharacter);
	}
}

// Called from GameType actor from DoWaveEnd() function in MatchInProgress state
simulated function SendSelectedVeterancyToServer(optional bool bForceChange)
{
	if ( Level.NetMode != NM_Client && UM_SRStatsBase(SteamStatsAndAchievements) != None )
		UM_SRStatsBase(SteamStatsAndAchievements).WaveEnded();
}

function SelectVeterancy(class<KFVeterancyTypes> VetSkill, optional bool bForceChange)
{
	if ( UM_SRStatsBase(SteamStatsAndAchievements) != None )
		UM_SRStatsBase(SteamStatsAndAchievements).ServerSelectPerk(Class<UM_SRVeterancyTypes>(VetSkill));
}

// Allow clients fix the behindview bug themself
exec function BehindView( Bool B )
{
	// Allow vehicles to limit view changes
	if ( Vehicle(Pawn) == None || Vehicle(Pawn).bAllowViewChange )  {
		ClientSetBehindView(B);
		bBehindView = B;
	}
}

exec function ToggleBehindView()
{
	ServerToggleBehindview();
}

function ServerToggleBehindview()
{
	local bool B;

	if ( Vehicle(Pawn) == None || Vehicle(Pawn).bAllowViewChange )  {
		B = !bBehindView;
		ClientSetBehindView(B);
		bBehindView = B;
	}
}

// Fix for vehicle mod crashes.
simulated function postfxon(int i)
{
	if ( Viewport(Player) != None )
		Super.postfxon(i);
}

simulated function postfxoff(int i)
{
	if ( Viewport(Player) != None )
		Super.postfxoff(i);
}

simulated function postfxblur(float f)
{
	if ( Viewport(Player) != None )
		Super.postfxblur(f);
}
simulated function postfxbw(float f, optional bool bDoNotTurnOffFadeFromBlackEffect)
{
	if ( Viewport(Player) != None )
		Super.postfxbw(f,bDoNotTurnOffFadeFromBlackEffect);
}

// Sets the bWantsTraderPath var on the server, since thats where its used
function ServerSetWantsTraderPath( bool bNewWantsTraderPath )
{
	bWantsTraderPath = bNewWantsTraderPath;
}

// Show the path the trader
function Timer()
{
	if ( !bWantsTraderPath )  {
        bShowTraderPath = False;
        SetTimer(0.0, False);
    }
    // Fairly lame place to call this, but I need a place that is called very often that is run on the server
	else if ( Role == ROLE_Authority && bShowTraderPath )
		UnrealMPGameInfo(Level.Game).ShowPathTo(Self, 0);
	
	// Achievements
	if ( Role == ROLE_Authority && Pawn != None && Pawn.Health > 0 )  {
		// Survived 10 Seconds After Vomit
		if ( bVomittedOn )  {
			if ( (Level.TimeSeconds - VomittedOnTime) >= 10.0 )  {
				if ( KFSteamStatsAndAchievements(SteamStatsAndAchievements) != None )  {
					KFSteamStatsAndAchievements(SteamStatsAndAchievements).Survived10SecondsAfterVomit();
					bVomittedOn = False;
				}
			}
			else if ( !bTimerLoop || TimerRate == 0.0 )
				SetTimer( (10.0 - (Level.TimeSeconds - VomittedOnTime)), False);
		}
		// Survived 10 Seconds After Scream
		if ( bScreamedAt )  {
			if ( (Level.TimeSeconds - ScreamTime) >= 10.0 )  {
				if ( KFSteamStatsAndAchievements(SteamStatsAndAchievements) != None )  {
					KFSteamStatsAndAchievements(SteamStatsAndAchievements).Survived10SecondsAfterScream();
					bScreamedAt = False;
				}
			}
			else if ( !bTimerLoop || TimerRate == 0.0 )
				SetTimer( (10.0 - (Level.TimeSeconds - ScreamTime)), False);
		}
	}
}

// Handle toggling showing the path to the trader
function SetShowPathToTrader( bool bShouldShowPath )
{
	if ( bWantsTraderPath && bShouldShowPath )  {
		Timer();
		bShowTraderPath = True;
		SetTimer(TraderPathInterval, True);
	}
	else  {
		bShowTraderPath = False;
		SetTimer(0.0, False);
	}
}

exec function TogglePathToTrader()
{
	SetShowPathToTrader( !bShowTraderPath );
}

// Just changed to pendingWeapon
function ChangedWeapon()
{
	if ( Pawn != None && Pawn.Weapon != None )  {
		Pawn.Weapon.SetHand(Handedness);
		LastPawnWeapon = Pawn.Weapon.Class;
	}
}

exec function SwitchToBestWeapon()
{
	local	float	rating;

	if ( Pawn == None || Pawn.Inventory == None )
		Return;

    if ( Pawn.PendingWeapon == None || AIController(self) != None )  {
	    Pawn.PendingWeapon = Pawn.Inventory.RecommendWeapon(rating);
	    if ( Pawn.PendingWeapon == Pawn.Weapon )
		    Pawn.PendingWeapon = None;
	    if ( Pawn.PendingWeapon == None )
    		Return;
    }

	StopFiring();

	if ( Pawn.Weapon == None )  {
		if ( Role < ROLE_Authority )
			Pawn.ChangedWeapon();
	}
	else if ( Pawn.Weapon != Pawn.PendingWeapon )
		Pawn.Weapon.PutDown();
}

// server calls this to force client to switch
function ClientSwitchToBestWeapon()
{
    SwitchToBestWeapon();
}

function ClientSetWeapon( class<Weapon> WeaponClass )
{
	local	Inventory	Inv;
	local	int			Count;

	for( Inv = Pawn.Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
		if ( ClassIsChildOf( Inv.Class, WeaponClass ) )  {
			if ( Pawn.Weapon == None )  {
				Pawn.PendingWeapon = Weapon(Inv);
				if ( Role < ROLE_Authority )
					Pawn.ChangedWeapon();
			}
			else if ( Pawn.Weapon != Weapon(Inv) )  {
				Pawn.PendingWeapon = Weapon(Inv);
				Pawn.Weapon.PutDown();
			}
			Return;
		}
		++Count;
	}
}


// Hide weapon highlight when using this shortcut key.
exec function SwitchWeapon(byte F)
{
	local Weapon W;

	if ( Pawn != None )  {
		W = Pawn.PendingWeapon;
		Pawn.SwitchWeapon(F);
		if ( W != Pawn.PendingWeapon && HudKillingFloor(MyHUD) != None )  {
			HudKillingFloor(MyHUD).SelectedInventory = Pawn.PendingWeapon;
			HudKillingFloor(MyHUD).HideInventory();
		}
	}
}

function ServerSpeech( name Type, int Index, string Callsign )
{
	// Disallow players to use trader lines.
	if ( Type != 'Trader' )
		Super.ServerSpeech(Type,Index,Callsign);
}

defaultproperties
{
	PlayerReplicationInfoClass="UnlimaginMod.UM_PlayerReplicationInfo"
	InputClass=None
	InputClassName="UnlimaginMod.UM_PlayerInput"
	LobbyMenuClassString="UnlimaginMod.UM_SRLobbyMenu"
	MidGameMenuClassName="UnlimaginMod.UM_SRInvasionLoginMenu"
	BuyMenuClassName="UnlimaginMod.UM_SRGUIBuyMenu"
	SteamStatsAndAchievementsClass=None
	SteamStatsAndAchievementsClassName="UnlimaginServer.UM_ServerStStats"
	PawnClass=Class'UnlimaginMod.UM_HumanPawn'
}