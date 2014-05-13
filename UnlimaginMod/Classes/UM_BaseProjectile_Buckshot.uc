//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Buckshot
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.04.2013 19:38
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_Buckshot extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     // Существует простое практическое правило: максимальная дальность полета дроби приблизительно 
     // равна такому числу сотен метров, какое число целых миллиметров имеет диаметр отдельной 
	 // дробины, выстреленной с максимальной начальной скоростью 375-400 м/с. 
	 // Так, дробь № 7 (2,5 мм) летит на 250 м.
     ProjectileDiameter=18.5
	 BallisticCoefficient=0.050000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=910.000000
	 MaxEffectiveRange=910.000000
	 // ToDo: отредактировать во всех классах картечи массу
	 ProjectileMass=0.037454
	 MuzzleVelocity=380.000000
     HeadShotDamageMult=1.500000
	 // Damage for 7 pellets
	 Damage=40.000000
	 MomentumTransfer=60000.000000
	 HitSoundVolume=0.650000
	 DrawScale=1.080000
}
