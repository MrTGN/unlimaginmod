//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPSniperRifle
//	Parent class:	 UM_BaseBoltActSniperRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.08.2013 14:00
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 The data are taken from the real prototype: M1903 Springfield
//================================================================================
class UM_SPSniperRifle extends UM_BaseBoltActSniperRifle
	config(user);


//========================================================================
//[block] Functions

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

//[end] Functions
//====================================================================


defaultproperties
{
     MagCapacity=10
     ReloadRate=2.866000
	 TacticalReloadTime=1.800000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_spSinper"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'KF_IJC_HUD.Trader_Weapon_Icons.Trader_Sniper'
     bIsTier2Weapon=True
     MeshRef="KF_IJC_Summer_Weps1.SniperRifle"
     SkinRefs(1)="KF_IJC_Summer_Weapons.SniperRifle.Sniper_cmb"
     SkinRefs(2)="KF_IJC_Summer_Weapons.SniperRifle.sniperrifle_scope_shader"
     SelectSoundRef="KF_SP_LongmusketSnd.KFO_Sniper_Select"
     HudImageRef="KF_IJC_HUD.WeaponSelect.Sniper_unselected"
     SelectedHudImageRef="KF_IJC_HUD.WeaponSelect.Sniper"
     PlayerIronSightFOV=55.000000
     ZoomedDisplayFOV=20.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_SPSniperRifleFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A finely crafted long rifle from the Victorian era fitted with telescopic aiming optics."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=155
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=18
     PickupClass=Class'UnlimaginMod.UM_SPSniperPickup'
     PlayerViewOffset=(X=25.000000,Y=17.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_SPSniperRifleAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="S.P. Musket"
     TransientSoundVolume=1.250000
}
