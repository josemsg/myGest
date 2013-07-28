Local loPDFCreator As PDFCreator.clsPDFCreator
loPDFCreator = Createobject("PDFCreator.clsPDFCreator")
If loPDFCreator.cStart("/NoProcessingAtStartup")
   With loPDFCreator
      Local loOptions As PDFCreator.clsPDFCreatorOptions
      loOptions = loPDFCreator.cOptions
      With loOptions
         .PrinterStop = .T.
         .UseAutosave = 1
         .UseAutosaveDirectory = 1
         .AutosaveDirectory = "C:\temp"
         .AutosaveFilename = "teste.pdf"
      Endwith
      loPDFCreator.cOptions = loOptions
      .cDefaultPrinter = "PDFCreator"
      .cClearCache()
      Local loEventHandler
      loEventHandler = Createobject("PDFCreatorStatus")
      Eventhandler(loPDFCreator,loEventHandler)
      Local lnFile
      For lnFile=1 To 2
         .cPrintfile(Getfile())
         Inkey(1)
      Endfor
      Inkey(1)
      .cCombineAll
      Do While (.cCountOfPrintjobs <> 1)
         Inkey(1)
      Enddo
      .cPrinterStop = .F.
   Endwith
   With loEventHandler
      .ReadyState = 0
      Do While (.ReadyState = 0)
         Inkey(1)
      Enddo
   Endwith
   Eventhandler(loPDFCreator,loEventHandler,.T.)
   loEventHandler = Null
Endif
loPDFCreator.cClose()
loPDFCreator = Null
Clear All
Return

Define Class PDFCreatorStatus As Session
   Implements  __clsPDFCreator In "PDFCreator.clsPDFCreatorOptions"

   ReadyState = 0

   Procedure __clsPDFCreator_eReady() As VOID
      * add user code here
      This.ReadyState = 1
   Endproc

   Procedure __clsPDFCreator_eError() As VOID
      * add user code here
   Endproc

Enddefine