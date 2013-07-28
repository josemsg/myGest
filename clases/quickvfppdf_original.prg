**************************************************
*-- Class Library:  quickfrx2pdf.vcx
**************************************************
*!*	EXTERNAL FILE iSEDQuickPDF.dll
*!*	EXTERNAL PROCEDURE iSEDNewDocument 
*!*	EXTERNAL PROCEDURE iSEDSaveToFile 
*!*	EXTERNAL PROCEDURE iSEDCompressContent 
*!*	EXTERNAL PROCEDURE iSEDAddImageFromFile 
*!*	EXTERNAL PROCEDURE iSEDCompressImages 
*!*	EXTERNAL PROCEDURE iSEDNewPage 
*!*	EXTERNAL PROCEDURE iSEDRemoveDocument 
*!*	EXTERNAL PROCEDURE iSEDLastErrorCode 
*!*	EXTERNAL PROCEDURE iSEDUnlockKey 
*!*	EXTERNAL PROCEDURE iSEDDrawImage 
*!*	EXTERNAL PROCEDURE iSEDSetMeasurementUnits
*!*	EXTERNAL PROCEDURE iSEDSetOrigin 
*!*	EXTERNAL PROCEDURE iSEDSetPageDimensions 
*!*	EXTERNAL PROCEDURE iSEDSetPageSize 
*!*	EXTERNAL PROCEDURE iSEDSetInformation 
*!*	EXTERNAL PROCEDURE iSEDEncrypt 
*!*	EXTERNAL PROCEDURE iSEDPermissions 
*!*	EXTERNAL PROCEDURE iSEDDrawText 

**************************************************
*-- Class:        pdflistener1
*-- ParentClass:  reportlistener
*-- BaseClass:    reportlistener
*-- TimeStamp:    2005/10/13 09:55:20
*-- Listener to Create PDF Files
*
*
DEFINE CLASS pdflistener1 AS reportlistener

   Height = 23
   Width = 23
   ListenerType = 3
   FRXDataSession = -1
   SendGDIPlusImage = 1
   lfirstreportinset = .T.
   *--  XML Metadata for customizable properties
*!*	   _memberdata = [<VFPData><memberdata name="declarepdfdll" type="method" ]+;
*!*	   		[display="DeclarePdfDll"/><memberdata name="lfirstreportinset" ]+;
*!*	   		[type="property" display="lFirstReportinSet"/><memberdata ]+;
*!*	   		[name="startpdfdocument" type="method" display="StartPdfDocument"/>]+;
*!*	   		[<memberdata name="targetfilename" type="property" ]+;
*!*	   		[display="TargetFileName"/><memberdata name="pdfhandle" type="property" ]+;
*!*	   		[display="PdfHandle"/><memberdata name="pageheight" type="property" ]+;
*!*	   		[display="PageHeight"/><memberdata name="pagewidth" type="property" ]+;
*!*	   		[display="PageWidth"/><memberdata name="writepdfinformation" ]+;
*!*	   		[type="method" display="WritePdfInformation"/><memberdata ]+;
*!*	   		[name="pdfauthor" type="property" display="PdfAuthor"/>]+;
*!*	   		[<memberdata name="pdftitle" type="property" display="PdfTitle"/>]+;
*!*	   		[<memberdata name="pdfsubject" type="property" display="PdfSubject"/>]+;
*!*	   		[<memberdata name="pdfkeywords" type="property" display="PdfKeyWords"/>]+;
*!*	   		[<memberdata name="pdfcreator" type="property" display="PdfCreator"/>]+;
*!*	   		[<memberdata name="pdfproducer" type="property" display="PdfProducer"/>]+;
*!*	   		[<memberdata name="encryptpdf" type="method" display="EncryptPdf"/>]+;
*!*	   		[<memberdata name="encryptdocument" type="property" ]+;
*!*	   		[display="EncryptDocument"/><memberdata name="encryptionlevel" ]+;
*!*	   		[type="property" display="EncryptionLevel"/><memberdata ]+;
*!*	   		[name="masterpassword" type="property" display="MasterPassword"/>]+;
*!*	   		[<memberdata name="userpassword" type="property" display="UserPassword"/>]+;
*!*	   		[<memberdata name="canprint" type="property" display="CanPrint"/>]+;
*!*	   		[<memberdata name="openviewer" type="property" display="OpenViewer"/>]+;
*!*	   		[<memberdata name="oprogress" type="property" display="oProgress"/>]+;
*!*	   		[<memberdata name="oregistry" type="property" display="oRegistry"/>]+;
*!*	   		[<memberdata name="shellexec" type="method" display="ShellExec"/>]+;
*!*	   		[<memberdata name="validatetrial" type="method" display="ValidateTrial"/>]+;
*!*	   		[<memberdata name="ocrypt" type="property" display="oCrypt"/>]+;
*!*	   		[<memberdata name="resetdatasession" type="method" ]+;
*!*	   		[display="ResetDataSession"/><memberdata name="setfrxdatasession" ]+;
*!*	   		[type="method" display="SetFRXDataSession"/><memberdata ]+;
*!*	   		[name="fontcollection" type="property" display="FontCollection"/>]+;
*!*	   		[<memberdata name="lastpageproccesed" type="property" ]+;
*!*	   		[display="LastPageProccesed"/><memberdata name="addfonts" ]+;
*!*	   		[type="method" display="AddFonts"/><memberdata name="getfontstyle" ]+;
*!*	   		[type="method" display="GetFontStyle"/><memberdata name="searchfont" ]+;
*!*	   		[type="method" display="SearchFont"/><memberdata name="started" ]+;
*!*	   		[type="property" display="Started"/><memberdata name="proccessfields" ]+;
*!*	   		[type="method" display="ProccessFields"/><memberdata ]+;
*!*	   		[name="proccesslabel" type="method" display="ProccessLabel"/>]+;
*!*	   		[<memberdata name="proccesslines" type="method" display="ProccessLines"/>]+;
*!*	   		[<memberdata name="proccesspictures" type="method" ]+;
*!*	   		[display="ProccessPictures"/><memberdata name="proccessshapes" ]+;
*!*	   		[type="method" display="ProccessShapes"/><memberdata name="canaddnotes" ]+;
*!*	   		[type="property" display="CanAddNotes"/><memberdata name="cancopy" ]+;
*!*	   		[type="property" display="CanCopy"/><memberdata name="canedit" ]+;
*!*	   		[type="property" display="CanEdit"/></VFPData>]
*!*	      
   *--  Handle for the Pdf Document To Generate
   pdfhandle = 0
   *--  Height of The Report Pages
   pageheight = 0
   *--  Width of Report Pages
   pagewidth = 0
   *--  Pdf Author
   pdfauthor = "Piscinas Pepe"
   *--  Pdf Title
   pdftitle = "Piscinas Pepe gestor de listados en PDF"
   *--  Pdf Subject
   pdfsubject = "Copyright 2011 Piscinas Pepe"
   *--  Pdf Keywords
   pdfkeywords = ""
   *--  Pdf Creator
   pdfcreator = "José María Sánchez"
   *--  Pdf Producer
   pdfproducer = "José María Sánchez"
   *--  Property to Know if the Document Will Be Encrypted
   encryptdocument = .F.
   *--  Accepts a Value of 0 Or 1, 0 = Standard 40-bit encryption. 1 = Advanced 128-bit encryption.
   encryptionlevel = 1
   *--  Master Password of the Pdf Document
   masterpassword = ""
   *--  User Pasword of the Document
   userpassword = ""
   *--  If 1 User will be allowed to print the document, if 0 he won't
   canprint = 1
   *--  Property to Store Progress Bar
   oprogress = .F.
   *--  If .T. Adobe Reader will be opened
   openviewer = .F.
   oregistry = .F.
   PROTECTED ocrypt
   ocrypt = .F.
   *--  Property to Know if the report proccess Starts
   started = .F.
   *--  Property to Know wich was the last page proccesed
   lastpageproccesed = 1
   targetfilename = ""
   *--  Property to let the user Copy the text in PDF File
   cancopy = 1
   *--  Property to Allow  User to Edit Document
   canedit = 0
   *--  Property to let user add notes to PDF FIle
   canaddnotes = 0
   divisionfactor = 960
   currentfont = ""
   currentfontsize = 0
   currentfontstyle = ""
   Name = "pdflistener1"

   *-- 
   DIMENSION fontcollection[1,1]

