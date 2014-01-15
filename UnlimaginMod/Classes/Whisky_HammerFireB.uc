//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Whisky_HammerFireB extends KFMeleeFire;

var     float           MomentumTransfer;         // Momentum magnitude imparted by impacting weapon.
var()	InterpCurve     AppliedMomentumCurve;     // How much momentum to apply to a zed based on how much mass it has
var(Hedshots)	class<DamageType>	HeadShotDamageClass;	// Headshot damage type

simulated event Timer()
{
	local Actor HitActor;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator PointRot;
	local int MyDamage;
	local bool bBackStabbed;
	local Pawn Victims;
	local vector dir, lookdir;
	local float DiffAngle, VictimDist;
	local float AppliedMomentum;

	MyDamage = MeleeDamage;

	If( !KFWeapon(Weapon).bNoHit )
	{
		MyDamage = MeleeDamage;
		StartTrace = Instigator.Location + Instigator.EyePosition();

		if ( Instigator.Controller != None && PlayerController(Instigator.Controller) == None && 
			 Instigator.Controller.Enemy != None )
			PointRot = rotator(Instigator.Controller.Enemy.Location-StartTrace); // Give aimbot for bots.
		else
			PointRot = Instigator.GetViewRotation();

		EndTrace = StartTrace + vector(PointRot)*weaponRange;
		HitActor = Instigator.Trace( HitLocation, HitNormal, EndTrace, StartTrace, true);

        //Instigator.ClearStayingDebugLines();
        //Instigator.DrawStayingDebugLine( StartTrace, EndTrace,0, 255, 0);

		if ( HitActor != None )
		{
			ImpactShakeView();

			if ( HitActor.IsA('ExtendedZCollision') && HitActor.Base != None &&
				 HitActor.Base.IsA('KFMonster') )
                HitActor = HitActor.Base;

			if ( (HitActor.IsA('KFMonster') || HitActor.IsA('KFHumanPawn')) && 
				 KFMeleeGun(Weapon).BloodyMaterial != None )
			{
				Weapon.Skins[KFMeleeGun(Weapon).BloodSkinSwitchArray] = KFMeleeGun(Weapon).BloodyMaterial;
				Weapon.texture = Weapon.default.Texture;
			}
			
			if ( Level.NetMode == NM_Client )
                Return;

			if ( HitActor.IsA('Pawn') && !HitActor.IsA('Vehicle') &&
				 (Normal(HitActor.Location-Instigator.Location) dot vector(HitActor.Rotation)) > 0 ) // Fixed in Balance Round 2
			{
				bBackStabbed = True;
				MyDamage *= 2; // Backstab >:P
			}

			if ( KFMonster(HitActor) != None )
			{
			//	log(VSize(Instigator.Velocity));

				KFMonster(HitActor).bBackstabbed = bBackStabbed;
				
				//[block] Copied from DwarfAxeFire
				dir = Normal((HitActor.Location + KFMonster(HitActor).EyePosition()) - Instigator.Location);
                AppliedMomentum = InterpCurveEval(AppliedMomentumCurve,HitActor.Mass);
				
				if ( KFMonster(HitActor).IsHeadShot(HitLocation, dir, 1.25) )
					HitActor.TakeDamage(MyDamage, Instigator, HitLocation, (dir * AppliedMomentum), HeadShotDamageClass);
				else
					HitActor.TakeDamage(MyDamage, Instigator, HitLocation, (dir * AppliedMomentum), hitDamageClass);
				
				// Break thier grapple if you are knocking them back!
                if ( KFMonster(HitActor) != None )
					KFMonster(HitActor).BreakGrapple();
				//[end]

            	if ( MeleeHitSounds.Length > 0 )
					Weapon.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);

				if ( VSize(Instigator.Velocity) > 300 && 
					 KFMonster(HitActor).Mass <= Instigator.Mass )
				    KFMonster(HitActor).FlipOver();
			}
			else
			{
				//[block] Copied from DwarfAxeFire
				HitActor.TakeDamage(MyDamage, Instigator, HitLocation, (Normal(vector(PointRot)) * MomentumTransfer), hitDamageClass);
				Spawn(HitEffectClass,,, HitLocation, rotator(HitLocation - StartTrace));
				//[end]
				//if( KFWeaponAttachment(Weapon.ThirdPersonActor)!=None )
		        //  KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(HitActor,HitLocation,HitNormal);

		        //Weapon.IncrementFlashCount(ThisModeNum);
			}
		}

		if ( WideDamageMinHitAngle > 0 )
		{
            foreach Weapon.VisibleCollidingActors( class 'Pawn', Victims, (weaponRange * 2), StartTrace ) //, RadiusHitLocation
    		{
                if ( (HitActor != none && Victims == HitActor) || Victims.Health <= 0 )
					Continue;

            	if ( Victims != Instigator )
    			{
    				VictimDist = VSizeSquared(Instigator.Location - Victims.Location);

                    //log("VictimDist = "$VictimDist$" Weaponrange = "$(weaponRange*Weaponrange));

                            //Instigator.ClearStayingDebugLines();
                    //Instigator.DrawStayingDebugLine( Instigator.Location, EndTrace,0, 255, 0);

                    if ( VictimDist > (((weaponRange * 1.1) * (weaponRange * 1.1)) + (Victims.CollisionRadius * Victims.CollisionRadius)) )
						Continue;

    	  			lookdir = Normal(Vector(Instigator.GetViewRotation()));
    				dir = Normal(Victims.Location - Instigator.Location);

    	           	DiffAngle = lookdir dot dir;
					//[block] Copied from DwarfAxeFire
					dir = Normal((Victims.Location + Victims.EyePosition()) - Instigator.Location);
					//[end]
    	           	if ( DiffAngle > WideDamageMinHitAngle )
    	           	{
    	           		//[block] Copied from DwarfAxeFire
						AppliedMomentum = InterpCurveEval(AppliedMomentumCurve,Victims.Mass);
						//Instigator.DrawStayingDebugLine( Victims.Location + vect(0,0,10), Instigator.Location,255, 0, 0);
                        //log("Shot would hit "$Victims$" DiffAngle = "$DiffAngle$" WideDamageMinHitAngle = "$WideDamageMinHitAngle$" for damage of: "$(MyDamage*DiffAngle));
    	           		if ( KFMonster(Victims) != None && 
							 KFMonster(Victims).IsHeadShot((Victims.Location + Victims.CollisionHeight * vect(0,0,0.7)), dir, 1.25) )
							Victims.TakeDamage((MyDamage * DiffAngle), Instigator, (Victims.Location + Victims.CollisionHeight * vect(0,0,0.7)), (dir * AppliedMomentum), HeadShotDamageClass);
						else
							Victims.TakeDamage((MyDamage * DiffAngle), Instigator, (Victims.Location + Victims.CollisionHeight * vect(0,0,0.7)), (dir * AppliedMomentum), hitDamageClass);
						
						// Break thier grapple if you are knocking them back!
                        if ( KFMonster(Victims) != None )
							KFMonster(Victims).BreakGrapple();
						//[end]
                    	if ( MeleeHitSounds.Length > 0 )
							Victims.PlaySound(MeleeHitSounds[Rand(MeleeHitSounds.length)],SLOT_None,MeleeHitVolume,,,,false);
    	           	}
    	           	//else
    	           	//{
                        //Instigator.DrawStayingDebugLine( Victims.Location, Instigator.Location,255, 255, 0);
                        //log("Shot would miss "$Victims$" DiffAngle = "$DiffAngle$" WideDamageMinHitAngle = "$WideDamageMinHitAngle);
    	           	//}
    			}
    		}
		}
	}
}

