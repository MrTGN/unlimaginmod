class Whisky_DamTypeHammer extends UM_BaseDamType_Melee
	Abstract;


defaultproperties
{
     HeadShotDamageMult=1.200000
	 WeaponClass=Class'UnlimaginMod.Whisky_Hammer'
     DeathString="%k killed %o (Hammer)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bExtraMomentumZ=True
	 PawnDamageSounds(0)=Sound'KFPawnDamageSound.MeleeDamageSounds.axehitflesh'
	 KDamageImpulse=16000.000000
     KDeathVel=300.000000
     KDeathUpKick=220.000000
     VehicleDamageScaling=0.800000
}
