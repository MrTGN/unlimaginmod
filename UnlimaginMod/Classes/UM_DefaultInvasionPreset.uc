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
					 Difficulty: Hard. Game Duration: 7 wave.
==================================================================================*/
class UM_DefaultInvasionPreset extends UM_BaseInvasionPreset;



defaultproperties
{
     // GameWaves - 7 waves
	 GameWaves(0)=(AliveMonsters=(Min=12,Max=46),MonsterSquadSize=(Min=4,RandMin=2,Max=12,RandMax=6),SquadsSpawnPeriod=(Min=5.0,RandMin=1.0,Max=4.0,RandMax=1.5),SquadsSpawnEndTime=20,WaveDifficulty=0.7,StartDelay=10,Duration=(Min=3.0,RandMin=0.4,Max=8.0,RandMax=0.8),BreakTime=(Min=90,Max=100),DoorsRepairChance=(Min=1.0,Max=0.6),StartingCash=(Min=240,Max=280),MinRespawnCash=(Min=200,Max=220),DeathCashModifier=(Min=0.98,Max=0.86))
	 GameWaves(1)=(AliveMonsters=(Min=14,Max=48),MonsterSquadSize=(Min=4,RandMin=2,Max=14,RandMax=7),SquadsSpawnPeriod=(Min=4.5,RandMin=1.0,Max=3.5,RandMax=1.5),SquadsSpawnEndTime=20,WaveDifficulty=0.8,StartDelay=8,Duration=(Min=3.5,RandMin=0.5,Max=9.0,RandMax=1.0),BreakTime=(Min=90,Max=110),DoorsRepairChance=(Min=1.0,Max=0.55),StartingCash=(Min=260,Max=300),MinRespawnCash=(Min=220,Max=240),DeathCashModifier=(Min=0.97,Max=0.85))
	 GameWaves(2)=(AliveMonsters=(Min=16,Max=48),MonsterSquadSize=(Min=5,RandMin=2,Max=14,RandMax=8),SquadsSpawnPeriod=(Min=4.0,RandMin=1.0,Max=3.5,RandMax=1.5),SquadsSpawnEndTime=19,WaveDifficulty=0.9,StartDelay=8,Duration=(Min=4.0,RandMin=0.6,Max=10.0,RandMax=1.2),BreakTime=(Min=100,Max=110),DoorsRepairChance=(Min=1.0,Max=0.5),StartingCash=(Min=280,Max=320),MinRespawnCash=(Min=240,Max=260),DeathCashModifier=(Min=0.96,Max=0.84))
	 GameWaves(3)=(AliveMonsters=(Min=18,Max=50),MonsterSquadSize=(Min=5,RandMin=3,Max=16,RandMax=8),SquadsSpawnPeriod=(Min=3.5,RandMin=1.0,Max=3.0,RandMax=1.5),SquadsSpawnEndTime=18,WaveDifficulty=1.0,StartDelay=8,Duration=(Min=4.5,RandMin=0.7,Max=11.0,RandMax=1.4),BreakTime=(Min=100,Max=120),DoorsRepairChance=(Min=1.0,Max=0.45),StartingCash=(Min=300,Max=340),MinRespawnCash=(Min=260,Max=280),DeathCashModifier=(Min=0.95,Max=0.83))
	 GameWaves(4)=(AliveMonsters=(Min=20,Max=50),MonsterSquadSize=(Min=6,RandMin=3,Max=16,RandMax=10),SquadsSpawnPeriod=(Min=3.5,RandMin=1.0,Max=3.0,RandMax=1.5),SquadsSpawnEndTime=17,WaveDifficulty=1.1,StartDelay=6,Duration=(Min=5.0,RandMin=0.8,Max=12.0,RandMax=1.6),BreakTime=(Min=110,Max=120),DoorsRepairChance=(Min=1.0,Max=0.4),StartingCash=(Min=320,Max=360),MinRespawnCash=(Min=280,Max=300),DeathCashModifier=(Min=0.94,Max=0.82))
	 GameWaves(5)=(AliveMonsters=(Min=22,Max=52),MonsterSquadSize=(Min=6,RandMin=3,Max=18,RandMax=10),SquadsSpawnPeriod=(Min=3.0,RandMin=1.0,Max=2.5,RandMax=1.5),SquadsSpawnEndTime=16,WaveDifficulty=1.2,StartDelay=6,Duration=(Min=5.5,RandMin=0.9,Max=13.0,RandMax=1.8),BreakTime=(Min=110,Max=130),DoorsRepairChance=(Min=1.0,Max=0.35),StartingCash=(Min=340,Max=380),MinRespawnCash=(Min=300,Max=320),DeathCashModifier=(Min=0.93,Max=0.81))
	 GameWaves(6)=(AliveMonsters=(Min=22,Max=52),MonsterSquadSize=(Min=7,RandMin=3,Max=18,RandMax=12),SquadsSpawnPeriod=(Min=3.0,RandMin=1.0,Max=2.0,RandMax=1.5),SquadsSpawnEndTime=16,WaveDifficulty=1.3,StartDelay=6,Duration=(Min=6.0,RandMin=1.0,Max=14.0,RandMax=2.0),BreakTime=(Min=120,Max=130),DoorsRepairChance=(Min=1.0,Max=0.3),StartingCash=(Min=360,Max=400),MinRespawnCash=(Min=320,Max=340),DeathCashModifier=(Min=0.92,Max=0.8))
	 
	 // BossWave
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 BossWaveAliveMonsters=(Min=16,Max=48)
	 BossWaveMonsterSquadSize=(Min=12,RandMin=4,Max=36,RandMax=12)
	 BossWaveSquadsSpawnPeriod=(Min=25.0,RandMin=5.0,Max=25.0,RandMax=10.0)
	 BossWaveDifficulty=1.4
	 BossWaveStartDelay=5
	 BossWaveDoorsRepairChance=(Min=1.0,Max=0.2)
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=(Min=340,Max=380)
	 
	 // UM_ZombieBloat
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieBloatData
		 MonsterClassName="UnlimaginMod.UM_ZombieBloat"
		 // WaveLimit
		 WaveLimit(0)=(Min=6,Max=48)
		 WaveLimit(1)=(Min=7,Max=56)
		 WaveLimit(2)=(Min=8,Max=64)
		 WaveLimit(3)=(Min=9,Max=72)
		 WaveLimit(4)=(Min=10,Max=80)
		 WaveLimit(5)=(Min=11,Max=88)
		 WaveLimit(6)=(Min=12,Max=96)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(1)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(2)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(3)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(4)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(5)=(Min=0.35,Max=0.45)
		 WaveSpawnChance(6)=(Min=0.35,Max=0.45)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=6)
		 WaveSquadLimit(1)=(Min=3,Max=7)
		 WaveSquadLimit(2)=(Min=4,Max=8)
		 WaveSquadLimit(3)=(Min=4,Max=9)
		 WaveSquadLimit(4)=(Min=4,Max=10)
		 WaveSquadLimit(5)=(Min=5,Max=10)
		 WaveSquadLimit(6)=(Min=5,Max=10)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=6,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=54.0,Max=20,MaxTime=32.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=48.0,Max=22,MaxTime=34.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=42.0,Max=22,MaxTime=32.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=36.0,Max=24,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=32.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=30.0,Max=26,MaxTime=30.0)
		 // BossWave
		 BossWaveLimit=(Min=6,Max=48)
		 BossWaveSpawnChance=(Min=0.25,Max=0.35)
		 BossWaveSquadLimit=(Min=2,Max=8)
		 BossWaveDeltaLimit=(Min=2,MinTime=30.0,Max=16,MaxTime=60.0)
	 End Object
	 Monsters(0)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieBloatData'
	 
	 // UM_ZombieClot
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieClotData
		 MonsterClassName="UnlimaginMod.UM_ZombieClot"
		 bNoWaveRestrictions=True
		 // BossWave
		 BossWaveLimit=(Min=32,Max=168)
		 BossWaveSpawnChance=(Min=1.0,Max=1.0)
		 BossWaveSquadLimit=(Min=12,Max=48)
		 BossWaveDeltaLimit=(Min=12,MinTime=10.0,Max=48,MaxTime=20.0)
	 End Object
	 Monsters(1)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieClotData'
	 
	 // UM_ZombieCrawler
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieCrawlerData
		 MonsterClassName="UnlimaginMod.UM_ZombieCrawler"
		 // WaveLimit
		 WaveLimit(0)=(Min=3,Max=20)
		 WaveLimit(1)=(Min=4,Max=26)
		 WaveLimit(2)=(Min=5,Max=32)
		 WaveLimit(3)=(Min=6,Max=38)
		 WaveLimit(4)=(Min=7,Max=44)
		 WaveLimit(5)=(Min=8,Max=50)
		 WaveLimit(6)=(Min=8,Max=56)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(1)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(2)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(3)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(4)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(5)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(6)=(Min=0.3,Max=0.4)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=4)
		 WaveSquadLimit(1)=(Min=2,Max=4)
		 WaveSquadLimit(2)=(Min=3,Max=5)
		 WaveSquadLimit(3)=(Min=3,Max=6)
		 WaveSquadLimit(4)=(Min=3,Max=7)
		 WaveSquadLimit(5)=(Min=4,Max=8)
		 WaveSquadLimit(6)=(Min=4,Max=8)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=2,MinTime=60.0,Max=8,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=2,MinTime=54.0,Max=8,MaxTime=26.0)
		 WaveDeltaLimit(2)=(Min=4,MinTime=48.0,Max=12,MaxTime=30.0)
		 WaveDeltaLimit(3)=(Min=4,MinTime=42.0,Max=12,MaxTime=26.0)
		 WaveDeltaLimit(4)=(Min=6,MinTime=48.0,Max=16,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=6,MinTime=42.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=6,MinTime=36.0,Max=16,MaxTime=28.0)
		 // BossWave
		 BossWaveLimit=(Min=4,Max=24)
		 BossWaveSpawnChance=(Min=0.15,Max=0.25)
		 BossWaveSquadLimit=(Min=2,Max=6)
		 BossWaveDeltaLimit=(Min=2,MinTime=40.0,Max=6,MaxTime=30.0)
	 End Object
	 Monsters(2)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieCrawlerData'
	 
	 // UM_ZombieFleshPound
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieFleshPoundData
		 MonsterClassName="UnlimaginMod.UM_ZombieFleshPound"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=0)
		 WaveLimit(1)=(Min=0,Max=2)
		 WaveLimit(2)=(Min=0,Max=4)
		 WaveLimit(3)=(Min=0,Max=6)
		 WaveLimit(4)=(Min=1,Max=8)
		 WaveLimit(5)=(Min=2,Max=10)
		 WaveLimit(6)=(Min=3,Max=12)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.0)
		 WaveSpawnChance(1)=(Min=0.0,Max=0.05)
		 WaveSpawnChance(2)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(3)=(Min=0.0,Max=0.15)
		 WaveSpawnChance(4)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=0)
		 WaveSquadLimit(1)=(Min=1,Max=1)
		 WaveSquadLimit(2)=(Min=1,Max=2)
		 WaveSquadLimit(3)=(Min=1,Max=3)
		 WaveSquadLimit(4)=(Min=1,Max=3)
		 WaveSquadLimit(5)=(Min=1,Max=4)
		 WaveSquadLimit(6)=(Min=1,Max=4)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=0,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=120.0,Max=1,MaxTime=120.0)
		 WaveDeltaLimit(2)=(Min=0,MinTime=120.0,Max=2,MaxTime=120.0)
		 WaveDeltaLimit(3)=(Min=0,MinTime=120.0,Max=3,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=3,MaxTime=90.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=4,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=60.0,Max=4,MaxTime=90.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=3)
		 BossWaveSpawnChance=(Min=0.0,Max=0.1)
		 BossWaveSquadLimit=(Min=1,Max=1)
		 BossWaveDeltaLimit=(Min=1,MinTime=120.0,Max=1,MaxTime=60.0)
	 End Object
	 Monsters(3)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieFleshPoundData'
	 
	 // UM_ZombieGoreFast
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieGoreFastData
		 MonsterClassName="UnlimaginMod.UM_ZombieGoreFast"
		 // WaveLimit
		 WaveLimit(0)=(Min=8,Max=64)
		 WaveLimit(1)=(Min=10,Max=80)
		 WaveLimit(2)=(Min=12,Max=96)
		 WaveLimit(3)=(Min=14,Max=112)
		 WaveLimit(4)=(Min=16,Max=128)
		 WaveLimit(5)=(Min=18,Max=144)
		 WaveLimit(6)=(Min=20,Max=160)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(1)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(2)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(3)=(Min=0.4,Max=0.5)
		 WaveSpawnChance(4)=(Min=0.4,Max=0.5)
		 WaveSpawnChance(5)=(Min=0.45,Max=0.55)
		 WaveSpawnChance(6)=(Min=0.45,Max=0.55)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=8)
		 WaveSquadLimit(1)=(Min=3,Max=9)
		 WaveSquadLimit(2)=(Min=3,Max=10)
		 WaveSquadLimit(3)=(Min=4,Max=11)
		 WaveSquadLimit(4)=(Min=4,Max=11)
		 WaveSquadLimit(5)=(Min=5,Max=12)
		 WaveSquadLimit(6)=(Min=5,Max=12)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=4,MinTime=30.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=30.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(2)=(Min=6,MinTime=24.0,Max=18,MaxTime=24.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=30.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(4)=(Min=8,MinTime=24.0,Max=24,MaxTime=24.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=30.0,Max=30,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=24.0,Max=30,MaxTime=24.0)
		 // BossWave
		 BossWaveLimit=(Min=8,Max=64)
		 BossWaveSpawnChance=(Min=0.35,Max=0.45)
		 BossWaveSquadLimit=(Min=3,Max=10)
		 BossWaveDeltaLimit=(Min=3,MinTime=20.0,Max=20,MaxTime=30.0)
	 End Object
	 Monsters(4)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieGoreFastData'
	 
	 // UM_ZombieHusk
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieHuskData
		 MonsterClassName="UnlimaginMod.UM_ZombieHusk"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=6)
		 WaveLimit(1)=(Min=1,Max=10)
		 WaveLimit(2)=(Min=1,Max=12)
		 WaveLimit(3)=(Min=2,Max=14)
		 WaveLimit(4)=(Min=2,Max=16)
		 WaveLimit(5)=(Min=3,Max=18)
		 WaveLimit(6)=(Min=3,Max=20)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(1)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(2)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=1,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=4)
		 WaveSquadLimit(3)=(Min=1,Max=4)
		 WaveSquadLimit(4)=(Min=1,Max=6)
		 WaveSquadLimit(5)=(Min=1,Max=6)
		 WaveSquadLimit(6)=(Min=1,Max=6)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(1)=(Min=1,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=120.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=120.0,Max=8,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=90.0,Max=10,MaxTime=120.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=12,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=60.0,Max=12,MaxTime=120.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=8)
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=4,MaxTime=60.0)
	 End Object
	 Monsters(5)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieHuskData'
	 
	 // UM_ZombieScrake
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieScrakeData
		 MonsterClassName="UnlimaginMod.UM_ZombieScrake"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=2)
		 WaveLimit(1)=(Min=0,Max=4)
		 WaveLimit(2)=(Min=1,Max=6)
		 WaveLimit(3)=(Min=1,Max=8)
		 WaveLimit(4)=(Min=2,Max=10)
		 WaveLimit(5)=(Min=2,Max=12)
		 WaveLimit(6)=(Min=3,Max=14)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.05)
		 WaveSpawnChance(1)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(2)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=0,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=2)
		 WaveSquadLimit(3)=(Min=1,Max=2)
		 WaveSquadLimit(4)=(Min=1,Max=2)
		 WaveSquadLimit(5)=(Min=2,Max=3)
		 WaveSquadLimit(6)=(Min=2,Max=3)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=240.0,Max=3,MaxTime=60.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=4,MaxTime=80.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=5,MaxTime=90.0)
		 WaveDeltaLimit(6)=(Min=2,MinTime=90.0,Max=6,MaxTime=120.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=4)
		 BossWaveSpawnChance=(Min=0.0,Max=0.15)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=2,MaxTime=60.0)
	 End Object
	 Monsters(6)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieScrakeData'
	 
	 // UM_ZombieSiren
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieSirenData
		 MonsterClassName="UnlimaginMod.UM_ZombieSiren"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=8)
		 WaveLimit(1)=(Min=1,Max=12)
		 WaveLimit(2)=(Min=1,Max=14)
		 WaveLimit(3)=(Min=2,Max=16)
		 WaveLimit(4)=(Min=2,Max=18)
		 WaveLimit(5)=(Min=4,Max=20)
		 WaveLimit(6)=(Min=4,Max=22)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(1)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(2)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(5)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(6)=(Min=0.2,Max=0.3)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=1,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=4)
		 WaveSquadLimit(3)=(Min=1,Max=4)
		 WaveSquadLimit(4)=(Min=2,Max=6)
		 WaveSquadLimit(5)=(Min=2,Max=6)
		 WaveSquadLimit(6)=(Min=2,Max=6)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=1,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(5)=(Min=2,MinTime=120.0,Max=6,MaxTime=72.0)
		 WaveDeltaLimit(6)=(Min=2,MinTime=90.0,Max=6,MaxTime=60.0)
		 // BossWave
		 BossWaveLimit=(Min=1,Max=12)
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=3)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=3,MaxTime=60.0)
	 End Object
	 Monsters(7)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieSirenData'
	 
	 // UM_ZombieStalker
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieStalkerData
		 MonsterClassName="UnlimaginMod.UM_ZombieStalker"
		 // WaveLimit
		 WaveLimit(0)=(Min=4,Max=32)
		 WaveLimit(1)=(Min=6,Max=40)
		 WaveLimit(2)=(Min=6,Max=48)
		 WaveLimit(3)=(Min=8,Max=56)
		 WaveLimit(4)=(Min=8,Max=64)
		 WaveLimit(5)=(Min=12,Max=72)
		 WaveLimit(6)=(Min=12,Max=80)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(1)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(2)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(3)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(4)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(5)=(Min=0.35,Max=0.45)
		 WaveSpawnChance(6)=(Min=0.35,Max=0.45)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=6)
		 WaveSquadLimit(1)=(Min=3,Max=8)
		 WaveSquadLimit(2)=(Min=4,Max=8)
		 WaveSquadLimit(3)=(Min=4,Max=10)
		 WaveSquadLimit(4)=(Min=5,Max=10)
		 WaveSquadLimit(5)=(Min=5,Max=12)
		 WaveSquadLimit(6)=(Min=6,Max=12)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=4,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=60.0,Max=24,MaxTime=42.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=60.0,Max=24,MaxTime=36.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=56.0,Max=30,MaxTime=42.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=60.0,Max=30,MaxTime=36.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=56.0,Max=36,MaxTime=42.0)
		 WaveDeltaLimit(6)=(Min=12,MinTime=56.0,Max=36,MaxTime=36.0)
		 // BossWave
		 BossWaveLimit=(Min=8,Max=64)
		 BossWaveSpawnChance=(Min=0.3,Max=0.4)
		 BossWaveSquadLimit=(Min=3,Max=8)
		 BossWaveDeltaLimit=(Min=6,MinTime=60.0,Max=12,MaxTime=30.0)
	 End Object
	 Monsters(8)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieStalkerData'
}
