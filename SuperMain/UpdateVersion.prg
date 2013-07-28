DEFINE CLASS UpdateVersion AS CUSTOM

PROTECTED cMyBinVersion  AS STRING   && STRING con la versión del bin actual (myBin)
PROTECTED cNewBinVersion AS STRING   && STRING con la versión del nuevo bin (newBin)
PROTECTED dNewBinDate    AS DATE     && fecha de actualización del nuevo bin
PROTECTED nStatusUpdate  AS INTEGER  && estado de la actualización (0=NORMAL, 1=crítica)

cMyBinFileName  = ""    && nombre del archivo que buscaremos actualizar, ej: MAIN.bin
cXMLinfoUpdate  = ""    && nombre del archivo XML con información de la nueva versión
cNewBinURL      = ""    && URL del archivo a descargar, 
                        && ej: http://miservidor/downloads/MAIN.bin
cXMLinfoURL     = ""    && URL del archivo XML con INFO sobre la nueva versión a descargar, 
                        && ej: http://miservidor/downloads/udMain.XML
cURLhistoryInfo = ""    && URL con el historial de cambios del archivo MAIN

PROCEDURE INIT
  THIS.cMyBinVersion  = ""
  THIS.cNewBinVersion = ""
  THIS.dNewBinDate    = {}
  THIS.cNewBinURL     = ""
  THIS.nStatusUpdate  = 0
  SET SAFETY OFF
  SET TALK OFF
ENDPROC

*[ descargamos a nuestro disco del archivo XML
*[ con la información del bin para actualizar
*[ de esta manera minimizamos el tráfico y solo 
*[ descargamos el nuevo bin solo si es necesario
FUNCTION getUpdateInfo() AS Boolean
  LOCAL llRet
  LOCAL loXMLHTTP AS "MSXML2.XMLHTTP"
    loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
  llRet = .T.

  TRY
    loXMLHTTP.OPEN("GET", THIS.cXMLinfoURL, .F.)
    loXMLHTTP.SEND()
    STRTOFILE(loXMLHTTP.responseBody,THIS.cXMLinfoUpdate)
  CATCH TO loErr
    MESSAGEBOX("ERROR en getUpdateInfo: " + loErr.MESSAGE,64,"ERROR")
    llRet = .F.
  ENDTRY
  RETURN llRet
ENDFUNC

*[ una vez que bajamos el XML lo leemos para 
*[ asignar a las propiedad de esta clase
*[ la información sobre el bin a actualizar
PROCEDURE ReadUpdateInfo
  XMLTOCURSOR(THIS.cXMLinfoUpdate,"cur_Info",512)
  SELECT cur_Info
  THIS.cNewBinVersion  = cur_Info.ver
  THIS.dNewBinDate     = cur_Info.DATE
  THIS.cURLhistoryInfo = cur_Info.url
  THIS.nStatusUpdate   = cur_Info.STATUS
  USE IN cur_Info
  ERASE (THIS.cXMLinfoUpdate)
ENDPROC

*[ Obtiene la versión del archivo main.bin actual
FUNCTION getMyBinInfo() AS STRING
  LOCAL laFile[1]
  AGETFILEVERSION(laFile, THIS.cMyBinFileName)
  THIS.cMyBinVersion = laFile[4]
  RETURN laFile[4]
ENDPROC

*[ descarga a nuestro disco el archivo a actualizar
FUNCTION downloadUpdate AS Boolean
  LOCAL llRet
  LOCAL loXMLHTTP AS "MSXML2.XMLHTTP"
  loXMLHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
  llret = .T.

  TRY
    loXMLHTTP.OPEN("GET", THIS.cNewBinURL,.F.)
    loXMLHTTP.SEND()
    STRTOFILE(loXMLHTTP.responseBody, THIS.cMyBinFileName)
  CATCH TO loErr
    MESSAGEBOX("ERROR en downloadUpdate: " + loErr.MESSAGE + CHR(13) + ;
      "# " + STR(loErr.ErrorNo) + CHR(13) + ;
      "LINE: " + STR(loErr.LINENO),64,"ERROR")
    llRet = .F.
  ENDTRY
  RETURN llRet
ENDPROC

FUNCTION getNewBinInfo() AS STRING
  RETURN THIS.cNewBinVersion
ENDFUNC

FUNCTION getStatus() AS STRING
  RETURN THIS.nStatusUpdate
ENDFUNC

ENDDEFINE