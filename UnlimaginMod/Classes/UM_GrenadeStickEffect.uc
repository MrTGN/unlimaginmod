//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GrenadeStickEffect
//	Parent class:	 UM_BaseHitEffects
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.04.2014 17:37
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GrenadeStickEffect extends UM_BaseHitEffects;

#exec OBJ LOAD FILE=..\Sounds\ProjectileSounds.uax

defaultproperties
{
     HitEffects(0)=(HitDecal=Class'ROEffects.BulletHoleDirt',HitEffect=Class'ROEffects.ROBulletHitRockEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(1)=(HitDecal=Class'ROEffects.BulletHoleConcrete',HitEffect=Class'ROEffects.ROBulletHitRockEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(2)=(HitDecal=Class'ROEffects.BulletHoleDirt',HitEffect=Class'ROEffects.ROBulletHitDirtEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(3)=(HitDecal=Class'ROEffects.BulletHoleMetal',HitEffect=Class'ROEffects.ROBulletHitMetalEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(4)=(HitDecal=Class'ROEffects.BulletHoleWood',HitEffect=Class'ROEffects.ROBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(5)=(HitDecal=Class'ROEffects.BulletHoleDirt',HitEffect=Class'ROEffects.ROBulletHitGrassEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(6)=(HitDecal=Class'ROEffects.BulletHoleFlesh',HitEffect=Class'ROEffects.ROBulletHitFleshEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(7)=(HitDecal=Class'ROEffects.BulletHoleIce',HitEffect=Class'ROEffects.ROBulletHitIceEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(8)=(HitDecal=Class'ROEffects.BulletHoleSnow',HitEffect=Class'ROEffects.ROBulletHitSnowEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(9)=(HitEffect=Class'ROEffects.ROBulletHitWaterEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(10)=(HitDecal=Class'ROEffects.BulletHoleIce',HitEffect=Class'ROEffects.ROBreakingGlass',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(11)=(HitDecal=Class'ROEffects.BulletHoleConcrete',HitEffect=Class'ROEffects.ROBulletHitGravelEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(12)=(HitDecal=Class'ROEffects.BulletHoleConcrete',HitEffect=Class'ROEffects.ROBulletHitConcreteEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(13)=(HitDecal=Class'ROEffects.BulletHoleWood',HitEffect=Class'ROEffects.ROBulletHitWoodEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(14)=(HitDecal=Class'ROEffects.BulletHoleSnow',HitEffect=Class'ROEffects.ROBulletHitMudEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(15)=(HitDecal=Class'ROEffects.BulletHoleMetalArmor',HitEffect=Class'ROEffects.ROBulletHitMetalArmorEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(16)=(HitDecal=Class'ROEffects.BulletHoleConcrete',HitEffect=Class'ROEffects.ROBulletHitPaperEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(17)=(HitDecal=Class'ROEffects.BulletHoleCloth',HitEffect=Class'ROEffects.ROBulletHitClothEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(18)=(HitDecal=Class'ROEffects.BulletHoleMetal',HitEffect=Class'ROEffects.ROBulletHitRubberEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
     HitEffects(19)=(HitDecal=Class'ROEffects.BulletHoleDirt',HitEffect=Class'ROEffects.ROBulletHitMudEffect',HitSound=Sound'ProjectileSounds.PTRD_deflect04')
}
