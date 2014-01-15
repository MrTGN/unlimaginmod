//=============================================================================
// ZedekPD_BrowningPistol Inventory class
//=============================================================================
class ZedekPD_BrowningPistol extends UM_BaseHandgun;

#exec OBJ LOAD FILE=Browning_S.uax
#exec OBJ LOAD FILE=Browning_A.ukx
#exec OBJ LOAD FILE=Browning_T.utx

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( B == None || B.Enemy == None )
		Return AIRating;

	Return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

function byte BestMode()
{
    Return 0;
}


defaultproperties
{
     EmptyIdleAnim="Idle_empty"
     EmptyIdleAimAnim="Idle_iron_empty"
     EmptySelectAnim="Select_Empty"
     EmptyPutDownAnim="PutDown_Empty"
     MagCapacity=10
     ReloadRate=2.266600
     ReloadAnim="Reload_Empty"
	 TacticalReloadRate=1.866600
	 TacticalReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Single9mm"
     Weight=2.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'Browning_T.pic_trader'
     bIsTier2Weapon=True
     MeshRef="Browning_A.browning"
     SkinRefs(0)="Browning_T.browning1"
     SkinRefs(1)="Browning_T.browning2"
     HudImageRef="Browning_T.pic_unsel"
     SelectedHudImageRef="Browning_T.pic_sel"
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.ZedekPD_BrowningFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     BringUpTime=0.833333
     SelectSoundRef="KF_HandcannonSnd.50AE_Select"
     AIRating=0.450000
     CurrentRating=0.450000
     bShowChargingBar=True
     Description="The Browning High-Power is a single-action, .40 S&W semi-automatic handgun."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=100
     InventoryGroup=2
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.ZedekPD_BrowningPickup'
     PlayerViewOffset=(X=10.000000,Y=19.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.ZedekPD_BrowningAttachment'
     IconCoords=(X1=250,Y1=110,X2=330,Y2=145)
     ItemName="Browning Hi-Power"
     bUseDynamicLights=True
     TransientSoundVolume=1.000000
}
