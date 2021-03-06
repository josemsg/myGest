LOCAL loCfg, loMsg, lcFile, loErr
TRY
  loCfg = CREATEOBJECT("CDO.Configuration")
  WITH loCfg.Fields
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 &&465 && � 587
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "jmsanchez.ibiza@gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "jm01191413jm"
    .Update
  ENDWITH
  
  loMsg = CREATEOBJECT ("CDO.Message")
  WITH loMsg
    .Configuration = loCfg
    *-- Remitenete y destinatarios
    .From = "Jos� Mar�a S�nchez <jmsanchez.ibiza@gmail.com>"
    .To = "Piscinas Pepe <info@piscinaspepe.com>"
    *.Cc = "Usuario Dos <user2@gmail.com>"
*!*	    .To = "user1@mail.com, user2@mail.com"
*!*	 	.Cc = "user3@mail.com"
*!*		.Bcc = "user4@mail.com"

    *- Notificaci�n de lectura
    .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
    .Fields("urn:schemas:mailheader:return-receipt-to") = .From

    *-- Prioridad
	  && -1=Low, 0=Normal, 1=High
	  .Fields("urn:schemas:httpmail:priority") = 1
	  .Fields("urn:schemas:mailheader:X-Priority") = 1
	  
	*-- Importancia
	  && 0=Low, 1=Normal, 2=High
  	.Fields("urn:schemas:httpmail:importance") = 2

    .Fields.Update
    *-- Tema
    .Subject = "Ejemplo del " + TTOC(DATETIME())
    *-- Formato HTML desde la Web
    .CreateMHTMLBody("http://www.portalfox.com/articulos/archivos/correo.htm", 0)
    *-- Archivo adjunto
*!*	    .AddAttachment("C:\Imagenes\Foto1.jpg")
*!*		.AddAttachment("C:\Imagenes\Foto2.jpg")
*!*		.AddAttachment("C:\Imagenes\Foto3.jpg")

    lcFile = GETFILE()
    IF NOT EMPTY(lcFile)
      .AddAttachment(lcFile)
    ENDIF
    *-- Envio el mensaje
    .Send()
  ENDWITH
CATCH TO loErr 
  MESSAGEBOX("No se pudo enviar el mensaje" + CHR(13) + ;
    "Error: " + TRANSFORM(loErr.ErrorNo) + CHR(13) + ;
    "Mensaje: " + loErr.Message , 16, "Error")
FINALLY
  loMsg = NULL
  loCfg = NULL
ENDTRY