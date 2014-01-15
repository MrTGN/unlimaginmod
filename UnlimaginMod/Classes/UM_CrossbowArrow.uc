//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_CrossbowArrow
//	Parent class:	 CrossbowArrow
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.11.2012 7:41
//================================================================================
class UM_CrossbowArrow extends CrossbowArrow;

#exec OBJ LOAD FILE=KFWeaponSound.uax

defaultproperties
{
     LifeSpan=120.000000
	 Mesh=Mesh'KFWeaponModels.XbowBolt'
}