**
   *-- Method to start pdf generation
   PROTECTED PROCEDURE startpdfdocument
      LOCAL lnreturn AS NUMBER
      lnreturn = 0
      WITH this
         .declarepdfdll()
         isedcompresscontent()
         isedsavetofile(.targetfilename)
         .targetfilename = SUBSTR(.targetfilename, 1, LEN(ALLTRIM(.targetfilename))-3)+"Pdf"
         IF .encryptdocument
            IF .encryptpdf()<>0
               lnreturn = -4
            ENDIF
         ENDIF
         isedsavetofile(.targetfilename)
         isedremovedocument(.pdfhandle)
         IF .openviewer
            .shellexec(.targetfilename)
         ENDIF
      ENDWITH
      RETURN lnreturn
   ENDPROC
**
   *-- Method to Start Dll Declarations
   PROCEDURE declarepdfdll
      IF FILE("iSEDQuickPDF.dll")
         DECLARE INTEGER CLSIDFromString IN ole32 STRING, STRING @
         DECLARE INTEGER GdipSaveImageToFile IN GDIPLUS.DLL INTEGER, STRING, STRING @, INTEGER
         DECLARE LONG iSEDNewDocument IN "iSEDQuickPDF.dll" AS "iSEDNewDocument"
         DECLARE LONG iSEDSaveToFile IN "iSEDQuickPDF.dll" AS "iSEDSaveToFile" STRING
         DECLARE LONG iSEDCompressContent IN "iSEDQuickPDF.dll" AS "iSEDCompressContent"
         DECLARE LONG iSEDAddImageFromFile IN "iSEDQuickPDF.dll" AS "iSEDAddImageFromFile" STRING, LONG
         DECLARE LONG iSEDCompressImages IN "iSEDQuickPDF.dll" AS "iSEDCompressImages" LONG
         DECLARE LONG iSEDNewPage IN "iSEDQuickPDF.dll" AS "iSEDNewPage"
         DECLARE LONG iSEDRemoveDocument IN "iSEDQuickPDF.dll" AS "iSEDRemoveDocument" LONG
         DECLARE LONG iSEDLastErrorCode IN "iSEDQuickPDF.dll" AS "iSEDLastErrorCode"
         DECLARE LONG iSEDUnlockKey IN "iSEDQuickPDF.dll" AS "iSEDUnlockKey" STRING
         DECLARE LONG iSEDDrawImage IN "iSEDQuickPDF.dll" AS "iSEDDrawImage" DOUBLE, DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDSetMeasurementUnits IN "iSEDQuickPDF.dll" AS "iSEDSetMeasurementUnits" LONG
         DECLARE LONG iSEDSetOrigin IN "iSEDQuickPDF.dll" AS "iSEDSetOrigin" LONG
         DECLARE LONG iSEDSetPageDimensions IN "iSEDQuickPDF.dll" AS "iSEDSetPageDimensions" DOUBLE, DOUBLE
         DECLARE LONG iSEDSetPageSize IN "iSEDQuickPDF.dll" AS "iSEDSetPageSize" STRING
         DECLARE LONG iSEDSetInformation IN "iSEDQuickPDF.dll" AS "iSEDSetInformation" LONG, STRING
         DECLARE LONG iSEDEncrypt IN "iSEDQuickPDF.dll" AS "iSEDEncrypt" STRING, STRING, LONG, LONG
         DECLARE LONG iSEDPermissions IN "iSEDQuickPDF.dll" AS "iSEDPermissions" LONG, LONG, LONG, LONG, LONG, LONG, LONG, LONG
         DECLARE LONG iSEDDrawText IN "iSEDQuickPDF.dll" AS "iSEDDrawText" DOUBLE, DOUBLE, STRING
         DECLARE LONG iSEDSetTextColor IN "iSEDQuickPDF.dll" AS "iSEDSetTextColor" DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDCompressFonts IN "iSEDQuickPDF.dll" AS "iSEDCompressFonts" LONG
         DECLARE LONG iSEDSetTextAlign IN "iSEDQuickPDF.dll" AS "iSEDSetTextAlign" LONG
         DECLARE LONG iSEDSetTextSize IN "iSEDQuickPDF.dll" AS "iSEDSetTextSize" DOUBLE
         DECLARE LONG iSEDSetFontFlags IN "iSEDQuickPDF.dll" AS "iSEDSetFontFlags" LONG, LONG, LONG, LONG, LONG, LONG, LONG, LONG
         DECLARE LONG iSEDAddTrueTypeFont IN "iSEDQuickPDF.dll" AS "iSEDAddTrueTypeFont" STRING, LONG
         DECLARE LONG iSEDSelectFont IN "iSEDQuickPDF.dll" AS "iSEDSelectFont" LONG
         DECLARE LONG iSEDSetTextUnderline IN "iSEDQuickPDF.dll" AS "iSEDSetTextUnderline" LONG
         DECLARE LONG iSEDSetTextUnderlineColor IN "iSEDQuickPDF.dll" AS "iSEDSetTextUnderlineColor" DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDDrawBox IN "iSEDQuickPDF.dll" AS "iSEDDrawBox" DOUBLE, DOUBLE, DOUBLE, DOUBLE, LONG
         DECLARE LONG iSEDDrawLine IN "iSEDQuickPDF.dll" AS "iSEDDrawLine" DOUBLE, DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDSetFillColor IN "iSEDQuickPDF.dll" AS "iSEDSetFillColor" DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDSetLineColor IN "iSEDQuickPDF.dll" AS "iSEDSetLineColor" DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDDrawRoundedBox IN "iSEDQuickPDF.dll" AS "iSEDDrawRoundedBox" DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, LONG
         DECLARE LONG iSEDDrawWrappedText IN "iSEDQuickPDF.dll" AS "iSEDDrawWrappedText" DOUBLE, DOUBLE, DOUBLE, STRING
         DECLARE LONG iSEDDrawScaledImage IN "iSEDQuickPDF.dll" AS "iSEDDrawScaledImage" DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDDrawMultiLineText IN "iSEDQuickPDF.dll" AS "iSEDDrawMultiLineText" DOUBLE, DOUBLE, STRING, STRING
         DECLARE LONG iSEDFitTextBox IN "iSEDQuickPDF.dll" AS "iSEDFitTextBox" DOUBLE, DOUBLE, DOUBLE, DOUBLE, STRING, LONG
         DECLARE LONG iSEDSetLineWidth IN "iSEDQuickPDF.dll" AS "iSEDSetLineWidth" DOUBLE
         DECLARE LONG iSEDAddSubsettedFont IN "iSEDQuickPDF.dll" AS "iSEDAddSubsettedFont" STRING, LONG, STRING
         DECLARE STRING iSEDGetSubsetString IN "iSEDQuickPDF.dll" AS "iSEDGetSubsetString" STRING
         DECLARE DOUBLE iSEDGetTextWidth IN "iSEDQuickPDF.dll" AS "iSEDGetTextWidth" STRING
         DECLARE DOUBLE iSEDGetTextHeight IN "iSEDQuickPDF.dll" AS "iSEDGetTextHeight"
         DECLARE INTEGER GetActiveWindow IN WIN32API
         DECLARE INTEGER GetDC IN WIN32API INTEGER
         DECLARE INTEGER GetDeviceCaps IN WIN32API INTEGER, INTEGER
         RETURN 0
      ELSE
      		MESSAGEBOX("iSEDQuickPDF.dll Not Found in Path", 64, "QuickFRX2PDF")
         IF this.quietmode
            RETURN -1
         ELSE
            MESSAGEBOX("iSEDQuickPDF.dll Not Found in Path", 64, "QuickFRX2PDF")
            RETURN -1
         ENDIF
      ENDIF
   ENDPROC
