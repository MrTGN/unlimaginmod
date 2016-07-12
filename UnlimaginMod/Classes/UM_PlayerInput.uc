//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_PlayerInput
//	Parent class:	 KFPlayerInput
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.01.2014 04:43
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_PlayerInput extends KFPlayerInput within UM_PlayerController
	config(User);


//========================================================================
//[block] Functions

// Postprocess the player's input.
event PlayerInput( float DeltaTime )
{
	local float FOVScale, MouseScale;

	// Ignore input if we're playing back a client-side demo.
	if ( Outer.bDemoOwner && !Outer.default.bDemoOwner )
		Return;

	// Modify mouse sensitivity based on the scope - Ramm
	if ( Outer.GetMouseModifier() < 0 )
	    FOVScale = DesiredFOV * 0.01111; // 0.01111 = 1/90
	else
	    FOVScale = Outer.GetMouseModifier() * 0.01111; // 0.01111 = 1/90

	// Smooth and amplify mouse movement
	MouseScale = MouseSensitivity * FOVScale;
	aMouseX = SmoothMouse( (aMouseX * MouseScale), DeltaTime, bXAxis, 0 );
	aMouseY = SmoothMouse( (aMouseY * MouseScale), DeltaTime, bYAxis, 1 );

	aMouseX = AccelerateMouse(aMouseX);
	aMouseY = AccelerateMouse(aMouseY);

	// adjust keyboard and joystick movements
	aLookUp *= FOVScale;
	aTurn *= FOVScale;

	// Remap raw x-axis movement.
	if ( bStrafe != 0 ) // strafe
		aStrafe += aBaseX * 7.5 + aMouseX;
	else // forward
		aTurn  += aBaseX * FOVScale + aMouseX;
	aBaseX = 0;

	// Remap mouse y-axis movement.
	if ( bStrafe == 0 && (bAlwaysMouseLook || bLook > 0) )  {
		// Look up/down.
		if ( bInvertMouse )
			aLookUp -= aMouseY;
		else
			aLookUp += aMouseY;
	}
	else // Move forward/backward.
		aForward += aMouseY;

	if ( bSnapLevel > 0 )  {
		bCenterView = True;
		bKeyboardLook = False;
	}
	else if ( aLookUp > 0 )  {
		bCenterView = False;
		bKeyboardLook = True;
	}
	else if ( bSnapToLevel && !bAlwaysMouseLook )  {
		bCenterView = True;
		bKeyboardLook = False;
	}

	// Remap other y-axis movement.
	if ( bFreeLook > 0 )  {
		bKeyboardLook = True;
		aLookUp += 0.5 * aBaseY * FOVScale;
	}
	else
		aForward += aBaseY;

	aBaseY = 0;

	// Handle walking.
	HandleWalking();
}

// turn off DoubleClickMove
function Actor.eDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
	Return DCLICK_None;
}

//[end] Functions
//====================================================================

defaultproperties
{
     bEnableDodging=False
}
