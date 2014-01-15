class Braindead_MP5_1st_MuzzleFlash extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	Emitters[0].SpawnParticle(2);
	Emitters[1].SpawnParticle(1);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseSubdivisionScale=True
         UseRandomSubdivision=True
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=12.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'BD_MP5_FL_T.Muzzleflash.MP5SDmuzzleflash'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'UnlimaginMod.Braindead_MP5_1st_MuzzleFlash.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Opacity=0.100000
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'UnlimaginMod.Braindead_MP5_1st_MuzzleFlash.SpriteEmitter1'

}