**
   *-- Writes Information About the File
   PROTECTED PROCEDURE writepdfinformation
      WITH this
         IF  .NOT. EMPTY(.pdfauthor)
            isedsetinformation(1, .pdfauthor)
         ENDIF
         IF  .NOT. EMPTY(.pdftitle)
            isedsetinformation(2, .pdftitle)
         ENDIF
         IF  .NOT. EMPTY(.pdfsubject)
            isedsetinformation(3, .pdfsubject)
         ENDIF
         IF  .NOT. EMPTY(.pdfkeywords)
            isedsetinformation(4, .pdfkeywords)
         ENDIF
         IF  .NOT. EMPTY(.pdfcreator)
            isedsetinformation(5, .pdfcreator)
         ENDIF
         IF  .NOT. EMPTY(.pdfproducer)
            isedsetinformation(6, .pdfproducer)
         ENDIF
      ENDWITH
   ENDPROC
**
   *-- Method to Encrypt the Pdf Document
   PROTECTED PROCEDURE encryptpdf
      LOCAL lnpermiso AS LONG
      WITH this
         .canprint = 1
         lnpermiso = isedpermissions(0, .cancopy, .canedit, .canaddnotes, 0, 0, 0, 1)
         l = isedencrypt(.masterpassword, .userpassword, .encryptionlevel, lnpermiso)
         l2 = isedlasterrorcode()
         RETURN l
      ENDWITH
   ENDPROC
**
   PROTECTED PROCEDURE shellexec
      LPARAMETERS lclink, lcaction, lcparms
      lcaction = IIF(EMPTY(lcaction), "Open", lcaction)
      lcparms = IIF(EMPTY(lcparms), "", lcparms)
      DECLARE INTEGER ShellExecute IN SHELL32.Dll INTEGER, STRING, STRING, STRING, STRING, INTEGER
      DECLARE INTEGER FindWindow IN WIN32API STRING, STRING
      RETURN shellexecute(findwindow(0, _SCREEN.caption), lcaction, lclink, lcparms, SYS(2023), 1)
   ENDPROC
**
   *-- Method to Validate 30 Days Limit
   PROTECTED PROCEDURE validatetrial
      RETURN .T.
   ENDPROC
**
   PROCEDURE setfrxdatasession
      IF (this.frxdatasession>-1) .AND. (this.frxdatasession<>SET("DATASESSION"))
         TRY
            SET DATASESSION TO (this.frxdatasession)
         CATCH WHEN .T.
            this.resettodefault("FRXDataSession")
            this.resetdatasession()
         ENDTRY
      ENDIF
   ENDPROC
**
   PROCEDURE resetdatasession
      TRY
         SET DATASESSION TO (this.currentdatasession)
      CATCH WHEN .T.
      ENDTRY
   ENDPROC
**
   *-- Method to Obtain the Style of a Font
   PROCEDURE getfontstyle
      LPARAMETERS lnstyle AS INTEGER
      LOCAL locollection AS COLLECTION
      locollection = CREATEOBJECT("Collection")
      locollection.add(BITTEST(lnstyle, 0))
      locollection.add(BITTEST(lnstyle, 1))
      locollection.add(BITTEST(lnstyle, 3))
      locollection.add(BITTEST(lnstyle, 7))
      RETURN locollection
   ENDPROC
**
   PROCEDURE searchfont
      LPARAMETERS lcfontname AS STRING, lnstyle AS INTEGER, lncodepage AS INTEGER
      this.currentfont = lcfontname
      IF BITTEST(lnstyle, 0)
         lcfontname = lcfontname+" [Bold]"
         this.currentfontstyle = "B"
      ELSE
         this.currentfontstyle = ""
      ENDIF
      IF BITTEST(lnstyle, 1)
         IF "["$lcfontname
            lcfontname = SUBSTR(lcfontname, 1, LEN(ALLTRIM(lcfontname))-1)+"Italic]"
         ELSE
            lcfontname = lcfontname+" [Italic]"
         ENDIF
         this.currentfontstyle = this.currentfontstyle+"I"
      ENDIF
      IF  .NOT. EMPTY(lncodepage)
         DO CASE
            CASE lncodepage=204
               lcfontname = lcfontname+" {1251}"
               this.divisionfactor = 960
            CASE lncodepage=161
               lcfontname = lcfontname+" {1253}"
               this.divisionfactor = 960
            CASE lncodepage=162
               lcfontname = lcfontname+" {1254}"
               this.divisionfactor = 960
            CASE lncodepage=186
               lcfontname = lcfontname+" {1257}"
               this.divisionfactor = 960
            OTHERWISE
               lcfontname = lcfontname+" {1250}"
               this.divisionfactor = 960
         ENDCASE
      ENDIF
      LOCAL lnresult AS INTEGER
      lnresult = ASCAN(this.fontcollection, lcfontname, -1, -1, 1, 15)
      IF lnresult<>0
         RETURN this.fontcollection(lnresult, 2)
      ELSE
         DIMENSION this.fontcollection(ALEN(this.fontcollection, 1)+1, 2)
         this.fontcollection(ALEN(this.fontcollection, 1), 1) = lcfontname
         this.fontcollection(ALEN(this.fontcollection, 1), 2) = isedaddtruetypefont(lcfontname, 0)
         RETURN this.fontcollection(ALEN(this.fontcollection, 1), 2)
      ENDIF
   ENDPROC
