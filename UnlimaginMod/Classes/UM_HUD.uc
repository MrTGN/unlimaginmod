class UM_HUD extends HUDKillingFloor;

#exec obj load file="KFMapEndTextures.utx"
#exec obj load file="2K4Menus.utx"

struct SmileyMessageType
{
	var string SmileyTag;
	var texture SmileyTex;
	var bool bInCAPS;
};
var array<SmileyMessageType> SmileyMsgs;

var UM_ClientRepInfoLink ClientRep;
var transient float OldDilation,CurrentBW,DesiredBW,NextLevelTimer,LevelProgressBar,VisualProgressBar;
var bool bUseBloom,bUseMotionBlur,bDisplayingProgress;
var transient bool bFadeBW;

var		UM_Syringe		Syringe;

var()   SpriteWidget            SlowMoChargeBG;
var()   SpriteWidget            SlowMoChargeIcon;
var()   NumericWidget           SlowMoChargeDigits;

var()   SpriteWidget            StaminaBG;
var()   SpriteWidget            StaminaIcon;
var()   NumericWidget           StaminaDigits;

simulated function SetHUDAlpha()
{
	Super.SetHUDAlpha();
	// SlowMoCharge
	SlowMoChargeBG.Tints[0].A = KFHUDAlpha;
	SlowMoChargeBG.Tints[1].A = KFHUDAlpha;
	SlowMoChargeIcon.Tints[0].A = KFHUDAlpha;
	SlowMoChargeIcon.Tints[1].A = KFHUDAlpha;
	SlowMoChargeDigits.Tints[0].A = KFHUDAlpha;
	SlowMoChargeDigits.Tints[1].A = KFHUDAlpha;
	// Stamina
	StaminaBG.Tints[0].A = KFHUDAlpha;
	StaminaBG.Tints[1].A = KFHUDAlpha;
	StaminaIcon.Tints[0].A = KFHUDAlpha;
	StaminaIcon.Tints[1].A = KFHUDAlpha;
	StaminaDigits.Tints[0].A = KFHUDAlpha;
	StaminaDigits.Tints[1].A = KFHUDAlpha;
}

simulated event PostBeginPlay()
{
	local Font MyFont;

	Super(HudBase).PostBeginPlay();
	SetHUDAlpha();

	foreach DynamicActors(class'KFSPLevelInfo', KFLevelRule)
		Break;

	Hint_45_Time = 9999999;

	MyFont = LoadWaitingFont(0);
	MyFont = LoadWaitingFont(1);

	bUseBloom = bool(ConsoleCommand("get ini:Engine.Engine.ViewportManager Bloom"));
	bUseMotionBlur = Class'KFHumanPawn'.Default.bUseBlurEffect;
}

simulated function FindPlayerGrenade()
{
	if ( UM_HumanPawn(PawnOwner) == None )
		Return;
	
	PlayerGrenade = Frag( UM_HumanPawn(PawnOwner).FindInventoryItem(Class'UnlimaginMod.UM_Weapon_HandGrenade', True) );
}

simulated function FindSyringe()
{
	if ( UM_HumanPawn(PawnOwner) == None )
		Return;
	
	Syringe = UM_Syringe( UM_HumanPawn(PawnOwner).FindInventoryItem(Class'UnlimaginMod.UM_Syringe', True) );
}

simulated function ShowQuickSyringe()
{
	if ( bDisplayQuickSyringe )  {
		if ( (Level.TimeSeconds - QuickSyringeStartTime) > QuickSyringeFadeInTime )  {
			if ( (Level.TimeSeconds - QuickSyringeStartTime) > (QuickSyringeDisplayTime - QuickSyringeFadeOutTime) )
				QuickSyringeStartTime = Level.TimeSeconds - QuickSyringeFadeInTime + ((QuickSyringeDisplayTime - (Level.TimeSeconds - QuickSyringeStartTime)) * QuickSyringeFadeInTime);
			else
				QuickSyringeStartTime = Level.TimeSeconds - QuickSyringeFadeInTime;
		}
	}
	else  {
		bDisplayQuickSyringe = True;
		QuickSyringeStartTime = Level.TimeSeconds;
	}
}

simulated function UpdateHud()
{
	local	float			MaxGren, CurGren;
	local	UM_HumanPawn	HumanPawn;

	if ( PawnOwner == None )  {
		Super(HudBase).UpdateHud();
		Return;
	}

	HumanPawn = UM_HumanPawn(PawnOwner);
	CalculateAmmo();
	
	if ( HumanPawn != None )
		FlashlightDigits.Value = int( 100.0 * (float(HumanPawn.TorchBatteryLife) / float(HumanPawn.default.TorchBatteryLife)) );
	
	if ( KFWeapon(PawnOwner.Weapon) != None )  {
		BulletsInClipDigits.Value = Max( KFWeapon(PawnOwner.Weapon).MagAmmoRemaining, 0 );
		ClipsDigits.Value = KFWeapon(PawnOwner.Weapon).AmmoAmount(0);
		SecondaryClipsDigits.Value = KFWeapon(PawnOwner.Weapon).AmmoAmount(1);
	}
	else  {
		ClipsDigits.Value = CurClipsPrimary;
		SecondaryClipsDigits.Value = CurClipsSecondary;
	}
	
	if ( PlayerGrenade == None )
		FindPlayerGrenade();
	
	if ( PlayerGrenade != None )  {
		PlayerGrenade.GetAmmoCount(MaxGren, CurGren);
		GrenadeDigits.Value = CurGren;
	}
	else
		GrenadeDigits.Value = 0;
	
	if ( Vehicle(PawnOwner) != None )  {
		if ( Vehicle(PawnOwner).Driver != None )
			HealthDigits.Value = Vehicle(PawnOwner).Driver.Health;
		ArmorDigits.Value = PawnOwner.Health;
	}
	else  {
		HealthDigits.Value = PawnOwner.Health;
		if ( HumanPawn != None )
			ArmorDigits.Value = HumanPawn.ShieldStrength;
	}
	
	// "Poison" the health meter
	if ( VomitHudTimer > Level.TimeSeconds )  {
		// Tints[0]
		HealthDigits.Tints[0].R = 196;
		HealthDigits.Tints[0].G = 206;
		HealthDigits.Tints[0].B = 0;
		// Tints[1]
		HealthDigits.Tints[1].R = 196;
		HealthDigits.Tints[1].G = 206;
		HealthDigits.Tints[1].B = 0;
	}
	else if ( HealthDigits.Value < 50 )  {
		if ( Level.TimeSeconds < SwitchDigitColorTime )  {
			// Tints[0]
			HealthDigits.Tints[0].R = 255;
			HealthDigits.Tints[0].G = 200;
			HealthDigits.Tints[0].B = 0;
			// Tints[1]
			HealthDigits.Tints[1].R = 255;
			HealthDigits.Tints[1].G = 200;
			HealthDigits.Tints[1].B = 0;
		}
		else  {
			// Tints[0]
			HealthDigits.Tints[0].R = 255;
			HealthDigits.Tints[0].G = 0;
			HealthDigits.Tints[0].B = 0;
			// Tints[1]
			HealthDigits.Tints[1].R = 255;
			HealthDigits.Tints[1].G = 0;
			HealthDigits.Tints[1].B = 0;
			// SwitchDigitColorTime
			if ( Level.TimeSeconds > (SwitchDigitColorTime + 0.2) )
				SwitchDigitColorTime = Level.TimeSeconds + 0.2;
		}
	}
	else  {
		// Tints[0]
		HealthDigits.Tints[0].R = 255;
		HealthDigits.Tints[0].G = 50;
		HealthDigits.Tints[0].B = 50;
		// Tints[1]
		HealthDigits.Tints[1].R = 255;
		HealthDigits.Tints[1].G = 50;
		HealthDigits.Tints[1].B = 50;
	}
	
	if ( PawnOwnerPRI != None )
		CashDigits.Value = PawnOwnerPRI.Score;
	else
		CashDigits.Value = 0;
	
	WelderDigits.Value = 100 * (CurAmmoPrimary / MaxAmmoPrimary);
	SyringeDigits.Value = WelderDigits.Value;
	if ( SyringeDigits.Value < 50 )  {
		// Tints[0]
		SyringeDigits.Tints[0].R = 128;
		SyringeDigits.Tints[0].G = 128;
		SyringeDigits.Tints[0].B = 128;
		// Tints[1]
		SyringeDigits.Tints[1] = SyringeDigits.Tints[0];
	}
	else if ( SyringeDigits.Value < 100 )  {
		// Tints[0]
		SyringeDigits.Tints[0].R = 192;
		SyringeDigits.Tints[0].G = 96;
		SyringeDigits.Tints[0].B = 96;
		// Tints[1]
		SyringeDigits.Tints[1] = SyringeDigits.Tints[0];
	}
	else  {
		// Tints[0]
		SyringeDigits.Tints[0].R = 255;
		SyringeDigits.Tints[0].G = 64;
		SyringeDigits.Tints[0].B = 64;
		// Tints[1]
		SyringeDigits.Tints[1] = SyringeDigits.Tints[0];
	}
	
	// QuickSyringe
	if ( bDisplayQuickSyringe )  {
		if ( Syringe == None )
			FindSyringe();
		// Syringe found
		if ( Syringe != None )  {
			QuickSyringeDigits.Value = Syringe.ChargeBar() * 100;
			if ( QuickSyringeDigits.Value < 50 )  {
				// Tints[0]
				QuickSyringeDigits.Tints[0].R = 128;
				QuickSyringeDigits.Tints[0].G = 128;
				QuickSyringeDigits.Tints[0].B = 128;
				// Tints[1]
				QuickSyringeDigits.Tints[1] = QuickSyringeDigits.Tints[0];
			}
			else if ( QuickSyringeDigits.Value < 100 )  {
				// Tints[0]
				QuickSyringeDigits.Tints[0].R = 192;
				QuickSyringeDigits.Tints[0].G = 96;
				QuickSyringeDigits.Tints[0].B = 96;
				// Tints[1]
				QuickSyringeDigits.Tints[1] = QuickSyringeDigits.Tints[0];
			}
			else  {
				// Tints[0]
				QuickSyringeDigits.Tints[0].R = 255;
				QuickSyringeDigits.Tints[0].G = 64;
				QuickSyringeDigits.Tints[0].B = 64;
				// Tints[1]
				QuickSyringeDigits.Tints[1] = QuickSyringeDigits.Tints[0];
			}
		}
	}
	
	if ( PawnOwner.Health <= 50 && KFPlayerController(PlayerOwner) != None )
		KFPlayerController(PlayerOwner).CheckForHint(51);

	Super(HudBase).UpdateHud();
}

