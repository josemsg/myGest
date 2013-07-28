* PDFListener.PRG
* (c) Lisa Slater Nicholls >L<
* except some Windows-command-invocation code as
*  noted below 
* ("   * from this point to the end of the class... ") 
* change as noted below (search for "fix:"), 6/15/2005, 
* for paths with spaces.


#DEFINE FFC_HOME ADDBS(HOME() + "FFC")
#DEFINE PDFLISTENER_SUPERCLASSLIB FFC_HOME + "_reportlistener.vcx"


#DEFINE WIN_API_ERROR_LOC "Error calling Windows API: "
#DEFINE INSTALLING_DRIVER_LOC "Installing PDF Driver... "
#DEFINE INSTALLING_LIBRARY_LOC "Installing PDF Libraries... "
#DEFINE GENERAL_FAILURE_LOC "Could not create PDF file."
#DEFINE PROCESS_FAILURE_LOC "Could not create GS process."
#DEFINE OUTPUTPDF_APPNAME_LOC "PDF Listener"
#DEFINE PSETUP_DEFAULTNAME_LOC "VFP-PDF"

#DEFINE LISTENER_TYPE_PRN     0
#DEFINE LISTENER_TYPE_PAGED   2

#DEFINE VFPSTARTMODE_DEV        1
#DEFINE VFPSTARTMODE_COMEXE     2
#DEFINE VFPSTARTMODE_INPROCDLL  3
#DEFINE VFPSTARTMODE_DISTAPPEXE 4
#DEFINE VFPSTARTMODE_MTDLL      5
#DEFINE VFP_USER_DEFINED_ERROR  1098

#DEFINE MB_ICONEXCLAMATION      48     

#DEFINE DRIVER_TO_USE "Apple Color LaserWriter 12/600"
#DEFINE BASE_GS_LOCATION  "GS"
#DEFINE BASE_GS_EXEC_FILE "gswin32c.exe"

#DEFINE GS_COMMAND_STRING_1  " -q -dNOPAUSE -I./lib;./fonts " + ;
                             "-sFONTPATH=./fonts " + ;
                             "-sFONTMAP=./lib/FONTMAP.GS " + ;
                             "-sDEVICE=pdfwrite -sOUTPUTFILE="
#DEFINE GS_COMMAND_STRING_2 " -dBATCH  "   

