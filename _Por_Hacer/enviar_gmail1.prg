**TODOS LOS DERECHOS RESERVADOS SON DE "ENDER QUEVEDO *** "SOFT - RYDE" 
** para utilizar este codigo primero deben tener una cuenta en gmail.com 
** no necesita un servidor smtp solo necesita acceso a la web 

LOCAL loCfg, loMsg, lcFile, loErr
TRY
  loCfg = CREATEOBJECT("CDO.Configuration")
  WITH loCfg.Fields
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "jmsanchez.ibiza@gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "jm011914"
    .Update
  ENDWITH
  loMsg = CREATEOBJECT ("CDO.Message")
  WITH loMsg
    .Configuration = loCfg
    *-- Remitenete y destinatarios
    .From = "José María Sánchez <jmsanchez.ibiza@gmail.com>"
    .To = "info@piscinaspepe.com"   &&"Usuario Uno <user1@gmail.com>"
    &&.Cc = "Usuario Dos <user2@gmail.com>"
    *- Notificación de lectura
    .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
    .Fields("urn:schemas:mailheader:return-receipt-to") = .From
    .Fields.Update
    *-- Tema
    .Subject = "Ejemplo del " + TTOC(DATETIME())
    *-- Formato HTML desde la Web
    &&.CreateMHTMLBody("http://www.portalfox.com/articulos/archivos/correo.htm", 0)
    *-- Formato texto
    .TextBody = "Este es el texto que contiene el mensaje, que es una prueba automática desde Foxpro"
    *-- Archivo adjunto
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
