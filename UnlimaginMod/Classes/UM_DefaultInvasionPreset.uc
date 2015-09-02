/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DefaultInvasionPreset
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
	Comment:		 Default Settings Profile. 
					 Difficulty: Hard. Game Duration: 7 wave (Normal).
==================================================================================*/
class UM_DefaultInvasionPreset extends UM_BaseInvasionPreset
	Abstract;



defaultproperties
{
     // Monsters
	 Monsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveMinLimits=(4,6,8,8,10,12,12),WaveMaxLimits=(40,60,80,80,100,120,120),WaveSpawnChances=(0.25,0.3,0.35,0.4,0.4,0.45,0.45),WaveSpawnDelays=(24.0,22.0,20.0,18.0,16.0,14.0,12.0))
	 Monsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 Monsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveMinLimits=(2,2,4,6,8,8,8),WaveMaxLimits=(16,18,36,48,54,54,54),WaveSpawnChances=(0.1,0.15,0.2,0.25,0.3,0.35,0.4),WaveSpawnDelays=(28.0,26.0,24.0,22.0,20.0,18.0,16.0))
	 Monsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieFleshPound",WaveMinLimits=(0,0,1,1,1,2,2),WaveMaxLimits=(0,0,4,6,8,12,12),WaveSpawnChances=(0.0,0.0,0.05,0.1,0.15,0.2,0.25),WaveSpawnDelays=(0.0,0.0,360.0,300.0,240.0,180.0,120.0))
	 Monsters(4)=(MonsterClassName="UnlimaginMod.UM_ZombieGoreFast",WaveMinLimits=(6,8,10,12,14,16,18),WaveMaxLimits=(60,80,100,120,140,160,180),WaveSpawnChances=(0.35,0.4,0.45,0.5,0.55,0.6,0.6))
	 Monsters(5)=(MonsterClassName="UnlimaginMod.UM_ZombieHusk",WaveMinLimits=(0,1,1,2,2,3,3),WaveMaxLimits=(2,8,10,),WaveSpawnChances=(0.0,0.1,0.15,0.15,0.2,0.25,0.3),WaveSpawnDelays=(0.0,300.0,240.0,180.0,120.0,90.0,60.0))
	 Monsters(6)=(MonsterClassName="UnlimaginMod.UM_ZombieScrake",WaveLimits=(0,0,2,4,4,6,6),WaveSpawnChances=(0.0,0.0,0.1,0.15,0.2,0.25,0.25),WaveSpawnDelays=(0.0,0.0,300.0,240.0,180.0,120.0,90.0))
	 Monsters(7)=(MonsterClassName="UnlimaginMod.UM_ZombieSiren",WaveLimits=(0,1,2,2,4,4,6),WaveSpawnChances=(0.0,0.15,0.15,0.2,0.2,0.25,0.25),WaveSpawnDelays=(0.0,240.0,210.0,180.0,120.0,90.0,60.0))
	 Monsters(8)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimits=(6,8,10,12,14,16,18),WaveSpawnChances=(0.45,0.45,0.5,0.55,0.55,0.5,0.5))
	 // GameWaves - 7 waves
	 GameWaves(0)=(AliveMonsters=(Min=16,Max=46),MonsterSquadSize=(Min=2,Max=6),SquadsSpawnPeriod=(Min=2.0,Max=4.0),WaveDifficulty=0.7,WaveStartDelay=10,WaveDuration=(Min=480,Max=2400),BreakTime=(Min=90,Max=100),StartingCash=(Min=240,Max=280),MinRespawnCash=200,RespawnCashModifier=0.98)
	 GameWaves(1)=(AliveMonsters=(Min=18,Max=48),MonsterSquadSize=(Min=4,Max=6),SquadsSpawnPeriod=(Min=2.5,Max=4.5),WaveDifficulty=0.8,WaveStartDelay=10,WaveDuration=(Min=600,Max=3000),BreakTime=(Min=90,Max=110),StartingCash=(Min=260,Max=300),MinRespawnCash=220,RespawnCashModifier=0.97)
	 GameWaves(2)=(AliveMonsters=(Min=20,Max=48),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=2.5,Max=5.0),WaveDifficulty=0.9,WaveStartDelay=8,WaveDuration=(Min=720,Max=3600),BreakTime=(Min=100,Max=110),StartingCash=(Min=280,Max=320),MinRespawnCash=240,RespawnCashModifier=0.96)
	 GameWaves(3)=(AliveMonsters=(Min=22,Max=50),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=3.0,Max=5.5),WaveDifficulty=1.0,WaveStartDelay=8,WaveDuration=(Min=840,Max=4200),BreakTime=(Min=100,Max=120),StartingCash=(Min=300,Max=340),MinRespawnCash=260,RespawnCashModifier=0.95)
	 GameWaves(4)=(AliveMonsters=(Min=24,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.0),WaveDifficulty=1.1,WaveStartDelay=6,WaveDuration=(Min=960,Max=4800),BreakTime=(Min=110,Max=120),StartingCash=(Min=320,Max=360),MinRespawnCash=280,RespawnCashModifier=0.94)
	 GameWaves(5)=(AliveMonsters=(Min=26,Max=52),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.5),WaveDifficulty=1.2,WaveStartDelay=6,WaveDuration=(Min=1080,Max=5400),BreakTime=(Min=110,Max=130),StartingCash=(Min=340,Max=380),MinRespawnCash=300,RespawnCashModifier=0.93)
	 GameWaves(6)=(AliveMonsters=(Min=26,Max=52),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=7.0),WaveDifficulty=1.3,WaveStartDelay=5,WaveDuration=(Min=1200,Max=6000),BreakTime=(Min=120,Max=130),StartingCash=(Min=360,Max=400),MinRespawnCash=320,RespawnCashModifier=0.92)
	 // Boss
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=350
	 BossWaveRespawnCashModifier=0.9
	 BossWaveStartDelay=5
	 // BossMonsters
	 BossMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveLimit=4,WaveSpawnChance=0.2)
	 BossMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 BossMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveLimit=2,WaveSpawnChance=0.2)
	 BossMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimit=4,WaveSpawnChance=0.4)
}
