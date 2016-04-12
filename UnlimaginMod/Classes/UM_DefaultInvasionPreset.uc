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
	GitHub:			 github.com/MrTGN/unlimaginmod
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
	 BossMonsterClassName="UnlimaginMod.UM_Monster_Boss_Standard"
	 BossWaveAliveMonsters=(Min=16,Max=48)
	 BossWaveMonsterSquadSize=(Min=12,RandMin=4,Max=36,RandMax=12)
	 BossWaveSquadsSpawnPeriod=(Min=40.0,RandMin=5.0,Max=40.0,RandMax=10.0)
	 BossWaveDifficulty=1.4
	 BossWaveStartDelay=6
	 BossWaveDoorsRepairChance=(Min=1.0,Max=0.2)
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=(Min=340,Max=380)
	 
	 
}
