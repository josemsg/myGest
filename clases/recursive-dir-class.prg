*-------------------------------------------------------------*
*__ CLASE: RecurseDir
*-------------------------------------------------------------*
*__ Ejemplo de uso:
*__		x = CREATEOBJECT("RecurseDir", ss) && ss, es Datasession_id
*__		x.ProcesarDir( "C:\Documents and Settings\USER\" )
*-------------------------------------------------------------*
*__ DEVUELVE: Dos cursores, tempFiles y tempDirs, que 
*__ 			contienen los ficheros y los diferentes dirs.
*-------------------------------------------------------------*

*__ Clase para tratar recursión en directorios
DEFINE CLASS RecurseDir AS Custom
	*__ Valor por defecto para la sesión de datos de esta clase
	znSesion = 1
	
	PROCEDURE Destroy
		*__ Establecer sesion de datos
		SET DATASESSION TO (This.znSesion)
		
		*__ Cerrar los cursores abiertos
		IF USED("tempFiles")
			USE IN tempFiles
		ENDIF
		IF USED("tempDirs")
			USE IN tempDirs
		ENDIF
	ENDPROC
	
	FUNCTION ProcesarDir( lcDir, ss )
		*__ Establecer sesion privada de datos
		IF VARTYPE(ss)="N"
			This.znSesion = ss
			SET DATASESSION TO (This.znSesion)
		ENDIF

		*__ Creamos el cursor tempFiles
		CREATE CURSOR tempfiles ( cDir c(254), cFilename c(254), nSize n(10), dMod d, cTime C(8) )

		*__ Procesar el directorio
		This.RecurseFolder( lcDir )
		
		*__ Crear los cursores tempFiles y tempDirs
		SELECT * FROM tempFiles ORDER BY cDir, cFilename ;
			INTO CURSOR tempFiles
		SELECT DISTINC cDir FROM tempFiles ORDER BY cDir ;
			INTO CURSOR tempDirs
	ENDFUNC
		
	PROTECTED FUNCTION RecurseFolder( lcDir )
		LOCAL i,n, laFiles[1]

		n = ADIR( laFiles, lcDir + "*.*", "shd" )

		FOR i = 1 TO n
		   IF ( LEFT( laFiles[i,1], 1 ) != '.' )
		      IF ( "D" $ laFiles[i,5] )
		         THIS.RecurseFolder( lcDir + laFiles[i,1] + "\" )
		      ELSE
		        INSERT INTO tempfiles ;
		               VALUES( lcDir, laFiles[i,1], laFiles[i,2], laFiles[i,3], ;
		               	laFiles[i,4] )
		      ENDIF
		   ENDIF
		ENDFOR
	RETURN

ENDDEFINE
