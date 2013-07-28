LOCAL lcLocal, lcRemoto, aLocal, aRemoto, lcVersionLocal, lcVersionRemota,;
	lcFechaLocal, lcFechaRemota
DIMENSION aLocal[1], aRemoto[1]

*__ 1. Obtener nuestra versión local y también la remota
*__ 1.1 Cargar el fichero XML
XMLTOCURSOR("myGestInfo.xml","cur_Info",512)
  SELECT cur_Info
  lcLocal  = cur_Info.local
  lcRemoto = cur_Info.remoto
  USE IN cur_Info
*__ 1.2 Comprobar la existencia de los ficheros
IF NOT FILE(lcLocal)
	MESSAGEBOX("No existe la versión local: "+lcLocal,0+16,"myGest")
	RETURN
ENDIF
IF NOT FILE(lcRemoto)
	MESSAGEBOX("No existe la versión remota: "+lcLocal,0+16,"myGest")
	RETURN
ENDIF
*__ 1.3 Obtener la versión de cada fichero
ADIR(aLocal, lcLocal)
ADIR(aRemoto, lcRemoto)
lcFechaLocal = DTOC(aLocal[3])
lcFechaRemota = DTOC(aRemoto[3])

lcVersionLocal = SUBSTR(lcFechaLocal,7,4)+SUBSTR(lcFechaLocal,4,2)+SUBSTR(lcFechaLocal,1,2)+;
	aLocal[4]
lcVersionRemota = SUBSTR(lcFechaRemota,7,4)+SUBSTR(lcFechaRemota,4,2)+SUBSTR(lcFechaRemota,1,2)+;
	aRemoto[4]
*__ 1.4 Comparar para saber si estamos actualizados
IF lcVersionLocal < lcVersionRemota
	*__ Tenemos que actualizar
	MESSAGEBOX("Existe una versión nueva del programa: MyGest"+CHR(13)+;
		"Se va a proceder a la actualización del programa.",0+64,"myGest")
	*__ Copiar el fichero remoto al directorio local
	COPY FILE (lcRemoto) TO (lcLocal)
	
	*__ Descomprimimos	
	RUN my7unZip.cmd
ENDIF

*__ 2. Ya estamos listos para lanzar el programa principal
DO myGest.exe
RETURN

*!*	lcAppName				= "myGest"
*!*	oVersion                = NEWOBJECT("ControlVer","ControlVersion.prg")
*!*	oVersion.cMyBinFileName = lcAppName+".bin"
*!*	oVersion.cXMLinfoUpdate = lcAppName+"Info.XML"
*!*	oVersion.cNewBinURL     = "http://c-dev.net/Test/"+lcAppName+".bin"
*!*	oVersion.cXMLinfoURL    = "http://c-dev.net/Test/"+lcAppName+"Info.XML"

*!*	IF oVersion.getUpdateInfo()
*!*	  oVersion.ReadUpdateInfo()
*!*	  lnNewVer     = VAL(STRTRAN(oVersion.getNewBinInfo(),".",""))
*!*	  lnCurrentVer = VAL(STRTRAN(oVersion.getMyBinInfo(),".",""))
*!*	  lnStatus     = oVersion.getStatus()

*!*	  IF lnNewVer > lnCurrentVer
*!*	    ? "Existe una nueva versión Y su STATUS es: " + TRANSFORM(lnStatus)
*!*	    ? "Ver actual    " + oVersion.getNewBinInfo()
*!*	    ? "Nueva versión " + oVersion.getMyBinInfo()
*!*	    ? "Descargando nueva versión...."
*!*	    IF oVersion.downloadUpdate()
*!*	      ? "Actualizo correctamente"
*!*	    ELSE
*!*	      ? "ERROR. No pudo actualizar"
*!*	    ENDIF
*!*	  ELSE
*!*	    ? "No hay actualizaciones"
*!*	  ENDIF
*!*	ENDIF

*!*	LOCAL lcProgExe, lcProgBin

*!*	lcProgExe = lcAppName+".exe"
*!*	lcProgBin = lcAppName+".bin"
*!*	IF FILE(lcProgExe)
*!*		DELETE FILE (lcProgExe)
*!*	ENDIF
*!*	IF FILE(lcProgBin)
*!*	  RENAME (lcProgBin) TO (lcProgExe)
*!*	  DO (lcProgExe)
*!*	  RENAME (lcProgExe) TO (lcProgBin)
*!*	ENDIF