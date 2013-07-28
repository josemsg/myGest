***************************************
*___ UTILS.PRG
***************************************
FUNCTION LimpiarParaSalir
*__ Lo dejamos todo listo para salir de la aplicación
LOCAL lcCmd
	
	*__ Quitar las toolbar
	_screen.oTB_principal.Release

	*__ Limpiar la conexión de MySql
	IF TYPE('_screen.oConMySQl')='O'
		_screen.oConMySQl.disconnect()
		_screen.RemoveObject("oConMySQl")
	ENDIF
	IF TYPE('_screen.oConTlmPlus')='O'
		_screen.oConTlmPlus.disconnect()
		_screen.RemoveObject("oConTlmPlus")
	ENDIF
	IF TYPE('_screen.oConTlmPlus1')='O'
		_screen.oConTlmPlus1.disconnect()
		_screen.RemoveObject("oConTlmPlus1")
	ENDIF
	IF TYPE('_screen.oConTlmPlus2')='O'
		_screen.oConTlmPlus2.disconnect()
		_screen.RemoveObject("oConTlmPlus2")
	ENDIF
	IF VERSION(2)==0
		*__ Foxpro Runtime (exe)
		lcCmd = "QUIT"
	ELSE
		set sysmenu to defa
	   	lcCmd = "RETURN"
	ENDIF
	
RETURN lcCmd

FUNCTION CrearConexionesTelematel
LOCAL lCancelar, lnVersionTelematel

*__ De momento, damos por hecho que se trata de la NUEVA version de Telematel
lnVersionTelematel = 1

*!*	DEFINE WINDOW w_input FROM 1,1 TO 4,60 TITLE "Selección de versión TELEMATEL"
*!*	ACTIVATE WINDOW w_input
*!*	lnVersionTelematel = -1
*!*	DO WHILE lnVersionTelematel < 0 OR lnVersionTelematel > 1

*!*		ACCEPT "Versión de Telematel?? 0- Antigüa, 1- Nueva: " TO lnVersionTelematel
*!*		lnVersionTelematel = INT(VAL(lnVersionTelematel))
*!*	ENDDO
*!*	CLEAR WINDOW w_input

lCancelar = .f.
	
	IF TYPE('_screen.oConTlmPlus')!='O'
  		_Screen.AddObject("oConTlmPlus","conexion") 
	ENDIF
	WITH _Screen.oConTlmPlus
		.Dsn = "TLMPLUS"
		.User = "userSQL"
		.PassWord = "userSQL"
		.Connect()
		.zVersionTelematel = lnVersionTelematel
		
		IF NOT .Connected
			MESSAGEBOX("No se ha podido conectar a TlmPlus",0+16,"Atención",5)
			lCancelar = .t.
		ENDIF
	ENDWITH
	
	IF TYPE('_screen.oConTlmPlus1')!='O'
  		_Screen.AddObject("oConTlmPlus1","conexion") 
	ENDIF
	WITH _Screen.oConTlmPlus1
		.Dsn = "TLMPLUS1"
		.User = "userSQL"
		.PassWord = "userSQL"
		.Connect()
		.zVersionTelematel = lnVersionTelematel
		
		IF NOT .Connected
			MESSAGEBOX("No se ha podido conectar a TlmPlus1",0+16,"Atención",5)
			lCancelar = .t.
		ENDIF
	ENDWITH
	
	IF TYPE('_screen.oConTlmPlus2')!='O'
  		_Screen.AddObject("oConTlmPlus2","conexion") 
	ENDIF
	WITH _Screen.oConTlmPlus2
		.Dsn = "TLMPLUS2"
		.User = "userSQL"
		.PassWord = "userSQL"
		.Connect()
		.zVersionTelematel = lnVersionTelematel
		
		IF NOT .Connected
			MESSAGEBOX("No se ha podido conectar a TlmPlus2",0+16,"Atención",5)
			lCancelar = .t.
		ENDIF
	ENDWITH

RETURN lCancelar
ENDFUNC

*******************************************************************
* CONVERTIR FECHA DE SUBMISSION-ODK DE PARTE A DATETIME
*******************************************************************
FUNCTION SubmissionDateToDateTime
LPARAMETERS pcSub

LOCAL lnDia, lnMes, lnAño, lcHora, lcFecha, ldtFechaHora

*__ El formato del string es:
*__ Dia de la semana -> 1ª palabra en Inglés, ej, Saturday
*__ Mes -> 2ª palabra en Ingles, ej, October
lnMes = MesEnNumero(GETWORDNUM(pcSub, 2, ", "))
*__ Dia del mes -> 3ª palabra, ej, 16
lnDia = INT(VAL(GETWORDNUM(pcSub, 3, ", ")))
*__ Año -> 4ª palabra, ej, 2010
lnAño = INT(VAL(GETWORDNUM(pcSub, 4, ", ")))
*__ Hora -> 5ª palabra, ej, 8:06:26
lcHora = PADL(GETWORDNUM(pcSub, 5, ", "), 8, "0")
lcFecha = ALLTRIM(STR(lnDia))+"/"+ALLTRIM(STR(lnMes))+"/"+ALLTRIM(STR(lnAño))
ldtFechaHora = CAST(lcFecha+" "+lcHora as Datetime)
RETURN ldtFechaHora

*******************************************************************
* CONVERTIR FECHA DE PARTE-ODK A DATETIME
*******************************************************************
FUNCTION OdkDateToDateTime
LPARAMETERS pcSub

