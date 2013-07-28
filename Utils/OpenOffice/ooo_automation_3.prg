*###################################*

*                                   *

**** EJEMPLO 1 STAROFFICE WRITER ****

*                                   *

*###################################*

SET STEP ON 

LOCAL ARRAY laPropertyValue[1]

LOCAL loManager, loDesktop, loDocument, loCursor, PaginaPre, EstilosPagina, FormaObjetoGrafico



loManager = CREATEOBJECT( "com.sun.star.ServiceManager" )

loDesktop = loManager.createInstance( "com.sun.star.frame.Desktop" )

comarray( loDesktop, 10 )



loReflection = loManager.createInstance("com.sun.star.reflection.CoreReflection" )

comarray( loReflection, 10 )

 

laPropertyValue[1] = createStruct( @loReflection,"com.sun.star.beans.PropertyValue" )

laPropertyValue[1].NAME = "ReadOnly"

laPropertyValue[1].VALUE = .F.

loDocument = loDesktop.LoadComponentFromUrl( "STAROFFICE.factory:swriter","_blank", 0, @laPropertyValue )

comarray( loDocument, 10 )



loCursor= loDocument.TEXT.CreateTextCursor()

loDocument.text.insertString(loCursor, "Esta es la primera linea del texto.", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

loCursor.text.insertString(loCursor, "Esta es la segunda linea", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



Tabla= loDocument.createInstance( "com.sun.star.text.TextTable")

Tabla.initialize(4, 4)

loCursor.text.insertTextContent(loCursor, Tabla, .f.)



objRows= Tabla.getRows

ColumnaT= objRows.getByIndex( 0)

Tabla.setPropertyValue("BackTransparent", .f.)

Tabla.setPropertyValue("BackColor", 13421823)



ColumnaT.setPropertyValue( "BackTransparent", .f.)

ColumnaT.setPropertyValue( "BackColor", 6710932)



insertIntoCell ("A1","FirstColumn", Tabla )

insertIntoCell ("B1","SecondColumn", Tabla )

insertIntoCell ("C1","ThirdColumn", Tabla )

insertIntoCell ("D1","SUM", Tabla )



var1=2

var2=48

var3=4



Tabla.getCellByName("A2").setValue(var1)

Tabla.getCellByName("B2").setValue(var2)

Tabla.getCellByName("C2").setValue(var3)

Tabla.getCellByName("D2").setFormula ((var1*var2)/var3)

Tabla.getCellByName("A3").setValue(21.5)

Tabla.getCellByName("B3").setValue(615.3)

Tabla.getCellByName("C3").setValue(-315.7)

Tabla.getCellByName("D3").setFormula ("sum ")

Tabla.getCellByName("A4").setValue (121.5)

Tabla.getCellByName("B4").setValue (-615.3)

Tabla.getCellByName("C4").setValue (415.7)

Tabla.getCellByName("D4").setPropertyValue( "BackColor", 16700000)

Tabla.getCellByName("D4").setFormula("sum")



loCursor.setPropertyValue ("CharColor", 255)

loCursor.text.insertControlCharacter (loCursor, 0 , .f.)

loDocument.text.insertString (loCursor, " Texto de Color" , .f.)

loCursor.setPropertyValue ("CharShadowed", .t.)

loDocument.text.insertString (loCursor, " - texto con sombra" , .f.)

loCursor.setPropertyValue ("CharShadowed", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loDocumentFrame= loDocument.createInstance("com.sun.star.text.TextFrame")



objSize= createStruct(@loReflection, "com.sun.star.awt.Size")

objSize.Width= 15000

objSize.Height= 400

loDocumentFrame.setSize( objSize)

loDocumentFrame.setPropertyValue("AnchorType", 1)

loDocument.text.insertTextContent(loCursor, loDocumentFrame, .f.)



objFrameText= loDocumentFrame.getText

objFrameTextCursor= objFrameText.createTextCursor

objFrameTextCursor.setPropertyValue ("CharHeight", 10)

objFrameText.insertString(objFrameTextCursor, "Primera linea dentro del marco.", .f.)

objFrameText.insertControlCharacter(objFrameTextCursor, 0, .f.)

objFrameText.insertString(objFrameTextCursor, "Otra linea dentro del marco.", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

 

loCursor.setPropertyValue ("CharColor", 65536)

loCursor.setPropertyValue ("CharFontName", 'Arial')

loDocument.text.insertString (loCursor, "Cambio de letra a Arial", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)





loCursor.setPropertyValue ("CharWeight", 150)

loCursor.text.insertString(loCursor, "Negritas ", .f.)

loCursor.setPropertyValue ("CharWeight", 100)

loCursor.setPropertyValue ("CharPosture", 50)

loCursor.text.insertString(loCursor, "Cursiva ", .f.)

loCursor.setPropertyValue ("CharPosture", 0)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loDocument.text.insertString (loCursor, "Texto Normal" ,.f.)

loCursor.setPropertyValue ("CharEscapement", 65)

loCursor.setPropertyValue ("CharHeight", 5)

loDocument.text.insertString (loCursor, " Superíndice" ,.f.)

loCursor.setPropertyValue ("CharEscapement", 0)

loCursor.setPropertyValue ("CharHeight", 10)

loDocument.text.insertString (loCursor, "  Texto Normal" ,.f.)

loCursor.setPropertyValue ("CharHeight", 5)

loCursor.setPropertyValue ("CharEscapement", -35)

loDocument.text.insertString (loCursor, " Subíndice" ,.f.)

loCursor.setPropertyValue ("CharEscapement", 0)

loCursor.setPropertyValue ("CharHeight", 10)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("CharUnderline", 1)

loDocument.text.insertString (loCursor, "Subrayado" ,.f.)

loCursor.setPropertyValue ("CharUnderline", 0)

loCursor.setPropertyValue ("CharFlash", .t.)

loDocument.text.insertString (loCursor, " Parpadeando" ,.f.)

loCursor.setPropertyValue ("CharFlash", .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("CharHeight", 8)

loCursor.setPropertyValue ("CharFontName", 'Arial Black')

loCursor.setPropertyValue ("CharColor", 14500)

loDocument.text.insertString (loCursor, "Color 1,4500" ,.f.)

loCursor.setPropertyValue ("CharColor", 18500)

loDocument.text.insertString (loCursor, CHR(9)+"Color 18,500" ,.f.)

loCursor.setPropertyValue ("CharColor", 20500)

loDocument.text.insertString (loCursor, CHR(9)+"Color 20,500" ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("ParaAdjust", 3)

loDocument.text.insertString (loCursor, "Color 13,459,998 AAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBB" ;

+" CCCCCC DDDDDD EEEEEEE F F F FFFF GGGGGGG HHHH" ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("ParaAdjust", 0)

loDocument.text.insertString (loCursor, "Color 16,711,680 AAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBB" ;

+" CCCCCC DDDDDD EEEEEEE F F F FFFF GGGGGGG HHHH" ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("ParaAdjust", 2)

loCursor.setPropertyValue ("CharColor", 9603696)

loDocument.text.insertString (loCursor, "Color 9,603,696 AAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBB" ;

+" CCCCCC DDDDDD EEEEEEE F F F FFFF GGGGGGG HHHH" ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("ParaAdjust", 1)

loCursor.setPropertyValue ("CharColor", 8355711)

loDocument.text.insertString (loCursor, "Color 8,355,711 AAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBB" ;

+" CCCCCC DDDDDD EEEEEEE F F F FFFF GGGGGGG HHHH" ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)



loCursor.setPropertyValue ("CharColor", RGB(0,0,255))

loDocument.text.insertString (loCursor, "Color 8,355,711 AAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBB" ;

+" CCCCCC DDDDDD EEEEEEE F F F FFFF GGGGGGG HHHH " ,.f.)

loDocument.text.insertControlCharacter( loCursor, 0, .f.)







or_url="file:///c:/test.sxw"

laPropertyValue[1].NAME= "Overwrite"

laPropertyValue[1].VALUE= .T.

loDocument.storeAsURL( or_url, @laPropertyValue )





*#################################*

*                                 *

**** EJEMPLO 2 STAROFFICE CALC ****

*                                 *

*#################################*



LOCAL ARRAY laNoArgs[1]

LOCAL oSManager, oSDesktop, oStarDoc, oCursor, oSheet, PaginaPredeterminada, EstilosDePagina, Hoja2, oColuna

STORE "file:///c:/test.sxc" TO ne_url



oSManager = CREATEOBJECT("Com.Sun.Star.ServiceManager.1")

oSDesktop = oSManager.createInstance("com.sun.star.frame.Desktop")

COMARRAY(oSDesktop, 10)

loReflection = oSManager.createInstance("com.sun.star.reflection.CoreReflection" )

COMARRAY( loReflection, 10 )



laNoArgs[1]= createStruct( @loReflection,"com.sun.star.beans.PropertyValue" )

laNoArgs[1].NAME = "ReadOnly"

laNoArgs[1].VALUE = .F.

or_url = "file:///c:/file.sxc" && debera existir este archivo antes de correr el ejemplo.

ne_url = "file:///c:/test.xls"



oStarDoc = oSDesktop.loadComponentFromURL(or_url,"_blank", 0, @laNoArgs)

comarray( oStarDoc, 10 )



EstilosDePagina = oStarDoc.StyleFamilies.getByName("PageStyles")

PaginaPredeterminada = EstilosDePagina.getByName("Default")



WITH PaginaPredeterminada 

	.setPropertyValue("LeftMargin" , 1500)

	.setPropertyValue("RightMargin" , 1500)

	.setPropertyValue("TopMargin" , 2500)

	.setPropertyValue("BottomMargin" , 2500)

	.setPropertyValue("Width" , 35570)

	.setPropertyValue("Height" , 21590)

	.setPropertyValue("IsLandscape", .t.)

ENDWITH



oSheet = oStarDoc.getSheets().getByIndex( 0 )

Fila2 = oSheet.getRows().getByIndex(7)

Fila2.Height=2500

oColuna = oSheet.getColumns().getByIndex(0)

oColuna.Width = 1500

var2=48.6214879



WITH oSheet

	.getCellByPosition( 0, 0 ).SETSTRING("Mes")

	.getCellByPosition( 1, 0 ).SETSTRING("Ventas")

	.getCellByPosition( 0, 1 ).SETSTRING("Enero")

	.getCellByPosition( 0, 2 ).SETSTRING("Febrero")

	.getCellByPosition( 0, 3 ).SETSTRING("Marzo")

	.getCellByPosition( 0, 4 ).SETSTRING("Abril")

	.getCellByPosition( 0, 5 ).SETSTRING("Mayo")

	.getCellByPosition( 0, 6 ).SETSTRING("Junio")

	.getCellByPosition( 0, 7 ).SETSTRING("TOTAL")	

	.getCellByPosition( 1, 1 ).setValue(3826)

	.getCellByPosition( 1, 2 ).setValue(3504)

	.getCellByPosition( 1, 3 ).setValue(2961)

	.getCellByPosition( 1, 4 ).setValue(2504)

	.getCellByPosition( 1, 5 ).setValue(23400.352356)

	.getCellByPosition( 1, 6 ).setValue(VAR2)

	.getCellByPosition( 1, 7 ).SETFormula("=B2+B3+B4+B5+B6+B7")

ENDWITH

WITH oSheet.getCellByPosition(1,7)

	.setPropertyValue("CellBackColor", RGB(152,0,0))

	.setPropertyValue("CharWeight", 150)

	.setPropertyValue("CharUnderline", 1)

	.setPropertyValue("ParaAdjust", 3)

ENDWITH

	

Hoja2= oStarDoc.getSheets().getByName("Hoja2")	

Hoja2.getCellByPosition(0, 0).SETSTRING("Texto en la Segunda Hoja")



oFormat = oStarDoc.NumberFormats

WITH Hoja2

	.getCellRangeByName("A2:A10").NumberFormat =NumberFormat(@loReflection, oFormat, "0,00") && Number

	.getCellRangeByName("B1:B10").NumberFormat =NumberFormat(@loReflection, oFormat, "MM/DD/AAAA") && Date 

	.getCellRangeByName("C1:C10").NumberFormat =NumberFormat(@loReflection, oFormat, "#.###,00") 

ENDWITH

	

laNoArgs[1].NAME  = "Overwrite"

laNoArgs[1].VALUE = .t.

laNoArgs[1].NAME  = "FilterName"

laNoArgs[1].VALUE = "MS Excel 97"

oStarDoc.storeAsURL( ne_url, @laNoArgs)





**** FUNCIONES ****





Function createStruct( toReflection, tcTypeName )



	local loPropertyValue, loTemp

	loPropertyValue = createobject( "relation" )

	toReflection.forName( tcTypeName).createobject(@loPropertyValue)

	return ( loPropertyValue )



endproc



Function insertIntoCell( strCellName, strText, objTable)



   objCellText= objTable.getCellByName( strCellName)

   objCellCursor= objCellText.createTextCursor

   objCellCursor.setPropertyValue ("CharColor",16777215)

   objCellText.insertString(objCellCursor, strText, .f.)



EndProc



Function NumberFormat()

Lparameters loReflection, _format, _mascara

Local a_lang, v_key

Private a_lang



a_lang = Createstruct(@loReflection,"com.sun.star.lang.Locale")



a_lang.Language = "es"

a_lang.Country = "Mx"

a_lang.Variant = ""



v_key = _format.queryKey(_mascara, @a_lang, .T.)



If v_key = -1

	v_key = _format.addNew(_mascara, @a_lang)

EndIf



Return v_key