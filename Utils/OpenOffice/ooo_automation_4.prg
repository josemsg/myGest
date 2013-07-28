
? ExporToCalc("micrs","d:\miscosas\micodigo\mygest\utils\openoffice\","ejemplo")
RETURN

*-------------------------------------------------------------*
*!*- FUNCTION ExporToCalc([cCursor], [cDestino], [cFileSave])
*!*- cCursor:  Alias del cursor que se va a exportar.
*!*- cDestino:  Nombre de la carpeta donde se va a grabar.
*!*- cFileName:  Nombre del archivo con el que se va a grabar.
*-------------------------------------------------------------*
FUNCTION ExporToCalc(cCursor, cDestino, cFileSave)
  LOCAL oManager, oDesktop, oDoc, oSheet, oCell, oRow, FileURL
  LOCAL ARRAY laPropertyValue[1]

  cWarning = "Exportar a OpenOffice.org Calc"

  IF EMPTY(cCursor)
    cCursor = ALIAS()
  ENDIF

  IF TYPE('cCursor') # 'C' OR !USED(cCursor)
    MESSAGEBOX("Parametros Invalidos",16,cWarning)
    RETURN .F.
  ENDIF

  lColNum = AFIELDS(lColName,cCursor)

  EXPORT TO (cDestino + cFileSave + [.ods]) TYPE XL5

  oManager = CREATEOBJECT("com.sun.star.ServiceManager.1")

  IF VARTYPE(oManager, .T.) # "O"
    MESSAGEBOX("OpenOffice.org Calc no esta instalado en su computador.",64,cWarning)
    RETURN .F.
  ENDIF

  oDesktop = oManager.createInstance("com.sun.star.frame.Desktop")

  COMARRAY(oDesktop, 10)

  oReflection = oManager.createInstance("com.sun.star.reflection.CoreReflection")

  COMARRAY(oReflection, 10)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "ReadOnly"
  laPropertyValue[1].VALUE= .F.

  FileURL = ConvertToURL(cDestino + cFileSave + [.ods])

  oDoc = oDesktop.loadComponentFromURL(FileURL , "_blank", 0, @laPropertyValue)

  oSheet = oDoc.getSheets.getByIndex(0)

  FOR i = 1 TO lColNum
    oColumn = oSheet.getColumns.getByIndex(i)
    oColumn.setPropertyValue("OptimalWidth", .T.)

    oCell = oSheet.getCellByPosition( i-1, 0 )
    oDoc.CurrentController.SELECT(oCell)

    WITH oDoc.CurrentSelection
      .CellBackColor = RGB(200,200,200)
      *.Cell
      .CharColor = RGB(255,0,0)
      .CharHeight = 10
      .CharPosture = 0
      .CharShadowed = .F.
      .FormulaLocal = lColName[i,1]
      .HoriJustify = 2
      .ParaAdjust = 3
      .ParaLastLineAdjust = 3
    ENDWITH
  ENDFOR

  oCell = oSheet.getCellByPosition( 0, 0 )
  oDoc.CurrentController.SELECT(oCell)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "Overwrite"
  laPropertyValue[1].VALUE = .T.

  oDoc.STORE()
ENDFUNC

FUNCTION createStruct(toReflection, tcTypeName)
  LOCAL loPropertyValue, loTemp
  loPropertyValue = CREATEOBJECT("relation")
  toReflection.forName(tcTypeName).CREATEOBJECT(@loPropertyValue)
  RETURN (loPropertyValue)
ENDFUNC

FUNCTION ConvertToURL(tcFile AS STRING)
  IF(TYPE( "tcFile" ) == "C") AND (!EMPTY( tcFile ))
    tcFile = [file:///] + CHRTRAN(tcFile, "\", "/" )
  ELSE
    tcFile = [file:///C:/] + ALIAS() + [.ods]
  ENDIF
  RETURN tcFile
ENDFUNC