CLEAR all
 
LOCAL ARRAY laPropertyValue[1]
LOCAL loManager, loDesktop, loDocument, loCursor
loManager = CREATEOBJECT( "com.sun.star.ServiceManager" )
loDesktop = loManager.createInstance( "com.sun.star.frame.Desktop" )
comarray( loDesktop, 10 )
 
loReflection = loManager.createInstance("com.sun.star.reflection.CoreReflection" )
 
comarray( loReflection, 10 )
laPropertyValue[1] = createStruct( @loReflection,"com.sun.star.beans.PropertyValue" )
laPropertyValue[1].NAME = "Hidden"
laPropertyValue[1].VALUE = .T.
 
*!*
*!* Creamos un nuevo documento
*!*
 
loDocument = loDesktop.LoadComponentFromUrl( "private:factory/swriter","_blank", 0, @laPropertyValue )
comarray( loDocument, 10 )
loCursor       = loDocument.TEXT.CreateTextCursor()
loDocument.TEXT.InsertString( loCursor, "Hola desde VFP" , .F. )
 
*!*
*!* Salvamos el documento
*!*
 
laPropertyValue[1] = createStruct( @loReflection,"com.sun.star.beans.PropertyValue" )
laPropertyValue[1].NAME  = "FilterName"
laPropertyValue[1].VALUE = "impress_pdf_Export"
laPropertyValue[1].NAME = "CompressionMode"
laPropertyValue[1].VALUE = 1
laPropertyValue[1].NAME = "Pages"
laPropertyValue[1].VALUE = "ALL"
 
*loDocument.storeToURL( "file:///c:/test.pdf", @laPropertyValue )
 loDocument.storeToURL( "test.pdf", @laPropertyValue )
*!*
*!* Terminamos la sesión en OpenOffice
*!*
 
loDocument.dispose()
 
loDesktop = .NULL.
loManager = .NULL.
loReflection = .NULL.
 
 
Function createStruct( toReflection, tcTypeName )
 
  local loPropertyValue, loTemp
  loPropertyValue = createobject( "relation" )
  toReflection.forName( tcTypeName).createobject(@loPropertyValue)
  return ( loPropertyValue )
 
endproc