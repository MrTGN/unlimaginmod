//=============================================================================
// The weight bar from the trader menu, modified by Marco.
//=============================================================================
class UM_SRWeightBar extends KFWeightBar;

function bool MyOnDraw(Canvas C)
{
	local int i;
	local float TextSizeX, TextSizeY, XScale, BoxScalar;

	CurX = WinLeft * C.ClipX;
	CurY = (WinTop + WinHeight / 2.5) * C.ClipY;

	// Background boxes
	C.SetPos(CurX, CurY);
	XScale = FMin(BoxSizeX*C.ClipX*MaxBoxes, WinWidth*C.ClipX);
	C.DrawTile(BarBack, XScale, BoxSizeY * C.ClipX, 0, 0, BarBack.MaterialUSize()*MaxBoxes, BarBack.MaterialVSize() );

	// Encumbrance String
	EncString = EncumbranceString$":" @ Eval(NewBoxes!=0,string(CurBoxes)$" (+"$string(NewBoxes)$")",string(CurBoxes)) $ "/" $ MaxBoxes;

	C.TextSize(EncString, TextSizeX, TextSizeY);
	C.SetPos(CurX, CurY-TextSizeY);
	C.DrawColor = CurrentColor;
	C.DrawText(EncString);

	// Our current weight
	C.SetPos(CurX,CurY);
	BoxScalar = XScale*FClamp(float(CurBoxes)/float(MaxBoxes),0.f,1.f);
	C.DrawTile(BarTop, BoxScalar, BoxSizeY * C.ClipX, 0, 0, BarTop.MaterialUSize()*Min(CurBoxes,MaxBoxes), BarTop.MaterialVSize() );

	// Draw weight of selected weapon
	if ( NewBoxes != 0 )
	{
		C.SetPos(CurX+BoxScalar,CurY);

		// Selected weapon is not to heavy to carry
		if ( CurBoxes + NewBoxes <= MaxBoxes )
		{
			C.DrawColor = NewColor;
			C.DrawTile(BarTop, XScale*(float(NewBoxes)/float(MaxBoxes)), BoxSizeY * C.ClipX, 0, 0, BarTop.MaterialUSize()*NewBoxes, BarTop.MaterialVSize() );
		}
		// Selected weapon is too heavy
		else if( CurBoxes<MaxBoxes )
		{
			i = MaxBoxes-CurBoxes;
			C.DrawColor = WarnColor;
			C.DrawTile(BarTop, XScale*(float(i)/float(MaxBoxes)), BoxSizeY * C.ClipX, 0, 0, BarTop.MaterialUSize()*i, BarTop.MaterialVSize() );
		}
	}
	return false;
}

defaultproperties
{
}