**
   *-- Method to Proccess Label Objects
   PROTECTED PROCEDURE proccesslabel
      LPARAMETERS lcfontface AS STRING, lifontstyle AS INTEGER, lnfontsize AS NUMBER, lnpenred AS NUMBER, lnpengreen AS NUMBER, lnpenblue AS NUMBER, lnfillred AS NUMBER, lnfillgreen AS NUMBER, lnfillblue AS NUMBER, nleft AS NUMBER, ntop AS NUMBER, lccontents AS STRING, lcfillchar AS STRING, lnoffset AS INTEGER, newwidth AS INTEGER, lncodepage AS INTEGER
      ntop = ntop/this.divisionfactor
      nleft = nleft/this.divisionfactor
      isedselectfont(this.searchfont(lcfontface, lifontstyle, lncodepage))
      isedsettextsize(lnfontsize)
      IF  .NOT. BITTEST(lifontstyle, 7)
         isedsettextunderline(IIF(BITTEST(lifontstyle, 3), 1, 0))
      ELSE
         isedsettextunderline(3)
      ENDIF
      isedsettextcolor(lnpenred, lnpengreen, lnpenblue)
      IF lnoffset=1
         isedsettextalign(2)
         iseddrawwrappedtext(nleft, ntop, newwidth, lccontents)
      ELSE
         lnoffset = ICASE(lnoffset=0, 0, lnoffset=1, 2, lnoffset=2, 1)
         isedsettextalign(lnoffset)
         iseddrawtext(nleft, ntop, lccontents)
      ENDIF
   ENDPROC
**
   *-- Method to Proccess Field Objects
   PROTECTED PROCEDURE proccessfields
      LPARAMETERS lcfontface AS STRING, lifontstyle AS INTEGER, lnfontsize AS NUMBER, lnpenred AS NUMBER, lnpengreen AS NUMBER, lnpenblue AS NUMBER, lnfillred AS NUMBER, lnfillgreen AS NUMBER, lnfillblue AS NUMBER, nleft AS NUMBER, ntop AS NUMBER, lccontents AS STRING, lcfillchar AS STRING, lnoffset AS INTEGER, newwidth AS INTEGER, lbstretch AS BOOLEAN, newheight AS INTEGER, lncodepage AS INTEGER
      LOCAL lnlenght AS NUMBER, lnalto AS NUMBER, lnlargo AS NUMBER, lnlargo2 AS NUMBER, lipixelsperinchx AS NUMBER, lipixelsperinchy AS NUMBER, lihdc AS INTEGER
      ntop = ntop/this.divisionfactor
      nleft = nleft/this.divisionfactor
      isedselectfont(this.searchfont(lcfontface, lifontstyle, lncodepage))
      isedsettextsize(lnfontsize)
      lnresta = 0
      IF  .NOT. BITTEST(lifontstyle, 7)
         isedsettextunderline(IIF(BITTEST(lifontstyle, 3), 1, 0))
      ELSE
         isedsettextunderline(3)
      ENDIF
      isedsettextcolor(lnpenred, lnpengreen, lnpenblue)
      IF lnoffset=1
         isedsettextalign(2)
         IF  .NOT. lbstretch
            iseddrawwrappedtext(nleft, ntop, newwidth, lccontents)
         ELSE
            lnlenght = isedgettextwidth(lccontents)
            IF lnlenght<=newwidth
               iseddrawwrappedtext(nleft, ntop, newwidth, lccontents)
            ELSE
               lihwnd = getactivewindow()
               lihdc = getdc(lihwnd)
               lipixelsperinchx = getdevicecaps(lihdc, 88)
               lipixelsperinchy = getdevicecaps(lihdc, 90)
               lnlargo = FONTMETRIC(6, this.currentfont, lnfontsize, this.currentfontstyle)/lipixelsperinchx
               lnalto = FONTMETRIC(1, this.currentfont, lnfontsize, this.currentfontstyle)/lipixelsperinchy
               lnlargo2 = LEN(lccontents)
               DO WHILE  .NOT. EMPTY(lccontents)
                  IF isedgettextwidth(lccontents)>newwidth
                     DO WHILE SUBSTR(lccontents, ((newwidth/lnlargo)-lnresta), 1)<>" "
                        lnresta = lnresta+lnlargo
                     ENDDO
                  ENDIF
                  lcstring = SUBSTR(lccontents, 1, (newwidth/lnlargo))
                  iseddrawwrappedtext(nleft, ntop, newwidth, lcstring)
                  lccontents = ALLTRIM(STUFF(lccontents, 1, LEN(lcstring), ""))
                  ntop = ntop+lnalto
                  lnresta = 0
               ENDDO
            ENDIF
         ENDIF
      ELSE
         lnoffset = ICASE(lnoffset=0, 0, lnoffset=1, 2, lnoffset=2, 1)
         isedsettextalign(lnoffset)
         IF  .NOT. lbstretch
            iseddrawwrappedtext(nleft, ntop, newwidth, lccontents)
         ELSE
            lnlenght = isedgettextwidth(lccontents)
            IF lnlenght<=newwidth
               iseddrawwrappedtext(nleft, ntop, newwidth, lccontents)
            ELSE
               lihwnd = getactivewindow()
               lihdc = getdc(lihwnd)
               lipixelsperinchx = getdevicecaps(lihdc, 88)
               lipixelsperinchy = getdevicecaps(lihdc, 90)
               lnlargo = FONTMETRIC(6, this.currentfont, lnfontsize, this.currentfontstyle)/lipixelsperinchx
               lnalto = FONTMETRIC(1, this.currentfont, lnfontsize, this.currentfontstyle)/lipixelsperinchy
               lnlargo2 = LEN(lccontents)
               DO WHILE  .NOT. EMPTY(lccontents)
                  IF isedgettextwidth(lccontents)>newwidth
                     DO WHILE SUBSTR(lccontents, ((newwidth/lnlargo)-lnresta), 1)<>" "
                        lnresta = lnresta+lnlargo
                     ENDDO
                  ENDIF
                  lcstring = SUBSTR(lccontents, 1, (newwidth/lnlargo)-lnresta)
                  iseddrawtext(nleft, ntop, lcstring)
                  lccontents = ALLTRIM(STUFF(lccontents, 1, LEN(lcstring), ""))
                  ntop = ntop+lnalto
                  lnresta = 0
               ENDDO
            ENDIF
         ENDIF
      ENDIF
   ENDPROC