function DrawCustomBeacon(Canvas C, Pawn P, float ScreenLocX, float ScreenLocY);

simulated function DrawKFHUDTextElements(Canvas C)
{
	local float    XL, YL;
	local int      Mnt, Sec;
	local string   S;
	local vector   Pos, FixedZPos;
	local rotator  ShopDirPointerRotation;
	local float    CircleSize;
	local float    ResScale;

	if ( PlayerOwner == None || KFGRI == None || !KFGRI.bMatchHasBegun || (KFPlayerController(PlayerOwner) != None && KFPlayerController(PlayerOwner).bShopping) )
		Return;

	ResScale =  C.SizeX / 1024.0;
	CircleSize = FMin(128 * ResScale,128);
	C.FontScaleX = FMin(ResScale,1.0);
	C.FontScaleY = FMin(ResScale,1.0);
	C.SetDrawColor(255, 255, 255, 255);
	C.SetPos(C.ClipX - CircleSize, 2);
	
	// Wave is in progress now
	if ( KFGRI.bWaveInProgress )  {
		//Hints
		if ( KFPlayerController(PlayerOwner) != None )  {
			KFPlayerController(PlayerOwner).CheckForHint(30);
			if ( !bHint_45_TimeSet && KFGRI.WaveNumber == 1 )  {
				Hint_45_Time = Level.TimeSeconds + 5.0;
				bHint_45_TimeSet = True;
			}
		}
		C.DrawTile(Material'KillingFloorHUD.HUD.Hud_Bio_Circle', CircleSize, CircleSize, 0, 0, 256, 256);
		// Show monsters count if MaxMonsters is enabled
		if ( KFGRI.MaxMonstersOn )  {
			S = string(KFGRI.MaxMonsters);
			C.Font = LoadFont(1);
			C.Strlen(S, XL, YL);
			C.SetDrawColor(255, 50, 50, KFHUDAlpha);
			C.SetPos((C.ClipX - CircleSize / 2 - XL / 2), (CircleSize / 2 - YL / 1.5));
			C.DrawText(S);
		}
		// Show time until the wave end
		else  {
			Mnt = KFGRI.TimeToNextWave / 60;
			Sec = KFGRI.TimeToNextWave - Mnt * 60;
			S = Eval( (Mnt > 9), string(Mnt), "0" $ string(Mnt) ) $ ":" $ Eval( (Sec > 9), string(Sec), "0" $ string(Sec) );
			C.Font = LoadFont(1);
			C.Strlen(S, XL, YL);
			C.SetDrawColor(255, 50, 50, KFHUDAlpha);
			C.SetPos((C.ClipX - CircleSize / 2 - XL / 2), (CircleSize / 2 - YL / 1.5));
			C.DrawText(S);
		}

		// Show the number of waves
		S = WaveString @ string(KFGRI.WaveNumber + 1) $ "/" $ string(KFGRI.FinalWave);
		C.Font = LoadFont(5);
		C.Strlen(S, XL, YL);
		C.SetPos((C.ClipX - CircleSize / 2 - XL / 2), (CircleSize / 2 + YL / 2.5));
		C.DrawText(S);

		//Needed for the hints showing up in the second downtime
		bIsSecondDowntime = True;
	}
	// Countdown Text
	else  {
		C.DrawTile(Material'KillingFloorHUD.HUD.Hud_Bio_Clock_Circle', CircleSize, CircleSize, 0, 0, 256, 256);
		if ( KFGRI.TimeToNextWave <= 5 && bIsSecondDowntime )
			KFPlayerController(PlayerOwner).CheckForHint(40);

		Mnt = KFGRI.TimeToNextWave / 60;
		Sec = KFGRI.TimeToNextWave - Mnt * 60;
		S = Eval( (Mnt > 9), string(Mnt), "0" $ string(Mnt) ) $ ":" $ Eval( (Sec > 9), string(Sec), "0" $ string(Sec) );
		C.Font = LoadFont(2);
		C.Strlen(S, XL, YL);
		C.SetDrawColor(255, 50, 50, KFHUDAlpha);
		C.SetPos(C.ClipX - CircleSize/2 - (XL / 2), CircleSize/2 - YL / 2);
		C.DrawText(S, False);
	}

	C.FontScaleX = 1;
	C.FontScaleY = 1;


	if ( KFPRI == None || KFPRI.Team == None || KFPRI.bOnlySpectator )
		Return;

	// Draw the shop pointer
	if ( ShopDirPointer == None )  {
		ShopDirPointer = Spawn(Class'KFShopDirectionPointer');
		ShopDirPointer.bHidden = bHideHud;
	}

	Pos.X = C.SizeX / 18.0;
	Pos.Y = C.SizeX / 18.0;
	Pos = PlayerOwner.Player.Console.ScreenToWorld(Pos) * 10.0 * (PlayerOwner.default.DefaultFOV / PlayerOwner.FovAngle) + PlayerOwner.CalcViewLocation;
	ShopDirPointer.SetLocation(Pos);

	if ( KFGRI.CurrentShop != None )  {
		// Let's check for a real Z difference (i.e. different floor) doesn't make sense to rotate the arrow
		// only because the trader is a midget or placed slightly wrong
		if ( KFGRI.CurrentShop.Location.Z > PawnOwner.Location.Z + 50.0 || KFGRI.CurrentShop.Location.Z < PawnOwner.Location.Z - 50.f )
		    ShopDirPointerRotation = rotator(KFGRI.CurrentShop.Location - PawnOwner.Location);
		else  {
		    FixedZPos = KFGRI.CurrentShop.Location;
		    FixedZPos.Z = PawnOwner.Location.Z;
		    ShopDirPointerRotation = rotator(FixedZPos - PawnOwner.Location);
		}
	}
	else  {
		ShopDirPointer.bHidden = True;
		Return;
	}

	ShopDirPointer.SetRotation(ShopDirPointerRotation);

	if ( Level.TimeSeconds > Hint_45_Time && Level.TimeSeconds < (Hint_45_Time + 2) && KFPlayerController(PlayerOwner) != None )
		KFPlayerController(PlayerOwner).CheckForHint(45);

	C.DrawActor(None, False, True); // Clear Z.
	ShopDirPointer.bHidden = False;
	C.DrawActor(ShopDirPointer, False, False);
	ShopDirPointer.bHidden = True;
	DrawTraderDistance(C);
}

simulated function DrawSpectatingHud(Canvas C)
{
	local rotator CamRot;
	local vector CamPos, ViewDir, ScreenPos;
	local KFPawn KFBuddy;

	DrawModOverlay(C);

	if( bHideHud )
		Return;

	PlayerOwner.PostFX_SetActive(0, False);

	// Grab our View Direction
	C.GetCameraLocation(CamPos, CamRot);
	ViewDir = vector(CamRot);

	// Draw the Name, Health, Armor, and Veterancy above other players (using this way to fix portal's beacon errors).
	foreach VisibleCollidingActors(Class'KFPawn',KFBuddy,1000.f,CamPos)
	{
		KFBuddy.bNoTeamBeacon = True;
		if ( KFBuddy.PlayerReplicationInfo!=None && KFBuddy.Health>0 && ((KFBuddy.Location - CamPos) Dot ViewDir)>0.8 )
		{
			ScreenPos = C.WorldToScreen(KFBuddy.Location+vect(0,0,1)*KFBuddy.CollisionHeight);
			if( ScreenPos.X>=0 && ScreenPos.Y>=0 && ScreenPos.X<=C.ClipX && ScreenPos.Y<=C.ClipY )
				DrawPlayerInfo(C, KFBuddy, ScreenPos.X, ScreenPos.Y);
		}
	}

	DrawFadeEffect(C);

	if ( KFPlayerController(PlayerOwner) != None && KFPlayerController(PlayerOwner).ActiveNote != None )
		KFPlayerController(PlayerOwner).ActiveNote = None;

	if( KFGameReplicationInfo(Level.GRI) != None && KFGameReplicationInfo(Level.GRI).EndGameType > 0 )
	{
		if( KFGameReplicationInfo(Level.GRI).EndGameType == 2 )
		{
			DrawEndGameHUD(C, True);
			Return;
		}
		else DrawEndGameHUD(C, False);
	}

	DrawKFHUDTextElements(C);
	DisplayLocalMessages(C);

	if ( bShowScoreBoard && ScoreBoard != None )
		ScoreBoard.DrawScoreboard(C);

	// portrait
	if ( bShowPortrait && Portrait != None )
		DrawPortrait(C);

	// Draw hints
	if ( bDrawHint )
		DrawHint(C);
}

