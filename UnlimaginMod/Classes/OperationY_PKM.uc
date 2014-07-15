//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_PKM extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE="PKM_SN.uax"
#exec OBJ LOAD FILE="..\textures\Pkm_T.utx"
#exec OBJ LOAD FILE="..\Animations\Pkm_A.ukx"

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
	 //Mesh=SkeletalMesh'Pkm_A.pkmmesh'
	 MeshRef="Pkm_A.pkmmesh"
     //Skins(0)=Texture'Pkm_T.wpn_pkm'
	 SkinRefs(0)="Pkm_T.wpn_pkm"
     //Skins(1)=Texture'Pkm_T.wpn_pkm_lenta'
	 SkinRefs(1)="Pkm_T.wpn_pkm_lenta"
     //Skins(2)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
	 SkinRefs(2)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     //SelectSound=Sound'PKM_SN.pkm_draw'
	 SelectSoundRef="PKM_SN.pkm_draw"
     //HudImage=Texture'Pkm_T.PKM_Unselected'
	 HudImageRef="Pkm_T.PKM_Unselected"
     //SelectedHudImage=Texture'Pkm_T.PKM_selected'
	 SelectedHudImageRef="Pkm_T.PKM_selected"
	 //[end]
     MagCapacity=100
     QuickPutDownTime=0.300000
     QuickBringUpTime=0.300000
     ReloadRate=6.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M14"
     Weight=14.000000
     SleeveNum=2
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'Pkm_T.PKM_Trader'
     bIsTier2Weapon=True
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.OperationY_PKMFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="7.62x54mmR general-purpose machine gun designed in the Soviet Union and currently in production in Russia."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=190
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=7
     PickupClass=Class'UnlimaginMod.OperationY_PKMPickup'
     PlayerViewOffset=(X=-10.000000,Y=18.000000,Z=-11.000000)
     BobDamping=5.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_PKMAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="PKM"
     TransientSoundVolume=1.250000
}
