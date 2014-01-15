//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ActorPool
//	Parent class:	 Actor
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.09.2013 09:20
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Creating and destroying actors is a relatively expensive operations.
//					 ActorPool allows to hidden and re-use actors to safe CPU and RAM resources.
//================================================================================
class UM_ActorPool extends Actor
	placeable;


//========================================================================
//[block] Variables

var		array< name >		ActorProbeFunctions;

// overall actors array
var		array< Actor >		Actors;

// Client separate arrays
var		array< Actor >		Effects;
var		array< Actor >		Emitters;
var		array< Actor >		Gibs;
var		array< Actor >		xEmitters;

// Server separate arrays
var		array< Actor >		Inventories;
var		array< Actor >		Pawns;
var		array< Actor >		Pickups;
var		array< Actor >		Projectiles;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		AuthorityActivateActor;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	Class'UM_AData'.default.ActorPool = self;
}

// ActivateActor with out function call replication from the server.
simulated function ActivateActor(
			Actor		A,
 optional	Vector		NewLocation, 
 optional 	Rotator		NewRotation,
 optional	Actor		NewOwner,
 optional	Pawn		NewInstigator,
 optional	bool		bReset)
{
	local	int		i;
	
	if ( A != None )  {
		//Log("Actor has found in arrays. Activating Actor.",Name);
		//Unhiding actor
		A.bHidden = A.default.bHidden;
		//Enabling ActorProbeFunctions
		if ( ActorProbeFunctions.Length > 0 )  {
			for ( i = 0; i < ActorProbeFunctions.Length; i++ )  {
				if ( ActorProbeFunctions[i] != '' )
					A.Enable(ActorProbeFunctions[i]);
			}
		}
		//A.SetPhysics(A.default.Physics);
		//Enabling collision
		A.SetCollision(A.default.bCollideActors, A.default.bBlockActors);
		A.bCollideWorld = A.default.bCollideWorld;
		if ( NewOwner != None )
			A.SetOwner(NewOwner);
		if ( NewInstigator != None )
			A.Instigator = NewInstigator;
		if ( NewLocation != Vect(0.0,0.0,0.0) )
			A.SetLocation(NewLocation);
		else
			A.SetLocation(A.Location);
		A.SetRotation(NewRotation);
		A.bAlwaysRelevant = A.default.bAlwaysRelevant;
		if ( bReset )
			A.Reset();
	}
}

// ActivateActor with function call replication from the server to the clients.
// Used for server arrays.
simulated function AuthorityActivateActor(
			Actor		A,
 optional	Vector		NewLocation, 
 optional 	Rotator		NewRotation,
 optional	Actor		NewOwner,
 optional	Pawn		NewInstigator,
 optional	bool		bReset)
{
	ActivateActor(A, NewLocation, NewRotation, NewOwner, NewInstigator, bReset);
}

