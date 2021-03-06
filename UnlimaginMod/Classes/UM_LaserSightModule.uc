//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_LaserSightModule
//	Parent class:	 UM_BaseTacticalModule
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 16.01.2014 22:01
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_LaserSightModule extends UM_BaseTacticalModule;


//========================================================================
//[block] Variables

// ToDo: ��� ��跫� �褞褞珮��瑣� � �褞襃頌瑣� �褞褌褊���, ��鈕瑣� �粽� ��瑰��.
// ﾑ�珞�頸��� ��� 蒡�跫�, ������, ������ �� �瑟�� ��韃���, � �� �褞粢�� ���裲�� �� ��跫�.
var         LaserDot                    Spot;                       // The first person laser site dot
var			Class<LaserDot>				SpotEffectClass;
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location

// ToDo: ��� ��跫� �碣瑣�, 鞦� � �褊� 褥�� �粽� ��瑰� 蓁� �珸褞� �� 3-胛 �頽�.
var         LaserBeamEffect             Beam;                       // Third person laser beam effect
var			Class<LaserBeamEffect>		BeamEffectClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================


defaultproperties
{
}
