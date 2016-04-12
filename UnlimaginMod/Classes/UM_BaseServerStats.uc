// Template class.
Class UM_BaseServerStats extends KFSteamStatsAndAchievements
	Abstract;

var UM_ClientRepInfoLink	Rep;
var UM_PlayerController		OwnerController;
var	bool					bStatsReadyNow;


function int GetID();
function SetID( int ID );
function ChangeCharacter( string CN );
function ApplyCharacter( string CN );

function ServerSelectPerkName( name N );
function ServerSelectPerk( Class<UM_SRVeterancyTypes> VetType );

function NotifyStatChanged();

// Used to save Killed Stats
function NotifyKilled( Controller Killed, Pawn KilledPawn, class<DamageType> DamageType );

// Allow no default functionality with the stats.
function OnStatsAndAchievementsReady();
event PostNetBeginPlay();
function InitializeSteamStatInt(int Index, int Value);
function SetSteamAchievementCompleted(int Index);
simulated event SetLocalAchievementCompleted(int Index);
function ServerSteamStatsAndAchievementsInitialized();
function UpdateAchievementProgress();
function int GetAchievementCompletedCount();
event OnPerkAvailable();
function WonLongGame(string MapName, float Difficulty);
function AddSCARKill();
function AddCrawlerKilledInMidair();
function Killed8ZedsWithGrenade();
function Killed10ZedsWithPipebomb();
function KilledHusk(bool bDamagedFriendly);
function AddDamageHealed(int Amount, optional bool bMP7MHeal, optional bool bMP5MHeal);
function AddWeldingPoints(int Amount);
function AddShotgunDamage(int Amount);
function AddHeadshotKill(bool bLaserSightedEBRHeadshot);
function AddStalkerKill();
function AddBullpupDamage(int Amount);
function AddMeleeDamage(int Amount);
function AddFlameThrowerDamage(int Amount);
function WaveEnded();
function AddKill(bool bLaserSightedEBRM14Headshotted, bool bMeleeKill, bool bZEDTimeActive, bool bM4Kill, bool bBenelliKill, bool bRevolverKill, bool bMK23Kill, bool bFNFalKill, bool bBullpupKill, string MapName);
function AddClotKill();
function AddBloatKill(bool bWithBullpup);
function AddSirenKill(bool bLawRocketImpact);
function AddDemolitionsPipebombKill();
function AddStalkerKillWithExplosives();
function AddFireAxeKill();
function AddChainsawScrakeKill();
function AddBurningCrossbowKill();
function AddFeedingKill();
function OnGrenadeExploded();
function AddGrenadeKill();
function OnShotHuntingShotgun();
function AddHuntingShotgunKill();
function KilledEnemyWithBloatAcid();
function KilledFleshpound(bool bWithMeleeAttack, bool bWithAA12, bool bWithKnife, bool bWithClaymore);
function AddMedicKnifeKill();
function OnShotM99();
function AddGibKill(bool bWithM79);
function AddFleshpoundGibKill();
function AddSelfHeal();
function AddOnlySurvivorOfWave();
function AddDonatedCash(int Amount);
function AddZedTime(float Amount);
function AddExplosivesDamage(int Amount);
function AddMac10BurnDamage(int Amount);
function AddGorefastBackstab();
function ScrakeKilledByFire();
function KilledCrawlerWithCrossbow();
function OnLARReloaded();
function AddStalkerKillWithLAR();
function KilledHuskWithPistol();
function AddDroppedTier3Weapon();
function Survived10SecondsAfterVomit();
function CheckChristmasAchievementsCompleted();
function PlayerDied();
function KilledPatriarch(bool bPatriarchHealed, bool bKilledWithLAW, bool bSuicidalDifficulty, bool bOnlyUsedCrossbows, bool bClaymore, string MapName);
function WonGame(string MapName, float Difficulty, bool bLong);
simulated function bool PlayerOwnsWeaponDLC(int AppID);
function string GetWeaponDLCPackName(int AppID);
function CheckEndGameAchievements(float Difficulty, int MapNormalDifficulty);
function KilledXMasHuskWithHuskCannon();
function OnM4Reloaded(bool bClipEmptied);
function AddM203NadeScrakeKill();
function OnBenelliReloaded();
function OnRevolverReloaded();
function OnDualsAddedToInventory(bool bHasDual9mms, bool bHasDualHCs, bool bHasDualRevolvers);
function AddXMasStalkerKill();
function AddXMasCrawlerKill();
function Check20MinuteAchievement();
function AddXMasClaymoreScrakeKill();
function OnMK23Reloaded();
function OnKilledZedInjuredPlayerWithM7A3();
function AddM99Kill();
function CheckBritishSuperiority();
function AddCrawlerKillWithKSG();
function AddBloatKillWithKSG();
function AddSirenKillWithKSG();
function AddStalkerKillWithKSG();
function AddHuskKillWithKSG();
function AddScrakeKillWithKSG();
function AddFleshPoundKillWithKSG();
function AddBossKillWithKSG();
function AddClotKillWithKSG();
function AddGoreFastKillWithKSG();
function CheckForFuglyAchievement();
function KilledCrawlerWithBullpup();
function KilledScrakeWithCrossbow();
function AddDroppedTier2Weapon();
function CheckSideshowAchievementsCompleted();
function MeleedGorefast();
function AddStalkerBackstab();
function KilledHuskWithLAW();
function AddClotKillWithLAR();
function KilledFleshpoundWithPistol();
function Survived10SecondsAfterScream();
function ClotKilledByFire();
function CheckHillbillyAchievementsCompleted();
function CheckSteamLandAchievementsCompleted();
function CheckFrightyardAchievementsCompleted();
function bool HasAchievementInRangeCompleted( int StartingAchievementIndex, int EndingAchievementIndex );
function AddKillPoints(int AchievementID);
function CheckAchievementPoints(int AchievementID, string DebugMessage, out int Counter, optional SteamStatInt Stat);
function ResetMKB42Kill();
function OneShotBuzzOrM99();
function OneShotLawOrHarpoon();
function OnReloadSPSorM14();
function OnReloadSPTorBullpup();
function HealedTeamWithMedicGrenade();
function KillHillbillyZedsIn10Seconds();
function CheckResetKillsWithM32OrSeekerIn5Secs();
function AddHuskAndZedOneShotKill(bool HuskKill, bool ZedKill);
function AddScrakeAndFPOneShotKill(bool ScrakeKill, bool FPKill);
function AddHeadshotsWithSPSOrM14( class<Actor> MonsterClass );
function AddMonsterKillsWithBileOrFlame( class<Actor> MonsterClass );
simulated function CheckEvents( Name EventName );
event Trigger(actor Other, pawn EventInstigator );
function OnWeaponReloaded();
function AddBurningDecapKill(string MapName);
function AddScrakeKill(string MapName);
function CheckHalloweenAchievementsCompleted();
function AddFleshpoundAxeKill();
function AddAirborneZedKill();
function AddZedKilledWhileZapped();
function SetCanGetAxe();
function ZEDPieceGrabbed();
function ZedTimeChainEnded();
simulated function OnAchievementReport( bool HasAchievement, string Achievement, int gameID, string steamIDIn);
function AddZedTimeKill();
function CheckAndSetAchievementComplete(int Index);
function SetObjAchievementFailed( bool bFailed );
function OnObjectiveCompleted( name ObjectiveName );
function UnlockObjectiveAchievement( int Index );

defaultproperties
{
	bNetNotify=False
	bUsedCheats=True
	bFlushStatsToClient=False
	bInitialized=True
	RemoteRole=ROLE_None
}