DEFINE CLASS PDFListener as utilityReportListener OF PDFLISTENER_SUPERCLASSLIB
                                       
   ListenerType = 0
   targetFileExt = "PDF"
   
   PROTECTED FRXPrintInfoAlias, reportTempFiles[1], IsOle

   generateNewStyleOutput = .F.  && default to .T. if you subclass from FX and have FXs
                                 && but you can still generate newstyle if 
                                 && AddReport includes a specified listener reference;
                                 && an explicit reference in the collection
                                 && OR an OBJECT clause in the Clauses element
                                 && overrides tlOmitListenerReferences

   GSLocation = ADDBS(JUSTPATH(THIS.ClassLibrary))
   GSExecFile = BASE_GS_EXEC_FILE
   PSDriverSetupName = PSETUP_DEFAULTNAME_LOC
   FRXPrintInfoAlias = "P"+SYS(2015)
   retainTempFiles = .F.   
   oWinAPI = NULL
   ThrowOleError = .F.
   IsOLE = ( INLIST(_VFP.StartMode, VFPSTARTMODE_COMEXE, VFPSTARTMODE_INPROCDLL,VFPSTARTMODE_MTDLL ))
   WaitAttempts = 20
   WaitInterval = 200
   
   PROCEDURE Init()
     IF DODEFAULT()
        THIS.appName =  OUTPUTPDF_APPNAME_LOC
        THIS.oWinAPI = CREATEOBJECT("VFPWinAPILib")      
        THIS.oWinAPI.ThrowOleError = THIS.ThrowOleError  
        THIS.GSLocation = THIS.GetDefaultGSLocation()
        RETURN NOT (THIS.HadError OR ISNULL(THIS.oWinAPI))
     ELSE
        RETURN .F.   
     ENDIF   
   ENDPROC
   
   PROCEDURE Error(nError, cMethod, nLine)
      DODEFAULT(nError,cMethod,nLine)
      IF (NOT THIS.lIgnoreErrors) AND ;
          THIS.IsOLE AND THIS.ThrowOleError
          IF EMPTY(THIS.LastErrorMessage)
             THIS.LastErrorMessage = MESSAGE() + ", line " + TRANSFORM(nLine)
          ENDIF
          COMRETURNERROR( _VFP.ServerName, THIS.LastErrorMessage)
      ENDIF     
   ENDPROC
   
   PROCEDURE ThrowOleError_Assign(tVal)
      IF VARTYPE(tVal) = "L"
         THIS.ThrowOleError = tVal
         IF NOT ISNULL(THIS.oWinAPI)
            THIS.oWinAPI.ThrowOLEError = .T.
         ENDIF
       ENDIF
    ENDPROC
   
   PROCEDURE RunReports(tlRemoveReportsAfterRun, tlOmitListenerReferences)
      * NB: we could force NOPAGEEJECT
      * on all reports in the collection
      * and then remove from the last one in 
      * the run, rather than processing multiple
      * temporary PS files as done in this class.
      * However, the extra work provides extra 
      * flexibility; one print job in Fox still
      * requires the page size to be the same for
      * each of the reports in the NOPAGEEJECT
      * sequence.  By running the separate reports
      * to separate PS files and then using
      * the appropriate GS syntax to bind them 
      * together we can include multiple report page
      * sizes, or different page sizes in multiple
      * document sections, as needed.
      IF (NOT ISNULL(THIS.ReportFileNames)) AND ;
         (NOT EMPTY(THIS.ReportFileNames[1])) AND ;
         THIS.LoadPrinterInfo()
         IF EMPTY(JUSTEXT(THIS.TargetFileName))
            THIS.TargetFileName = FORCEEXT(THIS.TargetFileName,THIS.TargetFileExt)
         ENDIF   
         THIS.verifyTargetFile()
         IF PCOUNT() = 2 OR VARTYPE(THIS.generateNewStyleOutput) # "L"
            DODEFAULT(.F., tlOmitListenerReferences)
         ELSE
            DODEFAULT(.F.,NOT THIS.generateNewStyleOutput)
         ENDIF   
         THIS.UnloadPrinterInfo()
         RETURN THIS.ProcessPDF(tlRemoveReportsAfterRun)
      ELSE
         RETURN .F.   
      ENDIF   
   ENDPROC
        
   PROTECTED PROCEDURE ProcessPDF(tlRemoveReportsAfterRun)
      IF EMPTY(THIS.reportTempFiles[1])
         RETURN .F.
      ELSE
         * move the collection of reportTempFiles into a GS batch file
         * for processing
         LOCAL llReturn, lcCmdFile, lcCmd, lcDir
         lcCmdFile = THIS.MakeGSCommandFile()
         * shell out to gs      
         lcCmd = FORCEPATH(THIS.GSExecFile,THIS.GSLocation)+ " @"+JUSTFNAME(lcCmdFile)
         lcCmd = STRTRAN(lcCmd,"\","/")
         lcDir = SET("DIRECT")
         CD (THIS.GSLocation)
         * llReturn = THIS.oWinAPI.ProgExecute(lcCmd," NOT FILE(["+THIS.TargetFileName+"]) ",THIS.WaitAttempts)      
         * or:
         llReturn = THIS.oWinAPI.ProgExecuteX(lcCmd,1)  
         CD (lcDir)
         IF (NOT llReturn) AND EMPTY(THIS.LastErrorMessage)
            THIS.LastErrorMessage = ;
              THIS.PrepareErrorMessage( ;
                  VFP_USER_DEFINED_ERROR, ;
                 PROGRAM(), ;
                 0, ;
                 THIS.AppName, ;
                 WIN_API_ERROR_LOC+TRANSFORM(THIS.oWinAPI.GetLastWindowsError()),;
                 "")
         ENDIF
         IF EMPTY(THIS.LastErrorMessage) AND NOT FILE(THIS.TargetFileName)
            THIS.LastErrorMessage = ;
              THIS.PrepareErrorMessage( ;
                  VFP_USER_DEFINED_ERROR, ;
                 PROGRAM(), ;
                 0, ;
                 THIS.AppName, ;
                 GENERAL_FAILURE_LOC+" "+THIS.TargetFileName,;
                 "")
         ENDIF        
         IF (NOT EMPTY(THIS.LastErrorMessage)) AND THIS.IsOle AND THIS.ThrowOleError
             COMRETURNERROR( _VFP.ServerName, THIS.LastErrorMessage)
         ENDIF    
         THIS.CleanupTempFiles(lcCmdFile)       
         IF tlRemoveReportsAfterRun
            THIS.RemoveReports()
         ENDIF
         RETURN llReturn
      ENDIF   
   ENDPROC    
      
   PROTECTED PROCEDURE CleanupTempFiles(tcFile)
      LOCAL liIndex, lvFile, lcRetain
      SET STEP ON 
      IF THIS.retainTempFiles
         lcRetain = " RECYCLE"
      ELSE
         lcRetain = ""
      ENDIF
      FOR liIndex = 1 TO ALEN(THIS.reportTempFiles)
          lvFile = THIS.reportTempFiles[liIndex]
          IF (NOT EMPTY(lvFile)) AND FILE(lvFile)
             WAIT WINDOW lvFile 
             *ERASE (lvFile) &lcRetain
          ENDIF   
      ENDFOR
      IF (NOT EMPTY(tcFile)) AND FILE(tcFile)
         ERASE (tcFile) &lcRetain
      ENDIF
   ENDPROC
   
   PROCEDURE AddReport(tcFRXName, tcClauses, toListener)
     LOCAL liReports
     IF ISNULL(THIS.reportClauses)
        liReports = 0
     ELSE
        liReports = THIS.reportClauses.Count
     ENDIF
     DODEFAULT(tcFRXName,tcClauses,toListener)
     IF (NOT ISNULL(THIS.reportClauses)) AND ;
        THIS.reportClauses.Count > liReports
        THIS.AdjustReportClauses(liReports + 1)
     ENDIF
   ENDPROC
   
   PROTECTED PROCEDURE RemoveReports()
      DODEFAULT()
      DIMENSION THIS.reportTempFiles[1]
      THIS.reportTempFiles[1] = .F.
   ENDPROC
   
   PROTECTED PROCEDURE AdjustReportClauses(tiWhich)
      LOCAL lcClauses, lcTempFile, laWords[1], liIndex, lcWord
      lcClauses = NVL(THIS.reportClauses,"")
      lcClauses = EVL(THIS.reportClauses[tiWhich],"")
      lcTempFile = FORCEEXT(FORCEPATH("PS"+SYS(2015),THIS.GSLocation),".PS")
      * parse out the possible PREVIEW/TO PRINT
      lcClauses = " " + UPPER(lcClauses)
      IF " TO " $ lcClauses
         * TO PRINT or TO FILE <name>, where FILE is optional
         lcClauses = STRTRAN(lcClauses,"FILE","")
      ENDIF
      * now get rid of TO and the following word and get rid of PREVIEW and PROMPT.        
      * we have to do this because we can't assume that a 
      * listener will be attached to the REPORT FORM command (could be
      * old style) or that, if it is, it is one of the appropriate
      * listener types. It's probably a user error
      * if these clauses occur, and there are other possible
      * problem clauses (for example IN SCREEN) that shouldn't 
      * be used in a COM object, but these should take care of most cases.
      ALINES(laWords,lcClauses,4," ")      
      lcClauses = ""
      FOR liIndex = 1 TO ALEN(laWords)
          IF EMPTY(laWords[liIndex])
             lcWord = " "
          ELSE   
             lcWord = " "+laWords[liIndex]+" "
          ENDIF
          DO CASE
          CASE " TO " $ lcWord
             * don't include, and
             * need to get rid of the following word
             laWords[liIndex+ 1] = " "             
          CASE " PROM " $ lcWord OR ;
               " PROMP " $ lcWord OR ;
               " PROM " $ STRTRAN(lcWord,"PT", " ")
             * don't include
          CASE " PREV " $ lcWord OR ;
               " PREVI " $ lcWord OR ;
               " PREVIE " $ lcWord OR ;
               " PREV " $ STRTRAN(lcWord,"IEW", " ")
             * don't include
          OTHERWISE
             lcClauses = lcClauses + " " + lcWord
          ENDCASE                       
      ENDFOR
      * adjust the clauses to go TO FILE
      * with a temporary name
      * and, because it can be old-style
      * make sure to add NODIALOG for auto-quietmode behavior
      lcClauses = " "+lcClauses + " "
      
      IF ATC(" NODI ",lcClauses) = 0 AND ;
         ATC(" NODIA ",lcClauses) = 0 AND ;
         ATC(" NODIAL ",lcClauses) = 0 AND ;
         ATC(" NODIALO ",lcClauses) = 0 AND ;
         ATC(" NODIALOG ",lcClauses) = 0 
         lcClauses = lcClauses + " NODIALOG "
      ENDIF

      IF ATC(" NOCO ",lcClauses) = 0 AND ;
         ATC(" NOCON ",lcClauses) = 0 AND ;
         ATC(" NOCONS ",lcClauses) = 0 AND ;
         ATC(" NOCONSO ",lcClauses) = 0 AND ;
         ATC(" NOCONSOL ",lcClauses) = 0 AND ;
         ATC(" NOCONSOLE ",lcClauses) = 0          
         lcClauses = lcClauses + " NOCONSOLE "
      ENDIF
         
      THIS.reportClauses.Remove[tiWhich]
      * fix: THIS.reportClauses.Add(lcClauses + " TO FILE "+ UPPER(lcTempFile))
      THIS.reportClauses.Add(lcClauses + " TO FILE (["+ UPPER(lcTempFile) + "]) " )

      * add to the collection of temporary Filenames
      IF tiWhich > 1
         DIMENSION THIS.reportTempFiles[tiWhich]
      ENDIF   
      THIS.reportTempFiles[tiWhich] = lcTempFile
   ENDPROC
   
   PROCEDURE SupportsListenerType(ti)
      RETURN INLIST(ti,LISTENER_TYPE_PRN) AND ;
        (NOT THIS.IsSuccessor)
      * NB/TBD: you could do this as a successor
      * and support LISTENER_TYPE_PAGED as well
      * as LISTENER_TYPE_PRN,
      * if you opened your own print job and 
      * fed that handle to the engine in OutputPage.
      * Not being done in this version,
      * by default this class will pass references to
      * itself as the listener in the OBJECT clause
      * to all REPORT FORM commands anyway unless
      * we're in an "old style" reporting situation.   
   ENDPROC
   
   PROTECTED PROCEDURE MakeGSCommandFile()
      LOCAL lcFile, lcContents, lcFileString, liH
      lcFile = FORCEPATH("C"+SYS(2015)+".TXT",THIS.GSLocation)
      lcFileString = THIS.GetQuotedFileString()
      lcContents = GS_COMMAND_STRING_1 + ;
                   ["]+THIS.TargetFileName+["]+ ;
                   GS_COMMAND_STRING_2 + ;
                   + lcFileString   
      * forward slashes or doublebackslashes
      lcContents = STRTRAN(lcContents,"\","/")                 
      IF FILE(lcFile)
         ERASE (lcFile)
      ENDIF
      liH = FCREATE(lcFile)
      FPUTS(liH,lcContents)
      FFLUSH(liH,.T.)      
      FCLOSE(liH)
*      STRTOFILE(lcContents, lcFile) seemed to cause some problems
   RETURN lcFile
   
   PROTECTED PROCEDURE GetQuotedFileString()
      LOCAL liIndex, lcReturn, lcFile
      lcReturn = ""
      FOR liIndex = 1 TO ALEN(THIS.reportTempFiles)
         IF NOT EMPTY(THIS.reportTempFiles[liIndex])
            lcFile = ALLTRIM(JUSTFNAME(THIS.reportTempFiles[liIndex]))
            IF LEFT(lcFile,1) # ["]
               lcFile = ["]+lcFile 
            ENDIF   
            IF RIGHT(lcFile,1) # ["]
               lcFile = lcFile + ["]
            ENDIF   
            lcFile = " " + lcFile + " "
            lcReturn = lcReturn + lcFile
         ENDIF
      ENDFOR
   RETURN lcReturn
   
   PROCEDURE LoadPrinterInfo()
      IF NOT THIS.VerifyGSLibrary()
         RETURN .F.
      ENDIF   
      IF NOT THIS.VerifyPrinterSetup()
         RETURN .F.
      ENDIF
      IF NOT THIS.AdjustVFPPrinterSetups()
         RETURN .F.
      ENDIF
   ENDPROC
   
   PROTECTED PROCEDURE UnloadPrinterInfo()
      THIS.setFRXDataSession()   
      IF USED(THIS.FRXPrintInfoAlias)
         LOCAL liSelect
         liSelect = SELECT()
         SELECT (THIS.FRXPrintInfoAlias)
         * restore current printer setup from special FRX in
         * FRXDataSession
         SYS(1037,3)
         USE IN (THIS.FRXPrintInfoAlias) && we're finished with it
         SELECT (liSelect)
      ENDIF   
      THIS.setCurrentDataSession()      
   ENDPROC   
   
   PROTECTED PROCEDURE PrepareFRXPrintInfo()
      LOCAL lcFile,liSelect, llCreated
      liSelect = SELECT()
      IF TYPE("THIS.CommandClauses.File") # "C" OR ;
         EMPTY(SYS(2000,THIS.CommandClauses.File)) OR  ;
         NOT USED("FRX")
         * could be built into the app, could be used 
         * at a different time than FRX is available
         * or simply could be used in a different
         * session than FRXDataSession
         lcFile = FORCEEXT(FORCEPATH("F"+SYS(2015),JUSTPATH(THIS.targetFileName)),"FRX")
         SELECT 0
         CREATE CURSOR x (onefield l)
         CREATE REPORT (lcFile) FROM (DBF("x"))
         USE IN x
         SELECT 0
         USE (lcFile) ALIAS TheFRX
         llCreated = .T.
      ELSE   
         lcFile = DBF("FRX")
      ENDIF
      SELECT * FROM (lcFile) ;
            INTO CURSOR (THIS.FRXPrintInfoAlias) READWRITE ;
            WHERE RECNO() = 1    
      SELECT (THIS.FRXPrintInfoAlias)
      REPLACE Expr WITH "", Tag WITH "", Tag2 WITH ""      
      IF llCreated
         USE IN TheFRX
         ERASE (lcFile)
         ERASE (FORCEEXT(lcFile,"FRT"))   
      ELSE   
         * TBD:
         * also attempt to remove printer setup info from 
         * The FRX? If readonly, do not attempt
      ENDIF       
      SELECT (liSelect)
      RETURN llCreated
   ENDPROC

   PROTECTED PROCEDURE AdjustVFPPrinterSetups()
      LOCAL llFailure, oError AS Exception, liSelect
      THIS.setFRXDataSession()
      liSelect = SELECT()
      TRY 
         THIS.prepareFRXPrintInfo()
         SELECT (THIS.FRXPrintInfoAlias)
         SYS(1037,2)
         SET PRINTER TO NAME (THIS.PSDriverSetupName)
      CATCH TO oError 
         THIS.DoMessage(oError.Message,MB_ICONEXCLAMATION)
         THIS.LastErrorMessage = ;
              THIS.PrepareErrorMessage( ;
                VFP_USER_DEFINED_ERROR, ;
                 PROGRAM(), ;
                 oError.Lineno, ;
                 THIS.AppName, ;
                 oError.Message,;
                 oError.LineContents)
         llFailure = .T.
      ENDTRY
      SELECT (liSelect)
      THIS.setCurrentDataSession()
      RETURN NOT llFailure
   ENDPROC
   
   PROCEDURE VerifyPrinterSetup()
      PRIVATE laSetups[1]
      LOCAL lcCmd, liTrials,oShell, lcFailureConditions
      lcFailureConditions = ;
       " APRINTERS(laSetups) = 0 OR " + ;
       " ASCAN(laSetups,["+THIS.PSDriverSetupName+"],1,ALEN(laSetups,1),1,7) = 0 "  
      
      * check for the existance of the appropriate printer driver
      * if it is not there, attempt to install
      * if it is not installed after attempt,
      * return .F.      
     IF &lcFailureConditions.
        THIS.DoStatus(INSTALLING_DRIVER_LOC)
        lcCmd = [%windir%\\system32\\rundll32.exe  printui.dll,PrintUIEntry /if /b ] + ;
                ["] + THIS.PSDriverSetupName + ["] + ;
                [ /f %windir%\\inf\\ntprint.inf /r  "lpt1:" /m "] + ;
                DRIVER_TO_USE + [" /Z]
        llReturn = THIS.oWinAPI.ProgExecute(lcCmd,lcFailureConditions,THIS.WaitAttempts)              
        THIS.ClearStatus()
     ENDIF   
     RETURN APRINTERS(laSetups) > 0 AND ;
        ASCAN(laSetups,THIS.PSDriverSetupName,1,ALEN(laSetups,1),1,7) > 0   
   ENDPROC
   
   PROCEDURE GetDefaultGSLocation()
      LOCAL aDummy[1]
      
      IF EMPTY(ASTACKINFO(aDummy))
         RETURN UPPER(ADDBS(JUSTPATH(THIS.ClassLibrary)))
      ELSE
         RETURN UPPER(ADDBS(JUSTPATH(aDummy[1,4])))
      ENDIF   
   ENDPROC
   
   PROCEDURE VerifyGSLibrary()
      IF EMPTY(SYS(2000,FORCEPATH(THIS.GSExecFile,THIS.GSLocation)))
         IF THIS.GSLocation == THIS.GetDefaultGSLocation()
            THIS.GSLocation = ADDBS(JUSTPATH(THIS.ClassLibrary))+ ADDBS(BASE_GS_LOCATION)
            * if it is the classlibrary loc, add BASE_GS_LOCATION
         ENDIF 
         * creating directory if necessary/possible.
         IF NOT DIRECTORY(THIS.GSLocation)
            TRY
               MD (THIS.GSLocation)
            CATCH WHEN .T.
            ENDTRY
         ENDIF
         IF DIRECTORY(THIS.GSLocation) AND FILE("Install.DBF")
            * attempt to install
            THIS.DoStatus(INSTALLING_LIBRARY_LOC)            
            THIS.setFRXDataSession()   
            LOCAL liSelect, lcFile
            liSelect = SELECT()
            SELECT 0
            USE Install
            SCAN
               lcFile = THIS.GSLocation + ALLTRIM(dir)+ ALLTRIM(filename)
               IF NOT DIRECTORY(THIS.GSLocation + ALLTRIM(dir))
                  MD (THIS.GSLocation + ALLTRIM(dir))
               ENDIF
               IF NOT FILE(lcFile)
                  COPY MEMO Contents TO (lcFile)
               ENDIF
            ENDSCAN
            USE 
            SELECT(liSelect)
            THIS.setCurrentDataSession()
            THIS.ClearStatus()
         ENDIF
      ENDIF   
      RETURN NOT EMPTY(SYS(2000,FORCEPATH(THIS.GSExecFile,THIS.GSLocation)))
   ENDPROC
   
   PROCEDURE GSLocation_Assign(tcVal)
      IF VARTYPE(tcVal) = "C" AND NOT EMPTY(tcVal)
        THIS.GSLocation = UPPER(ADDBS(ALLTRIM(tcVal)))
      ENDIF
   ENDPROC

   PROCEDURE PSDriverSetupName_Assign(tcVal)
      IF VARTYPE(tcVal) = "C" AND NOT EMPTY(tcVal)
         LOCAL laSetups[1], liIndex, llFoundAndNotAppropriate
         FOR liIndex = 1 TO APRINTERS(laSetups,1) 
             IF ( UPPER(laSetups[liIndex,1]) == ;
                  UPPER(ALLTRIM(THIS.PSDriverSetupName)) ) AND ;
                (NOT ( UPPER(laSetups[liIndex,3]) == ;
                       UPPER(ALLTRIM(DRIVER_TO_USE)) ) )
                 llFoundAndNotAppropriate = .T.
                 EXIT
             ENDIF 
         ENDFOR
         IF NOT llFoundAndNotAppropriate
           THIS.PSDriverSetupName = ALLTRIM(tcVal)
         ENDIF
      ENDIF
   ENDPROC

ENDDEFINE

DEFINE CLASS VFPWinAPILib AS Custom  

   PROTECTED IsOle

   ThrowOleError = .F.
   IsOLE = ( INLIST(_VFP.StartMode, VFPSTARTMODE_COMEXE, VFPSTARTMODE_INPROCDLL,VFPSTARTMODE_MTDLL ))
   LastErrorMessage = ""

   PROCEDURE Error(nError, cMethod, nLine)
      THIS.LastErrorMessage = THIS.Class+" error #"+ ;
                    TRANSFORM(nError)+", "+cMethod+"."+ ;
                    TRANSFORM(nLine)+" ["+MESSAGE()+"]"
      IF THIS.IsOLE AND THIS.ThrowOleError
          COMRETURNERROR( _VFP.ServerName, THIS.LastErrorMessage)
      ENDIF     
   ENDPROC


 PROCEDURE GetLastWindowsError()
    DECLARE INTEGER GetLastError IN kernel32.DLL
 RETURN GetLastError()  
 
 PROCEDURE ProgExecute(zCmdLine, cFailureConditions, nWait, cStatus)
    LOCAL liTrials, lcConditions
    IF NOT EMPTY(cFailureConditions)
       lcConditions = "("+cFailureConditions + ") AND "
    ELSE
       lcConditions = ""   
    ENDIF
    IF NOT (EMPTY(cStatus) OR THIS.IsOle)
       WAIT WINDOW NOWAIT cStatus
    ENDIF
    TRY 
        oShell = CreateObject("WScript.Shell") 
        oShell.Exec(zCmdLine)      
    CATCH WHEN .T.
        * don't want to use RUN command unless necessary
        RUN /N2 &zCmdLine.
     FINALLY
        IF VARTYPE(nWait) = "N"
           DECLARE Sleep IN Win32API INTEGER   
           liTrials = 0
           DO WHILE &lcConditions. liTrials < 100
              SLEEP(1000)
              liTrials = liTrials + 1
           ENDDO   
         ENDIF   
        IF NOT (EMPTY(cStatus) OR THIS.IsOle)
           WAIT CLEAR
        ENDIF
        oShell = NULL
     ENDTRY   

     IF EMPTY(cFailureConditions)
        RETURN .T.
     ELSE      
        RETURN (NOT &cFailureConditions.)
     ENDIF

 ENDPROC
 
 

   * from this point to the end of the class is a 
   * slightly edited version of code from:
   * http://www.experts-exchange.com/Databases/FoxPro/Q_10315608.html

      #DEFINE NORMAL_PRIORITY_CLASS 32
      #DEFINE IDLE_PRIORITY_CLASS 64
      #DEFINE HIGH_PRIORITY_CLASS 128
      #DEFINE REALTIME_PRIORITY_CLASS 1600

      * Return code from WaitForSingleObject() if
      * it timed out.
      #DEFINE WAIT_TIMEOUT 0x00000102
      #DEFINE TIMEOUT_INTERVAL 200
      #DEFINE TIMEOUT_ATTEMPTS 20
      
      #DEFINE PROCESSTIMEOUT 4294967295     

 
 PROCEDURE ProgExecuteX(zCmdLine, nWait)
   * zCmdLine ... Commandline
   * nWait    ... 1 = FoxPro waits until the called program is finished

      DECLARE INTEGER CreateProcess IN kernel32.DLL ;
         INTEGER lpApplicationName, ;
         STRING lpCommandLine, ;
         INTEGER lpProcessAttributes, ;
         INTEGER lpThreadAttributes, ;
         INTEGER bInheritHandles, ;
         INTEGER dwCreationFlags, ;
         INTEGER lpEnvironment, ;
         INTEGER lpCurrentDirectory, ;
         STRING @lpStartupInfo, ;
         STRING @lpProcessInformation

     DECLARE INTEGER WaitForSingleObject IN WIN32API ;
          INTEGER hHandle, INTEGER dwMilliseconds
          
     DECLARE INTEGER GetLastError IN WIN32API   

      LOCAL zStartUp, zProcess, nHandle, nReturn 
      IF PARAMETERS() < 2
          nWait = 0
      ENDIF     

      zStartUp =    THIS.getStartupInfo() && REPLICATE(CHR(0), 68) && 
      zProcess = REPLICATE(CHR(0), 16)
      nReturn = CreateProcess(0, zCmdLine, 0, 0, 1, HIGH_PRIORITY_CLASS, 0, 0, @zStartUp, @zProcess)
      IF nWait = 1
          nHandle = ASC(LEFT(zProcess,1)) + ;
               BITLSHIFT(ASC(SUBSTR(zProcess,2,1)),8) + ;
               BITLSHIFT(ASC(SUBSTR(zProcess,3,1)),16) + ;
               BITLSHIFT(ASC(SUBSTR(zProcess,4,1)),24)
          WaitForSingleObject(nHandle, PROCESSTIMEOUT ) 
      ENDIF

   RETURN (nReturn # 0)
   
   PROCEDURE getStartupInfo
   * creates the STARTUP structure to specify main window 
   * properties if a new window is created for a new process 

   *| typedef struct _STARTUPINFO {  
   *|     DWORD   cb;                4 
   *|     LPTSTR  lpReserved;        4 
   *|     LPTSTR  lpDesktop;         4 
   *|     LPTSTR  lpTitle;           4 
   *|     DWORD   dwX;               4 
   *|     DWORD   dwY;               4 
   *|     DWORD   dwXSize;           4 
   *|     DWORD   dwYSize;           4 
   *|     DWORD   dwXCountChars;     4 
   *|     DWORD   dwYCountChars;     4 
   *|     DWORD   dwFillAttribute;   4 
   *|     DWORD   dwFlags;           4 
   *|     WORD    wShowWindow;       2 
   *|     WORD    cbReserved2;       2 
   *|     LPBYTE  lpReserved2;       4 
   *|     HANDLE  hStdInput;         4 
   *|     HANDLE  hStdOutput;        4 
   *|     HANDLE  hStdError;         4 
   *| } STARTUPINFO, *LPSTARTUPINFO; total: 68 bytes 
    #define STARTF_USESHOWWINDOW   1 
    #define SW_SHOWMAXIMIZED       3 
    #define SW_SHOWMINIMIZED       2 
   RETURN  THIS.num2dword(68) +; 
       THIS.num2dword(0) + THIS.num2dword(0) + THIS.num2dword(0) +; 
       THIS.num2dword(0) + THIS.num2dword(0) + THIS.num2dword(0) + THIS.num2dword(0) +; 
       THIS.num2dword(0) + THIS.num2dword(0) + THIS.num2dword(0) +; 
       THIS.num2dword(STARTF_USESHOWWINDOW) +; 
       THIS.num2word(SW_SHOWMINIMIZED) +; 
       THIS.num2word(0) + THIS.num2dword(0) +; 
       THIS.num2dword(0) + THIS.num2dword(0) + THIS.num2dword(0) 
       
   * * *
   * dword is compatible with LONG
   PROCEDURE  num2dword (lnValue) 
   #DEFINE m0       256 
   #DEFINE m1     65536 
   #DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
   RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3) 
   * * *
   * dword is compatible with LONG
   FUNCTION  num2word (lnValue) 
   RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256)) 
   * * * 
   FUNCTION  buf2word (lcBuffer) 
   RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ; 
       Asc(SUBSTR(lcBuffer, 2,1)) * 256 
   * * *
   FUNCTION  buf2dword (lcBuffer)  
   RETURN;  
       Asc(SUBSTR(lcBuffer, 1,1)) + ;  
       Asc(SUBSTR(lcBuffer, 2,1)) * 256 +;  
       Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +;  
       Asc(SUBSTR(lcBuffer, 4,1)) * 16777216  
   ENDFUNC  

   FUNCTION num2dword (lnValue) 
   * dword is compatible with LONG
      #DEFINE m0       256 
   #DEFINE m1     65536 
   #DEFINE m2  16777216 
       LOCAL b0, b1, b2, b3 
       b3 = Int(lnValue/m2) 
       b2 = Int((lnValue - b3*m2)/m1) 
       b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
       b0 = Mod(lnValue, m0) 
   RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3) 
   
 

ENDDEFINE