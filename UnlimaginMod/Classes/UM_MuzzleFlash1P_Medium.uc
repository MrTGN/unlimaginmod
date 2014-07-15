//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MuzzleFlash1P_Medium
//	Parent class:	 UM_BaseEmitter
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.01.2014 15:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MuzzleFlash1P_Medium extends UM_BaseEmitter;


defaultproperties
{
     Begin Object Class=SpriteEmitter Name=MuzzleFlash0
	     UseColorScale=True
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         UseSubdivisionScale=True
         Acceleration=(Z=50.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		 Opacity=0.950000
         FadeOutStartTime=0.102500
         FadeInEndTime=0.050000
         MaxParticles=3
         SizeScale(0)=(RelativeTime=0.140000,RelativeSize=0.150000)
		 SizeScale(1)=(RelativeTime=0.400000,RelativeSize=0.300000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.750000)
         StartSizeRange=(X=(Min=10.000000,Max=14.000000),Y=(Min=10.000000,Max=14.000000),Z=(Min=10.000000,Max=14.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.explosions.impact_2frame'
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=50.000000,Max=50.000000))
		 TriggerDisabled=False
		 AutomaticInitialSpawning=False
		 RespawnDeadParticles=False
		 SpawnOnTriggerPPS=2000.000000
		 SpawnOnTriggerRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'UnlimaginMod.UM_MuzzleFlash1P_Medium.MuzzleFlash0'
}
