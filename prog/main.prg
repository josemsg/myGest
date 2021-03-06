#INCLUDE registry.h

*__ Establecer algunos SET de entorno
CLEAR
CLOSE ALL
SET ESCAPE OFF
SET EXCLUSIVE OFF
SET TALK OFF
SET DATE TO DMY
SET HOURS TO 24
SET MULTILOCKS ON
SET SAFETY OFF
SET DELETED ON
SET CENTURY ON
SET SYSFORMATS ON
SET CPDIALOG OFF
SET CONFIRM	ON
SET STRICTDATE TO 0
SET POINT TO ","
SET SEPARATOR TO "."

SET REPORTBEHAVIOR 80

LOCAL lcRootPath, PathDatos,PathForms,PathReports, ;
	PathImage,PathPrg,PathMnu,PathClass

lcRootPath = JUSTPATH(SYS(16,0))
IF EMPTY(lcRootPath)
	lcRootPath = SYS(5)+SYS(2003)
ENDIF

SET DEFAULT TO (lcRootPath)
SET PATH TO ;
.\,;
.\data,;
.\prog,;
.\clases,;
.\report,;
.\graphics

*___ Cargar clases y librerias por defecto
EXTERNAL FILE iSEDQuickPDF.dll

SET CLASSLIB TO odbc, zListaDeImagenes, zForms, appClases ADDITIVE
SET PROCEDURE TO utils.prg, quickvfppdf.prg, ReportListeners.prg, ;
	ooo_automation.prg, leerxmltocursor-class.prg, ;
	recursive-dir-class.prg

WITH _Screen
   .LockScreen=.T.                     && Disable screen redraw
   .BorderStyle=2                      && Change the border to double
   .Closable=.F.                       && Remove window control buttons
   .WindowState=2
   
   *__ A�adir TOOLBARS
   =ADDPROPERTY(_screen,'oTb_Principal')
	.oTb_Principal = CREATEOBJECT('tb_principal')
	.oTb_Principal.Show()
	.oTb_Principal.Dock(0)
   
   
   if type('_screen.Title1')!='O'
	   .AddObject ( "Title1", "Title" )
	   .AddObject ( "Title2", "Title" )
	   .Title2.Top  = .Title2.Top  - 4
	   .Title2.Left = .Title2.Left - 4
	   .Title2.ForeColor = RGB ( 255, 0, 0 )   
   endif
   .Caption="myGest v0.21 "            && Set a caption
   
   *__ A�adir propiedades para nombre de usuario en activo
   =ADDPROPERTY(_screen, 'goUser' )
   =ADDPROPERTY(_screen, 'goUserID')
   _screen.goUser = ""
   _screen.goUserID = 0
   
   .LockScreen=.F.                     && Enable screen redraw
ENDWITH


**** Agregar el objeto conexion a _SCREEN, este nos servir� en todo el
**** Proyecto, para hacer referencia a conexiones con BD
if type('_screen.oConMySql')!='O'
  _Screen.AddObject("oConMySQL","conexion") 
endif
Local lCancelar, lcCmd

*__ Vamos a probar si hacemos Login en la BD de mySql
do form dsn with _screen.oConMySql to lCancelar
IF (lCancelar)
   Messagebox("Login Cancelado",48,"Top Software")
ENDIF

IF NOT lCancelar
	*__ Vamos a crear las conexiones con la BD de Telematel
	lCancelar = CrearConexionesTelematel()
	IF lCancelar
		MESSAGEBOX("No se ha podido conectar con las bases de datos de Telematel",0+16,"Atenci�n")
	ENDIF
ENDIF

IF lCancelar
	*__ NO hemos conectado con todas las bases de datos, as� que salimos del programa
	lcCmd = LimpiarParaSalir()
	&lcCmd
ELSE
	*__ Hemos hecho login, ahora vamos a crear una conexi�n a telematel, en total 3
	
	
	do main.mpr
	
	*___ Ver si tenemos pendientes de leer usuarios_log
	
	TEXT TO cmd TEXTMERGE PRETEXT 1+2+4+8 NOSHOW
		select 0.00 as seleccionado, p.clcode, p.clcomer, p.clname,
			IF(p.tipo_log='i','IN','OUT') AS tipo_log, p.fecha_hora,
			 leido_por, id
		FROM Usuarios_log p
		where p.leido_por not like '%<<ALLTRIM(_screen.goUser)>>%'
			 or isnull(p.leido_por)
		ORDER BY p.fecha_hora DESC
	ENDTEXT
	*__ Ejecutamos la consulta y restauramos el cursor en el grid
	_screen.oConMysql.sqlExec(cmd, "crsUserLog")
	IF RECCOUNT("crsUserLog")>=1
		*__ Tenemos log�s por leer, los mostramos.
		DO FORM usuarios_log_lector.scx
	ENDIF
	IF USED("crsUserLog")
		USE IN crsUserLog
	ENDIF
	
	*__ Seguimos con el programa	
	
	
	*__ Quedamos en el buche de la aplicacii�n.
	if version(2)==0
  		read events
	ENDIF
	
ENDIF

RETURN

DEFINE CLASS Title AS LABEL
FontName= [Times New Roman]
FontSize= 72
Visible = .T.
Width	= 600
Height	= 125
Top		= _Screen.Height - 190
Left	= 25
Caption	= [myGest v0.10]
ForeColor=RGB ( 192,192,192 )
BackStyle= 0	&& Transparent
ENDDEFINE