//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KFMonstersXMasCollection
//	Parent class:	 UM_KFMonstersCollection
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 15.12.2012 0:42
//================================================================================
class UM_KFMonstersXMasCollection extends UM_KFMonstersCollection;

defaultproperties
{
     MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_XMas",Mid="A")
     MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_XMas",Mid="B")
     MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_XMas",Mid="C")
     MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_XMas",Mid="D")
     MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_XMas",Mid="E")
     MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_XMas",Mid="F")
     MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_XMas",Mid="G")
     MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_XMas",Mid="H")
     MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_XMas",Mid="I")
	 StandardMonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_XMas",Mid="A")
     StandardMonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_XMas",Mid="B")
     StandardMonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_XMas",Mid="C")
     StandardMonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_XMas",Mid="D")
     StandardMonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_XMas",Mid="E")
     StandardMonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_XMas",Mid="F")
     StandardMonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_XMas",Mid="G")
     StandardMonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_XMas",Mid="H")
     StandardMonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_XMas",Mid="I")
     ShortSpecialSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_XMas","UnlimaginMod.UM_ZombieGoreFast_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieScrake_XMas"),NumZeds=(2,2,1,1))
     ShortSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,2,1))
     NormalSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_XMas","UnlimaginMod.UM_ZombieGoreFast_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieScrake_XMas"),NumZeds=(2,2,1,1))
     NormalSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1))
     NormalSpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,1,1))
     NormalSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,1,2))
     LongSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_XMas","UnlimaginMod.UM_ZombieGoreFast_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieScrake_XMas"),NumZeds=(2,2,1,1))
     LongSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1))
     LongSpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,1,1))
     LongSpecialSquads(8)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieScrake_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,2,1,1))
     LongSpecialSquads(9)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieScrake_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,2,1,2))
     FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas"))
     FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas","UnlimaginMod.UM_ZombieCrawler_XMas"))
     FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieCrawler_XMas"))
     FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker_XMas"
     EndGameBossClass="UnlimaginMod.UM_ZombieBoss_XMas"
}
