//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_LaserSightModule
//	Parent class:	 UM_BaseTacticalModule
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 16.01.2014 22:01
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_LaserSightModule extends UM_BaseTacticalModule;


//========================================================================
//[block] Variables

// ToDo: ςσς νσζνξ οεπεπΰαξςΰςό θ οεπεοθρΰςό οεπεμεννϋε, ρξηδΰςό ρβξθ κλΰρρϋ.
// Ροΰβνθςόρÿ ξνξ δξλζνξ, οξρσςθ, ςξλόκξ νΰ ρΰμξμ κλθενςε, ΰ νε ρεπβεπε ύττεκςϋ νε νσζνϋ.
var         LaserDot                    Spot;                       // The first person laser site dot
var			Class<LaserDot>				SpotEffectClass;
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location

// ToDo: ύςξ νσζνξ σαπΰςό, θαξ σ μενÿ ερςό ρβξι κλΰρρ δλÿ λΰηεπΰ ξς 3-γξ λθφΰ.
var         LaserBeamEffect             Beam;                       // Third person laser beam effect
var			Class<LaserBeamEffect>		BeamEffectClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================


defaultproperties
{
}