**
   *-- Method to Proccess Shapes Objects
   PROTECTED PROCEDURE proccessshapes
      LPARAMETERS lnfillred AS INTEGER, lnfillgreen AS INTEGER, lnfillblue AS INTEGER, lnpenred AS INTEGER, lnpengreen AS INTEGER, lnpenblue AS INTEGER, nleft AS NUMBER, ntop AS NUMBER, nwidth AS NUMBER, nheight AS NUMBER, lnoffset AS INTEGER, lnpensize AS INTEGER
      IF lnfillred<>-1 .AND. lnfillgreen<>-1 .AND. lnfillblue<>-1
         isedsetfillcolor(lnfillred/255, lnfillgreen/255, lnfillblue/255)
      ENDIF
      isedsetlinecolor(lnpenred/255, lnpengreen/255, lnpenblue/255)
      IF lnpensize>1
         isedsetlinewidth(lnpensize/960)
      ELSE
         isedsetlinewidth(0)
      ENDIF
      IF lnoffset=0
         iseddrawbox(nleft/960, (ntop/960)-0.15 , nwidth/960, nheight/960, 2)
      ELSE
         iseddrawroundedbox(nleft/960, (ntop/960)-0.15 , nwidth/960, nheight/960, (lnoffset/960)+0.1 , 2)
      ENDIF
   ENDPROC
**
   *-- Method to Proccess Lines Objects
   PROTECTED PROCEDURE proccesslines
      LPARAMETERS lnpenred AS INTEGER, lnpengreen AS INTEGER, lnpenblue AS INTEGER, ntop AS NUMBER, nleft AS NUMBER, nwidth AS NUMBER, nheight AS NUMBER, lnpensize AS INTEGER, lnoffset AS NUMBER
      isedsetlinecolor(lnpenred/255, lnpengreen/255, lnpenblue/255)
      IF lnoffset=1
         IF lnpensize>1
            isedsetlinewidth(nheight/960)
         ELSE
            isedsetlinewidth(0)
         ENDIF
         iseddrawline(nleft/960, (ntop/960)-0.15 , (nleft/960)+(nwidth/960), (ntop/960)-0.15 )
      ELSE
         IF lnpensize>1
            isedsetlinewidth(nwidth/960)
         ELSE
            isedsetlinewidth(0)
         ENDIF
         iseddrawline(nleft/960, (ntop/960)-0.15 , (nleft/960), ((ntop/960)+(nheight/960))-0.15 )
      ENDIF
   ENDPROC
**
   *-- Method to Proccess Pictures
   PROTECTED PROCEDURE proccesspictures
      LPARAMETERS ntop AS NUMBER, nleft AS NUMBER, nwidth AS NUMBER, nheight AS NUMBER, lccontents AS STRING, gdiplusimage AS NUMBER, lnoffset AS INTEGER, lipicturemode AS INTEGER
      IF gdiplusimage<>0
         IF lnoffset=1
            m.lcid = REPLICATE(CHR(0), 16)
            l = clsidfromstring(STRCONV("{557CF401-1A04-11D3-9A73-0000F81EF32E}"+CHR(0), 5), @m.lcid)
            IF l=0
               lcfile = GETENV("TEMP")+"\"+SYS(2015)+".Jpg"+CHR(0)
               gdipsaveimagetofile(m.gdiplusimage, STRCONV(lcfile, 5), m.lcid, 0)
            ELSE
               WAIT WINDOW "Error Getting ID"
            ENDIF
         ENDIF
      ELSE
         IF FILE(lccontents)
            lcfile = GETENV("TEMP")+"\"+SYS(2015)+JUSTEXT(lccontents)
            COPY FILE (lccontents) TO (lcfile)
         ENDIF
      ENDIF
      *__ AQUI
      *__ He añadido el -15 en el 'ntop' de abajo
      IF FILE(lcfile)
         isedaddimagefromfile(lcfile, 0)
         IF lipicturemode=0 .OR. lipicturemode=1
            iseddrawimage(nleft/960, (ntop/960), nwidth/960, nheight/960)
         ELSE
            iseddrawscaledimage(nleft/960, (ntop/960), 1)
         ENDIF
      ENDIF
      DELETE FILE (lcfile)
   ENDPROC
**
   PROCEDURE AfterReport
      this.lfirstreportinset =  .NOT. (this.commandclauses.nopageeject)
      DODEFAULT()
   ENDPROC
**
   PROCEDURE Init
      DODEFAULT()
      RETURN this.validatetrial()
   ENDPROC
**
   PROCEDURE GetPageHeight
      this.pageheight = DODEFAULT()/960
   ENDPROC
**
   PROCEDURE GetPageWidth
      this.pagewidth = DODEFAULT()/960
   ENDPROC
**
   PROCEDURE UnloadReport
      DODEFAULT()
      WITH this
         .startpdfdocument()
      ENDWITH
   ENDPROC
**
   PROCEDURE BeforeReport
      WITH this
         IF .declarepdfdll()=0
            isedunlockkey("313046302352633F1B1C44F1592AA809")
         ENDIF
      ENDWITH
   ENDPROC
