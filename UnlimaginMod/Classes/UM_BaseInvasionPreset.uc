/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseInvasionPreset
	Creation date:	 01.09.2015 17:41
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
	Comment:		 
==================================================================================*/
class UM_BaseInvasionPreset extends UM_BaseGamePreset
	DependsOn(UM_InvasionGame)
	Abstract;

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var		array<UM_InvasionGame.WaveMonsterData>		Monsters;
var		array<UM_InvasionGame.GameWaveData>			GameWaves;

var		array<UM_InvasionGame.BossWaveMonsterData>	BossMonsters;
var		string										BossMonsterClassName;
var		array<float>								NumPlayersModifiers;

var		UM_BaseActor.IntRange						BossWaveStartingCash;
var		int											BossWaveMinRespawnCash;
var		float										BossWaveRespawnCashModifier;
var		int											BossWaveStartDelay;

var		UM_BaseActor.IntRange						StartShoppingTime;

var		int											InitialWaveNum;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
	 InitialWaveNum=0
	 StartShoppingTime=(Min=120,Max=140)
	 MaxHumanPlayers=12
	 //
	 NumPlayersModifiers(1)=1.0
	 NumPlayersModifiers(2)=1.75
	 NumPlayersModifiers(3)=2.5
	 NumPlayersModifiers(4)=3.25
	 NumPlayersModifiers(5)=4.0
	 NumPlayersModifiers(6)=4.75
	 NumPlayersModifiers(7)=5.5
	 NumPlayersModifiers(8)=6
	 NumPlayersModifiers(9)=6.5
	 NumPlayersModifiers(10)=7
	 NumPlayersModifiers(11)=7.5
	 NumPlayersModifiers(12)=8
	 // Kills for DramaticEvent
	 DramaticKills(0)=(MinKilled=2,EventChance=0.03,EventDuration=2.5)
	 DramaticKills(1)=(MinKilled=5,EventChance=0.05,EventDuration=3.0)
	 DramaticKills(2)=(MinKilled=10,EventChance=0.2,EventDuration=3.5)
	 DramaticKills(3)=(MinKilled=15,EventChance=0.4,EventDuration=4.0)
	 DramaticKills(4)=(MinKilled=20,EventChance=0.8,EventDuration=4.5)
	 DramaticKills(5)=(MinKilled=25,EventChance=1.0,EventDuration=5.0)
}
