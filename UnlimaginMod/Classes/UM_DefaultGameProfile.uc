/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DefaultGameProfile
	Creation date:	 24.01.2015 01:31
----------------------------------------------------------------------------------
	Copyright © 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 Default UnlimaginGameType Profile
==================================================================================*/
class UM_DefaultGameProfile extends UM_GameTypeProfile
	Abstract;


defaultproperties
{
     MaxHumanPlayers=12
	 // Kills for DramaticEvent
	 DramaticKills(0)=(MinKilled=2,EventChance=0.03,EventDuration=2.5)
	 DramaticKills(1)=(MinKilled=5,EventChance=0.05,EventDuration=3.0)
	 DramaticKills(2)=(MinKilled=10,EventChance=0.2,EventDuration=3.5)
	 DramaticKills(3)=(MinKilled=15,EventChance=0.4,EventDuration=4.0)
	 DramaticKills(4)=(MinKilled=20,EventChance=0.8,EventDuration=4.5)
	 DramaticKills(5)=(MinKilled=25,EventChance=1.0,EventDuration=5.0)
	 // WaveMonsters
	 WaveMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveLimits=(8,8,10,10,12,12,14),WaveSpawnChances=(0.25,0.3,0.35,0.4,0.4,0.45,0.45),WaveSpawnDelays=(24.0,22.0,20.0,18.0,16.0,14.0,12.0))
	 WaveMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 WaveMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveLimits=(2,2,4,6,8,8,10),WaveSpawnChances=(0.1,0.15,0.2,0.25,0.3,0.35,0.4),WaveSpawnDelays=(28.0,26.0,24.0,22.0,20.0,18.0,16.0))
	 WaveMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieFleshPound",WaveLimits=(0,0,1,1,1,2,2),WaveSpawnChances=(0.0,0.0,0.05,0.1,0.15,0.2,0.25),WaveSpawnDelays=(0.0,0.0,360.0,300.0,240.0,180.0,120.0))
	 WaveMonsters(4)=(MonsterClassName="UnlimaginMod.UM_ZombieGoreFast",WaveLimits=(14,16,18,20,22,24,26),WaveSpawnChances=(0.35,0.4,0.45,0.5,0.55,0.6,0.6))
	 WaveMonsters(5)=(MonsterClassName="UnlimaginMod.UM_ZombieHusk",WaveLimits=(0,1,2,2,3,3,3),WaveSpawnChances=(0.0,0.1,0.15,0.15,0.2,0.25,0.3),WaveSpawnDelays=(0.0,300.0,240.0,180.0,120.0,90.0,60.0))
	 WaveMonsters(6)=(MonsterClassName="UnlimaginMod.UM_ZombieScrake",WaveLimits=(0,0,2,4,4,6,6),WaveSpawnChances=(0.0,0.0,0.1,0.15,0.2,0.25,0.25),WaveSpawnDelays=(0.0,0.0,300.0,240.0,180.0,120.0,90.0))
	 WaveMonsters(7)=(MonsterClassName="UnlimaginMod.UM_ZombieSiren",WaveLimits=(0,1,2,2,4,4,6),WaveSpawnChances=(0.0,0.15,0.15,0.2,0.2,0.25,0.25),WaveSpawnDelays=(0.0,240.0,210.0,180.0,120.0,90.0,60.0))
	 WaveMonsters(8)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimits=(6,8,10,12,14,16,18),WaveSpawnChances=(0.45,0.45,0.5,0.55,0.55,0.5,0.5))
	 // GameWaves - 7 waves
	 GameWaves(0)=(MinMonsters=20,MaxMonsters=280,MaxMonstersAtOnce=36,MonstersPerPlayer=8,WaveDifficulty=0.2)
	 GameWaves(1)=(MinMonsters=25,MaxMonsters=350,MaxMonstersAtOnce=40,MonstersPerPlayer=8,WaveDifficulty=0.4)
	 GameWaves(2)=(MinMonsters=30,MaxMonsters=420,MaxMonstersAtOnce=42,MonstersPerPlayer=8,WaveDifficulty=0.8)
	 GameWaves(3)=(MinMonsters=35,MaxMonsters=490,MaxMonstersAtOnce=44,MonstersPerPlayer=8,WaveDifficulty=1.0)
	 GameWaves(4)=(MinMonsters=40,MaxMonsters=560,MaxMonstersAtOnce=46,MonstersPerPlayer=8,WaveDifficulty=1.2)
	 GameWaves(5)=(MinMonsters=50,MaxMonsters=700,MaxMonstersAtOnce=48,MonstersPerPlayer=8,WaveDifficulty=1.4)
	 GameWaves(6)=(MinMonsters=60,MaxMonsters=840,MaxMonstersAtOnce=50,MonstersPerPlayer=8,WaveDifficulty=1.6)
	 // Boss
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 // BossWaveMonsters
	 BossWaveMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveLimit=4,WaveSpawnChance=0.2)
	 BossWaveMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 BossWaveMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveLimit=2,WaveSpawnChance=0.2)
	 BossWaveMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimit=4,WaveSpawnChance=0.4)
}