// For debugging headshots
simulated function DrawHeadShotSphere() // Dave@Psyonix
{
	local	UM_BaseMonster	Monster;
	local	coords			CO;
	local	vector			HeadLoc;

	//super.DrawHeadShotSphere();

	foreach DynamicActors( class'UM_BaseMonster', Monster )  {
		if ( Monster != None && Monster.ServerHeadLocation != Monster.LastServerHeadLocation )  {
			//Monster.DrawDebugSphere(Monster.Location + (Monster.OnlineHeadshotOffset >> Monster.Rotation), Monster.HeadRadius * Monster.HeadScale * Monster.OnlineHeadshotScale, 10, 0, 255, 0);
			ClearStayingDebugLines();
			Monster.LastServerHeadLocation = Monster.ServerHeadLocation;
			// HeadLocation on the server
			DrawStayingDebugSphere(Monster.ServerHeadLocation, Monster.HeadRadius * Monster.HeadScale, 10, 255, 0, 0);
			CO = Monster.GetBoneCoords(Monster.HeadBone);
			HeadLoc = CO.Origin + (Monster.HeadHeight * Monster.HeadScale * CO.XAxis);
			// HeadLocation on Client side
			DrawStayingDebugSphere(HeadLoc, Monster.HeadRadius * Monster.HeadScale, 10, 0, 255, 0);
			Break;
		}
	}
}

simulated function DrawHud( Canvas C )
{
	local	KFGameReplicationInfo	CurrentGame;
	local	rotator					CamRot;
	local	vector					CamPos, ViewDir, ScreenPos;
	local	KFPawn					KFBuddy;

	CurrentGame = KFGameReplicationInfo(PlayerOwner.Level.GRI);

	if ( FontsPrecached < 2 )
		PrecacheFonts(C);

	UpdateHud();
	PassStyle = STY_Modulated;
	DrawModOverlay(C);

	if ( bUseBloom )
		PlayerOwner.PostFX_SetActive(0, True);

	if ( bHideHud )  {
		// Draw fade effects even if the hud is hidden so poeple can't just turn off thier hud
		C.Style = ERenderStyle.STY_Alpha;
		DrawFadeEffect(C);
		Return;
	}

	if ( !KFPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bViewingMatineeCinematic )  {
		if ( bShowTargeting )
			DrawTargeting(C);

		// Grab our View Direction
		C.GetCameraLocation(CamPos,CamRot);
		ViewDir = vector(CamRot);

		// Draw the Name, Health, Armor, and Veterancy above other players (using this way to fix portal's beacon errors).
		foreach VisibleCollidingActors(Class'KFPawn',KFBuddy,1000.f,CamPos)  {
			KFBuddy.bNoTeamBeacon = True;
			if ( KFBuddy != PawnOwner && KFBuddy.PlayerReplicationInfo != None && KFBuddy.Health > 0 && ((KFBuddy.Location - CamPos) Dot ViewDir) > 0.8 )  {
				ScreenPos = C.WorldToScreen(KFBuddy.Location+vect(0,0,1) * KFBuddy.CollisionHeight);
				if ( ScreenPos.X >= 0 && ScreenPos.Y >= 0 && ScreenPos.X <= C.ClipX && ScreenPos.Y <= C.ClipY )
					DrawPlayerInfo(C, KFBuddy, ScreenPos.X, ScreenPos.Y);
			}
		}

		PassStyle = STY_Alpha;
		DrawDamageIndicators(C);
		DrawHudPassA(C);
		DrawHudPassC(C);

		if ( KFPlayerController(PlayerOwner) != None && KFPlayerController(PlayerOwner).ActiveNote != None )  {
			if ( PlayerOwner.Pawn == None )
				KFPlayerController(PlayerOwner).ActiveNote = None;
			else
				KFPlayerController(PlayerOwner).ActiveNote.RenderNote(C);
		}

		PassStyle = STY_None;
		DisplayLocalMessages(C);
		DrawWeaponName(C);
		DrawVehicleName(C);

		PassStyle = STY_Alpha;

		if ( CurrentGame != None && CurrentGame.EndGameType > 0 )  {
			DrawEndGameHUD(C, (CurrentGame.EndGameType == 2));
			Return;
		}

		RenderFlash(C);
		C.Style = PassStyle;
		DrawKFHUDTextElements(C);
	}
	
	if ( KFPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).bViewingMatineeCinematic )  {
		PassStyle = STY_Alpha;
		DrawCinematicHUD(C);
	}
	
	if ( bShowNotification )
		DrawPopupNotification(C);
	
	DrawHeadShotSphere();
}

function DrawPlayerInfo(Canvas C, Pawn P, float ScreenLocX, float ScreenLocY)
{
	local float XL, YL, TempX, TempY, TempSize;
	local string PlayerName;
	local float Dist, OffsetX;
	local byte BeaconAlpha,Counter;
	local float OldZ;
	local Material TempMaterial, TempStarMaterial;
	local byte i, TempLevel;

	if ( KFPlayerReplicationInfo(P.PlayerReplicationInfo) == None || KFPRI == None || KFPRI.bViewingMatineeCinematic )
	{
		Return;
	}

	Dist = vsize(P.Location - PlayerOwner.CalcViewLocation);
	Dist -= HealthBarFullVisDist;
	Dist = FClamp(Dist, 0, HealthBarCutoffDist-HealthBarFullVisDist);
	Dist = Dist / (HealthBarCutoffDist - HealthBarFullVisDist);
	BeaconAlpha = byte((1.f - Dist) * 255.f);

	if ( BeaconAlpha == 0 )
	{
		Return;
	}

	OldZ = C.Z;
	C.Z = 1.0;
	C.Style = ERenderStyle.STY_Alpha;
	C.SetDrawColor(255, 255, 255, BeaconAlpha);
	C.Font = GetConsoleFont(C);
	PlayerName = Left(P.PlayerReplicationInfo.PlayerName, 16);
	C.StrLen(PlayerName, XL, YL);
	C.SetPos(ScreenLocX - (XL * 0.5), ScreenLocY - (YL * 0.75));
	C.DrawTextClipped(PlayerName);

	OffsetX = (36.f * VeterancyMatScaleFactor * 0.6) - (HealthIconSize + 2.0);

	if ( Class<UM_VeterancyTypes>(KFPlayerReplicationInfo(P.PlayerReplicationInfo).ClientVeteranSkill)!=None &&
		 KFPlayerReplicationInfo(P.PlayerReplicationInfo).ClientVeteranSkill.default.OnHUDIcon!=None )
	{
		TempLevel = Class<UM_VeterancyTypes>(KFPlayerReplicationInfo(P.PlayerReplicationInfo).ClientVeteranSkill).Static.PreDrawPerk(C,
					KFPlayerReplicationInfo(P.PlayerReplicationInfo).ClientVeteranSkillLevel,
					TempMaterial,TempStarMaterial);

		TempSize = 36.f * VeterancyMatScaleFactor;
		TempX = ScreenLocX + ((BarLength + HealthIconSize) * 0.5) - (TempSize * 0.25) - OffsetX;
		TempY = ScreenLocY - YL - (TempSize * 0.75);

		C.SetPos(TempX, TempY);
		C.DrawTile(TempMaterial, TempSize, TempSize, 0, 0, TempMaterial.MaterialUSize(), TempMaterial.MaterialVSize());

		TempX += (TempSize - (VetStarSize * 0.75));
		TempY += (TempSize - (VetStarSize * 1.5));

		for ( i = 0; i < TempLevel; i++ )
		{
			C.SetPos(TempX, TempY-(Counter*VetStarSize*0.7f));
			C.DrawTile(TempStarMaterial, VetStarSize * 0.7, VetStarSize * 0.7, 0, 0, TempStarMaterial.MaterialUSize(), TempStarMaterial.MaterialVSize());

			if( ++Counter==5 )
			{
				Counter = 0;
				TempX+=VetStarSize;
			}
		}
	}

	// Health
	if ( P.Health > 0 )
		DrawKFBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 0.4 * BarHeight, FClamp(P.Health / P.HealthMax, 0, 1), BeaconAlpha);

	// Armor
	if ( P.ShieldStrength > 0 )
		DrawKFBar(C, ScreenLocX - OffsetX, (ScreenLocY - YL) - 1.5 * BarHeight, FClamp(P.ShieldStrength / 100.f, 0, 1), BeaconAlpha, True);

	C.Z = OldZ;
}

