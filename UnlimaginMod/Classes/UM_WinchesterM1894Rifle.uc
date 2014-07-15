//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WinchesterM1894Rifle
//	Parent class:	 UM_BaseBoltActSniperRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 19:02
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Winchester Model 1894
//================================================================================
class UM_WinchesterM1894Rifle extends UM_BaseBoltActSniperRifle;


//========================================================================
//[block] Functions

function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	if ( (B.Target != None) && (Pawn(B.Target) == None) && (VSize(B.Target.Location - Instigator.Location) < 1250) )
		return 0.9;

	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 3500 )
			return 0.2;
		return AIRating;
	}

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
	{
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				return 0.2;
			return (AIRating - 0.3);
		}
		if ( EnemyDir.Z < -0.5 * EnemyDist )
			return (AIRating - 0.3);
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.35);
	else if ( EnemyDist < 400 )
		return (AIRating + 0.2);
	return FMax(AIRating + 0.2 - (EnemyDist - 400) * 0.0008, 0.2);
}

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
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

// Overridden to take out some UT stuff
simulated event RenderOverlays( Canvas Canvas )
{
    super.RenderOverlays( Canvas );
    if ( bAimingRifle )
    {
	   SetZoomBlendColor(Canvas);
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bHoldToReload=True
	 bHasTacticalReload=True
	 //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'KF_Weapons_Trip.Winchester_Trip'
	 MeshRef="KF_Weapons_Trip.Winchester_Trip"
	 //Skins(0)=Combiner'KF_Weapons_Trip_T.Rifles.winchester_cmb'
	 SkinRefs(0)="KF_Weapons_Trip_T.Rifles.winchester_cmb"
	 //SelectSound=Sound'KF_RifleSnd.Rifle_Select'
	 SelectSoundRef="KF_RifleSnd.Rifle_Select"
	 //HudImage=Texture'KillingFloorHUD.WeaponSelect.winchester_unselected'
	 HudImageRef="KillingFloorHUD.WeaponSelect.winchester_unselected"
     //SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.Winchester'
	 SelectedHudImageRef="KillingFloorHUD.WeaponSelect.Winchester"
	 //[end]
	 MagCapacity=7
     ReloadRate=0.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Winchester"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="AimIdle"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Winchester'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_WinchesterM1894Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.560000
     CurrentRating=0.560000
     bShowChargingBar=True
     OldCenteredOffsetY=0.000000
     OldPlayerViewOffset=(X=-8.000000,Y=5.000000,Z=-6.000000)
     OldSmallViewOffset=(X=4.000000,Y=11.000000,Z=-12.000000)
     OldPlayerViewPivot=(Pitch=800)
     OldCenteredRoll=3000
     Description="A rugged and reliable single-shot rifle."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=85
     CenteredOffsetY=-5.000000
     CenteredRoll=3000
     CenteredYaw=-1500
     InventoryGroup=3
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.UM_WinchesterM1894Pickup'
     PlayerViewOffset=(X=8.000000,Y=14.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_WinchesterM1894Attachment'
     ItemName="Winchester Model 1894"
     bUseDynamicLights=True
     DrawScale=0.900000
     TransientSoundVolume=50.000000
}