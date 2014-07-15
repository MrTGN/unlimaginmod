//=============================================================================
// ZedekPD_GoldenBrowningPistol Inventory class
//=============================================================================
class ZedekPD_GoldenBrowningPistol extends ZedekPD_BrowningPistol;

#exec OBJ LOAD FILE=Browning_T.utx

defaultproperties
{
     TraderInfoTexture=Texture'Browning_T.pic_trader_gold'
     SkinRefs(0)="Browning_T.browning_1_g_cmb"
     HudImageRef="Browning_T.pic_unsel_gold"
     SelectedHudImageRef="Browning_T.pic_sel_gold"
     FireModeClass(0)=Class'UnlimaginMod.ZedekPD_GoldenBrowningFire'
     Description="A deliciously golden pistol that packs a punch."
     PickupClass=Class'UnlimaginMod.ZedekPD_GoldenBrowningPickup'
     AttachmentClass=Class'UnlimaginMod.ZedekPD_GoldenBrowningAttachment'
     ItemName="Golden Browning Hi-Power"
}