simulated function DrawModOverlay( Canvas C )
{
	local float MaxRBrighten, MaxGBrighten, MaxBBrighten;

	// We want the overlay to start black, and fade in, almost like the player opened their eyes
	// BrightFactor = 1.5;   // Not too bright.  Not too dark.  Livens things up just abit
	// Hook for Optional Vision overlay.  - Alex

	if( PawnOwner==None )
	{
		if( CurrentZone!=None || CurrentVolume!=None ) // Reset everything.
		{
			LastR = 0;
				LastG = 0;
				LastB = 0;
			CurrentZone = None;
			LastZone = None;
			CurrentVolume = None;
			LastVolume = None;
			bZoneChanged = False;
			SetTimer(0.f, False);
		}
		VisionOverlay = default.VisionOverlay;

		// Dead Players see Red
		if( !PlayerOwner.IsSpectating() )
		{
			C.SetDrawColor(255, 255, 255, GrainAlpha);
			C.DrawTile(SpectatorOverlay, C.SizeX, C.SizeY, 0, 0, 1024, 1024);
		}
		Return;
	}

	C.SetPos(0, 0);

	// if critical, pulsate.  otherwise, dont.
	if ( (PlayerOwner.Pawn==PawnOwner || !PlayerOwner.bBehindView) && Vehicle(PawnOwner)==None && PawnOwner.Health>0 && PawnOwner.Health<(PawnOwner.HealthMax*0.25) )
		VisionOverlay = NearDeathOverlay;
	else VisionOverlay = default.VisionOverlay;

	// Players can choose to turn this feature off completely.
	// conversely, setting bDistanceFog = False in a Zone
	//will cause the code to ignore that zone for a shift in RGB tint
	if ( KFLevelRule != None && !KFLevelRule.bUseVisionOverlay )
		Return;

	// here we determine the maximum "brighten" amounts for each value.  CANNOT exceed 255
	MaxRBrighten = Round(LastR* (1.0 - (LastR / 255)) - 2) ;
	MaxGBrighten = Round(LastG* (1.0 - (LastG / 255)) - 2) ;
	MaxBBrighten = Round(LastB* (1.0 - (LastB / 255)) - 2) ;

	C.SetDrawColor(LastR + MaxRBrighten, LastG + MaxGBrighten, LastB + MaxBBrighten, GrainAlpha);
	C.DrawTileScaled(VisionOverlay, C.SizeX, C.SizeY);  //,0,0,1024,1024);

	// Here we change over the Zone.
	// What happens of importance is
	// A.  Set Old Zone to current
	// B.  Set New Zone
	// C.  Set Color info up for use by Tick()

	// if we're in a new zone or volume without distance fog...just , dont touch anything.
	// the physicsvolume check is abit screwy because the player is always in a volume called "DefaultPhyicsVolume"
	// so we've gotta make sure that the Return checks take this into consideration.

	// This block of code here just makes sure that if we've already got a tint, and we step into a zone/volume without
	// bDistanceFog, our current tint is not affected.
	// a.  If I'm in a zone and its not bDistanceFog. AND IM NOT IN A PHYSICSVOLUME. Just a zone.
	// b.  If I'm in a Volume
	if ( !PawnOwner.Region.Zone.bDistanceFog &&
		 DefaultPhysicsVolume(PawnOwner.PhysicsVolume)==None && !PawnOwner.PhysicsVolume.bDistanceFog )
		Return;

	if ( !bZoneChanged )
	{
		// Grab the most recent zone info from our PRI
		// Only update if it's different
		// EDIT:  AND HAS bDISTANCEFOG True
		if ( CurrentZone!=PawnOwner.Region.Zone || (DefaultPhysicsVolume(PawnOwner.PhysicsVolume) == None &&
			 CurrentVolume != PawnOwner.PhysicsVolume) )
		{
			if ( CurrentZone != None )
				LastZone = CurrentZone;
			else if ( CurrentVolume != None )
				LastVolume = CurrentVolume;

			// This is for all occasions where we're either in a Levelinfo handled zone
			// Or a zoneinfo.
			// If we're in a LevelInfo / ZoneInfo  and NOT touching a Volume.  Set current Zone
			if ( PawnOwner.Region.Zone.bDistanceFog && DefaultPhysicsVolume(PawnOwner.PhysicsVolume)!= None && !PawnOwner.Region.Zone.bNoKFColorCorrection )
			{
				CurrentVolume = None;
				CurrentZone = PawnOwner.Region.Zone;
			}
			else if ( DefaultPhysicsVolume(PawnOwner.PhysicsVolume) == None && PawnOwner.PhysicsVolume.bDistanceFog && !PawnOwner.PhysicsVolume.bNoKFColorCorrection)
			{
				CurrentZone = None;
				CurrentVolume = PawnOwner.PhysicsVolume;
			}

			if ( CurrentVolume != None )
				LastZone = None;
			else if ( CurrentZone != None )
				LastVolume = None;

			if ( LastZone != None )
			{
				if( LastZone.bNewKFColorCorrection )
				{
					LastR = LastZone.KFOverlayColor.R;
						LastG = LastZone.KFOverlayColor.G;
						LastB = LastZone.KFOverlayColor.B;
				}
				else
				{
					LastR = LastZone.DistanceFogColor.R;
						LastG = LastZone.DistanceFogColor.G;
						LastB = LastZone.DistanceFogColor.B;
				}
			}
			else if ( LastVolume != None )
			{
				if( LastVolume.bNewKFColorCorrection )
				{
					LastR = LastVolume.KFOverlayColor.R;
						LastG = LastVolume.KFOverlayColor.G;
						LastB = LastVolume.KFOverlayColor.B;
				}
				else
				{
						LastR = LastVolume.DistanceFogColor.R;
						LastG = LastVolume.DistanceFogColor.G;
						LastB = LastVolume.DistanceFogColor.B;
				}
			}
			else if ( LastZone != None && LastVolume != None )
				Return;

			if ( LastZone != CurrentZone || LastVolume != CurrentVolume )
			{
				bZoneChanged = True;
				SetTimer(OverlayFadeSpeed, False);
			}
		}
	}
	if ( !bTicksTurn && bZoneChanged )
	{
		// Pass it off to the tick now
		// valueCheckout signifies that None of the three values have been
		// altered by Tick() yet.

		// BOUNCE IT BACK! :D
		ValueCheckOut = 0;
		bTicksTurn = True;
		SetTimer(OverlayFadeSpeed, False);
	}
}

simulated function DrawEndGameHUD(Canvas C, bool bVictory)
{
	local float Scalar;
	local Shader M;

	C.DrawColor.A = 255;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	Scalar = FClamp(C.ClipY, 320, 1024);
	C.CurX = C.ClipX / 2 - Scalar / 2;
	C.CurY = C.ClipY / 2 - Scalar / 2;
	C.Style = ERenderStyle.STY_Alpha;

	if ( bVictory )
		M = Shader'KFMapEndTextures.VictoryShader';
	else M = Shader'KFMapEndTextures.DefeatShader';

	C.DrawTile(M, Scalar, Scalar, 0, 0, 1024, 1024);

	if ( bShowScoreBoard && ScoreBoard != None )
		ScoreBoard.DrawScoreboard(C);
}