simulated function Actor AllocateActor(
			class<Actor>	ActorClass, 
 optional	Vector			NewLocation, 
 optional 	Rotator			NewRotation,
 optional	Actor			NewOwner,
 optional	Pawn			NewInstigator,
 optional	bool			bReset)
{
	local	Actor 	A;
	local	int		i;
	local	bool	bAuthorityActivateActor;
	
	// Seracning the actor in arrays
	if ( Class<Effects>(ActorClass) != None )  {
		if ( Level.NetMode != NM_DedicatedServer && Effects.Length > 1 )  {
			for ( i = 0; i < Effects.Length; i++ )  {
				if ( Effects[i] != None )  {
					if ( Effects[i].Class == ActorClass )  {
						A = Effects[i];
						Effects.Remove(i,1);
						//Log("Removing actor from Effects array.",Name);
						Break;
					}
				}
				else
					Effects.Remove(i,1);
			}
		}
	}
	else if ( Class<Emitter>(ActorClass) != None )  {
		if ( Level.NetMode != NM_DedicatedServer && Emitters.Length > 1 )  {
			for ( i = 0; i < Emitters.Length; i++ )  {
				if ( Emitters[i] != None )  {
					if ( Emitters[i].Class == ActorClass )  {
						A = Emitters[i];
						Emitters.Remove(i,1);
						Break;
					}
				}
				else
					Emitters.Remove(i,1);
			}
		}
	}
	else if ( Class<Gib>(ActorClass) != None )  {
		if ( Level.NetMode != NM_DedicatedServer && Gibs.Length > 1 )  {
			for ( i = 0; i < Gibs.Length; i++ )  {
				if ( Gibs[i] != None )  {
					if ( Gibs[i].Class == ActorClass )  {
						A = Gibs[i];
						Gibs.Remove(i,1);
						Break;
					}
				}
				else
					Gibs.Remove(i,1);
			}
		}
	}
	else if ( Class<xEmitter>(ActorClass) != None )  {
		if ( Level.NetMode != NM_DedicatedServer && xEmitters.Length > 1 )  {
			for ( i = 0; i < xEmitters.Length; i++ )  {
				if ( xEmitters[i] != None )  {
					if ( xEmitters[i].Class == ActorClass )  {
						A = xEmitters[i];
						xEmitters.Remove(i,1);
						Break;
					}
				}
				else
					xEmitters.Remove(i,1);
			}
		}
	}
	else if ( Class<Inventory>(ActorClass) != None )  {
		bAuthorityActivateActor = True;
		if ( Role == ROLE_Authority && Inventories.Length > 1 )  {
			for ( i = 0; i < Inventories.Length; i++ )  {
				if ( Inventories[i] != None )  {
					if ( Inventories[i].Class == ActorClass )  {
						A = Inventories[i];
						Inventories.Remove(i,1);
						Break;
					}
				}
				else
					Inventories.Remove(i,1);
			}
		}
	}
	else if ( Class<Pawn>(ActorClass) != None )  {
		bAuthorityActivateActor = True;
		if ( Role == ROLE_Authority && Pawns.Length > 1 )  {
			for ( i = 0; i < Pawns.Length; i++ )  {
				if ( Pawns[i] != None )  {
					if ( Pawns[i].Class == ActorClass )  {
						A = Pawns[i];
						Pawns.Remove(i,1);
						Break;
					}
				}
				else
					Pawns.Remove(i,1);
			}
		}
	}
	else if ( Class<Pickup>(ActorClass) != None )  {
		bAuthorityActivateActor = True;
		if ( Role == ROLE_Authority && Pickups.Length > 1 )  {
			for ( i = 0; i < Pickups.Length; i++ )  {
				if ( Pickups[i] != None )  {
					if ( Pickups[i].Class == ActorClass )  {
						A = Pickups[i];
						Pickups.Remove(i,1);
						Break;
					}
				}
				else
					Pickups.Remove(i,1);
			}
		}
	}
	else if ( Class<Projectile>(ActorClass) != None )  {
		bAuthorityActivateActor = True;
		if ( Role == ROLE_Authority && Projectiles.Length > 1 )  {
			for ( i = 0; i < Projectiles.Length; i++ )  {
				if ( Projectiles[i] != None )  {
					if ( Projectiles[i].Class == ActorClass )  {
						A = Projectiles[i];
						Projectiles.Remove(i,1);
						Break;
					}
				}
				else
					Projectiles.Remove(i,1);
			}
		}
	}
	else if ( Actors.Length > 1 )  {
		for ( i = 0; i < Actors.Length; i++ )  {
			if ( Actors[i] != None )  {
				if ( Actors[i].Class == ActorClass )  {
					A = Actors[i];
					Actors.Remove(i,1);
					Break;
				}
			}
			else
				Actors.Remove(i,1);
		}
	}
	
	if ( A == None )  {
		//Log("Actor has not found in arrays. Spawning ActorClass="$string(ActorClass),Name);
		if ( NewLocation == Vect(0.0,0.0,0.0) )
			NewLocation = Location;
		A = Spawn(ActorClass, NewOwner,, NewLocation, NewRotation);
	}
	else if ( bAuthorityActivateActor )
		AuthorityActivateActor(A, NewLocation, NewRotation, NewOwner, NewInstigator, bReset);
	else
		ActivateActor(A, NewLocation, NewRotation, NewOwner, NewInstigator, bReset);
	
	Return A;
}

simulated function DeactivateActor(Actor A)
{
	local	int		i;
	
	A.bAlwaysRelevant = True;
	//A.SetPhysics(PHYS_None);
	//Disabling collision
	A.SetCollision(False, False);
	A.bCollideWorld = False;
	//Disabling ActorProbeFunctions
	for ( i = 0; i < ActorProbeFunctions.Length; i++ )  {
		if ( ActorProbeFunctions[i] != '' )
			A.Disable(ActorProbeFunctions[i]);
	}
	//Hiding actor
	A.bHidden = True;
}

simulated function FreeActor(Actor A)
{
	if ( A == None || A.bDeleteMe )
		Return;
	DeactivateActor(A);
	if ( Effects(A) != None )  {
		//Client array
		//log("ActorPool: Adding actor to the Effects array.",Name);
		if ( Level.NetMode != NM_DedicatedServer )
			Effects[Effects.Length] = A;
	}
	else if ( Emitter(A) != None )  {
		//Client array
		if ( Level.NetMode != NM_DedicatedServer )
			Emitters[Emitters.Length] = A;
	}
	else if ( Gib(A) != None )  {
		//Client array
		if ( Level.NetMode != NM_DedicatedServer )
			Gibs[Gibs.Length] = A;
	}
	else if ( xEmitter(A) != None )  {
		//Client array
		if ( Level.NetMode != NM_DedicatedServer )
			xEmitters[xEmitters.Length] = A;
	}
	else if ( Inventory(A) != None )  {
		//Server array
		if ( Role == ROLE_Authority )
			Inventories[Inventories.Length] = A;
	}
	else if ( Pawn(A) != None )  {
		//Server array
		if ( Role == ROLE_Authority )
			Pawns[Pawns.Length] = A;
	}
	else if ( Pickup(A) != None )  {
		//Server array
		if ( Role == ROLE_Authority )
			Pickups[Pickups.Length] = A;
	}
	else if ( Projectile(A) != None )  {
		//Server array
		if ( Role == ROLE_Authority )
			Projectiles[Projectiles.Length] = A;
	}
	else
		Actors[Actors.Length] = A;
}

