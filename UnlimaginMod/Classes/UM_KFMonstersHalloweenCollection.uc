//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KFMonstersHalloweenCollection
//	Parent class:	 UM_KFMonstersCollection
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 15.12.2012 0:46
//================================================================================
class UM_KFMonstersHalloweenCollection extends UM_KFMonstersCollection;

defaultproperties
{
     MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_HALLOWEEN",Mid="A")
     MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_HALLOWEEN",Mid="B")
     MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN",Mid="C")
     MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_HALLOWEEN",Mid="D")
     MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_HALLOWEEN",Mid="E")
     MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN",Mid="F")
     MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_HALLOWEEN",Mid="G")
     MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_HALLOWEEN",Mid="H")
     MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_HALLOWEEN",Mid="I")
	 StandardMonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_HALLOWEEN",Mid="A")
     StandardMonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_HALLOWEEN",Mid="B")
     StandardMonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN",Mid="C")
     StandardMonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_HALLOWEEN",Mid="D")
     StandardMonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_HALLOWEEN",Mid="E")
     StandardMonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN",Mid="F")
     StandardMonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_HALLOWEEN",Mid="G")
     StandardMonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_HALLOWEEN",Mid="H")
     StandardMonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_HALLOWEEN",Mid="I")
     ShortSpecialSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_HALLOWEEN","UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN"),NumZeds=(2,2,1,1))
     ShortSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,2,1))
     NormalSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_HALLOWEEN","UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN"),NumZeds=(2,2,1,1))
     NormalSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1))
     NormalSpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,1,1))
     NormalSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,1,2))
     LongSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_HALLOWEEN","UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN"),NumZeds=(2,2,1,1))
     LongSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1))
     LongSpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,1,1))
     LongSpecialSquads(8)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,2,1,1))
     LongSpecialSquads(9)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,2,1,2))
     FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN"))
     FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN","UnlimaginMod.UM_ZombieCrawler_HALLOWEEN"))
     FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieCrawler_HALLOWEEN"))
     FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker_HALLOWEEN"
     EndGameBossClass="UnlimaginMod.UM_ZombieBoss_HALLOWEEN"
}
