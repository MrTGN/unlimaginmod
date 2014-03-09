//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140Tactical
//	Parent class:	 UM_BaseGrenadeLauncher
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 04:00
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140Tactical extends UM_BaseGrenadeLauncher;


//========================================================================
//[block] Variables

var		array<Projectile>		RMCProjectiles;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		UpdateItemName;
	
	reliable if ( Role < ROLE_Authority )
		ExplodeRMCProjectiles;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

function FindRMCProjectiles()
{
	local	int		n;
	local	UM_BaseProjectile_StickyRMCGrenade	RMCP;
	
	n = RMCProjectiles.Length;
	
	foreach AllActors(class'UM_BaseProjectile_StickyRMCGrenade', RMCP)
	{
		if ( RMCP.Instigator == Instigator )
		{
			++n;
			RMCProjectiles[RMCProjectiles.Length] = RMCP;
		}
	}
	
	UpdateItemName(n);
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	ItemName = default.ItemName $ " [0]";
	
	if ( Role == ROLE_Authority )
		FindRMCProjectiles();
}

simulated function UpdateItemName(int i)
{
	ItemName = default.ItemName $ " [" $ i $ "]";
}

function AddRMCProjectiles(Projectile P)
{
	//local	int		i, n;
	local	int		n;
	
	// Storing array Length into variable
    n = RMCProjectiles.Length;
	
	/*
	if ( n > 0 )
	{
		// clearing array from Destroyed RMCProjectiles
		for ( i = 0; i < RMCProjectiles.Length; i++ )
		{
			if ( RMCProjectiles[i] == None )
			{
				//n--;
				--n;
				RMCProjectiles.Remove(i, 1);
			}
		}
	} */
	
	// Incrementing variable
	++n;
	//n++;
	// Adding new RMCProjectile
	RMCProjectiles[RMCProjectiles.Length] = P;
	// Updating ItmeName
	UpdateItemName(n);
}

//[block] ExplodeRMCProjectiles
// Use alt fire to Explode RMCProjectiles
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring )
		DoToggle();
}

// DoToggle to Explode RMCProjectiles
simulated function DoToggle()
{
	local	PlayerController	Player;

	Player = Level.GetLocalPlayerController();
		
	if ( Player != None )
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
	
	if ( Role < ROLE_Authority )
		ExplodeRMCProjectiles();
}

function ExplodeRMCProjectiles()
{
	local	int		i, n;
	local	UM_BaseProjectile_StickyRMCGrenade	RMCG;
	
	// Storing array Length into variable
    n = RMCProjectiles.Length;
	if ( n > 0 )
	{
		// clearing array from Destroyed RMCProjectiles
		for ( i = 0; i < RMCProjectiles.Length; i++ )
		{
			RMCG = UM_BaseProjectile_StickyRMCGrenade(RMCProjectiles[i]);
			if ( RMCG != None )
			{
				//--n;
				//n--;
				RMCG.Activate();
			}
		}
		
		RMCProjectiles.Length = 0;
		n = 0;
		// Updating ItmeName
		UpdateItemName(n);
	}
}

exec function SwitchModes()
{
	DoToggle();
}
//[end]

function float GetAIRating()
{
	local AIController B;

	B = AIController(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

function byte BestMode()
{
	return 0;
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

//[end] Functions
//====================================================================

defaultproperties
{
     ModeSwitchSound=(Ref="KF_KSGSnd.KSG_Magin",Vol=1.850000)
	 MagCapacity=6
     // ReloadRate=1.634000 / 1.10
	 ReloadRate=1.485454
     ReloadAnim="Reload"
     // ReloadAnimRate=1.000000 * 1.10
	 ReloadAnimRate=1.100000
     WeaponReloadAnim="Reload_M32_MGL"
     Weight=7.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_M32'
     bIsTier3Weapon=True
     MeshRef="KF_Weapons2_Trip.M32_MGL_Trip"
     SkinRefs(0)="KF_Weapons2_Trip_T.Special.M32_cmb"
     SkinRefs(1)="KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr"
     SelectSoundRef="KF_M79Snd.M79_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.M32_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.M32"
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_MGL140Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="An advanced semi-automatic tactical grenade launcher. Launches high explosive RMC grenades."
     DisplayFOV=65.000000
     Priority=190
     InventoryGroup=4
     GroupOffset=6
     PickupClass=Class'UnlimaginMod.UM_MGL140Pickup'
     PlayerViewOffset=(X=18.000000,Y=20.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_MGL140TAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="MGL140 Tactical"
     LightType=LT_None
     LightBrightness=0.000000
     LightRadius=0.000000
}
