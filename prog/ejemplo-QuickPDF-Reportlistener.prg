*__ EJEMPLO DE USO DE QUICKPDF, REPORTLISTENER mas abajo
*_______________________________________________________

SELECT DISTINC num_fac, aob ;
	FROM crsFacs ;
	WHERE seleccionado = 1 ;
	ORDER BY aob, num_fac ;
	INTO CURSOR miFacs

SELECT miFacs

LOCAL lcListaA as String, lcListaB as String
STORE "" TO lcListaA, lcListaB

SCAN ALL FOR aob = "A"
	lcListaA = lcListaA + "," + TRANSFORM(num_fac, "@L 999999999")
ENDSCAN

SCAN ALL FOR aob = "B"
	lcListaB = lcListaB + "," + TRANSFORM(num_fac, "@L 999999999")
ENDSCAN
IF NOT EMPTY(lcListaA)
	lcListaA = SUBSTR(lcListaA,2)
ENDIF
IF NOT EMPTY(lcListaB)
	lcListaB = SUBSTR(lcListaB,2)
ENDIF

USE IN miFacs
MESSAGEBOX("A: "+lcListaA+CHR(13)+"B: "+lcListaB, 0+64, "myGest")

*__ Construir filtro para Facturas A
IF NOT EMPTY(lcListaA)
	lcWhere = [facab.num_fac IN (] + lcListaA + ")"
	*__ Construir el cursor del listado miCRS
	ImprimeFacturas(lcWhere, "A", .t.)
	*__ Llamar al Report
	IF This.Parent.chkPDF.Value
		WITH This.Parent
			*__ Exportar a PDF
			Local loListener As ReportListener
			&&Normal Pdf
				*loListener = createobject('PdfListener1')
			&&PDF As Image
				loListener = createobject('PdfListener2')
			loListener.TargetFileName = GETFILE("pdf")
			loListener.QuietMode=.f.
			loListener.EncryptDocument=.f.
			loListener.MasterPassword=''
			loListener.UserPassword=''
			loListener.OpenViewer=.t.
			Report Form Reports\Factura.frx Object loListener
		ENDWITH
	ELSE
		REPORT FORM Reports\Factura.frx NOCONSOLE PREVIEW
	ENDIF	
	IF USED("miCRS")
		USE IN miCRS
	ENDIF
ENDIF

*__ Construir filtro para Facturas B
IF NOT EMPTY(lcListaB)
	lcWhere = [facab.num_fac IN (] + lcListaB + ")"
	*__ Construir el cursor del listado miCRS
	ImprimeFacturas(lcWhere, "B", .t.)
	*__ Llamar al Report
	IF This.Parent.chkPDF.Value
		WITH This.Parent
			*__ Exportar a PDF
			Local loListener As ReportListener
			&&Normal Pdf
				*loListener = createobject('PdfListener1')
			&&PDF As Image
				loListener = createobject('PdfListener2')
			loListener.TargetFileName = GETFILE("pdf")
			loListener.QuietMode=.f.
			loListener.EncryptDocument=.f.
			loListener.MasterPassword=''
			loListener.UserPassword=''
			loListener.OpenViewer=.t.
			Report Form Reports\Factura.frx Object loListener
		ENDWITH
	ELSE
		REPORT FORM Reports\Factura.frx NOCONSOLE PREVIEW
	ENDIF	
		
	IF USED("miCRS")
		USE IN miCRS
	ENDIF
ENDIF

SELECT crsFacs