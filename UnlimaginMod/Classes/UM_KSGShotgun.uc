//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGShotgun
//	Parent class:	 UM_BaseMagShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.09.2012 17:47
//================================================================================
class UM_KSGShotgun extends UM_BaseMagShotgun;


// Whether or not to use the wide spread setting
var		bool	bWideSpread;


replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle()
{
	local	PlayerController	Player;
	local	byte				DefPerkIndex;
	
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && 
		 KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
		DefPerkIndex = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex;
	
	Player = Level.GetLocalPlayerController();
	if ( Player != None )
	{
		BaseActor.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		
		if ( bWideSpread )
		{
			switch ( DefPerkIndex )
			{
				//Field Medic
				case 0:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',3); //Tight-Spreading Gas Projectile
					Break;
				//Sharpshooter
				case 2:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',4); //Shotgun Slug
					Break;
				//Firebug
				case 5:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',6); //Tight-Spreading Incendiary Bullet
					Break;
				//Demolitions
				case 6:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',8); //Tight-Spreading Frag
					Break;
				//Else
				default:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',1); //Tight-Spreading 000 Buckshot
					Break;
			}
		}
		else
		{
			switch ( DefPerkIndex )
			{
				//Field Medic
				case 0:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',2); //Wide-Spreading Gas Projectile
					Break;
				//Firebug
				case 5:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',5); //Wide-Spreading Incendiary Bullet
					Break;
				//Demolitions
				case 6:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',7); //Wide-Spreading Frag
					Break;
				//Else
				default:
					Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_KSGSwitchMessage',0); //Wide-Spreading 4 Buckshot
					Break;
			}
		}
	}
	bWideSpread = !bWideSpread;
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(bWideSpread);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewbWideSpread)
{
    bWideSpread = bNewbWideSpread;
}

exec function SwitchModes()
{
	DoToggle();
}


defaultproperties
{
	 ForceZoomOutOnFireTime=0.000000
     MagCapacity=14
     ReloadRate=3.160000
	 TacticalReloadRate=2.600000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_KSG"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_KSG'
     bIsTier2Weapon=True
     MeshRef="KF_Wep_KSG_Shotgun.KSG_Shotgun"
     SkinRefs(0)="KF_Weapons5_Trip_T.Weapons.KSG_SHDR"
     SelectSoundRef="KF_KSGSnd.KSG_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.KSG_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.KSG"
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_KSGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An advanced Horzine prototype tactical shotgun. Features a large capacity ammo magazine and selectable tight/wide spread fire modes."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=100
     InventoryGroup=3
     GroupOffset=12
     PickupClass=Class'UnlimaginMod.UM_KSGPickup'
     PlayerViewOffset=(X=15.000000,Y=20.000000,Z=-7.000000)
     BobDamping=4.500000
     AttachmentClass=Class'UnlimaginMod.UM_KSGAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Kel-Tec KSG-M"
     TransientSoundVolume=1.250000
     MessageNoAmmo="You've squandered all ammo! Ass!"
}