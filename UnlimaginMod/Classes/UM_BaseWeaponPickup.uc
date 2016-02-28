//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponPickup
//	Parent class:	 KFWeaponPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.07.2013 17:32
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseWeaponPickup extends KFWeaponPickup
	Abstract;


//Dual weapon
var		class<KFWeapon>		SingleWeaponClass, DualWeaponClass;
var		bool				bPickedUpSingleWeapon;
var		Pawn				LastCantCarryPawn;

function bool AllowRepeatPickup()
{
    Return ( DualWeaponClass != None || SingleWeaponClass != None || !bWeaponStay || (bDropped && !bThrown) );
}

function Inventory SpawnCopy( Pawn Other )
{
	local	Inventory	Copy;

	if ( bPickedUpSingleWeapon )  {
		if ( Inventory != None )  {
			Inventory.Destroy();
			Inventory = None;
		}
		Copy = Spawn(SingleWeaponClass, Other, , , rot(0,0,0));
	}
	else  {
		if ( Inventory != None )  {
			Copy = Inventory;
			Inventory = None;
		}
		else
			Copy = Spawn(InventoryType, Other, , , rot(0,0,0));
	}

	Copy.GiveTo( Other, self );

	Return Copy;
}

function SetRespawn()
{
	if ( bPickedUpSingleWeapon ) {
		Spawn(SingleWeaponClass.default.PickupClass, Owner);
		Destroy();
	}
	else if ( Level.Game.ShouldRespawn(self) )
		StartSleeping();
	else
		Destroy();
}

function bool CheckCanCarry( KFHumanPawn H )
{
	local	Inventory	Inv;
	
	if ( H == LastCantCarryPawn && Level.TimeSeconds < LastCantCarryTime )
		Return False;
	
	// Check if Pawn already have a Dual variant of this Weapon
	if ( DualWeaponClass != None )  {
		for ( Inv = H.Inventory; Inv != None; Inv = Inv.Inventory )  {
			if ( Inv.Class == DualWeaponClass )  {
				// Has this Weapon Msg
				if ( PlayerController(H.Controller) != None )
					PlayerController(H.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 1);
				// Can't carry this weapon
				LastCantCarryPawn = H;
				LastCantCarryTime = Level.TimeSeconds + 0.5;
				Return False;
			}
		}
	}
	// If Pawn can't carry this weapon
	else if ( !H.CanCarry(Weight) )  {
		// if this is a DualWeaponPickup
		if ( SingleWeaponClass != None && H.CanCarry(SingleWeaponClass.default.Weight) )  {
			bPickedUpSingleWeapon = True;
			Return True;
		}
		
		// Has this Weapon Msg
		if ( PlayerController(H.Controller) != None )
			PlayerController(H.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 2);
		// Can't carry this weapon
		LastCantCarryPawn = H;
		LastCantCarryTime = Level.TimeSeconds + 0.5;
		Return False;
	}

	Return True;
}

function bool ValidTouch( Actor Other )
{
	// Make sure its a live player, not touching through wall and can carry this item
	if ( Pawn(Other) == None || !Pawn(Other).bCanPickupInventory || (Pawn(Other).DrivenVehicle == None && Pawn(Other).Controller == None) || !FastTrace(Other.Location, Location) || (KFHumanPawn(Other) != None && !CheckCanCarry(KFHumanPawn(Other))) )
		Return False;
	
	// make sure game will let player pick me up
	if( Level.Game.PickupQuery(Pawn(Other), self) )  {
		TriggerEvent(Event, self, Pawn(Other));
		Return True;
	}
	
	Return False;
}

