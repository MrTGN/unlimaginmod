//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Hammer Inventory class
//===================================================================================
class Whisky_Hammer extends KFMeleeGun;

static function bool UnloadAssets()
{
	if ( super.UnloadAssets() )
	{
		default.SelectSound = none;
	}

	return true;
}

defaultproperties
{
     //[block] Dynamic Loading Vars
     //Mesh=SkeletalMesh'whisky_hammer_A.whisky_hammer_mesh'
	 MeshRef="whisky_hammer_A.whisky_hammer_mesh"
	 //Skins(0)=Texture'whisky_hammer_T.Hammer'
	 SkinRefs(0)="whisky_hammer_T.Hammer"
     //SelectSound=SoundGroup'KF_AxeSnd.Axe_Select'
	 SelectSoundRef="KF_AxeSnd.Axe_Select"
	 //HudImage=Texture'whisky_hammer_T.HUD_Hammer_Unselected'
	 HudImageRef="whisky_hammer_T.HUD_Hammer_Unselected"
     //SelectedHudImage=Texture'whisky_hammer_T.HUD_Hammer_Selected'
	 SelectedHudImageRef="whisky_hammer_T.HUD_Hammer_Selected"
     //BloodyMaterial=Texture'whisky_hammer_T.hammerbloody'
	 BloodyMaterialRef="whisky_hammer_T.hammerbloody"
	 //[end]
	 weaponRange=84.000000
     ChopSlowRate=0.200000
     BloodSkinSwitchArray=0
     bSpeedMeUp=True
     Weight=5.000000
     StandardDisplayFOV=75.000000
     TraderInfoTexture=Texture'whisky_hammer_T.Trader_Hammer'
     FireModeClass(0)=Class'UnlimaginMod.Whisky_HammerFire'
     FireModeClass(1)=Class'UnlimaginMod.Whisky_HammerFireB'
     AIRating=0.300000
     Description="A common seldgehammer."
     DisplayFOV=75.000000
     Priority=100
     GroupOffset=4
     PickupClass=Class'UnlimaginMod.Whisky_HammerPickup'
     BobDamping=8.000000
     AttachmentClass=Class'UnlimaginMod.Whisky_HammerAttachment'
     IconCoords=(X1=169,Y1=39,X2=241,Y2=77)
     ItemName="Hammer"
}
