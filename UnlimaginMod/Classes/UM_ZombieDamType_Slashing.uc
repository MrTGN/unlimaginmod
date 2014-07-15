//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieDamType_Slashing
//	Parent class:	 UM_ZombieDamType_Melee
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 29.04.2013 12:31
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ZombieDamType_Slashing extends UM_ZombieDamType_Melee
	Abstract;


defaultproperties
{
     HUDDamageTex=FinalBlend'KillingFloorHUD.SlashSplashNormalFB'
     HUDUberDamageTex=FinalBlend'KillingFloorHUD.SlashSplashUberFB'
}
