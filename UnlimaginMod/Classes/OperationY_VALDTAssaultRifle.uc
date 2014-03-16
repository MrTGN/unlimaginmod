class OperationY_VALDTAssaultRifle extends UM_BaseAssaultRifle
	config(user);

#exec OBJ LOAD FILE="VALDT_v2_A.ukx"

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	ItemName = default.ItemName $ " [Auto]";
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		PlayOwnedSoundData(ModeSwitchSound);
		
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		if ( FireMode[0].bWaitForRelease )
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',1);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		else
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
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
	 //Mesh=SkeletalMesh'VALDT_v2_A.ValDTmesh'
	 MeshRef="VALDT_v2_A.ValDTmesh"
     //Skins(0)=Combiner'VALDT_v2_A.ASVALDT_tex_1_cmb'
	 SkinRefs(0)="VALDT_v2_A.ASVALDT_tex_1_cmb"
     //Skins(1)=Combiner'VALDT_v2_A.ASVALDT_tex_2_cmb'
	 SkinRefs(1)="VALDT_v2_A.ASVALDT_tex_2_cmb"
     //Skins(2)=Combiner'VALDT_v2_A.ASVALDT_tex_3_cmb'
	 SkinRefs(2)="VALDT_v2_A.ASVALDT_tex_3_cmb"
     //Skins(3)=Texture'KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P'
	 //SkinRefs(3)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
	 //SelectSound=Sound'KF_PumpSGSnd.SG_Select'
	 SelectSoundRef="KF_PumpSGSnd.SG_Select"
	 //HudImage=Texture'VALDT_v2_A.ValDT_unselected'
	 HudImageRef="VALDT_v2_A.ValDT_unselected"
     //SelectedHudImage=Texture'VALDT_v2_A.ValDT_selected'
	 SelectedHudImageRef="VALDT_v2_A.ValDT_selected"
	 //[end]
	 MagCapacity=20
     ReloadRate=3.184500
	 TacticalReloadRate=1.920000
     ReloadAnim="Reload"
     ReloadAnimRate=1.120000
     WeaponReloadAnim="Reload_AK47"
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=3
     TraderInfoTexture=Texture'VALDT_v2_A.ValDT_Trader'
     bIsTier2Weapon=True
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.OperationY_VALDTFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The AS Val is a Soviet designed assault rifle featuring an integrated suppressor."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=135
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'UnlimaginMod.OperationY_VALDTPickup'
     PlayerViewOffset=(X=10.000000,Y=10.000000,Z=-5.000000)
     BobDamping=5.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_VALDTAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="AS Val"
     TransientSoundVolume=1.250000
}
