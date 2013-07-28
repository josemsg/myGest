CLEAR all
 
LOCAL ARRAY laPropertyValue[1]
LOCAL loManager, loDesktop, loDocument, loCursor
loManager = CREATEOBJECT( "com.sun.star.ServiceManager" )
loDesktop = loManager.createInstance( "com.sun.star.frame.Desktop" )
comarray( loDesktop, 10 )
 
loReflection = loManager.createInstance("com.sun.star.reflection.CoreReflection" )
comarray( loReflection, 10 )
 
laPropertyValue[1] = createStruct( @loReflection,"com.sun.star.beans.PropertyValue" )
laPropertyValue[1].NAME = "ReadOnlu"
laPropertyValue[1].VALUE = .T.
 
*!*
*!* Creamos un nuevo documento
*!*
 
loDocument = loDesktop.LoadComponentFromUrl( "private:factory/swriter","_blank", 0, @laPropertyValue )
comarray( loDocument, 10 )
loCursor        = loDocument.TEXT.CreateTextCursor()
 
*'Inserting some Text
loDocument.text.insertString(loCursor, "The first line in the newly created text document.", .f.)
 
*'Inserting a second line
loCursor.text.insertString(loCursor, "Now we're in the second line", .f.)
 
*'Create instance of a text table with 4 columns and 4 rows
objTable= loDocument.createInstance( "com.sun.star.text.TextTable")
objTable.initialize(4, 4)
 
*'Insert the table
loCursor.text.insertTextContent(loCursor, objTable, .f.)
 
*'Get first row
objRows= objTable.getRows
objRow= objRows.getByIndex( 0)
 
*'Set the table background color
objTable.setPropertyValue("BackTransparent", .f.)
objTable.setPropertyValue("BackColor", 13421823)
 
*'Set a different background color for the first row
objRow.setPropertyValue( "BackTransparent", .f.)
objRow.setPropertyValue( "BackColor", 6710932)
 
*'Fill the first table row
insertIntoCell ("A1","FirstColumn", objTable )
insertIntoCell ("B1","SecondColumn", objTable )
insertIntoCell ("C1","ThirdColumn", objTable )
insertIntoCell ("D1","SUM", objTable )
 
objTable.getCellByName("A2").setValue(22.5)
objTable.getCellByName("B2").setValue(5615.3)
objTable.getCellByName("C2").setValue(-2315.7)
objTable.getCellByName("D2").setFormula ("sum ")
 
objTable.getCellByName("A3").setValue(21.5)
objTable.getCellByName("B3").setValue(615.3)
objTable.getCellByName("C3").setValue(-315.7)
objTable.getCellByName("D3").setFormula ("=SUM(<A3:C3>)")
 
objTable.getCellByName("A4").setValue (121.5)
objTable.getCellByName("B4").setValue (-615.3)
objTable.getCellByName("C4").setValue (415.7)
objTable.getCellByName("D4").setFormula("sum ")
 
*'Change the CharColor and add a Shadow
loCursor.setPropertyValue ("CharColor", 255)
loCursor.setPropertyValue ("CharShadowed", .t.)
 
*'Create a paragraph break
*'The second argument is a com::sun::star::text::ControlCharacter::PARAGRAPH_BREAK constant
loCursor.text.insertControlCharacter (loCursor, 0 , .f.)
 
*'Inserting colored Text.
loDocument.text.insertString (loCursor, " This is a colored Text - blue with shadow" , .f.)
 
*'Create a paragraph break ( ControlCharacter::PARAGRAPH_BREAK).
loDocument.text.insertControlCharacter( loCursor, 0, .f.)
 
*'Create a TextFrame.
loDocumentFrame= loDocument.createInstance("com.sun.star.text.TextFrame")
 
*'Create a Size struct.
objSize= createStruct(@loReflection, "com.sun.star.awt.Size")
objSize.Width= 15000
objSize.Height= 400
loDocumentFrame.setSize( objSize)
 
*' TextContentAnchorType.AS_CHARACTER = 1
loDocumentFrame.setPropertyValue("AnchorType", 1)
 
*'insert the frame
loDocument.text.insertTextContent(loCursor, loDocumentFrame, .f.)
 
*'Get the text object of the frame
objFrameText= loDocumentFrame.getText
 
*'Create a cursor object
objFrameTextCursor= objFrameText.createTextCursor
 
*'Inserting some Text
objFrameText.insertString(objFrameTextCursor, "The first line in the newly created text frame.", .f.)
objFrameText.insertString(objFrameTextCursor, "With this second line the height of the frame raises.", .f.)
 
*'Create a paragraph break
*'The second argument is a com::sun::star::text::ControlCharacter::PARAGRAPH_BREAK constant
objFrameText.insertControlCharacter(loCursor, 0 , .f.)
 
*'Change the CharColor and add a Shadow
loCursor.setPropertyValue ("CharColor", 65536)
loCursor.setPropertyValue ("CharShadowed", .f.)
 
*'Insert another string
loDocument.text.insertString (loCursor, " That's all for now !!", .f.)
 
 
Function insertIntoCell( strCellName, strText, objTable)
   objCellText= objTable.getCellByName( strCellName)
   objCellCursor= objCellText.createTextCursor
   objCellCursor.setPropertyValue ("CharColor",16777215)
   objCellText.insertString(objCellCursor, strText, .f.)
EndProc
 
Function createStruct( toReflection, tcTypeName )
  local loPropertyValue, loTemp
  loPropertyValue = createobject( "relation" )
  toReflection.forName( tcTypeName).createobject(@loPropertyValue)
  return ( loPropertyValue )
endproc