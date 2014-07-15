class UM_SRKFBuyMenuInvListBox extends KFBuyMenuInvListBox;


final function GUIBuyable FindMatchingBuyable( Class<Actor> A )
{
	local bool bArmor;
	local int i;

	bArmor = ( A == Class'Vest');
	
	for( i = 0; i < List.MyBuyables.Length; ++i )  {
		if ( List.MyBuyables[i] != None && (List.MyBuyables[i].ItemWeaponClass == A || (bArmor && List.MyBuyables[i].bIsVest)) )
			Return List.MyBuyables[i];
	}
	
	Return None;
}

defaultproperties
{
     DefaultListClass="UnlimaginMod.UM_SRKFBuyMenuInvList"
}
