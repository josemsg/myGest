lcPDFPrinter="PDFCreator"  && or Acrobat pdfWriter (in print panel)...downloadable
lcOldPrinter=SET("PRINTER",2)      &&degrad old printer
SET PRINTER tO NAME(lcPDFPrinter)  &&do default printer
afile=getfile('frx|doc|htm|html|xls|rtf|ppt|pps|txt|prg|jpg|bmp|png|tif|gif')
if not empty(afile)

	if lower(justext(afile))="frx"  &&vfp report 
		repo form (afile) TO print prompt
	else
		DECLARE INTEGER ShellExecute IN shell32.dll ; 
		INTEGER hndWin, STRING cAction, STRING cFileName, ; 
		STRING cParams, STRING cDir, INTEGER nShowWin
		ShellExecute(0,"open",afile,"","",1)
		inkey(5)  &&pausing for show window
		oShell = CREATEOBJECT("Wscript.Shell")
		oShell.SendKeys("^{p}")   &&dialog printer CTRL+P
	endi

ENDIF
SET PRINTER tO NAME(lcOldPrinter)