CLOSE databases
USE "H:\Documents and Settings\josemsg\Escritorio\Partes\2011-07-18.dbf" AGAIN EXCLUSIVE ALIAS crsSource
*__ Ordenar por operario y fecha y hora
SELECT * FROM crsSource ORDER BY id_operari,fecha,hora_desde INTO CURSOR miCrs

*__ Crear cursor vacio d�nde vamos a ir almacenando los primeros y ultimos partes de 
*__ cada operario
SELECT * FROM miCrs WHERE 1=0 INTO CURSOR crsTemp READWRITE

*__ Seleccionar los diferentes operarios del cursor inicial
SELECT DISTINC id_operari FROM miCrs ORDER BY id_operari INTO CURSOR crsOper

*__ Ahora recorremos el cursor de los partes por orden de opeario
SELECT crsOper
SCAN all
	SELECT miCrs
	i=0
	l=0
	SCAN ALL FOR miCrs.id_operari = crsOper.id_operari
		IF i=0
			*__ Es el primer parte de este operario
			SCATTER MEMO MEMVAR
			INSERT INTO crsTemp FROM MEMVAR
		ENDIF
		i=i+1
		l=RECNO()	
	ENDSCAN
	
	*__ Se supone que el cursor est� en el �ltimo parte del usuario
	GOTO RECORD (l)
	SCATTER MEMO MEMVAR
	INSERT INTO crsTemp FROM MEMVAR
	
	SELECT crsOper
ENDSCAN

SELECT crsTemp
BROWSE LAST


