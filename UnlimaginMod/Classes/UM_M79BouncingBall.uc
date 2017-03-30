//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M79BouncingBall
//	Parent class:	 UM_BaseProjectile_BouncingBall
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.08.2013 05:59
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M79BouncingBall extends UM_BaseProjectile_BouncingBall;

state NoEnergy
{
	function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
	{
		local	Inventory	Inv;
		
		if ( Pawn(A) != None && Pawn(A) == Instigator && Pawn(A).Inventory != None )  {
			for ( Inv = Pawn(A).Inventory; Inv != None; Inv = Inv.Inventory )  {
				if ( Inv.Class == Class'M79GrenadeLauncher' && M79GrenadeLauncher(Inv).AmmoAmount(0) < M79GrenadeLauncher(Inv).MaxAmmo(0) )  {
					M79GrenadeLauncher(Inv).AddAmmo(1,0);
					if ( PickupSound.Snd != None )
						PlaySound(PickupSound.Snd, PickupSound.Slot, PickupSound.Vol, PickupSound.bNoOverride, PickupSound.Radius, BaseActor.static.GetRandPitch(PickupSound.PitchRange), PickupSound.bUse3D);
					Break;
				}
			}
			Destroy();
		}
	}
}

defaultproperties
{
     Damage=350.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM79BouncingBall'
	 //Trail=(xEmitterClass=Class'KFMod.NailGunTracer')
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",Slot=SLOT_Pain,Vol=2.2,Radius=400.0,PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
}
