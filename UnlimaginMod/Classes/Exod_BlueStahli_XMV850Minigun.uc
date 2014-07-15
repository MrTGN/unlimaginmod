//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//--------------------------------------------------
//Weapon import by Exod and sourcecode help by Ripza
//--------------------------------------------------
class Exod_BlueStahli_XMV850Minigun extends UM_BaseMachineGun
	config(user);

#exec OBJ LOAD FILE=XMV850_A.ukx
#exec OBJ LOAD FILE=XMV850_Snd.uax
#exec OBJ LOAD FILE=XMV850_SM.usx
#exec OBJ LOAD FILE=XMV850_T.utx
#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax
//#exec OBJ LOAD FILE=XMV850S.uax

var		float		DesiredSpeed;
var		float		BarrelSpeed;
var		int			BarrelTurn;

//[block] Dynamic Loading Vars
var		string		BarrelSpinSoundRef;
var		string		BarrelStopSoundRef;
var		string		BarrelStartSoundRef;
//[end]
var()	Sound		BarrelSpinSound;
var()	Sound		BarrelStopSound;
var()	Sound		BarrelStartSound;

//[block] Dynamic Loading
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super.PreloadAssets(Inv, bSkipRefCount);
	
	if ( default.BarrelSpinSoundRef != "" && default.BarrelSpinSound == None )
		default.BarrelSpinSound = sound(DynamicLoadObject(default.BarrelSpinSoundRef, class'sound'));
	
	if ( default.BarrelStopSoundRef != "" && default.BarrelStopSound == None )
		default.BarrelStopSound = sound(DynamicLoadObject(default.BarrelStopSoundRef, class'sound'));
	
	if ( default.BarrelStartSoundRef != "" && default.BarrelStartSound == None )
		default.BarrelStartSound = sound(DynamicLoadObject(default.BarrelStartSoundRef, class'sound'));
	
	if ( Exod_BlueStahli_XMV850Minigun(Inv) != None )
	{
		if ( default.BarrelSpinSound != None && Exod_BlueStahli_XMV850Minigun(Inv).BarrelSpinSound == None )
			Exod_BlueStahli_XMV850Minigun(Inv).BarrelSpinSound = default.BarrelSpinSound;
		
		if ( default.BarrelStopSound != None && Exod_BlueStahli_XMV850Minigun(Inv).BarrelStopSound == None )
			Exod_BlueStahli_XMV850Minigun(Inv).BarrelStopSound = default.BarrelStopSound;
		
		if ( default.BarrelStartSound != None && Exod_BlueStahli_XMV850Minigun(Inv).BarrelStartSound == None )
			Exod_BlueStahli_XMV850Minigun(Inv).BarrelStartSound = default.BarrelStartSound;
	}
}

static function bool UnloadAssets()
{
	if ( default.BarrelSpinSound != None )
		default.BarrelSpinSound = None;
		
	if ( default.BarrelStopSound != None )
		default.BarrelStopSound = None;
	
	if ( default.BarrelStartSound != None )
		default.BarrelStartSound = None;

	Return Super.UnloadAssets();
}
//[end]

simulated event WeaponTick(float dt)
{
	local Rotator bt;

	// Значение угла поворота за один тик (примерно за один кадр)
	bt.Roll = BarrelTurn;
	// Поворот "кости" Barrels на указанное выше значение
	SetBoneRotation('Barrels', bt);
	// Желаемая скорость, т.е. некое ограничение
	
	Super.WeaponTick(dt);
}

