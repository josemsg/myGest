*//.........................................................................................
*//......Fecha:      12-12-2012.............................................................
*//......Autor:      JOSE MARIA SANCHEZ GONZALEZ............................................
*//......eMail:      jmsanchez.ibiza@gmail.com..............................................
*//......Funcion:    Envia una tabla DBF a un script SQL de mySql...........................
*//......Par�metros: tcDBF, nombre de la tabla DBF a pasar..................................
*//......			 tcDataBase, nombre de la base de datos mySQL...........................
*//......Return:	 _cRet: Contiene el texto del fichero SQL para esta tabla...............
*//......            Recibe como par�metro el nombre de la tabla, el nombre de la base......
*//......            de datos mySQL.........................................................
*//.........................................................................................
*//-----------------------------------------------------------------------------------------
FUNCTION Dbf2Sql
LPARAMETERS tcDBF, tcDataBase

SET STEP ON 

*__ Comprobamos los par�metros
IF PCOUNT()<>2
	WAIT WINDOW "DBF2SQL: N� de par�metros incorrecto" TIMEOUT 3
	RETURN
ENDIF

IF VARTYPE(tcDBF)<>"C"
	WAIT WINDOW "DBF2SQL: par�metro tcDBF incorrecto"
	RETURN
ENDIF

IF VARTYPE(tcDataBase)<>"C"
	WAIT WINDOW "DBF2SQL: par�metro tcDataBase incorrecto"
	RETURN
ENDIF

*// inicializaci�n
SET DATE TO DMY
SET SAFETY OFF
SET SCOREBOARD OFF
SET TALK OFF
#define XCOMM  "-- "  &&definimos los caracteres de comentario para el servidor mysql

_cRet = ""
_eol=CHR(13)+CHR(10)
_tab=CHR(9)

*//---------------------------------------------------------------
* mysql tables type:
*    TINYINT[(length)] [UNSIGNED] [ZEROFILL]
*  | SMALLINT[(length)] [UNSIGNED] [ZEROFILL]
*  | MEDIUMINT[(length)] [UNSIGNED] [ZEROFILL]
*  | INT[(length)] [UNSIGNED] [ZEROFILL]
*  | INTEGER[(length)] [UNSIGNED] [ZEROFILL]
*  | BIGINT[(length)] [UNSIGNED] [ZEROFILL]
*  | REAL[(length,decimals)] [UNSIGNED] [ZEROFILL]
*  | DOUBLE[(length,decimals)] [UNSIGNED] [ZEROFILL]
*  | FLOAT[(length,decimals)] [UNSIGNED] [ZEROFILL]
*  | DECIMAL(length,decimals) [UNSIGNED] [ZEROFILL]
*  | NUMERIC(length,decimals) [UNSIGNED] [ZEROFILL]
*  | DATE
*  | TIME
*  | TIMESTAMP
*  | DATETIME
*  | CHAR(length) [BINARY | ASCII | UNICODE]
*  | VARCHAR(length) [BINARY]
*  | TINYBLOB
*  | BLOB
*  | MEDIUMBLOB
*  | LONGBLOB
*  | TINYTEXT [BINARY]
*  | TEXT [BINARY]
*  | MEDIUMTEXT [BINARY]
*  | LONGTEXT [BINARY]
*  | ENUM(value1,value2,value3,...)
*  | SET(value1,value2,value3,...)
*  | spatial_type
*//---------------------------------------------------------------

*//------------------------------------------------------
*//  enviamos cabecera
*//------------------------------------------------------
_cRet = _cRet + XCOMM+"*//............................................................................................" + _eol
_cRet = _cRet + XCOMM+"*//......Fecha:         "+DTOC(DATE())+"......................................................." + _eol
_cRet = _cRet + XCOMM+"*//......Autor:         JOSE MARIA SANCHEZ GONZALEZ............................................" + _eol
_cRet = _cRet + XCOMM+"*//......Localidad:     Encarnaci�n-Paraguay...xodrf@hotmail.com..............................." + _eol
_cRet = _cRet + XCOMM+"*//......               Backup generado desde vFoxpro.........................................." + _eol
_cRet = _cRet + XCOMM+"*//......               ......................................................................." + _eol
_cRet = _cRet + XCOMM+"*//......               para importar desde mysql ejecutar el siguiente comando................" + _eol
_cRet = _cRet + XCOMM+"*//......               WIN-SHELL:    mysql -u root -p < C:\xSQL.sql..........................." + _eol
_cRet = _cRet + XCOMM+"*//......               LINUX-SHELL:  mysql -u root -p < /home/xSQL.sql........................" + _eol
_cRet = _cRet + XCOMM+"*//............................................................................................" + _eol
_cRet = _cRet + XCOMM+"*//............................................................................................" + _eol
_cRet = _cRet + XCOMM + _eol
_cRet = _cRet + XCOMM + _eol
_cRet = _cRet + [USE ] + tcDataBase + [;] + _eol
_cRet = _cRet + XCOMM + _eol
_cRet = _cRet + XCOMM + _eol