**
   PROCEDURE Render
      LPARAMETERS nfrxrecno, nleft, ntop, nwidth, nheight, nobjectcontinuationtype, ccontentstoberendered, gdiplusimage
      LOCAL lccontents AS STRING, liobjtype AS INTEGER, liobjcode AS INTEGER, lnpenblue AS NUMBER, lnpengreen AS NUMBER, lnpenred AS NUMBER, lnfillblue AS NUMBER, lnfillgreen AS NUMBER, lnfillred AS NUMBER, lcfontface AS STRING, lifontstyle AS INTEGER, lnfontsize AS NUMBER, limode AS INTEGER, lnoffset AS INTEGER, lcfillchar AS STRING, lipicturemode AS INTEGER, lbstretch AS BOOLEAN, lnpensize AS INTEGER, lncodepage AS INTEGER
      WITH this
         .setfrxdatasession()
         IF  .NOT. .started
            *MESSAGEBOX("Trial Version of QuickFRX2PDF Please Register at www.crystalvfpclass.com", 64, "QuickFRX2PDF")
            .pdfhandle = isednewdocument()
            isedcompressimages(1)
            isedcompressfonts(1)
            .writepdfinformation()
            isedsetorigin(1)
            isedsetmeasurementunits(2)
            isedsetpagedimensions(.pagewidth, .pageheight)
            .started = .T.
            *__ Vamos a quitar esto porque queda muy feo
            *-->iseddrawtext(1, this.pageheight-0.2 , "Unregistered Version Comercial Use Prohibed, Contact at www.crystalvfpclass.com")
         ENDIF
         IF .pageno<>.lastpageproccesed
            isednewpage()
            .lastpageproccesed = .pageno
            *__ Vamos a quitar esto porque queda muy feo
            *-->iseddrawtext(1, this.pageheight-0.2 , "Unregistered Version Comercial Use Prohibed, Contact at www.crystalvfpclass.com")
         ENDIF
         IF EMPTY(ccontentstoberendered)
            lccontents = ''
         ENDIF
         GOTO nfrxrecno IN frx
         liobjtype = frx.objtype
         liobjcode = frx.objcode
         lnpenblue = frx.penblue
         lnpengreen = frx.pengreen
         lnpenred = frx.penred
         lnfillblue = frx.fillblue
         lnfillgreen = frx.fillgreen
         lnfillred = frx.fillred
         lcfontface = frx.fontface
         lifontstyle = frx.fontstyle
         lnfontsize = frx.fontsize
         limode = frx.mode
         lnoffset = frx.offset
         lcfillchar = frx.fillchar
         newwidth = frx.width
         newheight = frx.height
         lipicturemode = frx.general
         lbstretch = frx.stretch
         lnpensize = frx.pensize
         lncodepage = frx.resoid
         .resetdatasession()
         DO CASE
            CASE liobjtype=5
               IF  .NOT. EMPTY(lncodepage) .AND. lncodepage<>1
                  lccontents = STRCONV(ccontentstoberendered, 6, lncodepage, 2)
                  this.tag = lccontents
               ELSE
                  lccontents = STRCONV(ccontentstoberendered, 6)
                  this.tag = ""
               ENDIF
               .proccesslabel(lcfontface, lifontstyle, lnfontsize, lnpenred, lnpengreen, lnpenblue, lnfillred, lnfillgreen, lnfillblue, nleft, ntop, lccontents, lcfillchar, lnoffset, newwidth/10000, lncodepage)
            CASE liobjtype=8
               IF  .NOT. EMPTY(lncodepage) .AND. lncodepage<>1
                  lccontents = STRCONV(ccontentstoberendered, 6, lncodepage, 2)
                  this.tag = lccontents
               ELSE
                  lccontents = STRCONV(ccontentstoberendered, 6)
                  this.tag = ""
               ENDIF
               .proccessfields(lcfontface, lifontstyle, lnfontsize, lnpenred, lnpengreen, lnpenblue, lnfillred, lnfillgreen, lnfillblue, nleft, ntop, lccontents, lcfillchar, lnoffset, newwidth/10000, lbstretch, newheight/10000, lncodepage)
            CASE liobjtype=6
               .proccesslines(lnpenred, lnpengreen, lnpenblue, ntop, nleft, nwidth, nheight, lnpensize, lnoffset)
            CASE liobjtype=17
               lccontents = ccontentstoberendered
               .proccesspictures(ntop, nleft, nwidth, nheight, lccontents, gdiplusimage, lnoffset, lipicturemode)
            CASE liobjtype=7
               .proccessshapes(lnfillred, lnfillgreen, lnfillblue, lnpenred, lnpengreen, lnpenblue, nleft, ntop, nwidth, nheight, lnoffset, lnpensize)
         ENDCASE
      ENDWITH
   ENDPROC
**

ENDDEFINE
*
*-- EndDefine: pdflistener1
**************************************************


**************************************************
*-- Class:        pdflistener2
*-- ParentClass:  reportlistener
*-- BaseClass:    reportlistener
*-- TimeStamp:    2005/10/13 09:55:32
*-- Listener to Create PDF Files
*
*
DEFINE CLASS pdflistener2 AS reportlistener

   Height = 23
   Width = 23
   ListenerType = 2
   FRXDataSession = -1
   lfirstreportinset = .T.
   targetfilename = "PdfFile"
   *--  XML Metadata for customizable properties
