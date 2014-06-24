//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMuzzleSmoke1st
//	Parent class:	 UM_BaseEmitter
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.11.2013 01:13
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseMuzzleSmoke1st extends UM_BaseEmitter;


defaultproperties
{
	 Begin Object Class=SpriteEmitter Name=Smoke1
		 UseColorScale=True
		 FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=218))
         Opacity=0.220000
         MaxParticles=200
         StartLocationOffset=(X=5.000000)
         StartLocationRange=(X=(Max=10.000000))
		 UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
         LifetimeRange=(Min=1.200000,Max=1.200000)
         StartVelocityRange=(X=(Min=20.000000,Max=40.000000),Z=(Min=10.000000,Max=30.000000))
         VelocityLossRange=(X=(Max=2.000000))
		 TriggerDisabled=False
		 AutomaticInitialSpawning=False
		 RespawnDeadParticles=False
		 SpawnOnTriggerPPS=750.000000
		 SpawnOnTriggerRange=(Min=2.000000,Max=3.000000)
     End Object
	 Emitters(0)=SpriteEmitter'UnlimaginMod.UM_BaseMuzzleSmoke1st.Smoke1'
	 
	 Begin Object Class=SpriteEmitter Name=Smoke2
		 UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=218))
         Opacity=0.220000
         MaxParticles=100
         StartLocationOffset=(X=5.000000)
         StartLocationRange=(X=(Max=10.000000))
		 UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
         LifetimeRange=(Min=1.500000,Max=3.000000)
         StartVelocityRange=(X=(Min=50.000000,Max=75.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=1.000000)
		 TriggerDisabled=False
		 AutomaticInitialSpawning=False
		 RespawnDeadParticles=False
		 SpawnOnTriggerPPS=1500.000000
		 SpawnOnTriggerRange=(Min=1.000000,Max=2.000000)
     End Object
     Emitters(1)=SpriteEmitter'UnlimaginMod.UM_BaseMuzzleSmoke1st.Smoke2'
	 
	 CullDistance=20000.000000
	 bNoDelete=False
	 bUnlit=False
     //Style=STY_Masked
	 //Style=STY_Additive
     bDirectional=True
	 bHardAttach=True
}
