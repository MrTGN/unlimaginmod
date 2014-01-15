//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WeaponInfoGenerator
//	Parent class:	 Actor
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 23.09.2013 17:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_WeaponInfoGenerator extends Actor
	hidecategories(Object, Actor);


//========================================================================
//[block] Variables

/*
var		bool	bInfoGenerated;

struct WeaponInfo
{
	var	Class<KFWeaponPickup>	PickupClass;
	var	byte					CatNum;		// Category number
	var	int						Damage;
	var	float					FireRate;
	var	float					Spread;
	var	bool					bMelee;
	var	float					MeleeRange;
};

struct WeaponMaxPerfs
{
	var	int		MaxDamage;
	var	float	MaxFireRate;
	var	float	MaxSpread;
	var	bool	bMelee;
	var	float	MaxMeleeRange;
};

var		array< WeaponInfo >		WeaponsInfo;
*/

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated function RebalansDefaultClasses()
{
	//[block] Weapon balansing - ToDo: export to normal classes
	//--------------------
	//AA12AutoShotgun
	//------------------
	//Ammo
	class'AA12Ammo'.default.MaxAmmo = 128;
	class'AA12Ammo'.default.InitialAmount = 96;
	class'AA12Ammo'.default.AmmoPickupAmount = 32;
	//--------------------
	//GoldenAA12AutoShotgun
	//------------------
	//GoldenAA12Ammo
	class'GoldenAA12Ammo'.default.MaxAmmo = 128;
	class'GoldenAA12Ammo'.default.InitialAmount = 96;
	class'GoldenAA12Ammo'.default.AmmoPickupAmount = 32;
	//--------------------
	//AK47AssaultRifle
	//------------------
	//Ammo
	class'AK47Ammo'.default.MaxAmmo = 360;
	class'AK47Ammo'.default.InitialAmount = 240;
	class'AK47Ammo'.default.AmmoPickupAmount = 60;
	//--------------------
	//AK47AssaultRifle
	//------------------
	//Ammo
	class'GoldenAK47Ammo'.default.MaxAmmo = 360;
	class'GoldenAK47Ammo'.default.InitialAmount = 240;
	class'GoldenAK47Ammo'.default.AmmoPickupAmount = 60;
	//--------------------
	//Axe
	//------------------
	class'Axe'.default.Weight = 3.000000;
	//Pickup
	class'AxePickup'.default.Weight = 3.000000;
	//--------------------
	//BenelliShotgun
	//------------------
	//Ammo
	class'BenelliAmmo'.default.MaxAmmo = 60;
	class'BenelliAmmo'.default.InitialAmount = 42;
	class'BenelliAmmo'.default.AmmoPickupAmount = 6;
	//--------------------
	//GoldenBenelliShotgun
	//------------------
	//Ammo
	class'GoldenBenelliAmmo'.default.MaxAmmo = 60;
	class'GoldenBenelliAmmo'.default.InitialAmount = 42;
	class'GoldenBenelliAmmo'.default.AmmoPickupAmount = 6;
	//--------------------
	//Bullpup
	//------------------
	//Ammo
	class'BullpupAmmo'.default.MaxAmmo = 540;
	class'BullpupAmmo'.default.InitialAmount = 210;
	class'BullpupAmmo'.default.AmmoPickupAmount = 60;
	//--------------------
	//BoomStick (HuntingShotgun)
	//------------------
	class'BoomStick'.default.Weight = 4.000000;
	class'BoomStick'.default.MessageNoAmmo = "You've squandered all ammo! Ass!";
	//Ammo
	class'DBShotgunAmmo'.default.MaxAmmo = 48;
	class'DBShotgunAmmo'.default.InitialAmount = 30;
	class'DBShotgunAmmo'.default.AmmoPickupAmount = 4;
	//Pickup
	class'BoomStickPickup'.default.Weight = 4.000000;
	class'BoomStickPickup'.default.cost = 750;
	class'BoomStickPickup'.default.AmmoCost = 15;
	//BoomStickFire
	class'BoomStickFire'.default.ProjectileClass = Class'UnlimaginMod.UM_BoomStick_2Buckshot';
	class'BoomStickFire'.default.ProjPerFire = 15;
	//BoomStickAltFire
	class'BoomStickAltFire'.default.ProjectileClass = Class'UnlimaginMod.UM_BoomStick_2Buckshot';
	class'BoomStickAltFire'.default.ProjPerFire = 15;
	//--------------------
	//ClaymoreSword
	//------------------
	class'ClaymoreSword'.default.Weight = 4.000000;
	//Pickup
	class'ClaymoreSwordPickup'.default.Weight = 4.000000;
	//--------------------
	//Chainsaw
	//------------------
	class'Chainsaw'.default.Weight = 5.000000;
	//Pickup
	class'ChainsawPickup'.default.Weight = 5.000000;
	class'ChainsawPickup'.default.cost = 2700;
	//--------------------
	//GoldenChainsaw
	//------------------
	class'GoldenChainsaw'.default.Weight = 5.000000;
	//Pickup
	class'GoldenChainsawPickup'.default.cost = 2900;
	class'GoldenChainsawPickup'.default.Weight = 5.000000;
	//--------------------
	//Crossbow
	//------------------
	//DamTypeCrossbow
	class'DamTypeCrossbow'.default.WeaponClass = Class'UnlimaginMod.UM_Crossbow';
	//DamTypeCrossbowHeadShot
	class'DamTypeCrossbowHeadShot'.default.WeaponClass = Class'UnlimaginMod.UM_Crossbow';
	//Ammo
	class'CrossbowAmmo'.default.MaxAmmo = 30;
	class'CrossbowAmmo'.default.InitialAmount = 20;
	class'CrossbowAmmo'.default.AmmoPickupAmount = 2;
	//--------------------
	//Crossbuzzsaw
	//------------------
	//CrossbuzzsawAmmo
	class'CrossbuzzsawAmmo'.default.MaxAmmo = 20;
	class'CrossbuzzsawAmmo'.default.InitialAmount = 10;
	class'CrossbuzzsawAmmo'.default.AmmoPickupAmount = 5;
	//CrossbuzzsawPickup
	class'CrossbuzzsawPickup'.default.AmmoCost = 60;
	//Crossbuzzsaw
	//Class'Crossbuzzsaw'.default.bMeleeWeapon = True;
	Class'Crossbuzzsaw'.default.bSpeedMeUp = True;
	//--------------------
	//Deagle
	//------------------
	class'Deagle'.default.Weight = 2.000000;
	class'Deagle'.default.ItemName = "Desert Eagle";
	class'Deagle'.default.FireModeClass[0] = Class'UnlimaginMod.UM_DeagleFire';
	//Ammo
	class'DeagleAmmo'.default.MaxAmmo = 128;
	class'DeagleAmmo'.default.InitialAmount = 32;
	class'DeagleAmmo'.default.AmmoPickupAmount = 8;
	//Pickup
	class'DeaglePickup'.default.Weight = 2.000000;
	class'DeaglePickup'.default.cost = 500;
	class'DeaglePickup'.default.BuyClipSize = 8;
	class'DeaglePickup'.default.AmmoCost = 15;
	class'DeaglePickup'.default.ItemName = "Desert Eagle";
	class'DeaglePickup'.default.ItemShortName = "Deagle";
	class'DeaglePickup'.default.PickupMessage = "You got the Desert Eagle";
	//--------------------
	//Dual44Magnum
	//------------------
	class'Dual44Magnum'.default.Weight = 4.000000;
	class'Dual44Magnum'.default.ItemName = "Dual S&W Model 29";
	class'Dual44Magnum'.default.FireModeClass[0] = Class'UnlimaginMod.UM_Dual44MagnumFire';
	//Pickup
	class'Dual44MagnumPickup'.default.Weight = 4.000000;
	class'Dual44MagnumPickup'.default.cost = 900;
	class'Dual44MagnumPickup'.default.BuyClipSize = 12;
	class'Dual44MagnumPickup'.default.AmmoCost = 24;
	class'Dual44MagnumPickup'.default.ItemName = "Dual S&W Model 29";
	class'Dual44MagnumPickup'.default.ItemShortName = "Dual S&W M29";
	class'Dual44MagnumPickup'.default.PickupMessage = "You got the Dual S&W Model 29";
	//--------------------
	//DualDeagle
	//------------------
	class'DualDeagle'.default.Weight = 4.000000;
	class'DualDeagle'.default.ItemName = "Dual Desert Eagle";
	class'DualDeagle'.default.FireModeClass[0] = Class'UnlimaginMod.UM_DualDeagleFire';
	//Pickup
	class'DualDeaglePickup'.default.Weight = 4.000000;
	class'DualDeaglePickup'.default.cost = 1000;
	class'DualDeaglePickup'.default.BuyClipSize = 16;
	class'DualDeaglePickup'.default.AmmoCost = 30;
	class'DualDeaglePickup'.default.ItemName = "Dual Desert Eagle";
	class'DualDeaglePickup'.default.ItemShortName = "Dual Deagle";
	class'DualDeaglePickup'.default.PickupMessage = "You got the Dual Desert Eagle";
	//--------------------
	//Dualies
	//------------------
	class'Dualies'.default.MagCapacity = 42;
	class'Dualies'.default.Weight = 2.000000;
	class'Dualies'.default.bKFNeverThrow = False;
	class'Dualies'.default.FireModeClass[0] = Class'UnlimaginMod.UM_DualBeretta93MAFire';
	class'Dualies'.default.ItemName="Dual Beretta 93MA";
	//Ammo
	class'DualiesAmmo'.default.AmmoPickupAmount = 42;
	class'DualiesAmmo'.default.MaxAmmo = 336;
	class'DualiesAmmo'.default.InitialAmount = 210;
	//Pickup
	class'DualiesPickup'.default.Weight = 2.000000;
	class'DualiesPickup'.default.cost = 400;
	class'DualiesPickup'.default.BuyClipSize = 42;
	class'DualiesPickup'.default.ItemName = "Dual Beretta 93MA";
	class'DualiesPickup'.default.ItemShortName = "Dual Beretta 93MA";
	//--------------------
	//DualMK23
	//------------------
	class'DamTypeDualMK23Pistol'.default.WeaponClass = Class'UnlimaginMod.UM_DualMK23Pistol';
	class'DamTypeDualMK23Pistol'.default.HeadShotDamageMult = 1.600000;
	//--------------------
	//FlameThrower
	//------------------
	//DamTypeFlamethrower
	class'DamTypeFlamethrower'.default.WeaponClass = Class'UnlimaginMod.UM_FlameThrower';
	//--------------------
	//DwarfAxe
	//------------------
	//DwarfAxeFireB
	Class'DwarfAxeFireB'.default.bWaitForRelease = False;
	//Ammo
	//class'FlameAmmo'.default.MaxAmmo = 600;
	class'FlameAmmo'.default.InitialAmount = 300;
	class'FlameAmmo'.default.AmmoPickupAmount = 100;
	//--------------------
	//FNFAL_ACOG_AssaultRifle
	//------------------
	class'FNFALAmmo'.default.MaxAmmo = 300;
	//--------------------
	//Claws
	//------------------
	Class'Claws'.default.Weight = 0.000000;
	Class'Claws'.default.bKFNeverThrow = True;
	Class'Claws'.default.GroupOffset = 1;
	//--------------------
	//Frag
	//------------------
	class'DamTypeFrag'.default.WeaponClass = Class'UnlimaginMod.UM_Weapon_HandGrenade';
	class'FragPickup'.default.InventoryType = Class'UnlimaginMod.UM_Weapon_HandGrenade';
	//--------------------
	//HuskGun
	//------------------
	class'HuskGun'.default.FireModeClass[0] = Class'UnlimaginMod.UM_HuskGunFire';
	class'HuskGun'.default.FireModeClass[1] = Class'UnlimaginMod.UM_HuskGunFireB';
	//Ammo
	class'HuskGunAmmo'.default.MaxAmmo = 250;
	class'HuskGunAmmo'.default.InitialAmount = 100;
	//HuskGunProjectile
	class'HuskGunProjectile'.default.Damage = 100;
	//--------------------
	//M14EBRBattleRifle
	//------------------
	//Ammo
	class'M14EBRAmmo'.default.MaxAmmo = 160;
	class'M14EBRAmmo'.default.InitialAmount = 80;
	class'M14EBRAmmo'.default.AmmoPickupAmount = 20;
	//--------------------
	//MAC10MP
	//------------------
	//Ammo
	class'MAC10Ammo'.default.MaxAmmo = 540;
	class'MAC10Ammo'.default.InitialAmount = 300;
	class'MAC10Ammo'.default.AmmoPickupAmount = 60;
	//--------------------
	//Machete
	//------------------
	//MacheteFire
	class'MacheteFire'.default.MeleeDamage = 100;
	class'MacheteFire'.default.weaponRange = 80;
	class'MacheteFire'.default.FireRate = 0.600000;
	class'MacheteFire'.default.DamagedelayMin = 0.480000;
	class'MacheteFire'.default.DamagedelayMax = 0.480000;
	//MacheteFireB
	class'MacheteFireB'.default.MeleeDamage = 155;
	class'MacheteFireB'.default.weaponRange = 80;
	class'MacheteFireB'.default.FireRate = 1.000000;
	class'MacheteFireB'.default.DamagedelayMin = 0.640000;
	class'MacheteFireB'.default.DamagedelayMax = 0.640000;
	//--------------------
	//Magnum44Pistol
	//------------------
	class'Magnum44Pistol'.default.Weight = 2.000000;
	class'Magnum44Pistol'.default.ItemName = "S&W Model 29";
	class'Magnum44Pistol'.default.FireModeClass[0] = Class'UnlimaginMod.UM_Magnum44Fire';
	//Ammo
	class'Magnum44Ammo'.default.MaxAmmo = 144;
	class'Magnum44Ammo'.default.InitialAmount = 48;
	class'Magnum44Ammo'.default.AmmoPickupAmount = 6;
	//Pickup
	class'Magnum44Pickup'.default.Weight = 2.000000;
	class'Magnum44Pickup'.default.cost = 450;
	class'Magnum44Pickup'.default.BuyClipSize = 6;
	class'Magnum44Pickup'.default.AmmoCost = 12;
	class'Magnum44Pickup'.default.ItemName = "S&W Model 29";
	class'Magnum44Pickup'.default.ItemShortName = "S&W M29";
	class'Magnum44Pickup'.default.PickupMessage = "You got the S&W Model 29";
	//--------------------
	//MK23Pistol
	//------------------
	class'DamTypeMK23Pistol'.default.WeaponClass = Class'UnlimaginMod.UM_MK23Pistol';
	class'DamTypeMK23Pistol'.default.HeadShotDamageMult = 1.600000;
	//Ammo
	class'MK23Ammo'.default.AmmoPickupAmount = 30;
	class'MK23Ammo'.default.MaxAmmo = 240;
	class'MK23Ammo'.default.InitialAmount = 120;
	//--------------------
	//Katana
	//------------------
	class'Katana'.default.Weight = 2.000000;
	//Pickup
	class'KatanaPickup'.default.Weight = 2.000000;
	//Fire
	class'KatanaFireB'.default.bWaitForRelease = False;
	//--------------------
	//GoldenKatana
	//------------------
	class'GoldenKatana'.default.Weight = 2.000000;
	//Pickup
	class'GoldenKatanaPickup'.default.Weight = 2.000000;
	class'GoldenKatanaPickup'.default.cost = 2200;
	//--------------------
	//Knife
	//------------------
	class'Knife'.default.bKFNeverThrow = False;
	//--------------------
	//KSGShotgun
	//------------------
	//DamTypeKSGShotgun
	class'DamTypeKSGShotgun'.default.WeaponClass = Class'UnlimaginMod.UM_KSGShotgun';
	//Ammo
	//class'KSGAmmo'.default.MaxAmmo = 56;
	//class'KSGAmmo'.default.InitialAmount = 42;
	//--------------------
	//KrissMMedicGun
	//------------------
	//KrissMFire
	//class'KrissMFire'.default.DamageMin = 35;
	class'KrissMFire'.default.DamageMax = 44;
	class'KrissMFire'.default.Spread = 0.012000;
	class'KrissMFire'.default.MaxSpread = 0.060000;
	class'KrissMFire'.default.DamageType = Class'UnlimaginMod.UM_DamTypeKrissM';
	//KrissMAmmo
	class'KrissMAmmo'.default.MaxAmmo = 400;
	class'KrissMAmmo'.default.InitialAmount = 200;
	//--------------------
	//M7A3MMedicGun
	//------------------
	//Fire
	class'M7A3MFire'.default.MaxVerticalRecoilAngle = 400;
	class'M7A3MFire'.default.MaxHorizontalRecoilAngle = 200;
	class'M7A3MFire'.default.DamageMin = 65;
	class'M7A3MFire'.default.DamageMax = 75;
	class'M7A3MFire'.default.DamageType = Class'UnlimaginMod.UM_DamTypeM7A3M';
	class'M7A3MFire'.default.FireRate = 0.120000;
	class'M7A3MFire'.default.Spread = 0.009000;
	class'M7A3MFire'.default.MaxSpread = 0.045000;
	//--------------------
	//M4AssaultRifle
	//------------------
	//Ammo
	class'M4Ammo'.default.MaxAmmo = 540;
	class'M4Ammo'.default.InitialAmount = 240;
	class'M4Ammo'.default.AmmoPickupAmount = 90;
	//--------------------
	//M32GrenadeLauncher
	//------------------
	class'M32GrenadeLauncher'.default.Weight = 6.000000;
	class'M32GrenadeLauncher'.default.FireModeClass[0] = Class'UnlimaginMod.UM_M32Fire';
	class'M32GrenadeLauncher'.default.MessageNoAmmo = "You've squandered all projectiles! Ass!";
	//Ammo
	//class'M32Ammo'.default.MaxAmmo = 36;
	//class'M32Ammo'.default.InitialAmount = 18;
	//class'M32Ammo'.default.AmmoPickupAmount = 6;
	//Pickup
	class'M32Pickup'.default.Weight = 6.000000;
	class'M32Pickup'.default.cost = 2600;
	class'M32Pickup'.default.BuyClipSize = 6;
	class'M32Pickup'.default.AmmoCost = 60;
	//M32GrenadeProjectile
	class'M32GrenadeProjectile'.default.Damage = 330.000000;
	class'M32GrenadeProjectile'.default.DamageRadius = 460.000000;
	class'M32GrenadeProjectile'.default.ImpactDamage = 200;
	//--------------------
	//M79GrenadeLauncher
	//------------------
	class'M79GrenadeLauncher'.default.Weight = 4.000000;
	class'M79GrenadeLauncher'.default.FireModeClass[0] = Class'UnlimaginMod.UM_M79Fire';
	class'M79GrenadeLauncher'.default.MessageNoAmmo = "You've squandered all projectiles! Ass!";
	//Ammo
	//class'M79Ammo'.default.MaxAmmo = 24;
	//class'M79Ammo'.default.InitialAmount = 12;
	//Pickup
	class'M79Pickup'.default.Weight = 4.000000;
	class'M79Pickup'.default.cost = 1200;
	//M79GrenadeProjectile
	class'M79GrenadeProjectile'.default.Damage = 360.000000;
	class'M79GrenadeProjectile'.default.DamageRadius = 410.000000;
	class'M79GrenadeProjectile'.default.ImpactDamage = 240;
	//--------------------
	//GoldenM79GrenadeLauncher
	//------------------
	class'GoldenM79GrenadeLauncher'.default.Weight = 4.000000;
	class'GoldenM79GrenadeLauncher'.default.FireModeClass[0] = Class'UnlimaginMod.UM_M79Fire';
	class'GoldenM79GrenadeLauncher'.default.MessageNoAmmo = "You've squandered all projectiles! Ass!";
	//Pickup
	class'GoldenM79Pickup'.default.Weight = 4.000000;
	class'GoldenM79Pickup'.default.cost = 1400;
	//--------------------
	//M99SniperRifle
	//------------------
	//Ammo
	class'M99Ammo'.default.MaxAmmo = 25;
	//--------------------
	//M4203AssaultRifle
	//------------------
	//Ammo
	class'M4203Ammo'.default.MaxAmmo = 540;
	class'M203Ammo'.default.MaxAmmo = 10;
	class'M4203Ammo'.default.InitialAmount = 200;
	class'M4203Ammo'.default.AmmoPickupAmount = 30;
	//M203GrenadeProjectile
	class'M203GrenadeProjectile'.default.Damage = 350.000000;
	class'M203GrenadeProjectile'.default.DamageRadius = 390.000000;
	class'M203GrenadeProjectile'.default.ImpactDamage = 200;
	//--------------------
	//MKb42AssaultRifle
	//------------------
	class'MKb42Ammo'.default.MaxAmmo = 360;
	class'MKb42Ammo'.default.InitialAmount = 180;
	//--------------------
	//MP5MMedicGun
	//------------------
	class'MP5MMedicGun'.default.Weight = 4.000000;
	class'MP5MMedicGun'.default.MagCapacity = 30;
	//Ammo
	class'MP5MAmmo'.default.MaxAmmo = 480;
	class'MP5MAmmo'.default.InitialAmount = 300;
	class'MP5MAmmo'.default.AmmoPickupAmount = 60;
	//Pickup
	class'MP5MPickup'.default.Weight = 4.000000;
	class'MP5MPickup'.default.cost = 4000;
	class'MP5MPickup'.default.BuyClipSize = 30;
	class'MP5MPickup'.default.AmmoCost = 10;
	//Fire
	class'MP5MFire'.default.FireRate = 0.075000;
	class'MP5MFire'.default.Spread = 0.011000;
	class'MP5MFire'.default.MaxSpread = 0.055000;
	class'MP5MFire'.default.DamageMin = 26;
	class'MP5MFire'.default.DamageMax = 35;
	class'MP5MFire'.default.DamageType = Class'UnlimaginMod.UM_DamTypeMP5M';
	class'MP5MFire'.default.maxVerticalRecoilAngle = 110;
	class'MP5MFire'.default.maxHorizontalRecoilAngle = 80;
	//--------------------
	//MP7MMedicGun
	//------------------
	class'MP7MMedicGun'.default.Weight = 3.000000;
	class'MP7MMedicGun'.default.MagCapacity = 40;
	//Ammo
	class'MP7MAmmo'.default.MaxAmmo = 480;
	class'MP7MAmmo'.default.InitialAmount = 320;
	class'MP7MAmmo'.default.AmmoPickupAmount = 80;
	//Pickup
	class'MP7MPickup'.default.Weight = 3.000000;
	class'MP7MPickup'.default.BuyClipSize = 40;
	class'MP7MPickup'.default.AmmoCost = 10;
	//Fire
	class'MP7MFire'.default.Spread = 0.010000;
	class'MP7MFire'.default.MaxSpread = 0.050000;
	class'MP7MFire'.default.DamageMin = 20;
	class'MP7MFire'.default.DamageMax = 30;
	class'MP7MFire'.default.DamageType = Class'UnlimaginMod.UM_DamTypeMP7M';
	class'MP7MFire'.default.maxVerticalRecoilAngle = 80;
	class'MP7MFire'.default.maxHorizontalRecoilAngle = 60;
	//MP7MAltFire
	//class'MP7MAltFire'.default.ProjectileClass = Class'UnlimaginMod.UM_MP7MHealinglProjectile';
	//--------------------
	//NailGun
	//------------------
	class'NailGun'.default.MagCapacity = 7;
	class'NailGun'.default.Weight = 7.000000;
	//NailGunFire
	class'NailGunFire'.default.ProjPerFire = 15;
	class'NailGunFire'.default.Spread = 2500;
	class'NailGunFire'.default.FireRate = 0.400000; // default.FireRate=0.500000
	//NailGunProjectile
	class'NailGunProjectile'.default.Damage = 17.000000;
	class'NailGunProjectile'.default.Bounces = 3;
	class'NailGunProjectile'.default.MaxPenetrations = 2;
	class'NailGunProjectile'.default.PenDamageReduction = 0.630000;
	//NailGunPickup
	class'NailGunPickup'.default.Weight = 7.000000;
	class'NailGunPickup'.default.BuyClipSize = 14;
	//NailGunAmmo
	class'NailGunAmmo'.default.AmmoPickupAmount = 14;
	class'NailGunAmmo'.default.MaxAmmo = 56;
	class'NailGunAmmo'.default.InitialAmount = 35;
	//--------------------
	//PipeBombExplosive
	//------------------
	class'PipeBombExplosive'.default.FireModeClass[0] = Class'UnlimaginMod.UM_PipeBombFire';
	//Ammo
	class'PipeBombAmmo'.default.MaxAmmo = 2;
	//--------------------
	//SCARMK17AssaultRifle
	//------------------
	//Ammo
	class'SCARMK17Ammo'.default.MaxAmmo = 300;
	class'SCARMK17Ammo'.default.InitialAmount = 180;
	//--------------------
	//Shotgun
	//------------------
	//Ammo
	class'ShotgunAmmo'.default.MaxAmmo = 64;
	class'ShotgunAmmo'.default.InitialAmount = 40;
	class'ShotgunAmmo'.default.AmmoPickupAmount = 4;
	//--------------------
	//Single
	//------------------
	class'Single'.default.MagCapacity = 21;
	class'Single'.default.Weight = 1.000000;
	class'Single'.default.bKFNeverThrow = False;
	class'Single'.default.FireModeClass[0] = Class'UnlimaginMod.UM_Beretta93MAFire';
	class'Single'.default.ItemName="Beretta 93MA";
	//Ammo
	class'SingleAmmo'.default.AmmoPickupAmount = 42;
	class'SingleAmmo'.default.MaxAmmo = 336;
	class'SingleAmmo'.default.InitialAmount = 210;
	//Pickup
	class'SinglePickup'.default.Weight = 1.000000;
	class'SinglePickup'.default.cost = 200;
	class'SinglePickup'.default.BuyClipSize = 42;
	class'SinglePickup'.default.ItemName = "Beretta 93MA";
	class'SinglePickup'.default.ItemShortName = "Beretta 93MA";
	//Syringe
	//------------------
	class'Syringe'.default.bSpeedMeUp = True;
	//--------------------
	//ThompsonSMG
	//------------------
	//ThompsonAmmo
	class'ThompsonAmmo'.default.MaxAmmo = 540;
	class'ThompsonAmmo'.default.InitialAmount = 300;
	//--------------------
	//ThompsonDrumSMG
	//------------------
	class'ThompsonDrumAmmo'.default.MaxAmmo = 540;
	class'ThompsonDrumAmmo'.default.InitialAmount = 300;
	//--------------------
	//SPThompsonSMG
	//------------------
	class'SPThompsonAmmo'.default.MaxAmmo = 540;
	class'SPThompsonAmmo'.default.InitialAmount = 300;
	//--------------------
	//Trenchgun
	//------------------
	//TrenchgunAmmo
	class'TrenchgunAmmo'.default.AmmoPickupAmount = 6;
	class'TrenchgunAmmo'.default.MaxAmmo = 60;
	class'TrenchgunAmmo'.default.InitialAmount = 30;
	//--------------------
	//LAW
	//------------------
	class'LAW'.default.Weight = 8.000000;
	class'LAW'.default.FireModeClass[0] = Class'UnlimaginMod.UM_LAWFire';
	class'LAW'.default.MessageNoAmmo = "You've squandered all projectiles! Ass!";
	//Ammo
	//class'LAWAmmo'.default.MaxAmmo = 10;
	//class'LAWAmmo'.default.InitialAmount = 10;
	//class'LAWAmmo'.default.AmmoPickupAmount = 2;
	//Pickup
	class'LAWPickup'.default.Weight = 8.000000;
	class'LAWPickup'.default.cost = 3200;
	class'LAWPickup'.default.BuyClipSize = 1;
	class'LAWPickup'.default.AmmoCost = 40;
	//LAWProj
	class'LAWProj'.default.Damage = 950.000000;
	class'LAWProj'.default.DamageRadius = 500.000000;
	class'LAWProj'.default.ImpactDamage = 300;
	//--------------------
	//Winchester
	//------------------
	//Ammo
	class'WinchesterAmmo'.default.MaxAmmo = 112;
	class'WinchesterAmmo'.default.InitialAmount = 42;
	//-------------------
	//ZEDGun
	//-----------------
	//ZEDGunProjectile
	class'ZEDGunProjectile'.default.Damage = 100;
	//[end]
	
	class'KFLevelRules'.default.ItemForSale[12] = Class'UnlimaginMod.UM_MK23Pickup';
    class'KFLevelRules'.default.ItemForSale[13] = Class'UnlimaginMod.UM_DualMK23Pickup';
}

