//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_DamTypeV94SniperRifle extends UM_BaseDamType_SniperRifle
	Abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.OperationY_V94SniperRifle'
     DeathString="%k killed %o (V-94)."
     KDamageImpulse=11000.000000
     KDeathVel=360.000000
     KDeathUpKick=120.000000
}