*//------------------------------------------------------
*// procesamos la tabla  
  USE (tcDBF) IN 0 ALIAS XTABLE AGAIN NOUPDATE
  _Table=tcDBF
  
  _cRet = _cRet + "DROP TABLE IF EXISTS " + tcDBF + ";" + _eol
  _cRet = _cRet + XCOMM + _eol
  _cRet = _cRet + "CREATE TABLE " + tcDBF + " (" + _eol
  
  *// captura campos
  _col  =1
  _Slen  =AFIELDS( _Struct, [XTABLE] )
  _line = ""
  FOR _Sgir=1 TO _Slen STEP 1

    *//----------------------------------------------------------
    *// realizamos las conversiones de campos DBF a mysql
    *Field type: 
    *C=Character
    *D=Date
    *L=Logical
    *M=Memo
    *N=Num�rico
    *F=Float
    *I=Integer
    *B=Double
    *Y=Currency
    *T=DateTime
    *G=General
    DO CASE
      CASE _Struct[_Sgir,2]=="C"
        _type  ="CHAR ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+")"
      
      CASE _Struct[_Sgir,2]=="D"
        _type  ="DATE"
      
      CASE _Struct[_Sgir,2]=="L"
        _type  ="TINYINT (1)"
      
      CASE _Struct[_Sgir,2]=="M"
        _type  ="LONGTEXT"
      
      CASE _Struct[_Sgir,2]=="N"
        _type  ="DOUBLE ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+", "+ALLTRIM(STR(_Struct[_Sgir,4],2,0))+")"
      
      CASE _Struct[_Sgir,2]=="F"
        _type  ="FLOAT ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+", "+ALLTRIM(STR(_Struct[_Sgir,4],2,0))+")"
      
      CASE _Struct[_Sgir,2]=="I"
        _type  ="INT ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+")"
      
      CASE _Struct[_Sgir,2]=="B"
        _type  ="DOUBLE ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+", "+ALLTRIM(STR(_Struct[_Sgir,4],2,0))+")"
      
      CASE _Struct[_Sgir,2]=="Y"
        _type  ="DOUBLE ("+ALLTRIM(STR(_Struct[_Sgir,3],3,0))+", "+ALLTRIM(STR(_Struct[_Sgir,4],2,0))+")"
      
      CASE _Struct[_Sgir,2]=="T"
        _type  ="DATETIME"
      
      CASE _Struct[_Sgir,2]=="G"
        _type  ="LONGTEXT BINARY"
        
    ENDCASE
    _line=_tab+_Struct[_Sgir,1]+" "+_type
    _cRet = _cRet + IIF( _Sgir<_Slen, _line+",", _line ) + _eol
    
  ENDFOR
  RELEASE _line,_type
  
  *//
  *//  aca deberia verificarse y alterar el codigo de modo tal que permita generar las claves de indexado
  *//  complejas de VFP de modo tal que sea equivalente en mysql, el siguiente simplemente cuando tiene
  *//  una clave de indexado compleja la omite es decir no crea ningun indice para la tabla mysql
  *//  una expresion compleja seria algo como sigue:
  *//  index on campo1+campo2 o DTOS(fecha) u otros similares to ... 
  *//
  
  *// captura de indices
  _TagName=tcDBF+".CDX"
  _ltag=TAGCOUNT()
  IF _ltag>0
    
    *// OMITIMOS EXPRESIONES COMPLEJAS EN INDICES
    FOR _Sgir=1 TO _ltag
      _sexp  =KEY( _Sgir )
      _lsexp  =LEN( ALLTRIM( _sexp ) )
      _error  =.F.
      _kstr  =""
      _ckey  =0
      FOR _tgir=1 TO _lsexp
        _byte=ASC(SUBSTR(_sexp,_tgir,1))
        IF !(BETWEEN(_byte,48,57) OR BETWEEN(_byte,65,97) OR BETWEEN(_byte,90,122))
          _error=.T.
        ENDIF
      ENDFOR
      IF _error
        LOOP
      ENDIF
      _Kstr=_Kstr+IIF( _ckey>1,",", "" ) + KEY( _Sgir )
      _ckey=_ckey+1
    ENDFOR
    IF _ckey>0