/*
simulated function GenerateWeaponsInfo()
{
	local	array< WeaponMaxPerfs >		WMaxPerfs;
	local	Class<KFShotgunFire>		KFShotgunFireClass;
	local	Class<KFFire>				KFFireClass;
	local	Class<KFMeleeFire>			KFMeleeFireClass;
	local	Class<Projectile>			ProjClass;
	local	int							i;
	
	//[block] WeaponPickup PowerValue, SpeedValue and RangeValue AutoGenerator
	if ( !default.bInfoGenerated && WeaponsInfo.Length > 0 )
	{
		default.bInfoGenerated = True;
		//Filling Damage, FireRate and Spread_Or_MeleeRange vars in WeaponsInfo
		for ( i = 0; i < WeaponsInfo.Length; i++ )  {
			//filling WeaponsInfo elements
			if ( WeaponsInfo[i].PickupClass != None )  {
				KFShotgunFireClass = Class<KFShotgunFire>(Class<KFWeapon>(WeaponsInfo[i].PickupClass.default.InventoryType).default.FireModeClass[0]);
				KFFireClass = Class<KFFire>(Class<KFWeapon>(WeaponsInfo[i].PickupClass.default.InventoryType).default.FireModeClass[0]);
				KFMeleeFireClass = Class<KFMeleeFire>(Class<KFWeapon>(WeaponsInfo[i].PickupClass.default.InventoryType).default.FireModeClass[0]);
				if ( KFShotgunFireClass != None )  {
					//finding out ProjectileClass
					ProjClass = KFShotgunFireClass.default.ProjectileClass;
					//assign weapon Damage
					WeaponsInfo[i].Damage = KFShotgunFireClass.default.ProjPerFire * ProjClass.default.Damage;
					//assign weapon FireRate
					WeaponsInfo[i].FireRate = KFShotgunFireClass.default.FireRate;
					//assign weapon Range (Spread)
					WeaponsInfo[i].Spread = KFShotgunFireClass.default.Spread;
				}
				else if ( KFFireClass != None )  {
					//assign weapon Damage (DamageMin and DamageMax arithmetic average)
					WeaponsInfo[i].Damage = (KFFireClass.default.DamageMin + KFFireClass.default.DamageMax) / 2;
					//assign weapon FireRate
					WeaponsInfo[i].FireRate = KFFireClass.default.FireRate;
					//assign weapon Range (Spread and MaxSpread arithmetic average)
					WeaponsInfo[i].Spread = (KFFireClass.default.Spread + KFFireClass.default.MaxSpread) / 2;
				}
				else if ( KFMeleeFireClass != None )  {
					//assign weapon Damage
					WeaponsInfo[i].Damage = KFMeleeFireClass.default.MeleeDamage;
					//assign weapon FireRate
					WeaponsInfo[i].FireRate = KFMeleeFireClass.default.FireRate;
					//It is a Melee weapon
					WeaponsInfo[i].bMelee = True;
					//assign weapon Range (Melee)
					WeaponsInfo[i].MeleeRange = KFMeleeFireClass.default.weaponRange;
				}
			}
		}
		
		// Because UT2004 doesn't support structdefaultproperties 
		// initial values sets like that =)
		for ( i = 0; i < WeaponsInfo.Length; ++i )  {
			if ( (WeaponsInfo[i].CatNum + 1) > WMaxPerfs.Length )
				WMaxPerfs.Length = WeaponsInfo[i].CatNum + 1;
		}
		for ( i = 0; i < WMaxPerfs.Length; i++ )  {
			WMaxPerfs[i].MaxFireRate = 1000.0;
			WMaxPerfs[i].MaxSpread = 100000.0;
		}
		
		//Finding out weapons MaxDamage, MaxFireRate and MaxSpread_Or_MeleeRange
		for ( i = 0; i < WeaponsInfo.Length; i++ )  {
			if ( WeaponsInfo[i].PickupClass != None )  {
				//MaxDamage
				if ( WMaxPerfs[WeaponsInfo[i].CatNum].MaxDamage < WeaponsInfo[i].Damage )
					WMaxPerfs[WeaponsInfo[i].CatNum].MaxDamage = WeaponsInfo[i].Damage;
				
				//MaxFireRate
				if ( WMaxPerfs[WeaponsInfo[i].CatNum].MaxFireRate > WeaponsInfo[i].FireRate )
					WMaxPerfs[WeaponsInfo[i].CatNum].MaxFireRate = WeaponsInfo[i].FireRate;
				
				//MaxSpread Or MeleeRange
				if ( !WeaponsInfo[i].bMelee && 
					 WMaxPerfs[WeaponsInfo[i].CatNum].MaxSpread > WeaponsInfo[i].Spread )
					WMaxPerfs[WeaponsInfo[i].CatNum].MaxSpread = WeaponsInfo[i].Spread;
				else if ( WeaponsInfo[i].bMelee && 
					 WMaxPerfs[WeaponsInfo[i].CatNum].MaxMeleeRange < WeaponsInfo[i].MeleeRange )
					WMaxPerfs[WeaponsInfo[i].CatNum].MaxMeleeRange = WeaponsInfo[i].MeleeRange;
			}
		}
		
		//Assign PickupClasses PowerValue, SpeedValue and RangeValue
		for ( i = 0; i < WeaponsInfo.Length; i++ )  {
			if ( WeaponsInfo[i].PickupClass != None )  {
				//PowerValue
				if ( WeaponsInfo[i].Damage >= WMaxPerfs[WeaponsInfo[i].CatNum].MaxDamage )
					WeaponsInfo[i].PickupClass.default.PowerValue = 100;
				else
					WeaponsInfo[i].PickupClass.default.PowerValue = int(WeaponsInfo[i].Damage / WMaxPerfs[WeaponsInfo[i].CatNum].MaxDamage * 100.0);
				
				//SpeedValue
				if ( WeaponsInfo[i].FireRate <= WMaxPerfs[WeaponsInfo[i].CatNum].MaxFireRate )
					WeaponsInfo[i].PickupClass.default.SpeedValue = 100;
				else
					WeaponsInfo[i].PickupClass.default.SpeedValue = int(WMaxPerfs[WeaponsInfo[i].CatNum].MaxFireRate / WeaponsInfo[i].FireRate * 100.0);
				
				//RangeValue
				if ( !WeaponsInfo[i].bMelee )  {
					if ( WeaponsInfo[i].Spread <= WMaxPerfs[WeaponsInfo[i].CatNum].MaxSpread )
						WeaponsInfo[i].PickupClass.default.RangeValue = 100;
					else
						WeaponsInfo[i].PickupClass.default.RangeValue = int(WMaxPerfs[WeaponsInfo[i].CatNum].MaxSpread / WeaponsInfo[i].Spread * 100.0);
				}
				else {
					if ( WeaponsInfo[i].MeleeRange >= WMaxPerfs[WeaponsInfo[i].CatNum].MaxMeleeRange )
						WeaponsInfo[i].PickupClass.default.RangeValue = 100;
					else
						WeaponsInfo[i].PickupClass.default.RangeValue = int(WeaponsInfo[i].MeleeRange / WMaxPerfs[WeaponsInfo[i].CatNum].MaxMeleeRange * 100.0);
				}
			}
		}
	}
	//[end]
} */

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	Class'UM_AData'.default.WeapInfoGen = self;
	RebalansDefaultClasses();
}

simulated event Destroyed()
{
	Class'UM_AData'.default.WeapInfoGen = None;
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
     DrawType=DT_None
     LifeSpan=0.000000
	 bCanBeDamaged=False
	 bUnlit=True
	 bAlwaysRelevant=True
	 bGameRelevant=True
	 //RemoteRole=ROLE_SimulatedProxy
	 RemoteRole=ROLE_DumbProxy
     bHidden=True
	 bHiddenEd=True
	 bCollideActors=False
	 bCollideWorld=False
	 bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bSmoothKarmaStateUpdates=False
     bBlockHitPointTraces=False
	 CollisionRadius=0.000000
     CollisionHeight=0.000000
}
