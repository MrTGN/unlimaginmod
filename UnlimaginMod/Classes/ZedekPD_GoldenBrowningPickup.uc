//=============================================================================
// Deagle Pickup.
//=============================================================================
class ZedekPD_GoldenBrowningPickup extends ZedekPD_BrowningPickup;


defaultproperties
{
     cost=700
	 Description="A deliciously golden pistol, packing punch."
     ItemName="Golden Browning Hi-Power"
     ItemShortName="Golden Browning HP"
     //showMesh=SkeletalMesh'Browning_A.goldbrowning_3rd'
     InventoryType=Class'UnlimaginMod.ZedekPD_GoldenBrowningPistol'
     PickupMessage="You got the Golden Browning Hi-Power."
     StaticMesh=StaticMesh'Browning_SM.goldbrowning_pickup'
}
