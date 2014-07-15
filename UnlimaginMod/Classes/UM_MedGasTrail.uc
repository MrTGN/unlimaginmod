//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MedGasTrail
//	Parent class:	 UM_PanzerfaustTrail
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 09.08.2013 07:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MedGasTrail extends UM_PanzerfaustTrail;


defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
		 FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(X=70.000000,Z=20.000000)
         ColorScale(0)=(Color=(B=64,G=255,R=128,A=140))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=255,R=224,A=60))
         FadeOutStartTime=0.950000
         MaxParticles=100
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.250000)
         SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.500000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=4.500000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000))
         ParticlesPerSecond=25.000000
         InitialParticlesPerSecond=25.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Max=5.000000)
         StartVelocityRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.200000,Y=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
     End Object
     Emitters(0)=SpriteEmitter'UnlimaginMod.UM_MedGasTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         AutoReset=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(X=70.000000,Z=20.000000)
         ColorScale(0)=(Color=(B=0,G=255,R=128,A=180))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=192,R=64,A=90))
         FadeOutStartTime=1.200000
         MaxParticles=100
         AutoResetTimeRange=(Min=5.000000,Max=10.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.250000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=15.000000,Max=25.000000))
         ParticlesPerSecond=25.000000
         InitialParticlesPerSecond=25.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         StartVelocityRange=(X=(Min=40.000000,Max=80.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
         VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=0.150000,Y=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
     End Object
     Emitters(1)=SpriteEmitter'UnlimaginMod.UM_MedGasTrail.SpriteEmitter1'

     bNoDelete=False
}
