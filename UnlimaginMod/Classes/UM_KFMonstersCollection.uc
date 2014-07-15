//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KFMonstersCollection
//	Parent class:	 KFMonstersCollection
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.12.2012 0:26
//================================================================================
class UM_KFMonstersCollection extends KFMonstersCollection;

defaultproperties
{
     MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot",Mid="A")
     MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler",Mid="B")
     MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast",Mid="C")
     MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker",Mid="D")
     MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake",Mid="E")
     MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound",Mid="F")
     MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat",Mid="G")
     MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren",Mid="H")
     MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk",Mid="I")
	 StandardMonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot",Mid="A")
     StandardMonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler",Mid="B")
     StandardMonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast",Mid="C")
     StandardMonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker",Mid="D")
     StandardMonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake",Mid="E")
     StandardMonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound",Mid="F")
     StandardMonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat",Mid="G")
     StandardMonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren",Mid="H")
     StandardMonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk",Mid="I")
     ShortSpecialSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     ShortSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1))
     NormalSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     NormalSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1))
     NormalSpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,1))
     NormalSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,2))
     LongSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     LongSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1))
     LongSpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,1))
     LongSpecialSquads(8)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieScrake","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1,1))
     LongSpecialSquads(9)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieScrake","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1,2))
     FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot"),NumZeds=(6))
     FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot","UnlimaginMod.UM_ZombieCrawler"),NumZeds=(5,1))
     FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieCrawler"),NumZeds=(4,1,1))
     FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker"
     EndGameBossClass="UnlimaginMod.UM_ZombieBoss"
}
