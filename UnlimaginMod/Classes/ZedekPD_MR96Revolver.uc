//=============================================================================
// MR96
//=============================================================================
// MR96 Revolver Inventory Class
//=============================================================================
class ZedekPD_MR96Revolver extends UM_BaseRevolver;


function float GetAIRating()
{
	local Bot B;


	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		Return AIRating;

	Return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

function byte BestMode()
{
    Return 0;
}

defaultproperties
{
     MeshRef="MR96_A.mr96"
     SkinRefs(0)="MR96_T.mr96_cmb"
     SelectSoundRef="MR96_S.de_deploy"
     HudImageRef="MR96_T.mr96_unsel"
     SelectedHudImageRef="MR96_T.mr96_sel"
	 MagCapacity=6
     ReloadRate=2.660000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Revolver"
     Weight=2.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'MR96_T.mr96_trader'
     bIsTier2Weapon=True
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.ZedekPD_MR96RevolverFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.450000
     CurrentRating=0.450000
     bShowChargingBar=True
     Description="MR96 revolver pistol. Far more powerful than that ol' Magnum."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=105
     InventoryGroup=2
     GroupOffset=5
     PickupClass=Class'UnlimaginMod.ZedekPD_MR96RevolverPickup'
     PlayerViewOffset=(X=12.000000,Y=15.000000,Z=-7.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.ZedekPD_MR96RevolverAttachment'
     IconCoords=(X1=250,Y1=110,X2=330,Y2=145)
     ItemName="MR96 Revolver"
     bUseDynamicLights=True
     TransientSoundVolume=1.000000
}