*!*	   _memberdata = [<VFPData><memberdata name="declarepdfdll" type="method" ]+;
*!*	   		[display="DeclarePdfDll"/><memberdata name="lfirstreportinset" ]+;
*!*	   		[type="property" display="lFirstReportinSet"/><memberdata ]+;
*!*	   		[name="startpdfdocument" type="method" display="StartPdfDocument"/>]+;
*!*	   		[<memberdata name="targetfilename" type="property" ]+;
*!*	   		[display="TargetFileName"/><memberdata name="pdfhandle" type="property" ]+;
*!*	   		[display="PdfHandle"/><memberdata name="pageheight" type="property" ]+;
*!*	   		[display="PageHeight"/><memberdata name="pagewidth" type="property" ]+;
*!*	   		[display="PageWidth"/><memberdata name="writepdfinformation" ]+;
*!*	   		[type="method" display="WritePdfInformation"/><memberdata ]+;
*!*	   		[name="pdfauthor" type="property" display="PdfAuthor"/>]+;
*!*	   		[<memberdata name="pdftitle" type="property" display="PdfTitle"/>]+;
*!*	   		[<memberdata name="pdfsubject" type="property" display="PdfSubject"/>]+;
*!*	   		[<memberdata name="pdfkeywords" type="property" display="PdfKeyWords"/>]+;
*!*	   		[<memberdata name="pdfcreator" type="property" display="PdfCreator"/>]+;
*!*	   		[<memberdata name="pdfproducer" type="property" display="PdfProducer"/>]+;
*!*	   		[<memberdata name="encryptpdf" type="method" display="EncryptPdf"/>]+;
*!*	   		[<memberdata name="encryptdocument" type="property" ]+;
*!*	   		[display="EncryptDocument"/><memberdata name="encryptionlevel" ]+;
*!*	   		[type="property" display="EncryptionLevel"/><memberdata ]+;
*!*	   		[name="masterpassword" type="property" display="MasterPassword"/>]+;
*!*	   		[<memberdata name="userpassword" type="property" display="UserPassword"/>]+;
*!*	   		[<memberdata name="canprint" type="property" display="CanPrint"/>]+;
*!*	   		[<memberdata name="openviewer" type="property" display="OpenViewer"/>]+;
*!*	   		[<memberdata name="oprogress" type="property" display="oProgress"/>]+;
*!*	   		[<memberdata name="oregistry" type="property" display="oRegistry"/>]+;
*!*	   		[<memberdata name="shellexec" type="method" display="ShellExec"/>]+;
*!*	   		[<memberdata name="validatetrial" type="method" display="ValidateTrial"/>]+;
*!*	   		[<memberdata name="ocrypt" type="property" display="oCrypt"/>]+;
*!*	   		[<memberdata name="resetdatasession" type="method" ]+;
*!*	   		[display="ResetDataSession"/><memberdata name="setfrxdatasession" ]+;
*!*	   		[type="method" display="SetFRXDataSession"/><memberdata ]+;
*!*	   		[name="fontcollection" type="property" display="FontCollection"/>]+;
*!*	   		[<memberdata name="lastpageproccesed" type="property" ]+;
*!*	   		[display="LastPageProccesed"/><memberdata name="addfonts" ]+;
*!*	   		[type="method" display="AddFonts"/><memberdata name="getfontstyle" ]+;
*!*	   		[type="method" display="GetFontStyle"/><memberdata name="searchfont" ]+;
*!*	   		[type="method" display="SearchFont"/><memberdata name="started" ]+;
*!*	   		[type="property" display="Started"/><memberdata name="proccessfields" ]+;
*!*	   		[type="method" display="ProccessFields"/><memberdata ]+;
*!*	   		[name="proccesslabel" type="method" display="ProccessLabel"/>]+;
*!*	   		[<memberdata name="proccesslines" type="method" display="ProccessLines"/>]+;
*!*	   		[<memberdata name="proccesspictures" type="method" ]+;
*!*	   		[display="ProccessPictures"/><memberdata name="proccessshapes" ]+;
*!*	   		[type="method" display="ProccessShapes"/><memberdata name="canaddnotes" ]+;
*!*	   		[type="property" display="CanAddNotes"/><memberdata name="cancopy" ]+;
*!*	   		[type="property" display="CanCopy"/><memberdata name="canedit" ]+;
*!*	   		[type="property" display="CanEdit"/></VFPData>]
*!*	   		
*!*		TEXT TO _memberdata NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2+4+8
*!*		   <VFPData>
*!*		   <memberdata name="declarepdfdll" type="method" display="DeclarePdfDll"/>
*!*		   <memberdata name="lfirstreportinset" type="property" display="lFirstReportinSet"/>
*!*		   <memberdata name="startpdfdocument" type="method" display="StartPdfDocument"/>
*!*		   <memberdata name="targetfilename" type="property" display="TargetFileName"/>
*!*		   <memberdata name="pdfhandle" type="property" display="PdfHandle"/>
*!*		   <memberdata name="pageheight" type="property" display="PageHeight"/>
*!*		   <memberdata name="pagewidth" type="property" display="PageWidth"/>
*!*		   <memberdata name="writepdfinformation" type="method" display="WritePdfInformation"/>
*!*		   <memberdata name="pdfauthor" type="property" display="PdfAuthor"/>
*!*		   <memberdata name="pdftitle" type="property" display="PdfTitle"/>
*!*		   <memberdata name="pdfsubject" type="property" display="PdfSubject"/>
*!*		   <memberdata name="pdfkeywords" type="property" display="PdfKeyWords"/>
*!*		   <memberdata name="pdfcreator" type="property" display="PdfCreator"/>
*!*		   <memberdata name="pdfproducer" type="property" display="PdfProducer"/>
*!*		   <memberdata name="encryptpdf" type="method" display="EncryptPdf"/>
*!*		   <memberdata name="encryptdocument" type="property" display="EncryptDocument"/>
*!*		   <memberdata name="encryptionlevel" type="property" display="EncryptionLevel"/>
*!*		   <memberdata name="masterpassword" type="property" display="MasterPassword"/>
*!*		   <memberdata name="userpassword" type="property" display="UserPassword"/>
*!*		   <memberdata name="canprint" type="property" display="CanPrint"/>
*!*		   <memberdata name="openviewer" type="property" display="OpenViewer"/>
*!*		   <memberdata name="oprogress" type="property" display="oProgress"/>
*!*		   <memberdata name="oregistry" type="property" display="oRegistry"/>
*!*		   <memberdata name="shellexec" type="method" display="ShellExec"/>
*!*		   <memberdata name="validatetrial" type="method" display="ValidateTrial"/>
*!*		   <memberdata name="ocrypt" type="property" display="oCrypt"/>
*!*		   </VFPData>
*!*	   ENDTEXT
*!*	   
   
   *--  Handle for the Pdf Document To Generate
   pdfhandle = 0
   *--  Height of The Report Pages
   pageheight = 0
   *--  Width of Report Pages
   pagewidth = 0
   *--  Pdf Author
   pdfauthor = "Piscinas Pepe"
   *--  Pdf Title
   pdftitle = "Piscinas Pepe gestor de listados en PDF"
   *--  Pdf Subject
   pdfsubject = "Copyright 2011 Piscinas Pepe"
   *--  Pdf Keywords
   pdfkeywords = ""
   *--  Pdf Creator
   pdfcreator = "José María Sánchez"
   *--  Pdf Producer
   pdfproducer = "José María Sánchez"
   *--  Property to Know if the Document Will Be Encrypted
   encryptdocument = .F.
   *--  Accepts a Value of 0 Or 1, 0 = Standard 40-bit encryption. 1 = Advanced 128-bit encryption.
   encryptionlevel = 1
   *--  Master Password of the Pdf Document
   masterpassword = ""
   *--  User Pasword of the Document
   userpassword = ""
   *--  If 1 User will be allowed to print the document, if 0 he won't
   canprint = 1
   *--  Property to Store Progress Bar
   oprogress = .F.
   *--  If .T. Adobe Reader will be opened
   openviewer = .F.
   oregistry = .F.
   PROTECTED ocrypt
   ocrypt = .F.
   Name = "pdflistener2"


**
   *-- Method to start pdf generation
   PROTECTED PROCEDURE startpdfdocument
      LOCAL lnreturn AS NUMBER
      lnreturn = 0
      WITH this
         .declarepdfdll()
         .targetfilename = SUBSTR(.targetfilename, 1, LEN(ALLTRIM(.targetfilename))-3)+"Pdf"
         isedcompresscontent()
         isedsavetofile(.targetfilename)
         IF .encryptdocument
            IF .encryptpdf()<>0
               lnreturn = -4
            ENDIF
         ENDIF
         isedsavetofile(.targetfilename)
         isedremovedocument(.pdfhandle)
         DELETE FILE (.temporaryfilename)
         IF .openviewer
            .shellexec(.targetfilename)
         ENDIF
      ENDWITH
      RETURN lnreturn
   ENDPROC
