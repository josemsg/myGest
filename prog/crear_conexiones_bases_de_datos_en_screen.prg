SET DEFAULT TO i:\micodigo\mygest
SET PATH TO ;
.\,;
.\data,;
.\prog,;
.\clases,;
.\report,;
.\graphics

SET CLASSLIB TO odbc, zListaDeImagenes, zForms, appClases ADDITIVE
SET PROCEDURE TO utils.prg, quickvfppdf.prg
lnVersionTelematel = 1

IF TYPE('_screen.oConMySQL')!='O'
  	_Screen.AddObject("oConMySQL","conexion") 
ENDIF
WITH _Screen.oConMySQL
	.Dsn = "mysql_partes_piscinaspepe"
	.User = "josemsg"
	.PassWord = "jm011914JM011914"
	.Connect()
	.zVersionTelematel = lnVersionTelematel
	
	IF NOT .Connected
		MESSAGEBOX("No se ha podido conectar a TlmPlus2",0+16,"Atención",5)
		RETURN
	ENDIF
ENDWITH

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
		RETURN
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
		RETURN
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
		RETURN
	ENDIF
ENDWITH
