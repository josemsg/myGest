SET STEP ON 
=imppdf("informe1.frx", "informe1_result.pdf", "d:\") 
RETURN

*---------------------------------------------------------------- 
*---------Funci�n para convertir frx a pdf automatizaci�n-------- 
*--recibe nombre reporte, nombre archivo pdf, ubicaci�n del pdf-- 
*---------------------------------------------------------------- 
FUNCTION ImpPdf 
PARAMETERS lcRepo, lcPdf, lcUbi 
	=proclase() 
	DECLARE Sleep IN WIN32API INTEGER 
	ReadyState = 0 && Variable indiquant que l'imprimante n'est pas pr�te 
	PDFCreator = CREATEOBJECT("PDFCreator.clsPDFCreator") 
	PDFReady = CREATEOBJECT("PDFEvent") && Voir d�finition de la classe plus bas 
	EVENTHANDLER(PDFCreator,PDFReady) 
	WITH PDFCreator 
		* D�marrer sans lancer les travaux : 
		.cStart ("/NoProcessingAtStartup") 
		* Options de sauvegarde : 
		.cOption("UseAutosave") = 1 
		.cOption("UseAutosaveDirectory") = 1 
		.cOption("AutosaveDirectory") = "&lcUbi" 
		.cOption("AutosaveFilename") = lcPdf 
		.cOption("AutosaveFormat") = 0 && 0 pour le format PDF 
		* Modification temporaire de l'imprimante par d�faut : 
		DefaultPrinter = .cDefaultprinter 
		.cDefaultprinter = "PDFCreator" 
		.cClearcache 
	ENDWITH 
	REPORT FORM &lcRepo TO PRINTER NOCONSOLE 
	* Lancement de l'impression : 
	PDFCreator.cPrinterStop = .F. 
	* On attend jusqu'� ce que l'imprimante soit pr�te ou que 10 secondes sesoient �coul�es : 
	c = 0 
	DO WHILE (ReadyState = 0) AND (c < 10) 
		c = c + 1 
		Sleep (500) 
	ENDDO 
	PDFCreator.cDefaultprinter = DefaultPrinter 
	Sleep (200) 
	PDFCreator.cClearcache 
	PDFCreator.cClose 
	RELEASE PDFCreator 
	RELEASE PDFReady 
ENDFUNC

PROCEDURE proclase 
	*-------------------------------------------- 
	* D�finition de la classe g�rant les �v�nements : 
	DEFINE CLASS PDFEvent AS Custom 
		IMPLEMENTS __clsPDFCreator IN "PDFCreator.clsPDFCreatorOptions" 
	* Ev�nement qui indique si l'imprimante est pr�te 
	PROCEDURE __clsPDFCreator_eReady() AS VOID 
	ReadyState = 1 
	ENDPROC

	* Gestion des erreurs 
	PROCEDURE __clsPDFCreator_eError() AS VOID 
	ENDPROC 
	ENDDEFINE 
ENDPROC