simulated function Clear()
{
	while ( Actors.Length > 0 )  {
		if ( Actors[Actors.Length - 1] != None )
			Actors[Actors.Length - 1].Destroy();
		Actors.Remove((Actors.Length - 1),1);
	}
	
	while ( Effects.Length > 0 )  {
		if ( Effects[Effects.Length - 1] != None )
			Effects[Effects.Length - 1].Destroy();
		Effects.Remove((Effects.Length - 1),1);
	}
	
	while ( Emitters.Length > 0 )  {
		if ( Emitters[Emitters.Length - 1] != None )
			Emitters[Emitters.Length - 1].Destroy();
		Emitters.Remove((Emitters.Length - 1),1);
	}
	
	while ( Gibs.Length > 0 )  {
		if ( Gibs[Gibs.Length - 1] != None )
			Gibs[Gibs.Length - 1].Destroy();
		Gibs.Remove((Gibs.Length - 1),1);
	}
	
	while ( Inventories.Length > 0 )  {
		if ( Inventories[Inventories.Length - 1] != None )
			Inventories[Inventories.Length - 1].Destroy();
		Inventories.Remove((Inventories.Length - 1),1);
	}
	
	while ( Pawns.Length > 0 )  {
		if ( Pawns[Pawns.Length - 1] != None )
			Pawns[Pawns.Length - 1].Destroy();
		Pawns.Remove((Pawns.Length - 1),1);
	}
	
	while ( Pickups.Length > 0 )  {
		if ( Pickups[Pickups.Length - 1] != None )
			Pickups[Pickups.Length - 1].Destroy();
		Pickups.Remove((Pickups.Length - 1),1);
	}
	
	while ( Projectiles.Length > 0 )  {
		if ( Projectiles[Projectiles.Length - 1] != None )
			Projectiles[Projectiles.Length - 1].Destroy();
		Projectiles.Remove((Projectiles.Length - 1),1);
	}
	
	while ( xEmitters.Length > 0 )  {
		if ( xEmitters[xEmitters.Length - 1] != None )
			xEmitters[xEmitters.Length - 1].Destroy();
		xEmitters.Remove((xEmitters.Length - 1),1);
	}
}

simulated event Destroyed()
{
	if ( Class'UM_AData'.default.ActorPool != None )
		Class'UM_AData'.default.ActorPool = None;
	Super.Destroyed();
}

//[end] Functions
//====================================================================


defaultproperties
{
     DrawType=DT_None
     LifeSpan=0.000000
	 bNetTemporary=False
	 bCanBeDamaged=False
	 bUnlit=True
	 bAlwaysRelevant=True
	 bGameRelevant=True
	 //RemoteRole=ROLE_None
	 RemoteRole=ROLE_SimulatedProxy
     bHidden=True
	 bHiddenEd=True
	 bSkipActorPropertyReplication=True
	 bCollideActors=False
	 bCollideWorld=False
	 bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bSmoothKarmaStateUpdates=False
     bBlockHitPointTraces=False
	 CollisionRadius=0.000000
     CollisionHeight=0.000000
     //ActorProbeFunctions
	 ActorProbeFunctions(0)="AnimEnd"
	 ActorProbeFunctions(1)="Attach"
	 ActorProbeFunctions(2)="BaseChange"
	 ActorProbeFunctions(3)="Bump"
	 ActorProbeFunctions(4)="Detach"
	 ActorProbeFunctions(5)="EncroachedBy"
	 ActorProbeFunctions(6)="EncroachingOn"
	 ActorProbeFunctions(7)="EndedRotation"
	 ActorProbeFunctions(8)="Falling"
	 ActorProbeFunctions(9)="GainedChild"
	 ActorProbeFunctions(10)="HitWall"
	 ActorProbeFunctions(11)="Landed"
	 ActorProbeFunctions(12)="LostChild"
	 ActorProbeFunctions(13)="PhysicsVolumeChange"
	 ActorProbeFunctions(14)="PostNetReceive"
	 ActorProbeFunctions(15)="PostTouch"
	 ActorProbeFunctions(16)="SpecialHandling"
	 ActorProbeFunctions(17)="Tick"
	 ActorProbeFunctions(18)="Timer"
	 ActorProbeFunctions(19)="Touch"
	 ActorProbeFunctions(20)="UnTouch"
}