LOCAL lnDia, lnMes, lnAño, lcHora, lcFecha, ldtFechaHora
*__ El formato del string es:
*__ Dia de la semana -> 1ª palabra en Inglés, ej, Sat
*__ Mes -> 2ª palabra en Ingles, ej, Oct
lnMes = MesEnNumero(GETWORDNUM(pcSub, 2, ", "))
*__ Dia del mes -> 3ª palabra, ej, 16
lnDia = INT(VAL(GETWORDNUM(pcSub, 3, ", ")))
*__ Hora -> 4ª palabra, ej, 8:06:26
lcHora = PADL(GETWORDNUM(pcSub, 4, ", "), 8, "0")
*__ UTC -> 5ª palabra el texto 'UTC'
*__ Año -> 6ª palabra, ej, 2010
lnAño = INT(VAL(GETWORDNUM(pcSub, 6, ", ")))
lcFecha = ALLTRIM(STR(lnDia))+"/"+ALLTRIM(STR(lnMes))+"/"+ALLTRIM(STR(lnAño))
ldtFechaHora = CAST(lcFecha+" "+lcHora as Datetime)
RETURN ldtFechaHora

*!*	FOR i = 1 TO 5
*!*		lcStr = GETWORDNUM(pcSub, i, ", ")
*!*			&& Obtener la iª palabra con delimitadores el espacio y la coma
*!*		WAIT WINDOW "Palabra nº"+ALLTRIM(STR(I))+" "+ALLTRIM(lcStr)
*!*	ENDFOR i


FUNCTION MesEnNumero
LPARAMETERS pcMesEnLetra
*__ Recibimo el mes en letra y devolvemos el mes en número
LOCAL lcMes, lnMes

lcMes = LEFT(ALLTRIM(LOWER(pcMesEnLetra)),3)
DO CASE
CASE lcMes $ "ene,jan"
	lnMes = 1
CASE lcMes $ "feb"
	lnMes = 2
CASE lcMes $ "mar"
	lnMes = 3
CASE lcMes $ "abr,apr"
	lnMes = 4
CASE lcMes $ "may"
	lnMes = 5
CASE lcMes $ "jun"
	lnMes = 6
CASE lcMes $ "jul"
	lnMes = 7
CASE lcMes $ "ago,aug"
	lnMes = 8
CASE lcMes $ "sep"
	lnMes = 9
CASE lcMes $ "oct"
	lnMes = 10
CASE lcMes $ "nov"
	lnMes = 11
CASE lcMes $ "dic,dec"
	lnMes = 12
OTHERWISE
	lnMes = 0
ENDCASE
RETURN lnMes

*-------------------------------------------------------------------------
* Nombre: 		ShellExec
* Parametros:	lcLink, Nombre del fichero
*				lcAction, Accion a realizar 'open', 'edit', 'print'
*				lcParms, Parametros alternativos
* Return:		Entero, indicando como se llevo a cabo la acción
*-------------------------------------------------------------------------
FUNCTION ShellExec
LPARAMETER lcLink, lcAction, lcParms

lcAction = IIF(EMPTY(lcAction), "Open", lcAction)
lcParms = IIF(EMPTY(lcParms), "", lcParms)

DECLARE INTEGER ShellExecute ;
	IN SHELL32.dll ;
		INTEGER nWinHandle, ;
		STRING cOperation, ;
		STRING cFileName, ;
		STRING cParameters, ;
		STRING cDirectory, ;
		INTEGER nShowWindow

DECLARE INTEGER FindWindow ;
	IN WIN32API ;
		STRING cNull,STRING cWinName

RETURN ShellExecute(FindWindow(0, _SCREEN.caption), ;
		lcAction, lcLink, ;
		lcParms, SYS(2023), 1)
*-------------------------------------------------------------------------

*-----------------------------------------
* Nombre: 		DateToMySQL
* Parametros:	tdFecha, fecha a convertir
* Return:		Cadena en formato yyyymmdd
*-----------------------------------------
* Le pasamos una fecha y nos devuelve una
* cadena con el formato YYYYMMDD
*-----------------------------------------
FUNCTION DateToMySQL
LPARAMETERS tdFecha, tlTelematel
LOCAL lcDate

lcDate = TRANSFORM(YEAR(tdFecha))+;
	IIF(tlTelematel,"-","")+;
	TRANSFORM(MONTH(tdFecha),'@L 99')+;
	IIF(tlTelematel,"-","")+;
	TRANSFORM(DAY(tdFecha),'@L 99')

RETURN lcDate
*-----------------------------------------

*-----------------------------------------
* Nombre: 		SumarXmeses
* Parametros:	tdFecha, fecha a convertir
*				tnMeses, nº de meses que queremos sumar
* Return:		Fecha
*-----------------------------------------
* Le pasamos una fecha y un nº de meses
* y le suma x meses
*-----------------------------------------
FUNCTION SumarXmeses
LPARAMETERS tdFecha, tnMeses

_año = YEAR(tdFecha)
_mes = MONTH(tdFecha)
_dia = DAY(tdFecha)

_mes = _mes + tnMeses
IF _mes > 12
	_año = _año + 1
	_mes = _mes - 12
ENDIF
_bisiesto=IIF(MOD(_año,4)=0,.t.,.f.)
IF TRANSFORM(_mes,"@L 99")$"01,03,05,07,08,10,12"
	_ultimo_dia_del_mes = 31
ELSE
	IF _mes=2
		_ultimo_dia_del_mes = IIF(_bisiesto,29,28)
	ELSE
		_ultimo_dia_del_mes = 30
	ENDIF
ENDIF

IF _dia >= 28
	_dia = _ultimo_dia_del_mes
ENDIF

RETURN CTOD(ALLTRIM(STR(_dia))+ "/" + ;
			ALLTRIM(STR(_mes))+ "/" + ;
			ALLTRIM(STR(_año)) )

*-----------------------------------------
* Nombre: 	 	PrimerDiaDelAño
* Parametros:	tdFecha, fecha a convertir
* Return:		Fecha
*-----------------------------------------
* Le pasamos una fecha y nos devuelve la
* fecha con el primer día del año
*-----------------------------------------
FUNCTION PrimerDiaDelAño
LPARAMETERS tdFecha

_año = YEAR(tdFecha)
_mes = 1
_dia = 1

RETURN CTOD(ALLTRIM(STR(_dia))+ "/" + ;
			ALLTRIM(STR(_mes))+ "/" + ;
			ALLTRIM(STR(_año)) )
			
			