defaultproperties
{
     HeadShotDamageClass=Class'UnlimaginMod.Whisky_DamTypeHammerSecondaryHeadShot'
	 //[block] Dynamic Loading Vars
	 //MeleeHitSounds(0)=Sound'KFWeaponSound.bullethitflesh2'
	 MeleeHitSoundRefs(0)="KFWeaponSound.bullethitflesh2"
	 MeleeHitSoundRefs(1)="KFWeaponSound.bullethitflesh3"
	 MeleeHitSoundRefs(2)="KFWeaponSound.bullethitflesh4"
	 //[end]
	 MomentumTransfer=260000.000000
	 //AppliedMomentumCurve=(Points=((OutVal=10000.000000),(InVal=350.000000,OutVal=175000.000000),(InVal=600.000000,OutVal=250000.000000)))
     AppliedMomentumCurve=(Points=((OutVal=12000.000000),(InVal=350.000000,OutVal=185000.000000),(InVal=600.000000,OutVal=260000.000000)))
	 MeleeDamage=260
     ProxySize=0.150000
     weaponRange=94.000000
     DamagedelayMin=0.760000
     DamagedelayMax=0.760000
     hitDamageClass=Class'UnlimaginMod.Whisky_DamTypeHammerSecondary'
     HitEffectClass=Class'KFMod.AxeHitEffect'
	 WideDamageMinHitAngle=0.900000
     FireAnim="PowerAttack"
     FireRate=1.100000
     BotRefireRate=0.850000
}
