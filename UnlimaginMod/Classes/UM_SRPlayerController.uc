class UM_SRPlayerController extends KFPlayerController;

var transient	vector		CamPos;
var transient	rotator		CamRot;
var transient	Actor		CamActor;
var				bool		bUseAdvBehindview;

var				string		SteamStatsAndAchievementsClassName; 
var				string		MidGameMenuClassName, InputClassName;

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
}*/

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
	InputClass = Class<PlayerInput>( DynamicLoadObject(InputClassName, Class'Class') );
	PlayerInput = new(self) InputClass;
	
	if ( LoginMenuClass != "" )
		ShowLoginMenu();

	InitFOV();
	
	//ToDo: тут, возможно, следует использовать одну общую функцию, 
	// вместо приравнивания и вызова функции, просто вызывать функцию, вместе с репликацией.
	bReadyToStart = True;
	ServerSetReadyToStart();
}


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

	PlayerCalcView(CamActor,CamPos,CamRot);
	foreach Pawn.TraceActors(Class'Actor', Other,HitLocation, HitNormal, (CamPos + TraceRange * vector(CamRot)), CamPos)  {
		if ( Other != Pawn && (Other==Level || Other.bBlockActors || Other.bProjTarget || Other.bWorldGeometry)
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
    if ( (bBehindView && !bUseAdvBehindview && Pawn != None) || (bBehindView && Vehicle(Pawn) != None) )
        Return Pawn.Rotation;
    
	Return Rotation;
}

simulated final function bool GetShoulderCam( out vector Pos, Pawn Other )
{
	local vector HL,HN;

	if ( Vehicle(Other) != None )
		Return False;
	
	Pos = Other.Location + Other.EyePosition();
	CamPos = vect(-40,20,10) >> Rotation;
	
	if ( Pawn.Trace(HL, HN, (Pos + Normal(CamPos) * (VSize(CamPos) + 10.f)), Pos, false) != None )
		Pos = Pos + Normal(CamPos) * (VSize(HL - Pos) -10.f);
	else 
		Pos += CamPos;

	Return True;
}

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
    local Pawn PTarget;

	if ( Base != None )
		SetBase(None); // This error may happen on client, causing major desync.

	if ( LastPlayerCalcView == Level.TimeSeconds && CalcViewActor != None 
		 && CalcViewActor.Location == CalcViewActorLocation )  {
		ViewActor	= CalcViewActor;
		CameraLocation	= CalcViewLocation;
		CameraRotation	= CalcViewRotation;
		Return;
	}

	// If desired, call the pawn's own special callview
	// try the 'special' calcview. This may return false if its not applicable, and we do the usual.
	if ( Pawn != None && Pawn.bSpecialCalcView && ViewTarget == Pawn
		 && (Pawn.SpecialCalcView(ViewActor, CameraLocation, CameraRotation)) )  {
		CacheCalcView(ViewActor,CameraLocation,CameraRotation);
		Return;
	}

    if ( ( ViewTarget == None ) || ViewTarget.bDeleteMe )  {
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
			if ( !bUseAdvBehindview || !GetShoulderCam(CameraLocation,Pawn) )
				CalcBehindView(CameraLocation, CameraRotation, (CameraDist * Pawn.Default.CollisionRadius));
			else 
				CameraRotation = Rotation;
		}
		else 
			CalcFirstPersonView( CameraLocation, CameraRotation );

		CacheCalcView(ViewActor,CameraLocation,CameraRotation);
        
		Return;
    }
	
	if ( ViewTarget == self )  {
		CameraRotation = Rotation;
		CacheCalcView(ViewActor, CameraLocation, CameraRotation);
		Return;
	}

    if ( ViewTarget.IsA('Projectile') )  {
        if ( Projectile(ViewTarget).bSpecialCalcView 
			 && Projectile(ViewTarget).SpecialCalcView(ViewActor, CameraLocation, CameraRotation, bBehindView) )  {
            CacheCalcView(ViewActor,CameraLocation,CameraRotation);
            Return;
        }

        if ( !bBehindView )  {
            CameraLocation += (ViewTarget.CollisionHeight) * vect(0,0,1);
            CameraRotation = Rotation;
    		CacheCalcView(ViewActor,CameraLocation,CameraRotation);
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
        CalcBehindView(CameraLocation, CameraRotation, (CameraDist * ViewTarget.Default.CollisionRadius));
    }

	CacheCalcView(ViewActor,CameraLocation,CameraRotation);
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

function SendSelectedVeterancyToServer(optional bool bForceChange)
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

function ShowBuyMenu(string wlTag,float maxweight)
{
	StopForceFeedback();
	// Open menu
	ClientOpenMenu("UnlimaginMod.UM_SRGUIBuyMenu",,wlTag,string(maxweight));
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
			ClientopenMenu(DemoMenuClass);
		else if ( LoginMenuClass != "" )
			ClientOpenMenu(LoginMenuClass);
		else 
			ClientOpenMenu(MidGameMenuClassName);
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
	InputClassName="UnlimaginMod.UM_KFPlayerInput"
	LobbyMenuClassString="UnlimaginMod.UM_SRLobbyMenu"
	MidGameMenuClassName="UnlimaginMod.UM_SRInvasionLoginMenu"
	SteamStatsAndAchievementsClass=None
	SteamStatsAndAchievementsClassName="UnlimaginServer.UM_ServerStStats"
	PawnClass=Class'UnlimaginMod.UM_SRHumanPawn'
}