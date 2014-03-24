//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseShotgun
//	Parent class:	 UM_BaseWeapon
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.05.2013 05:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseShotgun extends UM_BaseWeapon
	Abstract;


//[block] Copied from KFWeaponShotgun with some changes
// AI Interface
function float GetAIRating()
{
	local	Bot		B;
	local	float	EnemyDist;
	local	vector	EnemyDir;

	B = Bot(Instigator.Controller);

	if ( B == None )
		Return AIRating;

	if ( B.Target != None && Pawn(B.Target) == None && 
		 VSize(B.Target.Location - Instigator.Location) < 1250 )
		Return 0.9;

	if ( B.Enemy == None )
	{
		if ( B.Target != None && VSize(B.Target.Location - B.Pawn.Location) > 3500 )
			Return 0.2;

		Return AIRating;
	}

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);

	if ( EnemyDist > 750 )
	{
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				Return 0.2;

			Return (AIRating - 0.3);
		}

		if ( EnemyDir.Z < -0.5 * EnemyDist )
			Return (AIRating - 0.3);
	}
	else if ( B.Enemy.Weapon != None && B.Enemy.Weapon.bMeleeWeapon )
		Return (AIRating + 0.35);
	else if ( EnemyDist < 400 )
		Return (AIRating + 0.2);

	Return FMax(AIRating + 0.2 - (EnemyDist - 400) * 0.0008, 0.2);
}

function float SuggestAttackStyle()
{
	if ( AIController(Instigator.Controller) != None &&
		 AIController(Instigator.Controller).Skill < 3 )
		Return 0.4;
	
    Return 0.8;
}
//[end]

defaultproperties
{
     bHasTacticalReload=True
	 TacticalReloadCapacityBonus=1
	 ForceZoomOutOnFireTime=0.000000
	 bHoldToReload=True
}