*-----------------------------------------
* Nombre: 	 	UltimoDiaDelAño
* Parametros:	tdFecha, fecha a convertir
* Return:		Fecha
*-----------------------------------------
* Le pasamos una fecha y nos devuelve la
* fecha con el ultimo día del año
*-----------------------------------------
FUNCTION UltimoDiaDelAño
LPARAMETERS tdFecha

_año = YEAR(tdFecha)
_mes = 12
_dia = 31

RETURN CTOD(ALLTRIM(STR(_dia))+ "/" + ;
			ALLTRIM(STR(_mes))+ "/" + ;
			ALLTRIM(STR(_año)) )


*-----------------------------------------
* Nombre: 	 	PrimerDiaDelMes
* Parametros:	tdFecha, fecha a convertir
* Return:		Fecha
*-----------------------------------------
* Le pasamos una fecha y nos devuelve la
* fecha con el primer día del mes
*-----------------------------------------
FUNCTION PrimerDiaDelMes
LPARAMETERS tdFecha

_año = YEAR(tdFecha)
_mes = MONTH(tdFecha)
_dia = 1

RETURN CTOD(ALLTRIM(STR(_dia))+ "/" + ;
			ALLTRIM(STR(_mes))+ "/" + ;
			ALLTRIM(STR(_año)) )
			

*-----------------------------------------
* Nombre: 	 	UltimoDiaDelMes
* Parametros:	tdFecha, fecha a convertir
* Return:		Fecha
*-----------------------------------------
* Le pasamos una fecha y nos devuelve la
* fecha con el ultimo día del mes
*-----------------------------------------
FUNCTION UltimoDiaDelMes
LPARAMETERS tdFecha

_año = YEAR(tdFecha)
_mes = MONTH(tdFecha)
_dia = DAY(tdFecha)
_bisiesto=IIF(MOD(_año,4)=0,.t.,.f.)
IF TRANSFORM(_mes,"@L 99")$"01,03,05,07,08,10,12"
	_ultimo_dia_del_mes = 31
ELSE
	IF _mes=2
		_ultimo_dia_del_mes = IIF(_bisiesto,29,28)
	ELSE
		_ultimo_dia_del_mes = 30
	ENDIF
ENDIF

_dia = _ultimo_dia_del_mes

RETURN CTOD(ALLTRIM(STR(_dia))+ "/" + ;
			ALLTRIM(STR(_mes))+ "/" + ;
			ALLTRIM(STR(_año)) )

*-----------------------------------------
* Nombre: 		ValorEnCadena
* Parametros:	tuValor, contiene un valor de cualquier tipo
*				tlVacio, si .t., nos indica que devolmenos un valor vacio
* Return:		Cadena con delimitadores nedesarios
*-----------------------------------------
* Le pasamos un valor y nos devuelve una cadena
* con el separador necesario
*-----------------------------------------
FUNCTION ValorEnCadena
LPARAMETERS tuValor, tlVacio

LOCAL lcRet

