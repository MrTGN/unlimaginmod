//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BulletTracer
//	Parent class:	 KFTracer
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 01:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BulletTracer extends KFTracer;



defaultproperties
{
     mStartParticles=0
     mMaxParticles=40
	 mLifeRange(0)=0.040000
     mLifeRange(1)=0.040000
	 mRegenRange(0)=30.000000
     mRegenRange(1)=30.000000
	 mSpawnVecB=(X=20.000000,Z=0.000000)
	 mSizeRange(0)=4.000000
     mSizeRange(1)=4.000000
     mGrowthRate=-0.500000
     mColorRange(0)=(B=82,G=231,R=252,A=92)
     mColorRange(1)=(B=82,G=231,R=252,A=92)
}
