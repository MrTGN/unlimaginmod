//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_AA12MedGasBulletDecal
//	Parent class:	 ProjectedDecal
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.11.2012 23:59
//================================================================================
class UM_AA12MedGasBulletDecal extends ProjectedDecal;

#exec OBJ LOAD File=kf_fx_trip_t.utx

simulated event BeginPlay()
{
    if ( !Level.bDropDetail && (FRand() < 0.5) )
        ProjTexture = Texture'kf_fx_trip_t.Misc.MedicNade_Stain';
    Super.BeginPlay();
}

defaultproperties
{
     ProjTexture=Texture'kf_fx_trip_t.Misc.MedicNade_Stain'
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=3.500000
     DrawScale=0.300000
}