*!*	      FSEEK( _han, -2, 1 )
*!*	      FPUTS( _han, "," )
*!*	      FWRITE( _han, _tab+[PRIMARY KEY(]+_Kstr+[)] )
		_cRet = LEFT(_cRet, LEN(_cRet)-2)
		_cRet = _cRet + "," + _eol
		_cRet = _cRet + _tab+[PRIMARY KEY(]+_Kstr+[)]		
    ENDIF
    RELEASE _kstr,_sexp,_ltag,_ckey,_TagName,_ltag

  ENDIF
*!*	  FPUTS( _han, " );" )
  _cRet = _cRet + " );" + _eol

  *// solo si hay registros en la tabla DBF procedemos a insertarlos 
  IF RECCOUNT()>0

    *//--------------------------------------------------------------------
    *// enviamos sentencia insert con los campos
    _line=""
    FOR _Sgir=1 TO _Slen STEP 1
      _line=_line+_Struct[_Sgir,1]+IIF( _Sgir<_Slen, ",", "" )
    ENDFOR
*!*	    FPUTS( _han, "INSERT INTO "+_Table+" ("+_line+") VALUES" )
	_cRet = _cRet + _eol + _eol + "INSERT INTO "+_Table+" ("+_line+") VALUES" + _eol
  
	*// enviamos cada registro de la tabla
	SELECT XTABLE
	GO TOP
	DO WHILE !EOF()

		_line="("

		IF DELETED()
			SKIP +1
			LOOP
		ENDIF
		FOR _Sgir=1 TO _Slen STEP 1
			DO CASE
				CASE _Struct[_Sgir,2]=="C"
				_value=CHR(39)+STRTRAN( ALLTRIM(EVALUATE( _Struct[_Sgir,1] )), CHR(39),"\"+CHR(39) )+CHR(39)
				CASE _Struct[_Sgir,2]=="D"
				_value=CHR(39)+STRTRAN( STR(YEAR(EVALUATE( _Struct[_Sgir,1] )),4,0)+"-"+STR(MONTH(EVALUATE( _Struct[_Sgir,1] )),2,0)+"-"+STR(DAY(EVALUATE( _Struct[_Sgir,1] )),2,0), " ", "0" )+CHR(39)
				CASE _Struct[_Sgir,2]=="L"
				_value=CHR(39)+IIF( EVALUATE( _Struct[_Sgir,1] ), "1", "0" )+CHR(39)
				CASE _Struct[_Sgir,2]=="M"
				_value=CHR(39)+EVALUATE( _Struct[_Sgir,1] )+CHR(39)
				CASE _Struct[_Sgir,2]=="N"
				_value=CHR(39)+ALLTRIM(STR(EVALUATE( _Struct[_Sgir,1] ),_Struct[_Sgir,3],_Struct[_Sgir,4]))+CHR(39)
				CASE _Struct[_Sgir,2]=="F"
				_value=CHR(39)+ALLTRIM(STR(EVALUATE( _Struct[_Sgir,1] ),_Struct[_Sgir,3],_Struct[_Sgir,4]))+CHR(39)
				CASE _Struct[_Sgir,2]=="I"
				_value=CHR(39)+ALLTRIM(STR(EVALUATE( _Struct[_Sgir,1] ),_Struct[_Sgir,3],_Struct[_Sgir,4]))+CHR(39)
				CASE _Struct[_Sgir,2]=="B"
				_value=CHR(39)+ALLTRIM(STR(EVALUATE( _Struct[_Sgir,1] ),_Struct[_Sgir,3],_Struct[_Sgir,4]))+CHR(39)
				CASE _Struct[_Sgir,2]=="Y"
				_value=CHR(39)+ALLTRIM(STR(EVALUATE( _Struct[_Sgir,1] ),_Struct[_Sgir,3],_Struct[_Sgir,4]))+CHR(39)
				CASE _Struct[_Sgir,2]=="T"
				_value=CHR(39)+TRANSFORM( TTOC(EVALUATE( _Struct[_Sgir,1] ),1), ";@r 9999-99-99 99:99:99" )+CHR(39)
				CASE _Struct[_Sgir,2]=="G"
				*_value=CHR(39)+EVALUATE( _Struct[_Sgir,1] )+CHR(39)
				_value=CHR(39)+CHR(39)	
			ENDCASE
			_line=_line+_value+IIF( _Sgir<_Slen, ",", ")" )
		ENDFOR

		*// enviamos el registro al archivo
*!*			FWRITE( _han, _line )
		_cRet = _cRet + _line
		SKIP +1


		*// si es el ultimo registro finalizamos sentencia sql
		IF EOF()
*!*				FWRITE( _han, ";"+_eol )
			_cRet = _cRet + ";" + _eol
		ELSE
*!*				FWRITE( _han, ","+_eol )
			_cRet = _cRet + "," + _eol
		ENDIF

	ENDDO
  
  ENDIF
  USE IN XTABLE

  _cRet = _cRet + _eol + _eol
  _cRet = _cRet + XCOMM+"*//............................................................................................" + _eol
  _cRet = _cRet + XCOMM+"*//............................................................................................" + _eol
  _cRet = _cRet + XCOMM+"*//............................................................................................" + _eol



RETURN _cRet

*//
*//  FIN DEL PROGRAMA
*//

* sample output
*CREATE TABLE IF NOT EXISTS 'usuarios' (
*  'id' int(11) NOT NULL AUTO_INCREMENT,
*  'usuario' varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
*  'pass' varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
*  'nivel' enum('USUARIO','ADMIN') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'USUARIO',
*  'fechaAlta' datetime NOT NULL,
*  'ip' varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
*  'activo' tinyint(1) NOT NULL DEFAULT '1',
*  'ultimoLogin' datetime DEFAULT NULL,
*  'email' varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
*  'nombre' varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
*  'apellido' varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
*  'paisId' int(11) NOT NULL,
*  'comentarios' text COLLATE utf8_spanish2_ci,
*  PRIMARY KEY ('id'),
*  UNIQUE KEY 'usuario' ('usuario')
*) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci AUTO_INCREMENT=10 ;
*INSERT INTO 'usuarios' ('id', 'usuario', 'pass', 'nivel', 'fechaAlta', 'ip', 'activo', 'ultimoLogin', 'email', 
*  'nombre', 'apellido', 'paisId', 'comentarios') VALUES
*(1, 'admin', 'admin', 'ADMIN', '2009-07-27 11:23:03', '127.0.0.1', 1, '2009-08-24 15:42:00', 'admin@demo.com', 
*  'Usuario', 'Administrador', 1, 'soy administrador ;)'),
*(2, 'usuario', 'usuario', 'USUARIO', '2009-07-28 16:19:58', '127.0.0.1', 1, '2009-08-24 15:48:46', 'juan@perez.com', 
*  'Juan', 'Perez', 1, NULL),
*(4, 'acarizza', '1234', 'USUARIO', '0000-00-00 00:00:00', '127.0.0.1', 0, '2009-08-18 22:10:51', 'email@server.com', 
*  'Andres', 'Carizza', 1, 'probando ''comilla "comilla doble \\ barra invertida /barra *asterisco'),
*(5, 'maria', '1234', 'USUARIO', '0000-00-00 00:00:00', NULL, 1, NULL, 'maria@hotmail.com', 
*  'Maria', 'Juana', 2, 'Comentarios para el campo de texto'),
*(7, 'juan', '1234', 'USUARIO', '0000-00-00 00:00:00', NULL, 1, NULL, 'juan@hotmail.com', 
*  'Juan', '', 4, ''),
*(9, 'pepe', '1234', 'USUARIO', '0000-00-00 00:00:00', NULL, 1, NULL, 'pepe@pepe.com', 
*  'Pepe', 'Perez', 3, 'hola que tal');
*//-----------------------------------------------------------------------------------------------
