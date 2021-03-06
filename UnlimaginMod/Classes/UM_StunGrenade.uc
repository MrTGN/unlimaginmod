//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_StunGrenade
//	Parent class:	 Nade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 17.01.2013 22:14
//================================================================================
class UM_StunGrenade extends Nade;

var		sound   ExplosionSound; // The sound of exploding

simulated function Explode(vector HitLocation, vector HitNormal)
{
	//local PlayerController  LocalPlayer;
	//local Projectile P;
	//local byte i;

	bHasExploded = True;
	BlowUp(HitLocation);

	PlaySound(ExplosionSound,,2.0);

	if ( EffectIsRelevant(Location,False) )
	{
		Spawn(Class'KFmod.KFNadeExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	Destroy();
}

/* HurtRadius()
 Hurt locally authoritative actors within the radius.
*/
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local int NumDazzled;
	local KFMonster KFMonsterVictim;
	local UM_BaseMonster UM_KFMonsterVictim;
	local Controller KFMVictimController;
	local Pawn P;
	//local KFPawn KFP;
	local array<Pawn> CheckedPawns;
	local int i;
	local bool bAlreadyChecked;


	if ( bHurtEntry )
		Return;

	bHurtEntry = True;

	foreach CollidingActors (class 'Actor', Victims, DamageRadius, HitLocation)
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo')
		 && ExtendedZCollision(Victims)==None )
		{
			if( (Instigator==None || Instigator.Health<=0) && KFPawn(Victims)!=None )
				Continue;
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

			if ( Instigator == None || Instigator.Controller == None )
			{
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			}

			P = Pawn(Victims);

			if( P != None )
			{
		        for (i = 0; i < CheckedPawns.Length; i++)
				{
		        	if (CheckedPawns[i] == P)
					{
						bAlreadyChecked = True;
						Break;
					}
				}

				if( bAlreadyChecked )
				{
					bAlreadyChecked = False;
					P = None;
					continue;
				}

                KFMonsterVictim = KFMonster(Victims);
				KFMVictimController = KFMonsterVictim.Controller;
				UM_KFMonsterVictim = UM_BaseMonster(Victims);

    			if( KFMonsterVictim != None && KFMonsterVictim.Health <= 0 )
    			{
                    KFMonsterVictim = None;
    			}

                //KFP = KFPawn(Victims);

                if( KFMonsterVictim != None )
                {
                    damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
                }
                /*else if( KFP != None )
				{
					damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
				}*/

				CheckedPawns[CheckedPawns.Length] = P;

				if ( damageScale <= 0)
				{
					P = None;
					continue;
				}
				else
				{
					//Victims = P;
					P = None;
				}
			}

			UM_KFMonsterVictim.Dazzle(damageScale);
			 
			if( Role == ROLE_Authority && KFMonsterVictim != None && KFMVictimController.IsInState('IamDazzled') )
                NumDazzled++;

			/*if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			{
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			}*/
        }
	}
	
	if( Role == ROLE_Authority )
    {
        if ( NumDazzled >= 4 )
        {
            KFGameType(Level.Game).DramaticEvent(0.05);
        }
        else if ( NumDazzled >= 2 )
        {
            KFGameType(Level.Game).DramaticEvent(0.03);
        }
    }

	bHurtEntry = False;
}

defaultproperties
{
	ExplodeTimer=2.000000
	ExplosionSound=Sound'KF_GrenadeSnd.NadeBase.Nade_Explode4'
	Damage=0.000000
	DamageRadius=360.000000
}