auto state Pickup
{
	// Overload state super function
	function bool ValidTouch( Actor Other );
	
	event BeginState()
	{
		UntriggerEvent(Event, self, None);
		if ( bDropped )  {
			AddToNavigation();
			SetTimer(20, false);
		}
	}

	/* When touched by an actor.  Let's mod this to account for Weights. 
		Player can't pickup items if he's exceeding his max carry weight */
	event Touch(Actor Other)
	{
		local	Inventory	Copy;

		// If touched by a player pawn, let him pick this up.
		if ( Global.ValidTouch(Other) )  {
			Copy = SpawnCopy(Pawn(Other));
			AnnouncePickup(Pawn(Other));
			SetRespawn();
			if ( Copy != None )
				Copy.PickupFunction(Pawn(Other));

			if ( MySpawner != None && KFGameType(Level.Game) != None )
				KFGameType(Level.Game).WeaponPickedUp(MySpawner);

			if ( KFWeapon(Copy) != None )  {
				KFWeapon(Copy).SellValue = SellValue;
				KFWeapon(Copy).bPreviouslyDropped = bDropped;
				if ( !bPreviouslyDropped && KFWeapon(Copy).bIsTier3Weapon 
					 && Pawn(Other).Controller != None && Pawn(Other).Controller != DroppedBy )
					KFWeapon(Copy).Tier3WeaponGiver = DroppedBy;
			}
		}
	}
}

state FallingPickup
{
	event BeginState();
	event Timer();
	
	function bool ValidTouch( Actor Other )
	{
		// make sure thrower doesn't run over own weapon
		if ( bThrown && Physics == PHYS_Falling && Velocity.Z > 0.0 && (Velocity dot Other.Velocity) > 0.0 && (Velocity dot (Location - Other.Location)) > 0.0 )
			Return False;
		
		Return Global.ValidTouch( Other );
	}
	
	// When touched by an actor.  Let's mod this to account for Weights. (Player can't pickup items)
	// IF he's exceeding his max carry weight.
	event Touch( Actor Other )
	{
		local	Inventory	Copy;

		// If touched by a player pawn, let him pick this up.
		if ( ValidTouch(Other) )  {
			Copy = SpawnCopy(Pawn(Other));
			AnnouncePickup(Pawn(Other));
			SetRespawn();
			if ( Copy != None )
				Copy.PickupFunction( Pawn(Other) );

			if ( MySpawner != None && KFGameType(Level.Game) != None )
				KFGameType(Level.Game).WeaponPickedUp(MySpawner);

			if ( KFWeapon(Copy) != None )  {
				KFWeapon(Copy).SellValue = SellValue;
				KFWeapon(Copy).bPreviouslyDropped = bDropped;
				if ( !bPreviouslyDropped && KFWeapon(Copy).bIsTier3Weapon && Pawn(Other).Controller != None && Pawn(Other).Controller != DroppedBy )
					KFWeapon(Copy).Tier3WeaponGiver = DroppedBy;
			}
		}
	}
}

state FadeOut
{
	event BeginState();
	event Tick(float DeltaTime);
	
	// When touched by an actor.  Let's mod this to account for Weights. (Player can't pickup items)
	// IF he's exceeding his max carry weight.
	event Touch(Actor Other)
	{
		local	Inventory	Copy;

		// If touched by a player pawn, let him pick this up.
		if ( Global.ValidTouch( Other ) )  {
			Copy = SpawnCopy(Pawn(Other));
			AnnouncePickup(Pawn(Other));
			SetRespawn();
			if ( Copy != None )
				Copy.PickupFunction(Pawn(Other));

			if ( MySpawner != None && KFGameType(Level.Game) != None )
				KFGameType(Level.Game).WeaponPickedUp(MySpawner);

			if ( KFWeapon(Copy) != None )  {
				KFWeapon(Copy).SellValue = SellValue;
				KFWeapon(Copy).bPreviouslyDropped = bDropped;
				if ( !bPreviouslyDropped && KFWeapon(Copy).bIsTier3Weapon 
					 && Pawn(Other).Controller != None && Pawn(Other).Controller != DroppedBy )
					KFWeapon(Copy).Tier3WeaponGiver = DroppedBy;
			}
		}
	}
}

defaultproperties
{
     bFixedRotationDir=False
	 UV2Texture=None
	 Physics=PHYS_Rotating
	 //LightColor
	 bAmbientGlow=True
	 LightBrightness=193.000000
	 LightHue=149
     LightSaturation=125
	 LightCone=1
	 LightEffect=LE_None
	 LightRadius=1.000000
	 LightPeriod=64
	 LightType=LT_Pulse
}