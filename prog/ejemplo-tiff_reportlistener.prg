*__ EJEMPLO DE REPORTLISTENER -> TIFF mas abajo
*________________________________________________

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

Local loListener As ReportListener
loListener = createobject('TiffListener')

*__ Construir filtro para Facturas A
IF NOT EMPTY(lcListaA)
	lcWhere = [facab.num_fac IN (] + lcListaA + ")"
	*__ Construir el cursor del listado miCRS
	ImprimeFacturas(lcWhere, "A")
	*__ Llamar al Report
	Report Form Reports\Factura.frx Object loListener
	IF USED("miCRS")
		USE IN miCRS
	ENDIF
ENDIF

*__ Construir filtro para Facturas B
IF NOT EMPTY(lcListaB)
	lcWhere = [facab.num_fac IN (] + lcListaB + ")"
	*__ Construir el cursor del listado miCRS
	ImprimeFacturas(lcWhere, "B")
	*__ Llamar al Report
	Report Form Reports\Factura.frx Object loListener
	
	IF USED("miCRS")
		USE IN miCRS
	ENDIF
ENDIF

SELECT crsFacs