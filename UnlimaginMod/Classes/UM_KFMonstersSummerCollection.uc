//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KFMonstersSummerCollection
//	Parent class:	 UM_KFMonstersCollection
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 03.07.2013 21:37
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_KFMonstersSummerCollection extends UM_KFMonstersCollection;


defaultproperties
{
     MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_CIRCUS")
     MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_CIRCUS")
     MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_CIRCUS")
     MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_CIRCUS")
     MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_CIRCUS")
     MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_CIRCUS")
     MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_CIRCUS")
     MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_CIRCUS")
     MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_CIRCUS")
     StandardMonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_CIRCUS")
     StandardMonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_CIRCUS")
     StandardMonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_CIRCUS")
     StandardMonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_CIRCUS")
     StandardMonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_CIRCUS")
     StandardMonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_CIRCUS")
     StandardMonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_CIRCUS")
     StandardMonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_CIRCUS")
     StandardMonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_CIRCUS")
     ShortSpecialSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_CIRCUS","UnlimaginMod.UM_ZombieGorefast_CIRCUS","UnlimaginMod.UM_ZombieStalker_CIRCUS","UnlimaginMod.UM_ZombieScrake_CIRCUS"))
     ShortSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     NormalSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_CIRCUS","UnlimaginMod.UM_ZombieGorefast_CIRCUS","UnlimaginMod.UM_ZombieStalker_CIRCUS","UnlimaginMod.UM_ZombieScrake_CIRCUS"))
     NormalSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     NormalSpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     NormalSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     LongSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_CIRCUS","UnlimaginMod.UM_ZombieGorefast_CIRCUS","UnlimaginMod.UM_ZombieStalker_CIRCUS","UnlimaginMod.UM_ZombieScrake_CIRCUS"))
     LongSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     LongSpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     LongSpecialSquads(8)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieScrake_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     LongSpecialSquads(9)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_CIRCUS","UnlimaginMod.UM_ZombieSiren_CIRCUS","UnlimaginMod.UM_ZombieScrake_CIRCUS","UnlimaginMod.UM_ZombieFleshPound_CIRCUS"))
     FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot_CIRCUS"))
     FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot_CIRCUS","UnlimaginMod.UM_ZombieCrawler_CIRCUS"))
     FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot_CIRCUS","UnlimaginMod.UM_ZombieStalker_CIRCUS","UnlimaginMod.UM_ZombieCrawler_CIRCUS"))
     FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker_CIRCUS"
     EndGameBossClass="UnlimaginMod.UM_ZombieBoss_CIRCUS"
}
