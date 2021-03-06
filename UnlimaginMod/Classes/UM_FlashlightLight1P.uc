//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_FlashlightLight1P
//	Parent class:	 UM_BaseEmitter
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.03.2014 18:09
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 1st person Flashlight light effect
//================================================================================
class UM_FlashlightLight1P extends UM_BaseEmitter;


defaultproperties
{
     Texture=None
	 DrawType=DT_Particle
	 Style=STY_Particle
     RemoteRole=ROLE_None
	 bMovable=True
	 bDirectional=True
	 bUnlit=False
	 bNoDelete=False
     bHardAttach=True
     bNotOnDedServer=True
	 //LightColor
	 LightBrightness=255.000000
	 LightHue=42
     LightSaturation=251
	 //Light
	 bActorShadows=True
	 //bCorona=True
	 //bDirectionalCorona=True
	 //bLightingVisibility=True
	 bDynamicLight=True
	 LightCone=2
	 LightEffect=LE_Spotlight
	 LightRadius=128.000000
	 LightType=LT_Steady
	 LifeSpan=0.000000
}