simulated function DrawHudPassA(Canvas C)
{
	local	KFHumanPawn		KFHPawn;
	local	Material		TempMaterial, TempStarMaterial;
	local	int				i, TempLevel;
	local	float			TempX, TempY, TempSize;
	local	byte			Counter;
	local	class<UM_VeterancyTypes>	SV;
	local	UM_HumanPawn	HumanPawn;

	KFHPawn = KFHumanPawn(PawnOwner);
	HumanPawn = UM_HumanPawn(PawnOwner);
	
	DrawDoorHealthBars(C);

	if ( !bLightHud )
	{
		DrawSpriteWidget(C, HealthBG);
	}

	DrawSpriteWidget(C, HealthIcon);
	DrawNumericWidget(C, HealthDigits, DigitsSmall);

	if ( !bLightHud )
	{
		DrawSpriteWidget(C, ArmorBG);
	}

	DrawSpriteWidget(C, ArmorIcon);
	DrawNumericWidget(C, ArmorDigits, DigitsSmall);

	if ( HumanPawn != None )  {
		// SlowMoCharge
		C.SetPos(C.ClipX * SlowMoChargeBG.PosX, C.ClipY * SlowMoChargeBG.PosY);
		if ( !bLightHud )
			C.DrawTile(SlowMoChargeBG.WidgetTexture, SlowMoChargeBG.WidgetTexture.MaterialUSize() * SlowMoChargeBG.TextureScale * 1.5 * HudCanvasScale * ResScaleX * HudScale, SlowMoChargeBG.WidgetTexture.MaterialVSize() * SlowMoChargeBG.TextureScale * HudCanvasScale * ResScaleY * HudScale, 0, 0, SlowMoChargeBG.WidgetTexture.MaterialUSize(), SlowMoChargeBG.WidgetTexture.MaterialVSize());
		
		DrawSpriteWidget(C, SlowMoChargeIcon);
		C.Font = LoadSmallFontStatic(5);
		C.FontScaleX = C.ClipX / 1024.0;
		C.FontScaleY = C.FontScaleX;
		C.SetPos(C.ClipX * SlowMoChargeDigits.PosX, C.ClipY * SlowMoChargeDigits.PosY);
		C.DrawColor = SlowMoChargeDigits.Tints[0];
		C.DrawText( string(HumanPawn.SlowMoCharge) @"s" );
		C.FontScaleX = 1;
		C.FontScaleY = 1;
		// Stamina
		C.SetPos(C.ClipX * StaminaBG.PosX, C.ClipY * StaminaBG.PosY);
		if ( !bLightHud )
			C.DrawTile(StaminaBG.WidgetTexture, StaminaBG.WidgetTexture.MaterialUSize() * StaminaBG.TextureScale * 1.5 * HudCanvasScale * ResScaleX * HudScale, StaminaBG.WidgetTexture.MaterialVSize() * StaminaBG.TextureScale * HudCanvasScale * ResScaleY * HudScale, 0, 0, StaminaBG.WidgetTexture.MaterialUSize(), StaminaBG.WidgetTexture.MaterialVSize());
		
		DrawSpriteWidget(C, StaminaIcon);
		C.Font = LoadSmallFontStatic(5);
		C.FontScaleX = C.ClipX / 1024.0;
		C.FontScaleY = C.FontScaleX;
		C.SetPos(C.ClipX * StaminaDigits.PosX, C.ClipY * StaminaDigits.PosY);
		C.DrawColor = StaminaDigits.Tints[0];
		C.DrawText( string(HumanPawn.Stamina) );
		C.FontScaleX = 1;
		C.FontScaleY = 1;
		// Weight
		C.SetPos(C.ClipX * WeightBG.PosX, C.ClipY * WeightBG.PosY);
		if ( !bLightHud )
			C.DrawTile(WeightBG.WidgetTexture, WeightBG.WidgetTexture.MaterialUSize() * WeightBG.TextureScale * 1.5 * HudCanvasScale * ResScaleX * HudScale, WeightBG.WidgetTexture.MaterialVSize() * WeightBG.TextureScale * HudCanvasScale * ResScaleY * HudScale, 0, 0, WeightBG.WidgetTexture.MaterialUSize(), WeightBG.WidgetTexture.MaterialVSize());

		DrawSpriteWidget(C, WeightIcon);
		C.Font = LoadSmallFontStatic(5);
		C.FontScaleX = C.ClipX / 1024.0;
		C.FontScaleY = C.FontScaleX;
		C.SetPos(C.ClipX * WeightDigits.PosX, C.ClipY * WeightDigits.PosY);
		C.DrawColor = WeightDigits.Tints[0];
		C.DrawText( string(HumanPawn.CurrentWeight) @"/" @string(HumanPawn.MaxCarryWeight) );
		C.FontScaleX = 1;
		C.FontScaleY = 1;
	}
	
	if ( !bLightHud )
		DrawSpriteWidget(C, GrenadeBG);

	DrawSpriteWidget(C, GrenadeIcon);
	DrawNumericWidget(C, GrenadeDigits, DigitsSmall);

	if ( PawnOwner != None && PawnOwner.Weapon != None )
	{
		if ( Syringe(PawnOwner.Weapon) != None )
		{
			if ( !bLightHud )
			{
				DrawSpriteWidget(C, SyringeBG);
			}

			DrawSpriteWidget(C, SyringeIcon);
			DrawNumericWidget(C, SyringeDigits, DigitsSmall);
		}
		else
		{
			if ( bDisplayQuickSyringe )
			{
				TempSize = Level.TimeSeconds - QuickSyringeStartTime;
				if ( TempSize < QuickSyringeDisplayTime )
				{
					if ( TempSize < QuickSyringeFadeInTime )
					{
						QuickSyringeBG.Tints[0].A = int((TempSize / QuickSyringeFadeInTime) * 255.0);
						QuickSyringeBG.Tints[1].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeIcon.Tints[0].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeIcon.Tints[1].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeDigits.Tints[0].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeDigits.Tints[1].A = QuickSyringeBG.Tints[0].A;
					}
					else if ( TempSize > QuickSyringeDisplayTime - QuickSyringeFadeOutTime )
					{
						QuickSyringeBG.Tints[0].A = int((1.0 - ((TempSize - (QuickSyringeDisplayTime - QuickSyringeFadeOutTime)) / QuickSyringeFadeOutTime)) * 255.0);
						QuickSyringeBG.Tints[1].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeIcon.Tints[0].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeIcon.Tints[1].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeDigits.Tints[0].A = QuickSyringeBG.Tints[0].A;
						QuickSyringeDigits.Tints[1].A = QuickSyringeBG.Tints[0].A;
					}
					else
					{
						QuickSyringeBG.Tints[0].A = 255;
						QuickSyringeBG.Tints[1].A = 255;
						QuickSyringeIcon.Tints[0].A = 255;
						QuickSyringeIcon.Tints[1].A = 255;
						QuickSyringeDigits.Tints[0].A = 255;
						QuickSyringeDigits.Tints[1].A = 255;
					}

					if ( !bLightHud )
					{
						DrawSpriteWidget(C, QuickSyringeBG);
					}

					DrawSpriteWidget(C, QuickSyringeIcon);
					DrawNumericWidget(C, QuickSyringeDigits, DigitsSmall);
				}
				else
				{
					bDisplayQuickSyringe = False;
				}
			}

			if ( MP7MMedicGun(PawnOwner.Weapon) != None || MP5MMedicGun(PawnOwner.Weapon) != None )
			{
				if( MP7MMedicGun(PawnOwner.Weapon) != None )
				{
					MedicGunDigits.Value = MP7MMedicGun(PawnOwner.Weapon).ChargeBar() * 100;
				}
				else
				{
					MedicGunDigits.Value = MP5MMedicGun(PawnOwner.Weapon).ChargeBar() * 100;
				}

				if ( MedicGunDigits.Value < 50 )
				{
					MedicGunDigits.Tints[0].R = 128;
					MedicGunDigits.Tints[0].G = 128;
					MedicGunDigits.Tints[0].B = 128;

					MedicGunDigits.Tints[1] = SyringeDigits.Tints[0];
				}
				else if ( MedicGunDigits.Value < 100 )
				{
					MedicGunDigits.Tints[0].R = 192;
					MedicGunDigits.Tints[0].G = 96;
					MedicGunDigits.Tints[0].B = 96;

					MedicGunDigits.Tints[1] = SyringeDigits.Tints[0];
				}
				else
				{
					MedicGunDigits.Tints[0].R = 255;
					MedicGunDigits.Tints[0].G = 64;
					MedicGunDigits.Tints[0].B = 64;

					MedicGunDigits.Tints[1] = MedicGunDigits.Tints[0];
				}

				if ( !bLightHud )
				{
					DrawSpriteWidget(C, MedicGunBG);
				}

				DrawSpriteWidget(C, MedicGunIcon);
				DrawNumericWidget(C, MedicGunDigits, DigitsSmall);
			}

			if ( Welder(PawnOwner.Weapon) != None )
			{
				if ( !bLightHud )
				{
					DrawSpriteWidget(C, WelderBG);
				}

				DrawSpriteWidget(C, WelderIcon);
				DrawNumericWidget(C, WelderDigits, DigitsSmall);
			}
			else if ( PawnOwner.Weapon.GetAmmoClass(0) != None )
			{
				if ( !bLightHud )
				{
					DrawSpriteWidget(C, ClipsBG);
				}

				if ( HuskGun(PawnOwner.Weapon) != None )
				{
					ClipsDigits.PosX = 0.873;
					DrawNumericWidget(C, ClipsDigits, DigitsSmall);
					ClipsDigits.PosX = default.ClipsDigits.PosX;
				}
				else
				{
				    DrawNumericWidget(C, ClipsDigits, DigitsSmall);
				}

				if ( LAW(PawnOwner.Weapon) != None )
				{
					DrawSpriteWidget(C, LawRocketIcon);
				}
				else if ( Crossbow(PawnOwner.Weapon) != None )
				{
					DrawSpriteWidget(C, ArrowheadIcon);
				}
				else if ( PipeBombExplosive(PawnOwner.Weapon) != None )
				{
					DrawSpriteWidget(C, PipeBombIcon);
				}
				else if ( M79GrenadeLauncher(PawnOwner.Weapon) != None )
				{
					DrawSpriteWidget(C, M79Icon);
				}
				else if ( HuskGun(PawnOwner.Weapon) != None )
				{
					DrawSpriteWidget(C, HuskAmmoIcon);
				}
				else
				{
					if ( !bLightHud )
					{
						DrawSpriteWidget(C, BulletsInClipBG);
					}

					DrawNumericWidget(C, BulletsInClipDigits, DigitsSmall);

					if ( Flamethrower(PawnOwner.Weapon) != None )
					{
						DrawSpriteWidget(C, FlameIcon);
						DrawSpriteWidget(C, FlameTankIcon);
					}
					else if ( Shotgun(PawnOwner.Weapon) != None || BoomStick(PawnOwner.Weapon) != None || Winchester(PawnOwner.Weapon) != None
					 || BenelliShotgun(PawnOwner.Weapon) != None )
					{
						DrawSpriteWidget(C, SingleBulletIcon);
						DrawSpriteWidget(C, BulletsInClipIcon);
					}
					else
					{
						DrawSpriteWidget(C, ClipsIcon);
						DrawSpriteWidget(C, BulletsInClipIcon);
					}
				}

				if ( KFWeapon(PawnOwner.Weapon) != None && KFWeapon(PawnOwner.Weapon).bTorchEnabled )
				{
					if ( !bLightHud )
					{
						DrawSpriteWidget(C, FlashlightBG);
					}

					DrawNumericWidget(C, FlashlightDigits, DigitsSmall);

					if ( KFWeapon(PawnOwner.Weapon).FlashLight != None && KFWeapon(PawnOwner.Weapon).FlashLight.bHasLight )
					{
						DrawSpriteWidget(C, FlashlightIcon);
					}
					else
					{
						DrawSpriteWidget(C, FlashlightOffIcon);
					}
				}
			}

			// Secondary ammo
			if ( KFWeapon(PawnOwner.Weapon) != None && KFWeapon(PawnOwner.Weapon).bHasSecondaryAmmo )
			{
				if ( !bLightHud )
				{
					DrawSpriteWidget(C, SecondaryClipsBG);
				}

				DrawNumericWidget(C, SecondaryClipsDigits, DigitsSmall);
				DrawSpriteWidget(C, SecondaryClipsIcon);
			}
		}
	}

	if( KFPlayerReplicationInfo(PawnOwnerPRI)!=None )
		SV = Class<UM_VeterancyTypes>(KFPlayerReplicationInfo(PawnOwnerPRI).ClientVeteranSkill);

	if ( SV!=None )
		SV.Static.SpecialHUDInfo(KFPlayerReplicationInfo(PawnOwnerPRI), C);

	if ( KFSGameReplicationInfo(PlayerOwner.GameReplicationInfo) == None || KFSGameReplicationInfo(PlayerOwner.GameReplicationInfo).bHUDShowCash )
	{
		DrawSpriteWidget(C, CashIcon);
		DrawNumericWidget(C, CashDigits, DigitsBig);
	}

	if ( SV!=None )
	{
		TempSize = 36 * VeterancyMatScaleFactor * 1.4;
		TempX = C.ClipX * 0.007;
		TempY = C.ClipY * 0.93 - TempSize;
		C.DrawColor = WhiteColor;

		TempLevel = KFPlayerReplicationInfo(PawnOwnerPRI).ClientVeteranSkillLevel;
		if( ClientRep!=None && (TempLevel+1)<ClientRep.MaximumLevel )
		{
			// Draw progress bar.
			bDisplayingProgress = True;
			if( NextLevelTimer<Level.TimeSeconds )
			{
				NextLevelTimer = Level.TimeSeconds+3.f;
				LevelProgressBar = SV.Static.GetTotalProgress(ClientRep,TempLevel+1);
			}
			C.DrawColor.A = 64;
			C.SetPos(TempX, TempY-TempSize*0.12f);
			C.DrawTileStretched(Texture'thinpipe_b',TempSize*2.f,TempSize*0.1f);
			if( VisualProgressBar>0.f )
			{
				C.DrawColor.A = 150;
				C.SetPos(TempX, TempY-TempSize*0.12f);
				C.DrawTileStretched(Texture'thinpipe_f',TempSize*2.f*VisualProgressBar,TempSize*0.1f);
			}
		}

		C.DrawColor.A = 192;
		TempLevel = SV.Static.PreDrawPerk(C,TempLevel,TempMaterial,TempStarMaterial);

		C.SetPos(TempX, TempY);
		C.DrawTile(TempMaterial, TempSize, TempSize, 0, 0, TempMaterial.MaterialUSize(), TempMaterial.MaterialVSize());

		TempX += (TempSize - VetStarSize);
		TempY += (TempSize - (2.0 * VetStarSize));

		for ( i = 0; i < TempLevel; i++ )
		{
			C.SetPos(TempX, TempY-(Counter*VetStarSize*0.8f));
			C.DrawTile(TempStarMaterial, VetStarSize, VetStarSize, 0, 0, TempStarMaterial.MaterialUSize(), TempStarMaterial.MaterialVSize());

			if( ++Counter==5 )
			{
				Counter = 0;
				TempX+=VetStarSize;
			}
		}
	}

	if ( Level.TimeSeconds - LastVoiceGainTime < 0.333 )
	{
		if ( !bUsingVOIP && PlayerOwner != None && PlayerOwner.ActiveRoom != None &&
			 PlayerOwner.ActiveRoom.GetTitle() == "Team" )
		{
			bUsingVOIP = True;
			PlayerOwner.NotifySpeakingInTeamChannel();
		}

		DisplayVoiceGain(C);
	}
	else
	{
		bUsingVOIP = False;
	}

	if ( bDisplayInventory || bInventoryFadingOut )
	{
		DrawInventory(C);
	}
}