simulated event Tick(float dt)
{
	local	float	OldBarrelTurn;

	Super.Tick(dt);
	
	if ( FireMode[0].IsFiring() || FireMode[1].IsFiring() )
	{
		// Здесь оружие уже стреляет во время этого кадра
		// BarrelSpeed - это скорость вращения ствола 
		// FClamp( float V, float A, float B ) возвращается значение V, если оно между A и B
		// если значение больше, возращается B, если меньше, возвращается A, т.е. это
		// ограничение, позволяющие замедлять  на (-0.20 * dt) или ускорять
		// скорость вращения ствола на (0.40 * dt)
		// потому-то A здесь и отрицательное, он позволяется замедлять ствол
		// DesiredSpeed - BarrelSpeed - как раз тут и определяется замедлять ствол или ускорять
		// т.е., если значние получается отрицательное, то ствол будет замедлен в указанном "A" 
		// приделе, если положительное, то ускорен в указаанном "B" приделе.
		BarrelSpeed = BarrelSpeed + FClamp(DesiredSpeed - BarrelSpeed, -0.20 * dt, 0.40 * dt);
		//Это расчет угла поворота для следующего кадра, если я правильно понимаю
		// Здесь BarrelSpeed скорость вращения ствола умножается на угол 655360 UU (Unreal Units)
		// страно только то, что 360гр = 65536 UU. Т.е. здесь 10 * 360гр, т.е. 3600гр, т.е. 10 оборотов.
		// Возможно это обусловленно тем, что BarrelSpeed - это дробное число и dt,
		// т.е. DeltaTime дробное число.
		// По идее, DeltaTime = 1 сек / количество кадров в секунду. И оно переодически меняется,
		// так как меняется и количество кадров в секунуду.
		BarrelTurn += int(BarrelSpeed * float(655360) * dt);
	}
	else
	{
		// Здесь оружие не стреляет во время этого тика (кадра)
		// если скорость вращения  ствола больше 0 во float (0,000000), т.е. ствол вращается, 
		// то выполняется условие ниже
		if ( BarrelSpeed > 0.000000 )
		{
			// Высчитывается скорость вращения
			// FMax( float A, float B ) - возвращает максимальное из двух указанных значений
			BarrelSpeed = FMax(BarrelSpeed - 0.10 * dt, 0.01);
			// Запоминается предыдущий угол повортора
			OldBarrelTurn = float(BarrelTurn);
			// Расчет угла поворота для следующего кадра
			BarrelTurn += int(BarrelSpeed * float(655360) * dt);
			// Если скорость вращения меньше или равна 0.03 и
			// предыдущий угол поворота / 10922.67 в целом числе меньше, чем
			// следующий, т.е. будущий угол поворота, / 10922.67
			// т.е. ствол практически замедлился до полной остановки
			// то выполняется это условие
			if ( BarrelSpeed <= 0.03 && (int(OldBarrelTurn / 10922.67) < int(float(BarrelTurn) / 10922.67)) )
			{
				// тут некое приведение к нулю
				// с начала угол поворота делят на 10922.67, потом округляют до целого числа
				// потом умножают на 10922.67 и опять округляют до целого числа
				BarrelTurn = int(float(int(float(BarrelTurn) / 10922.67)) * 10922.67);
				// Скорость вращение устанавливается в 0.00
				BarrelSpeed = 0.00;
				// Отчищается AmbientSound переменная, дабы не вопроизводился звук вращения
				// ствола, т.е. привода.
				if ( AmbientSound != None )
					AmbientSound = None;
				// Проигрывается звук остановки вращения ствола
				// PlaySound(Sound, Slot, Volume, bNoOverride, Radius, Pitch, Attenuate)
				// Attenuate - ослоблять, т.е. звук постепенно становится тише
				PlayOwnedSound(BarrelStopSound, SLOT_None, 1.0,, SoundRadius, 1.00, true);
			}
		}
	}
	
	// Если ствол вращается, т.е. скрость вращения больше 0.000000,
	// то условие выполняется
	if ( BarrelSpeed > 0.000000 )
	{
		// Здесь указывается воспроизводимый актором звук вращения ствола
		if ( AmbientSound == None )
			AmbientSound = BarrelSpinSound;
		// тут указывается тон, т.е. частота повторения и скорость вроигрывания звука.
		SoundPitch = byte(float(32) + float(96) * BarrelSpeed);
	}
	
	// Если вид от 3-го лица
	if ( ThirdPersonActor != None )
		Exod_BlueStahli_XMV850Attachment(ThirdPersonActor).BarrelSpeed = BarrelSpeed;
}

simulated function HandleSleeveSwapping();

simulated function bool PutDown()
{
	if ( AmbientSound != None )
		AmbientSound = None;
	
	if ( BarrelSpeed > 0.03 )
	{
		BarrelSpeed = 0.00;
		PlayOwnedSound(BarrelStopSound, SLOT_None, 1.0,, SoundRadius, 1.00, true);
		BarrelTurn = int( float( int( float(BarrelTurn) / 10922.67 ) ) * 10922.67 );
	}
	
	Return Super.PutDown();
}


defaultproperties
{
	 //[block] Dynamic Loading vars
	 //BarrelSpinSound=Sound'XMV850S.XMV-BarrelSpinLoop'
	 //BarrelSpinSoundRef="XMV850S.XMV-BarrelSpinLoop"
	 BarrelSpinSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_BarrelSpinLoop_M"
	 //BarrelSpinSoundRef="KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop"
     
	 //BarrelStopSound=Sound'XMV850S.XMV-BarrelSpinEnd'
	 //BarrelStopSoundRef="XMV850S.XMV-BarrelSpinEnd"
	 BarrelStopSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_BarrelStop_M"
	 //BarrelStopSoundRef="KF_BasePatriarch.Attack.Kev_MG_TurbineWindDown"
	 
     //BarrelStartSound=Sound'XMV850S.XMV-BarrelSpinStart'
	 //BarrelStartSoundRef="XMV850S.XMV-BarrelSpinStart"
	 BarrelStartSoundRef="UnlimaginMod_Snd.XMV850_MG.XMV850_BarrelStart_M"
	 //BarrelStartSoundRef="KF_BasePatriarch.Attack.Kev_MG_TurbineWindUp"
	 
	 MeshRef="XMV850_A.XMV-850Minigun"
     SkinRefs(0)="XMV850_T.Special.XMV850_Main"
     SkinRefs(1)="XMV850_T.Special.Hands-Shiny"
     SkinRefs(2)="XMV850_T.Special.XMV850_Barrels_SD"
     SelectSoundRef="XMV850_Snd.XMV-PullOut"
     HudImageRef="XMV850_T.Special.XMV_unselected"
     SelectedHudImageRef="XMV850_T.Special.XMV"
	 //[end]
	 //DesiredSpeed=0.500000
	 SoundRadius=200.000000
	 DesiredSpeed=0.520000
     MagCapacity=160
     ReloadRate=4.650000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload"
     Weight=14.000000
     IdleAimAnim="Idle"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     SleeveNum=7
     TraderInfoTexture=Texture'XMV850_T.Special.Trader_XMV850'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=20.000000
     FireModeClass(0)=Class'UnlimaginMod.Exod_BlueStahli_XMV850Fire'
     FireModeClass(1)=Class'UnlimaginMod.UM_XMV850AltNoFire'
     PutDownAnim="Putaway"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Shut up and kill'em."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=15
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=7
     PickupClass=Class'UnlimaginMod.Exod_BlueStahli_XMV850Pickup'
     PlayerViewOffset=(X=30.000000,Y=19.000000,Z=-25.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Exod_BlueStahli_XMV850Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="XMV850 Minigun"
     TransientSoundVolume=2.000000
	 TransientSoundRadius=300.000000
}
