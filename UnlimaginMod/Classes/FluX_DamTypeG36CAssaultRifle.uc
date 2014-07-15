//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// G36C Damage Type class
// Made by FluX
// http://www.fluxiserver.co.uk
//===================================================================================
class FluX_DamTypeG36CAssaultRifle extends UM_BaseDamType_AssaultRifle
	Abstract;

defaultproperties
{
	 WeaponClass=Class'UnlimaginMod.FluX_G36CAssaultRifle'
     DeathString="%k killed %o (G36C)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=1800.000000
     KDeathVel=130.000000
     KDeathUpKick=6.000000
}
