//===================================================================================
// Whisky_HammerPickup Pickup.
//===================================================================================
class Whisky_HammerPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=1400
     PowerValue=76
     SpeedValue=20
     RangeValue=-20
     Description="A sturdy sledge hammer."
     ItemName="Sledge Hammer"
     ItemShortName="Hammer"
     //showMesh=SkeletalMesh'whisky_hammer_A.whisky_hammer_3rd'
     CorrespondingPerkIndex=4
     InventoryType=Class'UnlimaginMod.Whisky_Hammer'
     PickupMessage="You got the Sledge Hammer."
     PickupSound=Sound'KF_AxeSnd.Axe_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'WHammer_SM.hammerpickup'
     CollisionRadius=27.000000
     CollisionHeight=5.000000
}
