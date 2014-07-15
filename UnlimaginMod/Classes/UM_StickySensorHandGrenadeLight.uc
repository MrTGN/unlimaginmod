//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_StickySensorHandGrenadeLight
//	Parent class:	 UM_StickyGrenadeLight
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.08.2013 04:57
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_StickySensorHandGrenadeLight extends UM_StickyGrenadeLight;


defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         UniformSize=True
		 UseColorScale=True
         ColorScale(0)=(Color=(B=255,G=16,R=0,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=16,R=16,A=255))
         FadeOutStartTime=0.235000
         FadeInEndTime=0.235000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=2.600000,Max=2.600000),Z=(Min=3.000000,Max=3.000000))
         StartSizeRange=(X=(Min=4.000000,Max=4.000000),Y=(Min=4.000000,Max=4.000000),Z=(Min=4.000000,Max=4.000000))
         InitialParticlesPerSecond=1.000000
         Texture=Texture'kf_fx_trip_t.Misc.healingFX'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'UnlimaginMod.UM_StickySensorHandGrenadeLight.SpriteEmitter0'

     bNoDelete=False
}
