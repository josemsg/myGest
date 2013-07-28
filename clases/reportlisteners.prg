#define OutputNothing -1
#define OutputTIFF 101
#define OutputTIFFAdditive (OutputTIFF+100)

*!*	LOCAL oReportListener
*!*	oReportListener = NEWOBJECT("MPTiffListener")
*!*	oReportListener.Filename = "Multi"

*!*	WAIT WINDOW "Processing report to TIFF file...." NOWAIT
*!*	REPORT FORM ? OBJECT oReportListener 
*!*	WAIT CLEAR

DEFINE CLASS TiffListener AS ReportListener
   Filename = "temp"

   PROCEDURE Init
      *THIS.AddProperty("Filename", "temp")
      THIS.ListenerType = 2
   ENDPROC
   
   PROCEDURE BeforeReport
      ERASE THIS.Filename
   ENDPROC

   PROCEDURE OutputPage(nPageNo, eDevice, nDeviceType)
      IF (nDeviceType == OutputNothing)
         IF (nPageNo == 1)
             nDeviceType = OutputTIFF
         ELSE 
            nDeviceType = OutputTIFFAdditive
         ENDIF
         THIS.OutputPage(nPageNo, THIS.Filename, nDeviceType)
         NODEFAULT
     ENDIF
   ENDPROC

ENDDEFINE