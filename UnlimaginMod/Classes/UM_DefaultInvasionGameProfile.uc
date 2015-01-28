/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_DefaultInvasionGameProfile
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
	Comment:		 Default Settings Profile
==================================================================================*/
class UM_DefaultInvasionGameProfile extends UM_GameSettingsProfile
	DependsOn(UM_InvasionGame)
	Abstract;

//========================================================================
//[block] Variables

var		array<UM_InvasionGame.WaveMonsterData>		WaveMonsters;
var		array<UM_InvasionGame.GameWaveData>			GameWaves;

var		array<UM_InvasionGame.BossWaveMonsterData>	BossWaveMonsters;
var		string										BossMonsterClassName;

//[end] Varibles
//====================================================================

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
	 WaveMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveMinLimits=(4,6,8,8,10,12,12),WaveMaxLimits=(40,60,80,80,100,120,120),WaveSpawnChances=(0.25,0.3,0.35,0.4,0.4,0.45,0.45),WaveSpawnDelays=(24.0,22.0,20.0,18.0,16.0,14.0,12.0))
	 WaveMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 WaveMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveMinLimits=(2,2,4,6,8,8,8),WaveMaxLimits=(16,18,36,48,54,54,54),WaveSpawnChances=(0.1,0.15,0.2,0.25,0.3,0.35,0.4),WaveSpawnDelays=(28.0,26.0,24.0,22.0,20.0,18.0,16.0))
	 WaveMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieFleshPound",WaveMinLimits=(0,0,1,1,1,2,2),WaveMaxLimits=(0,0,4,6,8,12,12),WaveSpawnChances=(0.0,0.0,0.05,0.1,0.15,0.2,0.25),WaveSpawnDelays=(0.0,0.0,360.0,300.0,240.0,180.0,120.0))
	 WaveMonsters(4)=(MonsterClassName="UnlimaginMod.UM_ZombieGoreFast",WaveMinLimits=(6,8,10,12,14,16,18),WaveMaxLimits=(60,80,100,120,140,160,180),WaveSpawnChances=(0.35,0.4,0.45,0.5,0.55,0.6,0.6))
	 WaveMonsters(5)=(MonsterClassName="UnlimaginMod.UM_ZombieHusk",WaveMinLimits=(0,1,1,2,2,3,3),WaveMaxLimits=(2,8,10,),WaveSpawnChances=(0.0,0.1,0.15,0.15,0.2,0.25,0.3),WaveSpawnDelays=(0.0,300.0,240.0,180.0,120.0,90.0,60.0))
	 WaveMonsters(6)=(MonsterClassName="UnlimaginMod.UM_ZombieScrake",WaveLimits=(0,0,2,4,4,6,6),WaveSpawnChances=(0.0,0.0,0.1,0.15,0.2,0.25,0.25),WaveSpawnDelays=(0.0,0.0,300.0,240.0,180.0,120.0,90.0))
	 WaveMonsters(7)=(MonsterClassName="UnlimaginMod.UM_ZombieSiren",WaveLimits=(0,1,2,2,4,4,6),WaveSpawnChances=(0.0,0.15,0.15,0.2,0.2,0.25,0.25),WaveSpawnDelays=(0.0,240.0,210.0,180.0,120.0,90.0,60.0))
	 WaveMonsters(8)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimits=(6,8,10,12,14,16,18),WaveSpawnChances=(0.45,0.45,0.5,0.55,0.55,0.5,0.5))
	 // GameWaves - 7 waves
	 GameWaves(0)=(MinMonsters=18,MaxMonsters=270,MonstersAtOnce=(Min=16,Max=42),MonsterSquadSize=(Min=2,Max=6),SquadsSpawnPeriod=(Min=2.0,Max=4.0),WaveDifficulty=0.2,BreakTime=(Min=90.0,Max=100.0))
	 GameWaves(1)=(MinMonsters=24,MaxMonsters=360,MonstersAtOnce=(Min=18,Max=44),MonsterSquadSize=(Min=4,Max=6),SquadsSpawnPeriod=(Min=2.5,Max=4.5),WaveDifficulty=0.4,BreakTime=(Min=90.0,Max=110.0))
	 GameWaves(2)=(MinMonsters=30,MaxMonsters=450,MonstersAtOnce=(Min=20,Max=46),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=2.5,Max=5.0),WaveDifficulty=0.8,BreakTime=(Min=100.0,Max=110.0))
	 GameWaves(3)=(MinMonsters=36,MaxMonsters=540,MonstersAtOnce=(Min=22,Max=48),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=3.0,Max=5.5),WaveDifficulty=1.0,BreakTime=(Min=100.0,Max=120.0))
	 GameWaves(4)=(MinMonsters=42,MaxMonsters=630,MonstersAtOnce=(Min=24,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.0),WaveDifficulty=1.2,BreakTime=(Min=110.0,Max=120.0))
	 GameWaves(5)=(MinMonsters=48,MaxMonsters=720,MonstersAtOnce=(Min=26,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.5),WaveDifficulty=1.4,BreakTime=(Min=110.0,Max=130.0))
	 GameWaves(6)=(MinMonsters=54,MaxMonsters=810,MonstersAtOnce=(Min=26,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=7.0),WaveDifficulty=1.6,BreakTime=(Min=120.0,Max=130.0))
	 // Boss
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 // BossWaveMonsters
	 BossWaveMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveLimit=4,WaveSpawnChance=0.2)
	 BossWaveMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 BossWaveMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveLimit=2,WaveSpawnChance=0.2)
	 BossWaveMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimit=4,WaveSpawnChance=0.4)
}