simulated final function RenderFlash( canvas Canvas )
{
	if( PlayerOwner==None || PlayerOwner.FlashScale.X==0 || PlayerOwner.FlashFog==vect(0,0,0) )
		Return;
	Canvas.DrawColor.R = Min(Abs(PlayerOwner.FlashFog.X*PlayerOwner.FlashScale.X)*255,255);
	Canvas.DrawColor.G = Min(Abs(PlayerOwner.FlashFog.Y*PlayerOwner.FlashScale.X)*255,255);
	Canvas.DrawColor.B = Min(Abs(PlayerOwner.FlashFog.Z*PlayerOwner.FlashScale.X)*255,255);
	Canvas.DrawColor.A = 255;
	Canvas.Style = ERenderStyle.STY_Translucent;
	Canvas.SetPos(0,0);
	Canvas.DrawTile(Texture'engine.WhiteSquareTexture', Canvas.ClipX, Canvas.ClipY, 0, 0, 1, 1);
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

// Draw Health Bars for damage opened doors.
function DrawDoorHealthBars(Canvas C)
{
	local KFDoorMover DamageDoor;
	local vector CameraLocation, CamDir, TargetLocation, HBScreenPos;
	local rotator CameraRotation;
	local name DoorTag;
	local int i;

	if( PawnOwner==None )
		Return;

	if ( (Level.TimeSeconds>LastDoorBarHealthUpdate) || (Welder(PawnOwner.Weapon)!=None && PlayerOwner.bFire==1) )
	{
		DoorCache.Length = 0;

		foreach CollidingActors(class'KFDoorMover', DamageDoor, 300.00, PlayerOwner.CalcViewLocation)
		{
			if ( DamageDoor.WeldStrength<=0 )
				continue;

			DoorCache[DoorCache.Length] = DamageDoor;

			C.GetCameraLocation(CameraLocation, CameraRotation);
			TargetLocation = DamageDoor.WeldIconLocation /*+ vect(0, 0, 1) * Height*/;
			TargetLocation.Z = CameraLocation.Z;
			CamDir	= vector(CameraRotation);

			if ( Normal(TargetLocation - CameraLocation) dot Normal(CamDir) >= 0.1 && DamageDoor.Tag != DoorTag && FastTrace(DamageDoor.WeldIconLocation - ((DoorCache[i].WeldIconLocation - CameraLocation) * 0.25), CameraLocation) )
			{
				HBScreenPos = C.WorldToScreen(TargetLocation);
				DrawDoorBar(C, HBScreenPos.X, HBScreenPos.Y, DamageDoor.WeldStrength / DamageDoor.MaxWeld, 255);
				DoorTag = DamageDoor.Tag;
			}
		}
		LastDoorBarHealthUpdate = Level.TimeSeconds+0.2;
	}
	else
	{
		for ( i = 0; i < DoorCache.Length; i++ )
		{
			if ( DoorCache[i].WeldStrength<=0 )
				continue;
	 		C.GetCameraLocation(CameraLocation, CameraRotation);
			TargetLocation = DoorCache[i].WeldIconLocation /*+ vect(0, 0, 1) * Height*/;
			TargetLocation.Z = CameraLocation.Z;
			CamDir	= vector(CameraRotation);

			if ( Normal(TargetLocation - CameraLocation) dot Normal(CamDir) >= 0.1 && DoorCache[i].Tag != DoorTag && FastTrace(DoorCache[i].WeldIconLocation - ((DoorCache[i].WeldIconLocation - CameraLocation) * 0.25), CameraLocation) )
			{
				HBScreenPos = C.WorldToScreen(TargetLocation);
				DrawDoorBar(C, HBScreenPos.X, HBScreenPos.Y, DoorCache[i].WeldStrength / DoorCache[i].MaxWeld, 255);
				DoorTag = DoorCache[i].Tag;
			}
		}
	}
}

simulated event Tick( float Delta )
{
	if( ClientRep==None )
	{
		ClientRep = Class'UM_ClientRepInfoLink'.Static.FindStats(PlayerOwner);
		if( ClientRep!=None )
			SmileyMsgs = ClientRep.SmileyTags;
	}
	if( ClientRep!=None && ClientRep.bBWZEDTime && OldDilation!=Level.TimeDilation )
	{
		OldDilation = Level.TimeDilation;
		if( OldDilation<0.5f )
		{
			DesiredBW = 1.f;
			bFadeBW = (bUseBloom || bUseMotionBlur);
		}
		else
		{
			DesiredBW = 0.f;
			bFadeBW = (bUseBloom || bUseMotionBlur);
		}
	}
	if( bDisplayingProgress )
	{
		bDisplayingProgress = False;
		if( VisualProgressBar<LevelProgressBar )
			VisualProgressBar = FMin(VisualProgressBar+Delta,LevelProgressBar);
		else if( VisualProgressBar>LevelProgressBar )
			VisualProgressBar = FMax(VisualProgressBar-Delta,LevelProgressBar);
	}
	if( bFadeBW )
	{
		if( CurrentBW>DesiredBW )
			CurrentBW = FMax(CurrentBW-Delta*2.f,DesiredBW);
		else if( CurrentBW<DesiredBW )
			CurrentBW = FMin(CurrentBW+Delta*2.f,DesiredBW);

		if( CurrentBW>0 )
		{
			KFPlayerController(PlayerOwner).postfxon(2);
			KFPlayerController(PlayerOwner).postfxbw(CurrentBW);
		}
		else KFPlayerController(PlayerOwner).postfxoff(2);
		if( CurrentBW==DesiredBW )
			bFadeBW = False;
	}
	Super.Tick(Delta);
}

final function DrawSelectionIcon( Canvas C, bool bSelected, KFWeapon I, float Width, float Height )
{
	local float RX,RY;
	local Material M;

	if( bSelected )
		M = I.SelectedHudImage;
	else M = I.HudImage;

	if( M!=None )
	{
		RX = C.CurX;
		RY = C.CurY;
		C.DrawTile(M, Width, Height, 0, 0, 256, 192);
		if( !bSelected )
			Return;
		C.CurX = RX;
		C.CurY = RY;
	}

	if( !bSelected )
	{
		C.DrawColor.G = 128;
		C.DrawColor.B = 128;
	}
	RX = C.ClipX;
	RY = C.ClipY;
	C.OrgX = C.CurX;
	C.CurX = 0;
	C.ClipX = Width;
	C.ClipY = C.CurY+Height;
	C.DrawText(I.ItemName,False);
	C.OrgX = 0;
	C.ClipX = RX;
	C.ClipY = RY;
	if( !bSelected )
	{
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function DrawInventory( Canvas C )
{
	local	Inventory			Inv;
	local	InventoryCategory	Categorized[5];
	local	int					i, j;
	local	float				TempX, TempY, TempWidth, TempHeight, TempBorder;

	if ( PawnOwner == None )
		Return;

	if ( bInventoryFadingIn )  {
		if ( Level.TimeSeconds < (InventoryFadeStartTime + InventoryFadeTime) )
			C.SetDrawColor(255, 255, 255, byte(((Level.TimeSeconds - InventoryFadeStartTime) / InventoryFadeTime) * 255.0));
		else
			bInventoryFadingIn = False;
			C.SetDrawColor(255, 255, 255, 255);
	}
	else if ( bInventoryFadingOut )  {
		if ( Level.TimeSeconds < (InventoryFadeStartTime + InventoryFadeTime) )
			C.SetDrawColor(255, 255, 255, byte((1.0 - ((Level.TimeSeconds - InventoryFadeStartTime) / InventoryFadeTime)) * 255.0));
		else  {
			bInventoryFadingOut = False;
			Return;
		}
	}
	else
		C.SetDrawColor(255, 255, 255, 255);
	
	for ( Inv = PawnOwner.Inventory; Inv != None; Inv = Inv.Inventory )  {
		// Don't allow non-categorized or Grenades
		if ( Inv.InventoryGroup > 0 )
			Categorized[ Inv.InventoryGroup - 1 ].Items[ Categorized[Inv.InventoryGroup - 1].ItemCount++ ] = Inv;
	}

	TempX = InventoryX * C.ClipX;
	TempWidth = InventoryBoxWidth * C.ClipX;
	TempHeight = InventoryBoxHeight * C.ClipX;
	TempBorder = BorderSize * C.ClipX;
	
	for ( i = 0; i < 5; ++i )  {
		if ( Categorized[i].ItemCount == 0 )  {
			TempY = InventoryY * C.ClipY;
			C.SetPos(TempX, TempY);
			C.DrawTileStretched( InventoryBackgroundTexture, TempWidth, (TempHeight * 0.25) );
		}
		else  {
			TempY = InventoryY * C.ClipY;
			for ( j = 0; j < Categorized[i].ItemCount; ++j )  {
				// If this is the currently Selected Item
				if ( i == SelectedInventoryCategory && j == SelectedInventoryIndex )  {
					// Draw this item's Background
					C.SetPos(TempX, TempY);
					C.DrawTileStretched(SelectedInventoryBackgroundTexture, TempWidth, TempHeight);
					// Draw the Weapon's Icon over the Background
					C.SetPos(TempX + TempBorder, TempY + TempBorder);
					C.DrawTile(KFWeapon(Categorized[i].Items[j]).SelectedHudImage, TempWidth - (2.0 * TempBorder), TempHeight - (2.0 * TempBorder), 0, 0, 256, 192);
				}
				else {
					// Draw this item's Background
					C.SetPos(TempX, TempY);
					C.DrawTileStretched(InventoryBackgroundTexture, TempWidth, TempHeight);
					// Draw the Weapon's Icon over the Background
					C.SetPos(TempX + TempBorder, TempY + TempBorder);
					C.DrawTile(KFWeapon(Categorized[i].Items[j]).HudImage, TempWidth - (2.0 * TempBorder), TempHeight - (2.0 * TempBorder), 0, 0, 256, 192);
				}
				TempY += TempHeight;
			}
		}
		TempX += TempWidth;
	}
}

function SelectWeapon()
{
	local	Weapon	W;

	HideInventory();

	if ( PawnOwner == None )
		Return;

	W = Weapon( PawnOwner.FindInventoryType(SelectedInventory.Class) );
	if ( W == None || W != SelectedInventory || W.Class != SelectedInventory.Class )
		Return;	// Didn't find Selected weapon in Inventory list
	
	if ( UM_HumanPawn(PawnOwner) != None && !UM_HumanPawn(PawnOwner).AllowHoldWeapon(W) )
		Return;
	
	PawnOwner.PendingWeapon = W;
	if ( PawnOwner.Weapon == None )
		PawnOwner.ChangedWeapon();
	else if ( PawnOwner.Weapon != PawnOwner.PendingWeapon )
		PawnOwner.Weapon.PutDown();
}

function bool ShowInventory()
{
	if ( !bDisplayInventory )  {
		bDisplayInventory = True;
		bInventoryFadingIn = True;
		bInventoryFadingOut = False;
		InventoryFadeStartTime = Level.TimeSeconds - 0.01;

		if ( PawnOwner != None && PawnOwner.Weapon != None )
			SelectedInventory = PawnOwner.Weapon;
		else if ( PawnOwner != None && PawnOwner.Inventory != None )
			SelectedInventory = PawnOwner.Inventory;
		else
			Return False;
	}

	Return True;
}

function PrevWeapon()
{
	local	Inventory			Inv;
	local	InventoryCategory	Categorized[5];
	local	int					i, c;

	if ( PawnOwner == None || PawnOwner.Inventory == None || !ShowInventory() )
		Return;
	
	for ( Inv = PawnOwner.Inventory; Inv != None && c < 1000; Inv = Inv.Inventory )  {
		// Don't allow non-categorized or Grenades
		if ( Inv.InventoryGroup > 0 )  {
			if ( Inv == SelectedInventory )  {
				SelectedInventoryCategory = Inv.InventoryGroup - 1;
				SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount;
			}
			Categorized[ Inv.InventoryGroup - 1 ].Items[ Categorized[Inv.InventoryGroup - 1].ItemCount++ ] = Inv;
		}
		++c; // Prevent runaway loop
	}
	
	if ( SelectedInventoryIndex >= Categorized[SelectedInventoryCategory].ItemCount )
		SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount - 1;
	
	if ( SelectedInventoryIndex > 0 )  {
		--SelectedInventoryIndex;
		SelectedInventory = Categorized[SelectedInventoryCategory].Items[SelectedInventoryIndex];
	}
	else  {
		c = 0;
		for ( i = SelectedInventoryCategory - 1; i != SelectedInventoryCategory && c < 10; --i )  {
			if ( i < 0 )
				i = 4;	// 5 Category (0 - 4)
			if ( Categorized[i].ItemCount > 0 )  {
				SelectedInventoryCategory = i;
				SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount - 1;
				SelectedInventory = Categorized[SelectedInventoryCategory].Items[SelectedInventoryIndex];
				Return;
			}
			++c;
		}
		
		// if we only have one category with items in it, this will move to the last(or lowest) item in this category
		SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount - 1;
	}
}

function NextWeapon()
{
	local	Inventory			Inv;
	local	InventoryCategory	Categorized[5];
	local	int					i, c;
	
	if ( PawnOwner == None || PawnOwner.Inventory == None || !ShowInventory() )
		Return;
	
	for ( Inv = PawnOwner.Inventory; Inv != None && c < 1000; Inv = Inv.Inventory )  {
		// Don't allow non-categorized or Grenades
		if ( Inv.InventoryGroup > 0 )  {
			if ( Inv == SelectedInventory )  {
				SelectedInventoryCategory = Inv.InventoryGroup - 1;
				SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount;
			}
			Categorized[ Inv.InventoryGroup - 1 ].Items[ Categorized[Inv.InventoryGroup - 1].ItemCount++ ] = Inv;
		}
		++c; // Prevent runaway loop
	}
	
	if ( SelectedInventoryIndex >= Categorized[SelectedInventoryCategory].ItemCount )
		SelectedInventoryIndex = Categorized[SelectedInventoryCategory].ItemCount - 1;
	
	if ( SelectedInventoryIndex < (Categorized[SelectedInventoryCategory].ItemCount - 1) )  {
		++SelectedInventoryIndex;
		SelectedInventory = Categorized[SelectedInventoryCategory].Items[SelectedInventoryIndex];
	}
	else  {
		c = 0;
		for ( i = SelectedInventoryCategory + 1; i != SelectedInventoryCategory && c < 10; ++i )  {
			if ( i > 4 )
				i = 0;	// 0 Category (0 - 4)
			if ( Categorized[i].ItemCount > 0 )  {
				SelectedInventoryCategory = i;
				SelectedInventoryIndex = 0;
				SelectedInventory = Categorized[SelectedInventoryCategory].Items[SelectedInventoryIndex];
				Return;
			}
			++c;
		}
		
		// if we only have one category with items in it, this will move to the first(or highest) item in this category
		SelectedInventoryIndex = 0;
	}
}

function HideInventory()
{
	if ( bDisplayInventory )
		Super.HideInventory();
}

function DisplayMessages(Canvas C)
{
	local int i, j, XPos, YPos,MessageCount;
	local float XL, YL, XXL, YYL;
	local string S;

	for( i = 0; i < ConsoleMessageCount; i++ )
	{
		if ( TextMessages[i].Text == "" )
			Break;
		else if( TextMessages[i].MessageLife < Level.TimeSeconds )
		{
			TextMessages[i].Text = "";

			if( i < ConsoleMessageCount - 1 )
			{
				for( j=i; j<ConsoleMessageCount-1; j++ )
					TextMessages[j] = TextMessages[j+1];
			}
			TextMessages[j].Text = "";
			Break;
		}
		else
			MessageCount++;
	}

	YPos = (ConsoleMessagePosY * HudCanvasScale * C.SizeY) + (((1.0 - HudCanvasScale) / 2.0) * C.SizeY);
	if ( PlayerOwner == None || PlayerOwner.PlayerReplicationInfo == None || !PlayerOwner.PlayerReplicationInfo.bWaitingPlayer )
	{
		XPos = (ConsoleMessagePosX * HudCanvasScale * C.SizeX) + (((1.0 - HudCanvasScale) / 2.0) * C.SizeX);
	}
	else
	{
		XPos = (0.005 * HudCanvasScale * C.SizeX) + (((1.0 - HudCanvasScale) / 2.0) * C.SizeX);
	}

	C.Font = GetConsoleFont(C);
	C.DrawColor = LevelActionFontColor;

	C.TextSize ("A", XL, YL);

	YPos -= YL * MessageCount+1; // DP_LowerLeft
	YPos -= YL; // Room for typing prompt

	for( i=0; i<MessageCount; i++ )
	{
		if ( TextMessages[i].Text == "" )
			Break;

		C.SetPos( XPos, YPos );
		C.DrawColor = TextMessages[i].TextColor;
		YYL = 0;
		XXL = 0;
		if( TextMessages[i].PRI!=None )
		{
			S = TextMessages[i].PRI.PlayerName$": ";
			C.DrawText(S,False);
			C.CurY = YPos;
		}
		if( SmileyMsgs.Length!=0 )
			DrawSmileyText(TextMessages[i].Text,C,,YYL);
		else C.DrawText(TextMessages[i].Text,False);
		YPos += (YL+YYL);
	}
}

function AddTextMessage(string M, class<LocalMessage> MessageClass, PlayerReplicationInfo PRI)
{
	local int i;

	if( bMessageBeep && MessageClass.Default.bBeep )
		PlayerOwner.PlayBeepSound();

	for( i=0; i<ConsoleMessageCount; i++ )
	{
		if ( TextMessages[i].Text == "" )
			Break;
	}
	if( i == ConsoleMessageCount )
	{
		for( i=0; i<ConsoleMessageCount-1; i++ )
			TextMessages[i] = TextMessages[i+1];
	}
	TextMessages[i].Text = M;
	TextMessages[i].MessageLife = Level.TimeSeconds + MessageClass.Default.LifeTime;
	TextMessages[i].TextColor = MessageClass.static.GetConsoleColor(PRI);
	if( MessageClass==class'SayMessagePlus' )
		TextMessages[i].PRI = PRI;
	else TextMessages[i].PRI = None;
}

simulated function Message(PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	local Class<LocalMessage> LocalMessageClass;

	if ( PRI != None && MsgType == 'Say' || MsgType == 'TeamSay' )
	{
		DisplayPortrait(PRI);
	}

	switch( MsgType )
	{
		case 'Trader':
			Msg = TraderString$":" @ Msg;
			LocalMessageClass = class'SayMessagePlus';
			PRI = None;
			Break;
		case 'Voice':
		case 'Say':
			if ( PRI == None )
				Return;
			LocalMessageClass = class'SayMessagePlus';
			Break;
		case 'TeamSay':
			if ( PRI == None )
				Return;
			Msg = PRI.PlayerName $ " (" $ PRI.GetLocationName() $ "): " $ Msg;
			LocalMessageClass = class'TeamSayMessagePlus';
			Break;
		case 'CriticalEvent':
			LocalMessageClass = class'KFCriticalEventPlus';
			LocalizedMessage(LocalMessageClass, 0, None, None, None, Msg);
			Return;
		case 'DeathMessage':
			LocalMessageClass = class'xDeathMessage';
			Break;
		default:
			LocalMessageClass = class'StringMessagePlus';
			Break;
	}
	AddTextMessage(Msg, LocalMessageClass, PRI);
}

simulated final function DrawSmileyText( string S, canvas C, optional out float XXL, optional out float XYL )
{
	local int i,n;
	local float PX,PY,XL,YL,CurX,CurY,SScale,Sca,AdditionalY,NewAY;
	local string D;
	local color OrgC;

	// Initilize
	C.TextSize("T",XL,YL);
	SScale = YL;
	PX = C.CurX;
	PY = C.CurY;
	CurX = PX;
	CurY = PY;
	OrgC = C.DrawColor;

	// Search for smiles in text
	i = FindNextSmile(S,n);
	While( i!=-1 )
	{
		D = Left(S,i);
		S = Mid(S,i+Len(SmileyMsgs[n].SmileyTag));
		// Draw text behind
		C.SetPos(CurX,CurY);
		C.DrawText(D);
		// Draw smile
		C.StrLen(StripColorForTTS(D),XL,YL);
		CurX+=XL;
		While( CurX>C.ClipX )
		{
			CurY+=(YL+AdditionalY);
			XYL+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		C.DrawColor = Default.WhiteColor;
		C.SetPos(CurX,CurY);
		if( SmileyMsgs[n].SmileyTex.USize==16 )
			Sca = SScale;
		else Sca = SmileyMsgs[n].SmileyTex.USize/32*SScale;
		C.DrawRect(SmileyMsgs[n].SmileyTex,Sca,Sca);
		if( Sca>SScale )
		{
			NewAY = (Sca-SScale);
			if( NewAY>AdditionalY )
				AdditionalY = NewAY;
			NewAY = 0;
		}
		CurX+=Sca;
		While( CurX>C.ClipX )
		{
			CurY+=(YL+AdditionalY);
			XYL+=(YL+AdditionalY);
			AdditionalY = 0;
			CurX-=C.ClipX;
		}
		// Then go for next smile
		C.DrawColor = OrgC;
		i = FindNextSmile(S,n);
	}
	// Then draw rest of text remaining
	C.SetPos(CurX,CurY);
	C.StrLen(StripColorForTTS(S),XL,YL);
	C.DrawText(S);
	CurX+=XL;
	While( CurX>C.ClipX )
	{
		CurY+=(YL+AdditionalY);
		XYL+=(YL+AdditionalY);
		AdditionalY = 0;
		CurX-=C.ClipX;
	}
	XYL+=AdditionalY;
	AdditionalY = 0;
	XXL = CurX;
	C.SetPos(PX,PY);
}

simulated final function int FindNextSmile( string S, out int SmileNr )
{
	local int i,p,bp;
	local string CS;

	CS = Caps(S);
	bp = -1;
	for( i=(SmileyMsgs.Length-1); i>=0; --i )
	{
		if( SmileyMsgs[i].bInCAPS )
			p = InStr(CS,SmileyMsgs[i].SmileyTag);
		else p = InStr(S,SmileyMsgs[i].SmileyTag);
		if( p!=-1 && (p<bp || bp==-1) )
		{
			bp = p;
			SmileNr = i;
		}
	}
	Return bp;
}

static final function string StripColorForTTS(string s) // Strip color codes.
{
	local int p;

	p = InStr(s,chr(27));
	while ( p>=0 )
	{
		s = left(s,p)$mid(S,p+4);
		p = InStr(s,Chr(27));
	}
	Return s;
}

defaultproperties
{
	 // SlowMoCharge
	 SlowMoChargeBG=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Box_128x64',RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=64),TextureScale=0.350000,PosX=0.155000,PosY=0.935000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=128),Tints[1]=(B=255,G=255,R=255,A=128))
	 SlowMoChargeIcon=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Lightning_Bolt',RenderStyle=STY_Alpha,TextureCoords=(X2=64,Y2=64),TextureScale=0.200000,PosX=0.160000,PosY=0.945000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	 SlowMoChargeDigits=(RenderStyle=STY_Alpha,TextureScale=0.300000,PosX=0.185000,PosY=0.950000,Tints[0]=(B=64,G=64,R=255,A=255),Tints[1]=(B=64,G=64,R=255,A=255))
	 // Stamina
	 StaminaBG=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Box_128x64',RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=128),TextureScale=0.350000,PosX=0.155000,PosY=0.0.865000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=128),Tints[1]=(B=255,G=255,R=255,A=128))
	 StaminaIcon=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Lightning_Bolt',RenderStyle=STY_Alpha,TextureCoords=(X2=64,Y2=64),TextureScale=0.200000,PosX=0.160000,PosY=0.875000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	 StaminaDigits=(RenderStyle=STY_Alpha,TextureScale=0.300000,PosX=0.185000,PosY=0.880000,Tints[0]=(B=64,G=64,R=255,A=255),Tints[1]=(B=64,G=64,R=255,A=255))
	 // Weight
	 WeightBG=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Box_128x64',RenderStyle=STY_Alpha,TextureCoords=(X2=384,Y2=64),TextureScale=0.350000,PosX=0.295000,PosY=0.935000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	 WeightIcon=(WidgetTexture=Texture'KillingFloorHUD.HUD.Hud_Weight',RenderStyle=STY_Alpha,TextureCoords=(X2=64,Y2=64),TextureScale=0.280000,PosX=0.300000,PosY=0.941000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	 WeightDigits=(RenderStyle=STY_Alpha,TextureScale=0.300000,PosX=0.335000,PosY=0.946000,Tints[0]=(B=64,G=64,R=255,A=255),Tints[1]=(B=64,G=64,R=255,A=255))
}