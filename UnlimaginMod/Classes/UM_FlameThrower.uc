//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FlameThrower
//	Parent class:	 FlameThrower
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 31.12.2012 16:29
//================================================================================
class UM_FlameThrower extends UM_BaseFlameThrower;

function bool RecommendRangedAttack()
{
	Return True;
}

function float SuggestAttackStyle()
{
	Return -1.0;
}


function bool RecommendLongRangedAttack()
{
	Return True;
}

defaultproperties
{
	 bReduceMagAmmoOnSecondaryFire=True
	 MagCapacity=100
     ReloadRate=4.140000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Flamethrower"
     MinimumFireRange=300
     bSteadyAim=True
     bHasAimingMode=True
     IdleAimAnim="Idle"
     QuickPutDownTime=0.500000
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Flame_Thrower'
     bIsTier2Weapon=True
     MeshRef="KF_Weapons_Trip.Flamethrower_Trip"
     SkinRefs(0)="KF_Weapons_Trip_T.Supers.flamethrower_cmb"
     SkinRefs(2)="KillingFloorWeapons.Welder.FBFlameOrange"
     HudImageRef="KillingFloorHUD.WeaponSelect.FlameThrower_unselected"
     SelectedHudImageRef="KillingFloorHUD.WeaponSelect.FlameThrower"
     ZoomInRotation=(Pitch=-1000,Roll=1500)
     ZoomedDisplayFOV=70.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_FlameThrowerFire'
	 FireModeClass(1)=Class'UnlimaginMod.UM_FlameThrowerAltFire'
     PutDownAnim="PutDown"
     PutDownAnimRate=1.000000
     PutDownTime=1.000000
     AIRating=0.700000
     CurrentRating=0.700000
     Description="A deadly experimental weapon designed by Horzine industries. It can fire streams of burning liquid which ignite on contact."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=145
     InventoryGroup=3
     GroupOffset=8
     PickupClass=Class'UnlimaginMod.UM_FlameThrowerPickup'
     PlayerViewOffset=(X=5.000000,Y=7.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_FlameThrowerAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="FlameThrower"
     DrawScale=0.900000
     TransientSoundVolume=1.250000
	 Weight=9.000000
}