DO CASE
CASE VARTYPE(tuValor)='C'
	&& Character, Memo, Varchar, Varchar (Binary)
	tuValor = IIF(tlVacio,'',TRIM(tuValor))
	lcRet = [']+STRTRAN(tuValor,"'",CHR(34))+[']
	
CASE VARTYPE(tuValor)='D'
	&& DATE
	tuValor = IIF(tlVacio,CTOD(''),tuValor)
	lcRet = ['{]+DTOC(tuValor)+[}']
	
CASE VARTYPE(tuValor)='N'
	&& Numeric, Float, Double, or Integer
	tuValor = IIF(tlVacio,0,tuValor)
	lcRet = TRANSFORM(tuValor)

CASE VARTYPE(tuValor)='Y'
	&& Currency
	tuValor = IIF(tlVacio,0,tuValor)
	lcRet = TRANSFORM(tuValor)

CASE VARTYPE(tuValor)='L'
	&& Boleano
	lcRet = IIF(tuValor,'.t.','.f.')
ENDCASE

RETURN lcRet
*-----------------------------------------

PROCEDURE PonSets
SET TALK OFF
SET CONFIRM	ON
SET MULTILOCKS ON
SET CENTURY ON
SET DATE TO DMY
SET EXCLUSIVE ON
SET SAFETY OFF
SET DELETED ON
SET STRICTDATE TO 0
ENDPROC

*** Regresa numero en letras
Procedure NToLetra
Parameter numero
num_car = Str(numero,15,2)
num_dig = Subs(num_car,14,2)
pos = 1
Store "" To num_car_fin,leyenda
For t=1 To 4
	Store 0 To uni,dec,cen
	cen = Val(Subs(num_car,pos+0,1))
	dec = Val(Subs(num_car,pos+1,1))
	uni = Val(Subs(num_car,pos+2,1))
	pos = pos + 3
	letra3 = centena(uni,dec,cen)
	letra2 = decenas(uni,dec,cen)
	letra1 = unidads(uni,dec,cen)
	Do Case
		Case t=1
			leyenda = IIf(uni+dec+cen=1,"billon ",IIf(uni+dec+cen>1,"billones ",""))
		Case t=2
			leyenda = IIf(uni+dec+cen=1,"millon ",IIf(uni+dec+cen>1,"millones ",""))
		Case t=3
			leyenda = IIf(uni+dec+cen=1,"mil ",IIf(uni+dec+cen>1,"mil ",""))
		Case t=4
			leyenda = IIf(uni+dec+cen=1,"",IIf(uni+dec+cen>1,"",""))
	EndCase
	num_car_fin = num_car_fin + letra3 + letra2 + letra1 + leyenda
EndFor
num_1 = Val(Subs(num_car,1,12))
num_2 = Val(Subs(num_car,4,9))
num_3 = Val(Subs(num_car,7,6))
leyenda = ""
If num_1=1
	leyenda = " €uro "
Else
	If num_2=0 .Or. num_3=0
		leyenda = " de €uros "
	Else
		leyenda = " €uros "
	EndIf
EndIf
If num_1 = 0
	num_car_fin = "Cero "
	leyenda = "€uros "
EndIf
num_car_fin = "(" + num_car_fin + leyenda + num_dig + "/100 Cts.)"
Return num_car_fin

** Unidades
Procedure unidads
Parameter uni,dec,cen
Do Case
	Case uni = 1 .And. dec#1
		ctexto = "Un "
	Case uni = 2 .And. dec#1
		ctexto = "Dos "
	Case uni = 3 .And. dec#1
		ctexto = "Tres "
	Case uni = 4 .And. dec#1
		ctexto = "Cuatro "
	Case uni = 5 .And. dec#1
		ctexto = "Cinco "
	Case uni = 6
		ctexto = "Seis "
	Case uni = 7
		ctexto = "Siete "
	Case uni = 8
		ctexto = "Ocho "
	Case uni = 9
		ctexto = "Nueve "
	OtherWise
		ctexto = ""
EndCase
Return ctexto

** Centenas
Procedure centena
Parameter uni,dec,cen
Do Case
	Case cen=1 .And. (dec=0 .And. uni=0)
		ctexto = "Cien "
	Case cen=1 .And. (dec>0 .Or. uni>0)
		ctexto = "Ciento "
	Case cen=2
		ctexto = "Doscientos "
	Case cen=3
		ctexto = "Trescientos "
	Case cen=4
		ctexto = "Cuatrocientos "
	Case cen=5
		ctexto = "Quinientos "
	Case cen=6
		ctexto = "Seiscientos "
	Case cen=7
		ctexto = "Setecientos "
	Case cen=8
		ctexto = "Ochocientos "
	Case cen=9
		ctexto = "Novecientos "
	OtherWise
		ctexto = ""
EndCase
Return ctexto

** Decenas
Procedure decenas
Parameter uni,dec,cen
Do Case
	Case dec=1 .and. uni=0
		ctexto = "Diez "
	Case dec=1 .and. uni=1
		ctexto = "Once "
	Case dec=1 .and. uni=2
		ctexto = "Doce "
	Case dec=1 .and. uni=3
		ctexto = "Trece "
	Case dec=1 .and. uni=4
		ctexto = "Catorce "
	Case dec=1 .and. uni=5
		ctexto = "Quince "
	Case dec=1 .and. (uni>5 .and. uni<10)
		ctexto = "Dieci"
	Case dec=2 .and. uni=0
		ctexto = "Veinte "
	Case dec=2 .and. uni>0
		ctexto = "Veinti"
	Case dec=3 .and. uni=0
		ctexto = "Treinta "
	Case dec=3 .and. uni>0
		ctexto = "Treinta y "
	Case dec=4 .and. uni=0
		ctexto = "Cuarenta "
	Case dec=4 .and. uni>0
		ctexto = "Cuarenta y "
	Case dec=5 .and. uni=0
		ctexto = "Cincuenta "
	Case dec=5 .and. uni>0
		ctexto = "Cincuenta y "
	Case dec=6 .and. uni=0
		ctexto = "Sesenta "
	Case dec=6 .and. uni>0
		ctexto = "Sesenta y "
	Case dec=7 .and. uni=0
		ctexto = "Setenta "
	Case dec=7 .and. uni>0
		ctexto = "Setenta y "
	Case dec=8 .and. uni=0
		ctexto = "Ochenta "
	Case dec=8 .and. uni>0
		ctexto = "Ochenta y "
	Case dec=9 .and. uni=0
		ctexto = "Noventa "
	Case dec=9 .and. uni>0
		ctexto = "Noventa y "
	OtherWise
		ctexto = ""
EndCase
Return ctexto

** 
* Calculo_DC Function 
* 
* Calcula el DC de una cuenta bancaria en España. 
* Recibe como parámetros: 
* lnB - código de banco y agencia 
* lnC - número de cuenta 
* 
* @author Javier Leyba <jleyba@leyba.com.ar> 
* @version 1.0 - Aug 2002 
* 
*/ 

function calculo_dc(lnB, lnC) 
LOCAL lnD1, lnD2, laPeso, lcBcoOf, lcCuenta, lnResto

lnD1 = 0
lnD2 = 0
DIMENSION laPeso(10)
store 1 to laPeso(1)
store 2 to laPeso(2)
store 4 to laPeso(3)
store 8 to laPeso(4)
store 5 to laPeso(5)
store 10 to laPeso(6)
store 9 to laPeso(7)
store 7 to laPeso(8)
store 3 to laPeso(9)
store 6 to laPeso(10)

*--$peso = array(1,2,4,8,5,10,9,7,3,6); 

lcBcoOf = ALLT(STR(lnB))

if (LEN(lcBcoOf) < 8) 
	lcBcoOf = PADL(lcBcoOf, 8, "0")
endif

for i=1 to 8
	lnD1 = lnD1 + (val(substr(lcBcoOf,i,1)) * laPeso(i+2))
endfor

lnResto = lnD1 % 11
if lnResto > 1
	lnD1 = 11 - lnResto
else
	lnD1 = lnResto
endif


lcCuenta = ALLT(STR(lnC)) 

if LEN(lcCuenta) < 10
	lcCuenta = PADL(lcCuenta, 10, "0")
endif

for i = 1 to 10
	lnD2 = lnD2 + ( val( substr(lcCuenta,i,1) )* laPeso[i] )
endfor

lnResto = lnD2 % 11
if lnResto > 1
	lnD2 = 11 - lnResto
else
	lnD2 = lnResto
endif
return (lnD1 * 10) + lnD2

PROCEDURE AutoReport
**************************************************************
* Autogeneracion de un listado (report rapido) partiendo de un
* cursor o tabla.
* Se autoajusta fuente, tamaño y nº de columnas a mostrar
*
* Parametros: cCursor --> Nombre del cursor/tabla origen
*                    cTitulo --> Titulo para el listado
*
* Ej: do autorepo with "micursor", "Titulo del Listado"
*
****************************************************************
LPARAMETERS cCursor, cTitulo, cCamposSeleccionados
*
LOCAL cRepo, nLong, sFont, cFont, cCampos, nMaxCol, sExtra



cRepo = SYS(2015) + '.frx'
*
IF VARTYPE(cCursor) # 'C'
  WAIT WINDOW "Faltan Datos"
ENDIF
IF VARTYPE(cTitulo) # 'C'
  cTitulo = ''
ENDIF
IF VARTYPE(cCamposSeleccionados) # 'C'
	cCamposSeleccionados= ''
ENDIF
cCamposSeleccionados=UPPER(cCamposSeleccionados)

cFont = 'Calibri'  && Fuente de letra a usar
nMaxCol = 225      && Nº máximo de columnas (depende de fuente)
nLong = 0
cCampos = ''

* Establecer anchura, limites y tamaño fuente
nCampos = AFIELDS(aCampos, cCursor)
FOR xx = 1 TO nCampos
  IF EMPTY(cCamposSeleccionados) OR ;
  	UPPER(ALLTRIM(aCampos(xx, 1))) $ cCamposSeleccionados
  	  *__ Si no se ha especificado la lista de campos o 
		*__ si si se ha hecho y el campo esta en la lista.
	  nLong = nLong + aCampos(xx, 3)
	  IF nLong > nMaxCol
	    cTitulo = cTitulo + '    ***'
	    EXIT
	  ELSE
	    IF EMPTY(cCampos)
	      cCampos = cCampos + aCampos(xx,1)
	    ELSE
	      cCampos = cCampos + ', ' +aCampos(xx,1)
	    ENDIF
	  ENDIF
   ENDIF
ENDFOR

* Ajusto tamaño de fuente depende long. datos
* 'sExtra' para ajustar campos (depende de ver. VFP)
DO CASE
  CASE nLong > 190
    sFont = 7
    sExtra = IIF(VERSION(5) / 100 = 9, 120, -320)

  CASE nLong > 160
    sFont = 8
    sExtra = IIF(VERSION(5) / 100 = 9, 200, -170)

  CASE nLong > 135
    sFont = 9
    sExtra = IIF(VERSION(5) / 100 = 9, 360, -110)

  OTHERWISE
    sFont = 10
    sExtra = IIF(VERSION(5) / 100 = 9, 450, 180)
ENDCASE

* Crear un report y pasar a realizar ajustes
CREATE REPORT (cRepo) FROM DBF(cCursor) FIELDS &cCampos COLUMN WIDTH 256
*
USE (cRepo) IN 0 ALIAS mirepor EXCL
SELECT mirepor
*
* Cambiar texto 'Page' por 'Página' en caso de runtime en ingles
REPLACE EXPR WITH ["Página "] FOR ALLTRIM(EXPR) = ["Page "] IN mirepor
*
* Cambiar la fuente para todos 'labels' y 'campos'
REPLACE ALL fontface WITH cFont FOR INLIST(objtype, 5, 8)

* Cambiar tamaño fuente y estilo para 'labels' encabezado columnas
REPLACE ALL FONTSIZE WITH sFont, fontstyle WITH 3  FOR objtype=5 AND Vpos=0 IN mirepor

* Reducir tamaño fuente para todos 'campos'
REPLACE ALL FONTSIZE WITH sFont - 1  FOR objtype = 8

* Cambiar tamaño fuente y estilo para 'labels' y 'campos' del pie de pagina
REPLACE FONTSIZE WITH sFont - 1, fontstyle WITH 2 FOR ALLTRIM(EXPR) = [DATE()] IN mirepor
REPLACE FONTSIZE WITH sFont - 1, fontstyle WITH 2 FOR ALLTRIM(EXPR) = ["Página "] IN mirepor
REPLACE FONTSIZE WITH sFont - 1, fontstyle WITH 2 FOR ALLTRIM(EXPR) = [_PAGENO] IN mirepor
*
* Añadir línea separación en pie de pagina
GOTO TOP
LOCATE FOR ALLTRIM(mirepor.EXPR) = [_PAGENO]
miW = mirepor.hpos + mirepor.WIDTH + 100
miV = mirepor.Vpos -100
*
APPEND BLANK IN mirepor
REPLACE mirepor.objtype WITH 6
REPLACE mirepor.Vpos WITH miV
REPLACE mirepor.WIDTH WITH miW
REPLACE mirepor.HEIGHT WITH 105
REPLACE mirepor.penpat WITH 8
REPLACE mirepor.supalways WITH .T.
REPLACE mirepor.platform WITH 'WINDOWS'
*
* Añadir línea separación en encabezado
GOTO TOP
LOCATE FOR mirepor.objtype=5 AND mirepor.Vpos=0
*
miV = mirepor.Vpos + mirepor.HEIGHT
*
APPEND BLANK IN mirepor
REPLACE mirepor.objtype WITH 6
REPLACE mirepor.Vpos WITH miV
REPLACE mirepor.WIDTH WITH miW
REPLACE mirepor.HEIGHT WITH 105
REPLACE mirepor.penpat WITH 8
REPLACE mirepor.supalways WITH .T.
REPLACE mirepor.platform WITH 'WINDOWS'
*
* Mover todo hacia abajo, para colocar titulo
IF !EMPTY(cTitulo)
  *
  extra = 4000	&& Altura para el titulo
  GOTO TOP
  REPLACE ALL Vpos WITH Vpos + extra FOR INLIST(objtype, 5, 6, 8) IN mirepor
  REPLACE ALL HEIGHT WITH HEIGHT + extra FOR objcode = 1 IN mirepor
  *
  * Añadir Titulo
  APPEND BLANK IN mirepor
  REPLACE mirepor.platform WITH 'WINDOWS'
  REPLACE mirepor.objtype WITH 5
  REPLACE mirepor.hpos WITH 100
  REPLACE mirepor.fontface WITH cFont
  REPLACE mirepor.fontstyle WITH 4
  REPLACE mirepor.FONTSIZE WITH 16
  REPLACE mirepor.WIDTH WITH 70000
  REPLACE mirepor.HEIGHT WITH 2800
  REPLACE mirepor.supalways WITH .T.
  REPLACE mirepor.EXPR WITH ["&cTitulo"]
  REPLACE mirepor.mode WITH 1
  *
ENDIF
*
* Ajustar 'labels' columnas segun version VFP
REPLACE ALL mirepor.Vpos WITH mirepor.Vpos - sExtra FOR mirepor.objtype=5 AND mirepor.Vpos = extra
*
DELETE ALL FOR objtype = 26 IN mirepor
PACK
*
USE IN mirepor
*
* Mandar impresion
oForm = CREATEOBJECT("Form")
WITH oForm
  .CAPTION = "Vista Previa "
  .WINDOWTYPE = 1
  .WIDTH = _SCREEN.WIDTH - 16
  .HEIGHT = _SCREEN.HEIGHT - 16
  *
  SELECT &cCursor
  GOTO TOP
  REPORT FORM (cRepo) PREVIEW WINDOW (.NAME)
  *REPORT FORM (cRepo) TO PRINTER PROMPT NOCONSOLE NOEJECT
  *
  .RELEASE()
ENDWITH
*
* Borrar Report autogenerado
DELETE FILE (JUSTSTEM(cRepo) + '.frx')
DELETE FILE (JUSTSTEM(cRepo) + '.frt')
*
RETURN

*-----------------------------------------
* Nombre: 		ImprimeFacturas
* Parametros:	tcWhere, contiene la clausula 'Where' sobre gvFaCab
*				tcAoB, 'A' o 'B'
*				tlCrearTabla, si .T. crear una tabla para miCRS
* Return:		Nada
*-----------------------------------------
* Imprimir Facturas según la cláusula tcWhere
*-----------------------------------------
PROCEDURE ImprimeFacturas
LPARAMETERS tcWhere, tcAoB, tlCrearTabla

*!*	TLMPLUS: gmempr, v_gttesoc, gmclidel, gmdirenv, goobrcer, goparlin
*!*	TLMPLUS1-2: gvfacab, gofacobr, gvallin, gofalind, gopaend

*!*	GVFACAB-GVALLIN: cod_ent, num_fac, cod_def
*!*	GVFACAB-GMDIRENV: cod_cen, cod_cli, cli_amb
*!*	GVFACAB-GOFACOBR: cod_ent, cod_def, num_fac
*!*	GVFACAB-GMEMPR: cod_ent, cod_del
*!*	GVFACAB-V_GTTESOC: cod_del, cod_ent, num_fac
*!*	GVFACAB-GMCLIDEL: cod_del, cod_ent, cod_cli, cli_amb

*!*	GVALLIN-GOFALIND: cod_ent, cod_del, id_gvallin
*!*	GVALLIN-GOOBRCER: cod_del, cod_ent, cod_ocer

*!*	GOFALIND-GOPARLIN: cod_oprl, aoo_oprt, cod_ab1, cod_ent,
*!*	                   cod_del, cod_oprt
*!*	GOFALIND-GOPAEND: cod_del, cod_ent, id_gopaend, cod_opec


*__ GVFACAB-GVALLIN: cod_ent, num_fac, cod_def
*__ GVFACAB-GOFACOBR: cod_ent, cod_def, num_fac
*__ GVALLIN-GOFALIND: cod_ent, cod_del, id_gvallin
*__ GOFALIND-GOPAEND: cod_del, cod_ent, id_gopaend, cod_opec

LOCAL cmd AS String
LOCAL loTlmplus1o2

*__ Elegir el motor de base de datos segun A o B
IF tcAoB = "A"
	loTlmplus1o2 = _screen.oConTLMPLUS1
ELSE
	loTlmplus1o2 = _screen.oConTLMPLUS2
ENDIF

*!*	LOCAL cWhere AS String

*!*	cWhere = [facab.fec_fac BETWEEN '2011-06-01' AND '2011-06-10']

TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
SELECT
		facab.num_fac, facab.fec_fac, facab.cod_cli, facab.raz_cli, facab.cod_via, facab.dir_cli, facab.num_cli, facab.ref_fac, facab.tip_fac, facab.dpo_cli, facab.pob_cli, facab.cif_cli,
		facab.tot_imp, facab.cod_sas, facab.bas_fac, facab.iva_fac, facab.iiv_fac,
		facab.cod_fpg, facab.bru_fac, facab.bas_fac1, facab.bas_fac2, facab.bas_fac3,
		facab.iva_fac1, facab.iva_fac2, facab.iva_fac3, facab.iiv_fac1, facab.iiv_fac2, facab.iiv_fac3,
		fobr.cod_obr,
		lin.id_gvallin, lin.lin_fac, lin.tip_lin, lin.det_art, lin.can_abl, lin.pvp_abl, lin.importe, lin.texto,
		fal.des_fde, fal.icer_fde, fal.ccer_fde, fal.cod_fde, fal.cod_oprl, fal.aoo_oprt, fal.cod_ab1, fal.cod_ent, fal.cod_del, fal.cod_oprt,
		pae.ord_oped, pae.des_oped, pae.can_oped, pae.pvp_oped, pae.dt1_oped, pae.dt2_oped, imp_oped
	FROM pub.gvfacab facab
		LEFT OUTER JOIN pub.gofacobr fobr
		ON fobr.cod_ent = facab.cod_ent
			AND fobr.num_fac = facab.num_fac
			AND fobr.cod_def = facab.cod_def
		LEFT OUTER JOIN pub.gvallin lin
		ON lin.cod_ent = facab.cod_ent
			AND lin.num_fac = facab.num_fac
			AND lin.cod_def = facab.cod_def
		LEFT OUTER JOIN pub.gofalind fal
		ON fal.cod_ent = lin.cod_ent
			AND fal.cod_del = lin.cod_del
			AND fal.id_gvallin = lin.id_gvallin
		LEFT OUTER JOIN pub.gopaend pae
		ON pae.cod_del = fal.cod_del
			AND pae.cod_ent = fal.cod_ent
			AND pae.id_gopaend = fal.id_gopaend
			AND pae.cod_opec = fal.cod_opec
	WHERE fobr.cod_obr <> 0 
		AND <<tcWhere>>
	ORDER BY facab.num_fac, lin.lin_fac
ENDTEXT
*__ AND facab.cod_cli = 1843
*__ facab.fec_fac BETWEEN '2011-06-20' AND '2011-06-30'

loTlmplus1o2.sqlexec(cmd, "miCRS")

*__ Cargar los efectos de las facturas
TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
SELECT
		facab.num_fac,
		tesoc.efc_ppg, tesoc.fvt_ppg, tesoc.ivt_ppg, tesoc.est_ppg
	FROM pub.gvfacab facab
		INNER JOIN pub.gmtesoc tesoc
		ON tesoc.cod_ent = facab.cod_ent
			AND tesoc.num_fac = facab.num_fac
			AND tesoc.cod_def = facab.cod_def
			AND tesoc.cod_cli = facab.cod_cli
			AND tesoc.cli_amb = facab.cli_amb
	WHERE <<tcWhere>>
	ORDER BY facab.num_fac, tesoc.fvt_ppg
ENDTEXT
loTlmplus1o2.sqlexec(cmd, "crsEfectos")

*__ Agrupar los vencimientos por factura
CREATE CURSOR miEfectos (num_fac I, vtos C(250), cobrado F(12,2))

SELECT distinc num_fac FROM crsEfectos ORDER BY num_fac INTO CURSOR crsNumFac
SCAN ALL
	SELECT crsEfectos
	lcFechas = ""
	lnCobrado = 0.00
	SCAN ALL FOR crsEfectos.num_fac = crsNumFac.num_fac
		lcFechas = lcFechas + " " + DTOC(crsEfectos.fvt_ppg)
		lnCobrado = lnCobrado + IIF(crsEfectos.est_ppg = "C", crsEfectos.ivt_ppg, 0)
	ENDSCAN
	lcFechas = SUBSTR(lcFechas, 2)
	INSERT INTO miEfectos (num_fac, vtos, cobrado) VALUES (crsNumFac.num_fac, lcFechas, lnCobrado)
	SELECT crsNumFac
ENDSCAN

*!*	GOFALIND-GOPARLIN: cod_oprl, aoo_oprt, cod_ab1, cod_ent,
*!*	                   cod_del, cod_oprt
SELECT distinct id_gvallin, cod_oprl, aoo_oprt, cod_ab1, cod_ent, cod_del, cod_oprt, ;
		cod_fpg ;
	FROM miCRS ;
	WHERE cod_obr <> 0 ;
	ORDER BY miCrs.id_gvallin ;
	INTO CURSOR crsGvallin
	
SELECT distinct cod_oprt FROM crsGvallin ;
	WHERE cod_oprt>0 AND NOT ISNULL(cod_oprt) AND aoo_oprt = "A" ;  &&Solo P. administracion
		AND cod_ab1 = tcAoB  ;
	ORDER BY cod_oprt ;
	INTO CURSOR crsGoparlin

*__ Poner los nº de partes en una cadena separada por comas
LOCAL cad as String, cad1 as String
STORE "" TO cad, cad1

SELECT crsGoparlin
SCAN ALL
	cad = cad + "," + ALLTRIM(STR(crsGoparlin.cod_oprt))
ENDSCAN

IF NOT EMPTY(cad)
	*__ Tiene lineas de partes
	cad1 = "ctr.cod_oprt in ("+SUBSTR(cad,2)+")"		&& Copia para los contratos
	*__ Quitar la primera coma
	cad = "AND plin.cod_oprt in ("+SUBSTR(cad,2)+")"

	TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
		SELECT
			plin.cod_oprt, plin.ord_oprl, plin.cod_art, plin.des_oprl, plin.can_oprl, plin.cod_uea, plin.pvp_oprl, plin.dt1_oprl, plin.dt2_oprl, plin.imp_oprl, plin.cod_ab1
		FROM pub.goparlin plin
		WHERE plin.aoo_oprt = 'A' AND plin.cod_ab1 = '<<tcAoB>>' <<cad>>
		ORDER BY plin.cod_oprt, plin.ord_oprl
	ENDTEXT
	_screen.oConTLMPLUS.sqlexec(cmd, "crsGoparlin")

	*__ Obtener las lineas de contratos
	TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
		SELECT
			ctr.cod_oprt, ctr.cod_fea
		FROM pub.atalbctr ctr
		WHERE <<cad1>>
		ORDER BY ctr.cod_oprt, ctr.cod_fea
	ENDTEXT
	loTlmplus1o2.sqlexec(cmd, "crsContratos")
ENDIF

*__ Obtener las FORMAS DE PAGO
TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
	SELECT
		cod_fpg, nom_fpg
	FROM pub.gmfopag
	ORDER BY cod_fpg
ENDTEXT
_screen.oConTLMPLUS.sqlexec(cmd, "crsGmfopag")

*__ Es necesario para la clausula GROUP BY del siguiente SELECT
SET ENGINEBEHAVIOR 70

*__ Unir TODOS los cursores
*__ Si no hay lineas de partes
IF NOT EMPTY(cad)
	*__ HAY partes de administracion
	SELECT miCRS.*, tcAoB as AoB, ;
			plin.ord_oprl, plin.cod_art, plin.des_oprl, plin.can_oprl, plin.cod_uea, plin.pvp_oprl, plin.dt1_oprl, plin.dt2_oprl, plin.imp_oprl, ;
			pag.nom_fpg, efe.vtos, ctr.cod_fea, efe.cobrado ;
		 FROM miCRS ;
		 LEFT OUTER JOIN crsGoparlin plin ;
			ON plin.cod_oprt = miCRS.cod_oprt ;
		 LEFT OUTER JOIN crsGmfopag pag ;
		 	ON pag.cod_fpg = miCRS.cod_fpg ;
		 LEFT OUTER JOIN miEfectos efe ;
		 	ON efe.num_fac = miCRS.num_fac ;
		 LEFT OUTER JOIN crsContratos ctr ;
		 	ON ctr.cod_oprt = miCRS.cod_oprt ;
		ORDER BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt, plin.ord_oprl ;
		GROUP BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt, plin.ord_oprl ;
		INTO CURSOR miCRS
		IF tlCrearTabla
			SELECT * FROM miCRS ;
				ORDER BY num_fac, lin_fac, cod_oprt, ord_oprl ;
				INTO TABLE miCRS.dbf
		ENDIF
ELSE
	*__ NO HAY partes de administracion
	SELECT miCRS.*, tcAoB as AoB, ;
			0 as ord_oprl, '' as cod_art, '' as des_oprl, ;
			0 as can_oprl, '' as cod_uea, 0 as pvp_oprl, ;
			0 as dt1_oprl, 0 as dt2_oprl, 0 as imp_oprl, ;
			pag.nom_fpg, efe.vtos, {} as cod_fea, efe.cobrado ;
		 FROM miCRS ;
		 LEFT OUTER JOIN crsGmfopag pag ;
		 	ON pag.cod_fpg = miCRS.cod_fpg ;
		 LEFT OUTER JOIN miEfectos efe ;
		 	ON efe.num_fac = miCRS.num_fac ;
		ORDER BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt ;
		GROUP BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt ;
		INTO CURSOR miCRS
		IF tlCrearTabla
			SELECT * FROM miCRS ;
				ORDER BY num_fac, lin_fac, cod_oprt ;
				INTO TABLE miCRS.dbf
		ENDIF
ENDIF
SELECT miCRS
*__ Restaurar el comportamiento
SET ENGINEBEHAVIOR 80

*__ El cursor para el listado es: miCRS
*__ Cerrar el resto de cursores
IF USED("")
	USE IN crsGmfopag
ENDIF
IF USED("crsGmfopag")
	USE IN crsGmfopag
ENDIF
IF USED("crsContratos")
	USE IN crsContratos
ENDIF
IF USED("crsGoparlin")
	USE IN crsGoparlin
ENDIF
IF USED("crsGvallin")
	USE IN crsGvallin
ENDIF
IF USED("miEfectos")
	USE IN miEfectos
ENDIF
IF USED("crsEfectos")
	USE IN crsEfectos
ENDIF
IF USED("crsNumFac")
	USE IN crsNumFac
ENDIF
RETURN

*-----------------------------------------
* Nombre: 		ImprimeHistoricoFacturas
* Parametros:	tcLista, contiene una lista con el formato:
*				empresa/year/serie/numero/oon
*				999/9999/A/99999999/A
* Return:		Nada
*-----------------------------------------
PROCEDURE ImprimeHistoricoFacturas
LPARAMETERS tcLista

*__ LÓGICA:
*__ Son dos tablas: hist_facs (cabecera) y hist_facline (líneas)
*__ Se relacionan mediante los campos: empresa, year, serie, numero y oon
*__ La relación será INNER JOIN

*__ Los datos de clientes vendran de la tabla 'clientes_old'
*__ La relación sera LEFT OUTER JOIN

LOCAL cmd AS String

TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
	SELECT 	cab.*,  
		lin.linea, lin.alcode, lin.arcode, lin.arname, lin.cajas, lin.unidades,
	    lin.precio, lin.descuento, lin.importe, lin.iva,
	    c.nombre_fiscal, c.nombre_comercial, c.cif, c.direccion, c.localidad,
	    c.codigo_postal, c.provincia
	  FROM hist_facs cab
	  	LEFT OUTER JOIN clientes_old c
	    	ON c.codigo = cab.clcode
	    INNER JOIN hist_facline lin
	    	ON lin.empresa = cab.empresa AND lin.year = cab.year AND
	        	lin.serie = cab.serie AND lin.numero = cab.numero AND
	            lin.oon = cab.oon
	  WHERE cab.clave IN (<<tcLista>>)
	  ORDER BY cab.clcode, cab.fecha, cab.empresa, cab.year, cab.serie, cab.numero, cab.oon
ENDTEXT
*__ Crear el cursor
_screen.oConMysql.sqlexec(cmd, "miCRS")
*_cliptext = cmd
RETURN

********************************************************
* FUNCIONES PARA REPORT: Factura_detalle.frx
********************************************************
PROCEDURE Factura_detalle_on_entry
total_cobrado = total_cobrado + micrs.cobrado
total_facturas = total_facturas + micrs.tot_imp
total_pendiente = total_facturas - total_cobrado
RETURN

********************************************************
* FUNCIONES PARA REPORT: Clientes_pa_pendientes.frx
********************************************************
PROCEDURE clientes_pa_pendientes_cod_cli_on_entry
LPARAMETERS pcCodigo
LOCAL lnImp, lnTot
lnImp=imp_oprt
lnTot=tot_oprt
*__ Por si es un ABONO
IF coa_oprt = "A"
	lnImp = lnImp * (-1)
	lnTot = lnTot * (-1)
ENDIF
	
DO CASE
CASE pcCodigo = "S"
	*__ Sumar
	pv_base_cliente=pv_base_cliente+lnImp
	pv_total_cliente=pv_total_cliente+lnTot
	pv_base_final=pv_base_final+lnImp
	pv_total_final=pv_total_final+lnTot
CASE pcCodigo = "R1"
	*__ Reset cliente
	STORE 0.00 TO pv_base_cliente, pv_total_cliente
CASE pcCodigo = "R2"
	*__ Reset total
	STORE 0.00 TO pv_base_final, pv_total_final
ENDCASE
RETURN
