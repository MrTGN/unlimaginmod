//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_IncBulletTracer
//	Parent class:	 UM_BulletTracer
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.11.2012 4:16
//================================================================================
class UM_IncBulletTracer extends UM_BulletTracer;

defaultproperties
{
	mColorRange(0)=(B=25,G=80,R=255,A=112)
    mColorRange(1)=(B=25,G=80,R=255,A=112)
	Skins(0)=Texture'KFX.TransTrailT'
}