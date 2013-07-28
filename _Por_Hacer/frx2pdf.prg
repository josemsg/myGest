SET STEP ON 
=imppdf("informe1.frx", "informe1_result.pdf", "d:\") 
RETURN

*---------------------------------------------------------------- 
*---------Función para convertir frx a pdf automatización-------- 
*--recibe nombre reporte, nombre archivo pdf, ubicación del pdf-- 
*---------------------------------------------------------------- 
FUNCTION ImpPdf 
PARAMETERS lcRepo, lcPdf, lcUbi 
	=proclase() 
	DECLARE Sleep IN WIN32API INTEGER 
	ReadyState = 0 && Variable indiquant que l'imprimante n'est pas prête 
	PDFCreator = CREATEOBJECT("PDFCreator.clsPDFCreator") 
	PDFReady = CREATEOBJECT("PDFEvent") && Voir définition de la classe plus bas 
	EVENTHANDLER(PDFCreator,PDFReady) 
	WITH PDFCreator 
		* Démarrer sans lancer les travaux : 
		.cStart ("/NoProcessingAtStartup") 
		* Options de sauvegarde : 
		.cOption("UseAutosave") = 1 
		.cOption("UseAutosaveDirectory") = 1 
		.cOption("AutosaveDirectory") = "&lcUbi" 
		.cOption("AutosaveFilename") = lcPdf 
		.cOption("AutosaveFormat") = 0 && 0 pour le format PDF 
		* Modification temporaire de l'imprimante par défaut : 
		DefaultPrinter = .cDefaultprinter 
		.cDefaultprinter = "PDFCreator" 
		.cClearcache 
	ENDWITH 
	REPORT FORM &lcRepo TO PRINTER NOCONSOLE 
	* Lancement de l'impression : 
	PDFCreator.cPrinterStop = .F. 
	* On attend jusqu'à ce que l'imprimante soit prête ou que 10 secondes sesoient écoulées : 
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
	* Définition de la classe gérant les événements : 
	DEFINE CLASS PDFEvent AS Custom 
		IMPLEMENTS __clsPDFCreator IN "PDFCreator.clsPDFCreatorOptions" 
	* Evénement qui indique si l'imprimante est prête 
	PROCEDURE __clsPDFCreator_eReady() AS VOID 
	ReadyState = 1 
	ENDPROC

	* Gestion des erreurs 
	PROCEDURE __clsPDFCreator_eError() AS VOID 
	ENDPROC 
	ENDDEFINE 
ENDPROC