**
   *-- Method to Start Dll Declarations
   PROCEDURE declarepdfdll
      IF FILE("iSEDQuickPDF.dll")
         DECLARE LONG iSEDNewDocument IN "iSEDQuickPDF.dll" AS "iSEDNewDocument"
         DECLARE LONG iSEDSaveToFile IN "iSEDQuickPDF.dll" AS "iSEDSaveToFile" STRING
         DECLARE LONG iSEDCompressContent IN "iSEDQuickPDF.dll" AS "iSEDCompressContent"
         DECLARE LONG iSEDAddImageFromFile IN "iSEDQuickPDF.dll" AS "iSEDAddImageFromFile" STRING, LONG
         DECLARE LONG iSEDCompressImages IN "iSEDQuickPDF.dll" AS "iSEDCompressImages" LONG
         DECLARE LONG iSEDNewPage IN "iSEDQuickPDF.dll" AS "iSEDNewPage"
         DECLARE LONG iSEDRemoveDocument IN "iSEDQuickPDF.dll" AS "iSEDRemoveDocument" LONG
         DECLARE LONG iSEDLastErrorCode IN "iSEDQuickPDF.dll" AS "iSEDLastErrorCode"
         DECLARE LONG iSEDUnlockKey IN "iSEDQuickPDF.dll" AS "iSEDUnlockKey" STRING
         DECLARE LONG iSEDDrawImage IN "iSEDQuickPDF.dll" AS "iSEDDrawImage" DOUBLE, DOUBLE, DOUBLE, DOUBLE
         DECLARE LONG iSEDSetMeasurementUnits IN "iSEDQuickPDF.dll" AS "iSEDSetMeasurementUnits" LONG
         DECLARE LONG iSEDSetOrigin IN "iSEDQuickPDF.dll" AS "iSEDSetOrigin" LONG
         DECLARE LONG iSEDSetPageDimensions IN "iSEDQuickPDF.dll" AS "iSEDSetPageDimensions" DOUBLE, DOUBLE
         DECLARE LONG iSEDSetPageSize IN "iSEDQuickPDF.dll" AS "iSEDSetPageSize" STRING
         DECLARE LONG iSEDSetInformation IN "iSEDQuickPDF.dll" AS "iSEDSetInformation" LONG, STRING
         DECLARE LONG iSEDEncrypt IN "iSEDQuickPDF.dll" AS "iSEDEncrypt" STRING, STRING, LONG, LONG
         DECLARE LONG iSEDPermissions IN "iSEDQuickPDF.dll" AS "iSEDPermissions" LONG, LONG, LONG, LONG, LONG, LONG, LONG, LONG
         DECLARE LONG iSEDDrawText IN "iSEDQuickPDF.dll" AS "iSEDDrawText" DOUBLE, DOUBLE, STRING
         RETURN 0
      ELSE
      	MESSAGEBOX("iSEDQuickPDF.dll Not Found in Path", 64, "QuickFRX2PDF")
         IF this.quietmode
            RETURN -1
         ELSE
            MESSAGEBOX("iSEDQuickPDF.dll Not Found in Path", 64, "QuickFRX2PDF")
            RETURN -1
         ENDIF
      ENDIF
   ENDPROC
**
   PROCEDURE targetfilename_assign
      LPARAMETERS vnewval
      this.targetfilename = m.vnewval
      this.temporaryfilename = GETENV("TEMP")+"\"+JUSTSTEM(this.targetfilename)+".Jpg"
   ENDPROC
**
   *-- Writes Information About the File
   PROTECTED PROCEDURE writepdfinformation
      WITH this
         IF  .NOT. EMPTY(.pdfauthor)
            isedsetinformation(1, .pdfauthor)
         ENDIF
         IF  .NOT. EMPTY(.pdftitle)
            isedsetinformation(2, .pdftitle)
         ENDIF
         IF  .NOT. EMPTY(.pdfsubject)
            isedsetinformation(3, .pdfsubject)
         ENDIF
         IF  .NOT. EMPTY(.pdfkeywords)
            isedsetinformation(4, .pdfkeywords)
         ENDIF
         IF  .NOT. EMPTY(.pdfcreator)
            isedsetinformation(5, .pdfcreator)
         ENDIF
         IF  .NOT. EMPTY(.pdfproducer)
            isedsetinformation(6, .pdfproducer)
         ENDIF
      ENDWITH
   ENDPROC
**
   *-- Method to Encrypt the Pdf Document
   PROTECTED PROCEDURE encryptpdf
      LOCAL lnpermiso AS LONG
      WITH this
         .canprint = 1
         lnpermiso = isedpermissions(.canprint, 1, 0, 0, 0, 0, 0, 1)
         RETURN isedencrypt(.masterpassword, .userpassword, .encryptionlevel, lnpermiso)
      ENDWITH
   ENDPROC
**
   PROTECTED PROCEDURE shellexec
      LPARAMETERS lclink, lcaction, lcparms
      lcaction = IIF(EMPTY(lcaction), "Open", lcaction)
      lcparms = IIF(EMPTY(lcparms), "", lcparms)
      DECLARE INTEGER ShellExecute IN SHELL32.Dll INTEGER, STRING, STRING, STRING, STRING, INTEGER
      DECLARE INTEGER FindWindow IN WIN32API STRING, STRING
      RETURN shellexecute(findwindow(0, _SCREEN.caption), lcaction, lclink, lcparms, SYS(2023), 1)
   ENDPROC
**
   *-- Method to Validate 30 Days Limit
   PROTECTED PROCEDURE validatetrial
      RETURN .T.
   ENDPROC
**
   PROCEDURE UnloadReport
      DODEFAULT()
      WITH this
         .startpdfdocument()
      ENDWITH
   ENDPROC
**
   PROCEDURE GetPageWidth
      this.pagewidth = DODEFAULT()/960
   ENDPROC
**
   PROCEDURE GetPageHeight
      this.pageheight = DODEFAULT()/960
   ENDPROC
**
   PROCEDURE Init
      DODEFAULT()
      WITH this
         .addproperty("TemporaryFileName", "", 1)
         RETURN .validatetrial()
      ENDWITH
   ENDPROC
**
   PROCEDURE AfterReport
      this.lfirstreportinset =  .NOT. (this.commandclauses.nopageeject)
      DODEFAULT()
   ENDPROC
**
   PROCEDURE OutputPage
      LPARAMETERS npageno, edevice, ndevicetype, nleft, ntop, nwidth, nheight, nclipleft, ncliptop, nclipwidth, nclipheight
      WITH this
         IF (ndevicetype==-1)
            IF (npageno==1 .AND. .lfirstreportinset)
               ndevicetype = 102
               IF .declarepdfdll()=0
                  *MESSAGEBOX("Trial Version of QuickFRX2PDF Please Register at www.crystalvfpclass.com", 64, "QuickFRX2PDF")
                  isedunlockkey("313046302352633F1B1C44F1592AA809")
                  .pdfhandle = isednewdocument()
                  .writepdfinformation()
                  isedsetorigin(1)
                  isedsetmeasurementunits(2)
                  isedsetpagedimensions(.pagewidth, .pageheight)
                  isedcompressimages(1)
               ENDIF
            ELSE
               isednewpage()
               ndevicetype = 102
            ENDIF
            .outputpage(npageno, .temporaryfilename, ndevicetype)
            NODEFAULT
            isedaddimagefromfile(.temporaryfilename, 0)
            iseddrawimage(0, 0, .pagewidth, .pageheight)
            *__ Vamos a quitar esto porque queda muy feo
            *-->iseddrawtext(1, .pageheight-0.2 , "Unregistered Version Comercial Use Prohibed, Contact at www.crystalvfpclass.com")
         ENDIF
      ENDWITH
   ENDPROC
**

ENDDEFINE
*
*-- EndDefine: pdflistener2
**************************************************

