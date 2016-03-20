//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M4203AssaultRifle
//	Parent class:	 UM_BaseAssaultRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 04.05.2013 17:52
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M4203AssaultRifle extends UM_BaseAssaultRifle;


simulated function bool CanZoomNow()
{
    Return ( !FireMode[1].bIsFiring &&
           ((FireMode[1].NextFireTime - FireMode[1].FireRate * 0.2) < Level.TimeSeconds + FireMode[1].PreFireTime));
}

function bool AllowReload()
{
	if ( (FireMode[1].NextFireTime - FireMode[1].FireRate * 0.1) > Level.TimeSeconds + FireMode[1].PreFireTime )
		Return False;

	Return super.AllowReload();
}

simulated function bool ReadyToFire(int Mode)
{
    // Don't allow firing while reloading the shell
	if ( (FireMode[1].NextFireTime - FireMode[1].FireRate * 0.06) > Level.TimeSeconds + FireMode[1].PreFireTime )
		Return False;

    Return Super.ReadyToFire(Mode);
}


defaultproperties
{
     MagCapacity=30
     ForceZoomOutOnAltFireTime=0.000000
     bHasSecondaryAmmo=True
     bReduceMagAmmoOnSecondaryFire=False
	 ReloadRate=3.633300
	 TacticalReloadTime=2.484000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M4203"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     SleeveNum=1
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_M4_203'
     bIsTier2Weapon=True
	 bIsTier3Weapon=True
     MeshRef="KF_Wep_M4M203.M4M203_Trip"
     SkinRefs(0)="KF_Weapons4_Trip_T.Weapons.m4_cmb"
     SelectSoundRef="KF_M4RifleSnd.WEP_M4_Foley_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.M4_203_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.M4_203"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_M4203Fire'
     FireModeClass(1)=Class'UnlimaginMod.UM_M203Fire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An assault rifle with an attached grenade launcher."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=190
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=8
     PickupClass=Class'UnlimaginMod.UM_M4203Pickup'
     PlayerViewOffset=(X=25.000000,Y=18.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_M4203Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="M4 203"
     TransientSoundVolume=1.250000
}
