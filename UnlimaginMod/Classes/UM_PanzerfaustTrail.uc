//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_PanzerfaustTrail
//	Parent class:	 UM_BaseEmitter
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 17.07.2013 00:00
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_PanzerfaustTrail extends UM_BaseEmitter;

simulated function HandleOwnerDestroyed()
{
    Emitters[0].ParticlesPerSecond = 0;
    Emitters[0].InitialParticlesPerSecond = 0;
    Emitters[0].RespawnDeadParticles = False;

    Emitters[1].ParticlesPerSecond = 0;
    Emitters[1].InitialParticlesPerSecond = 0;
    Emitters[1].RespawnDeadParticles = False;

    AutoDestroy = True;
}

simulated event Destroyed()
{
	HandleOwnerDestroyed();
	Super.Destroyed();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(X=70.000000,Z=20.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.950000
         MaxParticles=100
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.200000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=15.000000,Max=30.000000))
         ParticlesPerSecond=20.000000
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Max=5.000000)
         StartVelocityRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.200000,Y=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
     End Object
     Emitters(0)=SpriteEmitter'UnlimaginMod.UM_PanzerfaustTrail.SpriteEmitter0'

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
         ColorScale(0)=(Color=(B=60,G=60,R=60,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=117,G=117,R=117,A=255))
         FadeOutStartTime=1.200000
         MaxParticles=100
         AutoResetTimeRange=(Min=5.000000,Max=10.000000)
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.075000,Max=0.075000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.370000,RelativeSize=2.200000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=11.000000,Max=21.000000))
         ParticlesPerSecond=20.000000
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         StartVelocityRange=(X=(Min=40.000000,Max=80.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
         VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.400000,RelativeVelocity=(X=0.150000,Y=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=0.400000,Z=0.400000))
     End Object
     Emitters(1)=SpriteEmitter'UnlimaginMod.UM_PanzerfaustTrail.SpriteEmitter1'

     bNoDelete=False
}
