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

	// �������� ���� �������� �� ���� ��� (�������� �� ���� ����)
	bt.Roll = BarrelTurn;
	// ������� "�����" Barrels �� ��������� ���� ��������
	SetBoneRotation('Barrels', bt);
	// �������� ��������, �.�. ����� �����������
	
	Super.WeaponTick(dt);
}

simulated event Tick(float dt)
{
	local	float	OldBarrelTurn;

	Super.Tick(dt);
	
	if ( FireMode[0].IsFiring() || FireMode[1].IsFiring() )
	{
		// ����� ������ ��� �������� �� ����� ����� �����
		// BarrelSpeed - ��� �������� �������� ������ 
		// FClamp( float V, float A, float B ) ������������ �������� V, ���� ��� ����� A � B
		// ���� �������� ������, ����������� B, ���� ������, ������������ A, �.�. ���
		// �����������, ����������� ���������  �� (-0.20 * dt) ��� ��������
		// �������� �������� ������ �� (0.40 * dt)
		// ������-�� A ����� � �������������, �� ����������� ��������� �����
		// DesiredSpeed - BarrelSpeed - ��� ��� ��� � ������������ ��������� ����� ��� ��������
		// �.�., ���� ������� ���������� �������������, �� ����� ����� �������� � ��������� "A" 
		// �������, ���� �������������, �� ������� � ���������� "B" �������.
		BarrelSpeed = BarrelSpeed + FClamp(DesiredSpeed - BarrelSpeed, -0.20 * dt, 0.40 * dt);
		//��� ������ ���� �������� ��� ���������� �����, ���� � ��������� �������
		// ����� BarrelSpeed �������� �������� ������ ���������� �� ���� 655360 UU (Unreal Units)
		// ������ ������ ��, ��� 360�� = 65536 UU. �.�. ����� 10 * 360��, �.�. 3600��, �.�. 10 ��������.
		// �������� ��� ������������ ���, ��� BarrelSpeed - ��� ������� ����� � dt,
		// �.�. DeltaTime ������� �����.
		// �� ����, DeltaTime = 1 ��� / ���������� ������ � �������. � ��� ������������ ��������,
		// ��� ��� �������� � ���������� ������ � ��������.
		BarrelTurn += int(BarrelSpeed * float(655360) * dt);
	}
	else
	{
		// ����� ������ �� �������� �� ����� ����� ���� (�����)
		// ���� �������� ��������  ������ ������ 0 �� float (0,000000), �.�. ����� ���������, 
		// �� ����������� ������� ����
		if ( BarrelSpeed > 0.000000 )
		{
			// ������������� �������� ��������
			// FMax( float A, float B ) - ���������� ������������ �� ���� ��������� ��������
			BarrelSpeed = FMax(BarrelSpeed - 0.10 * dt, 0.01);
			// ������������ ���������� ���� ���������
			OldBarrelTurn = float(BarrelTurn);
			// ������ ���� �������� ��� ���������� �����
			BarrelTurn += int(BarrelSpeed * float(655360) * dt);
			// ���� �������� �������� ������ ��� ����� 0.03 �
			// ���������� ���� �������� / 10922.67 � ����� ����� ������, ���
			// ���������, �.�. ������� ���� ��������, / 10922.67
			// �.�. ����� ����������� ���������� �� ������ ���������
			// �� ����������� ��� �������
			if ( BarrelSpeed <= 0.03 && (int(OldBarrelTurn / 10922.67) < int(float(BarrelTurn) / 10922.67)) )
			{
				// ��� ����� ���������� � ����
				// � ������ ���� �������� ����� �� 10922.67, ����� ��������� �� ������ �����
				// ����� �������� �� 10922.67 � ����� ��������� �� ������ �����
				BarrelTurn = int(float(int(float(BarrelTurn) / 10922.67)) * 10922.67);
				// �������� �������� ��������������� � 0.00
				BarrelSpeed = 0.00;
				// ���������� AmbientSound ����������, ���� �� �������������� ���� ��������
				// ������, �.�. �������.
				if ( AmbientSound != None )
					AmbientSound = None;
				// ������������� ���� ��������� �������� ������
				// PlaySound(Sound, Slot, Volume, bNoOverride, Radius, Pitch, Attenuate)
				// Attenuate - ���������, �.�. ���� ���������� ���������� ����
				PlayOwnedSound(BarrelStopSound, SLOT_None, 1.0,, SoundRadius, 1.00, true);
			}
		}
	}
	
	// ���� ����� ���������, �.�. ������� �������� ������ 0.000000,
	// �� ������� �����������
	if ( BarrelSpeed > 0.000000 )
	{
		// ����� ����������� ��������������� ������� ���� �������� ������
		if ( AmbientSound == None )
			AmbientSound = BarrelSpinSound;
		// ��� ����������� ���, �.�. ������� ���������� � �������� ������������ �����.
		SoundPitch = byte(float(32) + float(96) * BarrelSpeed);
	}
	
	// ���� ��� �� 3-�� ����
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
