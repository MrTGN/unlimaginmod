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
	 InitialWaveNum=0
	 // WaveAliveMonsters
	 WaveAliveMonsters(0)=(Min=12,Max=46)
	 WaveAliveMonsters(1)=(Min=14,Max=48)
	 WaveAliveMonsters(2)=(Min=14,Max=48)
	 WaveAliveMonsters(3)=(Min=16,Max=50)
	 WaveAliveMonsters(4)=(Min=16,Max=50)
	 WaveAliveMonsters(5)=(Min=18,Max=52)
	 WaveAliveMonsters(6)=(Min=18,Max=52)
	 // WaveMonsterSquadSize
	 WaveMonsterSquadSize(0)=(Min=4,RandMin=2,Max=12,RandMax=6)
	 WaveMonsterSquadSize(1)=(Min=4,RandMin=2,Max=14,RandMax=7)
	 WaveMonsterSquadSize(2)=(Min=5,RandMin=2,Max=14,RandMax=8)
	 WaveMonsterSquadSize(3)=(Min=5,RandMin=3,Max=16,RandMax=8)
	 WaveMonsterSquadSize(4)=(Min=6,RandMin=3,Max=16,RandMax=10)
	 WaveMonsterSquadSize(5)=(Min=6,RandMin=3,Max=18,RandMax=10)
	 WaveMonsterSquadSize(6)=(Min=7,RandMin=3,Max=18,RandMax=12)
	 // WaveSquadsSpawnPeriod
	 WaveSquadsSpawnPeriod(0)=(Min=5.0,RandMin=1.0,Max=4.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(1)=(Min=4.5,RandMin=1.0,Max=3.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(2)=(Min=4.5,RandMin=1.0,Max=3.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(3)=(Min=4.0,RandMin=1.0,Max=3.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(4)=(Min=4.0,RandMin=1.0,Max=3.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(5)=(Min=3.5,RandMin=1.0,Max=2.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(6)=(Min=3.5,RandMin=1.0,Max=2.5,RandMax=1.5)
	 // WaveSquadsSpawnEndTime
	 WaveSquadsSpawnEndTime(0)=25
	 WaveSquadsSpawnEndTime(1)=26
	 WaveSquadsSpawnEndTime(2)=26
	 WaveSquadsSpawnEndTime(3)=28
	 WaveSquadsSpawnEndTime(4)=28
	 WaveSquadsSpawnEndTime(5)=30
	 WaveSquadsSpawnEndTime(6)=30
	 // WaveDifficulty
	 WaveDifficulty(0)=0.7
	 WaveDifficulty(1)=0.8
	 WaveDifficulty(2)=0.9
	 WaveDifficulty(3)=1.0
	 WaveDifficulty(4)=1.1
	 WaveDifficulty(5)=1.2
	 WaveDifficulty(6)=1.3
	 // WaveStartDelay
	 WaveStartDelay(0)=10
	 WaveStartDelay(1)=10
	 WaveStartDelay(2)=8
	 WaveStartDelay(3)=8
	 WaveStartDelay(4)=8
	 WaveStartDelay(5)=6
	 WaveStartDelay(6)=6
	 // WaveDuration
	 WaveDuration(0)=(Min=2.0,RandMin=0.5,Max=4.0,RandMax=1.0)
	 WaveDuration(1)=(Min=2.5,RandMin=0.5,Max=5.0,RandMax=1.0)
	 WaveDuration(2)=(Min=3.0,RandMin=0.6,Max=6.0,RandMax=1.2)
	 WaveDuration(3)=(Min=3.5,RandMin=0.7,Max=7.0,RandMax=1.4)
	 WaveDuration(4)=(Min=4.0,RandMin=0.8,Max=8.0,RandMax=1.6)
	 WaveDuration(5)=(Min=4.5,RandMin=0.9,Max=9.0,RandMax=1.8)
	 WaveDuration(6)=(Min=5.0,RandMin=1.0,Max=10.0,RandMax=2.0)
	 // WaveBreakTime
	 WaveBreakTime(0)=(Min=90.0,Max=100.0)
	 WaveBreakTime(1)=(Min=90.0,Max=110.0)
	 WaveBreakTime(2)=(Min=100.0,Max=110.0)
	 WaveBreakTime(3)=(Min=100.0,Max=120.0)
	 WaveBreakTime(4)=(Min=110.0,Max=120.0)
	 WaveBreakTime(5)=(Min=110.0,Max=130.0)
	 WaveBreakTime(6)=(Min=120.0,Max=130.0)
	 // WaveDoorsRepairChance
	 WaveDoorsRepairChance(0)=(Min=1.0,Max=0.6)
	 WaveDoorsRepairChance(1)=(Min=1.0,Max=0.55)
	 WaveDoorsRepairChance(2)=(Min=1.0,Max=0.5)
	 WaveDoorsRepairChance(3)=(Min=1.0,Max=0.45)
	 WaveDoorsRepairChance(4)=(Min=1.0,Max=0.4)
	 WaveDoorsRepairChance(5)=(Min=1.0,Max=0.35)
	 WaveDoorsRepairChance(6)=(Min=1.0,Max=0.3)
	 // WaveStartingCash
	 WaveStartingCash(0)=(Min=240,Max=280)
	 WaveStartingCash(1)=(Min=260,Max=300)
	 WaveStartingCash(2)=(Min=280,Max=320)
	 WaveStartingCash(3)=(Min=300,Max=340)
	 WaveStartingCash(4)=(Min=320,Max=360)
	 WaveStartingCash(5)=(Min=340,Max=380)
	 WaveStartingCash(6)=(Min=360,Max=400)
	 // WaveMinRespawnCash
	 WaveMinRespawnCash(0)=(Min=200,Max=220)
	 WaveMinRespawnCash(1)=(Min=220,Max=240)
	 WaveMinRespawnCash(2)=(Min=240,Max=260)
	 WaveMinRespawnCash(3)=(Min=260,Max=280)
	 WaveMinRespawnCash(4)=(Min=280,Max=300)
	 WaveMinRespawnCash(5)=(Min=300,Max=320)
	 WaveMinRespawnCash(6)=(Min=320,Max=340)
	 // WaveDeathCashModifier
	 WaveDeathCashModifier(0)=(Min=0.98,Max=0.86)
	 WaveDeathCashModifier(1)=(Min=0.97,Max=0.85)
	 WaveDeathCashModifier(2)=(Min=0.96,Max=0.84)
	 WaveDeathCashModifier(3)=(Min=0.95,Max=0.83)
	 WaveDeathCashModifier(4)=(Min=0.94,Max=0.82)
	 WaveDeathCashModifier(5)=(Min=0.93,Max=0.81)
	 WaveDeathCashModifier(6)=(Min=0.92,Max=0.8)
	 
	 // BossWave
	 BossWaveNum=7
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 BossWaveAliveMonsters=(Min=16,Max=48)
	 BossWaveMonsterSquadSize=(Min=12,RandMin=4,Max=36,RandMax=12)
	 BossWaveSquadsSpawnPeriod=(Min=40.0,RandMin=5.0,Max=40.0,RandMax=10.0)
	 BossWaveDifficulty=1.4
	 BossWaveStartDelay=6
	 BossWaveDoorsRepairChance=(Min=1.0,Max=0.2)
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=(Min=340,Max=380)
	 
	 // UM_ZombieBloat
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieBloatData
		 MonsterClassName="UnlimaginMod.UM_ZombieBloat"
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
		 BossWaveSpawnChance=(Min=0.25,Max=0.35)
		 BossWaveSquadLimit=(Min=2,Max=8)
		 BossWaveDeltaLimit=(Min=2,MinTime=30.0,Max=16,MaxTime=60.0)
	 End Object
	 Monsters(0)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieBloatData'
	 
	 // UM_ZombieClot
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieClotData
		 MonsterClassName="UnlimaginMod.UM_ZombieClot"
		 bNoWaveRestrictions=True
		 // BossWave
		 BossWaveSpawnChance=(Min=1.0,Max=1.0)
		 BossWaveSquadLimit=(Min=12,Max=48)
		 BossWaveDeltaLimit=(Min=12,MinTime=10.0,Max=48,MaxTime=20.0)
	 End Object
	 Monsters(1)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieClotData'
	 
	 // UM_ZombieCrawler
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieCrawlerData
		 MonsterClassName="UnlimaginMod.UM_ZombieCrawler"
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
		 BossWaveSpawnChance=(Min=0.15,Max=0.25)
		 BossWaveSquadLimit=(Min=2,Max=6)
		 BossWaveDeltaLimit=(Min=2,MinTime=40.0,Max=6,MaxTime=30.0)
	 End Object
	 Monsters(2)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieCrawlerData'
	 
	 // UM_ZombieFleshPound
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieFleshPoundData
		 MonsterClassName="UnlimaginMod.UM_ZombieFleshPound"
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
		 BossWaveSpawnChance=(Min=0.0,Max=0.1)
		 BossWaveSquadLimit=(Min=1,Max=1)
		 BossWaveDeltaLimit=(Min=1,MinTime=120.0,Max=1,MaxTime=60.0)
	 End Object
	 Monsters(3)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieFleshPoundData'
	 
	 // UM_ZombieGoreFast
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieGoreFastData
		 MonsterClassName="UnlimaginMod.UM_ZombieGoreFast"
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
		 BossWaveSpawnChance=(Min=0.35,Max=0.45)
		 BossWaveSquadLimit=(Min=3,Max=10)
		 BossWaveDeltaLimit=(Min=3,MinTime=20.0,Max=20,MaxTime=30.0)
	 End Object
	 Monsters(4)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieGoreFastData'
	 
	 // UM_ZombieHusk
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieHuskData
		 MonsterClassName="UnlimaginMod.UM_ZombieHusk"
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
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=4,MaxTime=60.0)
	 End Object
	 Monsters(5)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieHuskData'
	 
	 // UM_ZombieScrake
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieScrakeData
		 MonsterClassName="UnlimaginMod.UM_ZombieScrake"
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
		 BossWaveSpawnChance=(Min=0.0,Max=0.15)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=2,MaxTime=60.0)
	 End Object
	 Monsters(6)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieScrakeData'
	 
	 // UM_ZombieSiren
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieSirenData
		 MonsterClassName="UnlimaginMod.UM_ZombieSiren"
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
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=3)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=3,MaxTime=60.0)
	 End Object
	 Monsters(7)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieSirenData'
	 
	 // UM_ZombieStalker
	 Begin Object Class=UM_InvasionMonsterData Name=UM_ZombieStalkerData
		 MonsterClassName="UnlimaginMod.UM_ZombieStalker"
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
		 BossWaveSpawnChance=(Min=0.3,Max=0.4)
		 BossWaveSquadLimit=(Min=3,Max=8)
		 BossWaveDeltaLimit=(Min=6,MinTime=60.0,Max=12,MaxTime=30.0)
	 End Object
	 Monsters(8)=UM_InvasionMonsterData'UnlimaginMod.UM_DefaultInvasionPreset.UM_ZombieStalkerData'
}
