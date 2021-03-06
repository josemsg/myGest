***    Here is a very similar Visual FoxPro - Open Office example that..... 
***    1. Creates an OOo Calc spreadsheet 
***    2. Puts some strings into it. 
***    3. Puts some numbers into it. 
***    4. Puts some dates into it (as formulas) 
***    5. Saves it in Calc format (as C:\Example.sxw) 
***    6. Saves it in Excel format (as C:\Example.xls) 
***    7. Closes the document -- but this line is commented to leave the spreadsheet open in OOo 

***    Code: 
VfpOOoCalcExample() 

PROCEDURE VfpOOoCalcExample() 
   * Create a spreadsheet. 
   LOCAL oDoc 
   
   oDoc = OOoOpenURL( "private:factory/scalc" ) 
    
   * Get first sheet 
   LOCAL oSheet 
   oSheet = oDoc.getSheets().getByIndex( 0 ) 
    
   *----- 
   * Put some sales figures onto the sheet. 
   oSheet.getCellByPosition( 0, 0 ).setString( "Month" ) 
   oSheet.getCellByPosition( 1, 0 ).setString( "Sales" ) 
   oSheet.getCellByPosition( 2, 0 ).setString( "End Date" ) 
    
   oSheet.getCellByPosition( 0, 1 ).setString( "Jan" ) 
   oSheet.getCellByPosition( 0, 2 ).setString( "Feb" ) 
   oSheet.getCellByPosition( 0, 3 ).setString( "Mar" ) 
   oSheet.getCellByPosition( 0, 4 ).setString( "Apr" ) 
   oSheet.getCellByPosition( 0, 5 ).setString( "May" ) 
   oSheet.getCellByPosition( 0, 6 ).setString( "Jun" ) 
   oSheet.getCellByPosition( 0, 7 ).setString( "Jul" ) 
   oSheet.getCellByPosition( 0, 8 ).setString( "Aug" ) 
   oSheet.getCellByPosition( 0, 9 ).setString( "Sep" ) 
   oSheet.getCellByPosition( 0, 10 ).setString( "Oct" ) 
   oSheet.getCellByPosition( 0, 11 ).setString( "Nov" ) 
   oSheet.getCellByPosition( 0, 12 ).setString( "Dec" ) 
    
   oSheet.getCellByPosition( 1, 1 ).setValue( 3826.37 ) 
   oSheet.getCellByPosition( 1, 2 ).setValue( 3504.21 ) 
   oSheet.getCellByPosition( 1, 3 ).setValue( 2961.45 ) 
   oSheet.getCellByPosition( 1, 4 ).setValue( 2504.12 ) 
   oSheet.getCellByPosition( 1, 5 ).setValue( 2713.98 ) 
   oSheet.getCellByPosition( 1, 6 ).setValue( 2448.17 ) 
   oSheet.getCellByPosition( 1, 7 ).setValue( 1802.13 ) 
   oSheet.getCellByPosition( 1, 8 ).setValue( 2203.22 ) 
   oSheet.getCellByPosition( 1, 9 ).setValue( 1502.54 ) 
   oSheet.getCellByPosition( 1, 10 ).setValue( 1207.68 ) 
   oSheet.getCellByPosition( 1, 11 ).setValue( 1819.71 ) 
   oSheet.getCellByPosition( 1, 12 ).setValue( 986.03 ) 
    
   oSheet.getCellByPosition( 2, 1 ).setFormula( "=DATE(2004;01;31)" ) 
   oSheet.getCellByPosition( 2, 2 ).setFormula( "=DATE(2004;02;29)" ) 
   oSheet.getCellByPosition( 2, 3 ).setFormula( "=DATE(2004;03;31)" ) 
   oSheet.getCellByPosition( 2, 4 ).setFormula( "=DATE(2004;04;30)" ) 
   oSheet.getCellByPosition( 2, 5 ).setFormula( "=DATE(2004;05;31)" ) 
   oSheet.getCellByPosition( 2, 6 ).setFormula( "=DATE(2004;06;30)" ) 
   oSheet.getCellByPosition( 2, 7 ).setFormula( "=DATE(2004;07;31)" ) 
   oSheet.getCellByPosition( 2, 8 ).setFormula( "=DATE(2004;08;31)" ) 
   oSheet.getCellByPosition( 2, 9 ).setFormula( "=DATE(2004;09;30)" ) 
   * Note that these last three dates are not set as DATE() function calls. 
   oSheet.getCellByPosition( 2, 10 ).setFormula( "10/31/2004" ) 
   oSheet.getCellByPosition( 2, 11 ).setFormula( "11/30/2004" ) 
   oSheet.getCellRangeByName( "C13" ).setFormula( "12/31/2004" ) 
   *----- 
    
   * Format the date cells as dates.    
   oFormats = oDoc.getNumberFormats() 
   oLocale = OOoCreateStruct( "com.sun.star.lang.Locale" ) 
   * com.sun.star.util.NumberFormat.DATE = 2 
   nDateKey = oFormats.getStandardFormat( 2, oLocale ) 
   oCell = oSheet.getCellRangeByName( "C2:C13" ) 
   oCell.NumberFormat = nDateKey 
    
   LOCAL ARRAY aOneArg[1] 
   LOCAL cFile, cURL 
    
*   cFile = GetDesktopFolderPathname()+"example" 
   cFile = "c:\example" 

   * Now save the spreadsheet. 
   cURL = OOoConvertToURL( cFile + ".sxw" ) 
   aOneArg[1] = OOoMakePropertyValue( "Overwrite", .T. ) 
   oDoc.storeToUrl( cURL, @ aOneArg ) 
    
   * Now save it as Excel 
   cURL = OOoConvertToURL( cFile + ".xls" ) 
   aOneArg[1] = OOoMakePropertyValue( "FilterName", "MS Excel 97" ) 
   oDoc.storeToUrl( cURL, @ aOneArg ) 
    
   * Close the document. 
*   oDoc.close( 1 ) && TRUE 
ENDPROC 





* Open or Create a document from it's URL. 
* New documents are created by URL's such as: 
*   private:factory/sdraw 
*   private:factory/swriter 
*   private:factory/scalc 
*   private:factory/simpress 
FUNCTION OOoOpenURL( cURL ) 
*   LOCAL oPropertyValue 
*   oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" ) 

*   LOCAL ARRAY aNoArgs[1] 
*   aNoArgs[1] = oPropertyValue 
*   aNoArgs[1].Name = "ReadOnly" 
*   aNoArgs[1].Value = .F. 

   * These two lines replace the alternate version above, 
   *  which are left commented for the insight they provide. 
   LOCAL ARRAY aNoArgs[1] 
   aNoArgs[1] = OOoMakePropertyValue( "Hidden", .F. ) 
    
   LOCAL oDesktop 
   oDesktop = OOoGetDesktop() 

   LOCAL oDoc 
   oDoc = oDesktop.LoadComponentFromUrl( cURL, "_blank", 0, @ aNoargs ) 
    
   * Make sure that arrays passed to this document are passed zero based. 
   COMARRAY( oDoc, 10 ) 
    
   RETURN oDoc 
ENDFUNC 

* Create a com.sun.star.beans.PropertyValue struct and return it. 
FUNCTION OOoMakePropertyValue( cName, uValue, nHandle, nState ) 
   LOCAL oPropertyValue 
   oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" ) 
    
   oPropertyValue.Name = cName 
   oPropertyValue.Value = uValue 
    
   IF TYPE([nHandle])="N" 
      oPropertyValue.Handle = nHandle 
   ENDIF 
   IF TYPE([nState])="N" 
      oPropertyValue.State = nState 
   ENDIF 
    
   RETURN oPropertyValue 
ENDFUNC 



* Sugar coated routine to create any UNO struct. 
* Use the Bridge_GetStruct() feature of the OLE-UNO bridge. 
FUNCTION OOoCreateStruct( cTypeName ) 
   LOCAL oServiceManager 
   oServiceManager = OOoGetServiceManager() 
    
   LOCAL oStruct 
   oStruct = .NULL. 

   LOCAL cOldErrHandler 
   cOldErrHandler = ON( "ERROR" ) 
   ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) ) 
      oStruct = oServiceManager.Bridge_GetStruct( cTypeName ) 
   ON ERROR &cOldErrHandler 
    
   IF ISNULL( oStruct ) 
      =__OOoReleaseCachedVars() 
      oServiceManager = OOoGetServiceManager() 
      oStruct = oServiceManager.Bridge_GetStruct( cTypeName ) 
   ENDIF 

   RETURN oStruct 
ENDFUNC 


* Return the OpenOffice.org desktop object. 
* Cache it in a global variable. 
* Create it if not already cached. 
FUNCTION OOoGetDesktop() 
   IF (TYPE([goOOoDesktop])!="O")  OR  ISNULL( goOOoDesktop ) 
      PUBLIC goOOoDesktop 
      goOOoDesktop = OOoServiceManager_CreateInstance( "com.sun.star.frame.Desktop" ) 
      COMARRAY( goOOoDesktop, 10 ) 
   ENDIF 
   RETURN goOOoDesktop 
ENDFUNC 



* Return the OpenOffice.org service manager object. 
* Cache it in a global variable. 
* Create it if not already cached. 
FUNCTION OOoGetServiceManager() 
   IF (TYPE([goOOoServiceManager])!="O")  OR  ISNULL( goOOoServiceManager ) 
      PUBLIC goOOoServiceManager 
      goOOoServiceManager = CREATEOBJECT( "com.sun.star.ServiceManager" ) 
   ENDIF 
   RETURN goOOoServiceManager 
ENDFUNC 


* Sugar coated routine to ask the service manager to 
*  create you an instance of some other OpenOffice.org UNO object. 
FUNCTION OOoServiceManager_CreateInstance( cServiceName ) 
   LOCAL oServiceManager 
   oServiceManager = OOoGetServiceManager() 
    
   LOCAL oInstance 
   oInstance = .NULL. 

   LOCAL cOldErrHandler 
   cOldErrHandler = ON( "ERROR" ) 
   ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) ) 
      oInstance = oServiceManager.createInstance( cServiceName ) 
   ON ERROR &cOldErrHandler 
    
   IF ISNULL( oInstance ) 
      =__OOoReleaseCachedVars() 
      oServiceManager = OOoGetServiceManager() 
      oInstance = oServiceManager.createInstance( cServiceName ) 
   ENDIF 

   RETURN oInstance 
ENDFUNC 


PROCEDURE DoNothing__ErrorHandler( pnError, pcErrMessage, pnLineNo, pcProgramFileSys16, pcProgram, pcErrorParamSys2018 ) 
ENDPROC 


PROCEDURE __OOoReleaseCachedVars() 
   RELEASE goOOoServiceManager, goOOoDesktop, goOOoCoreReflection 
ENDPROC 


* Convert a local filename to an OOo URL. 
FUNCTION OOoConvertToURL( cFilename ) 
   * Ensure leading slash. 
   IF LEFT( cFilename, 1 ) != "/" 
      cFileName = "/" + cFileName 
   ENDIF 
    
   LOCAL cURL 
   cURL = CHRTRAN( cFilename, "\", "/" )   && change backslashes to forward slashes. 
   cURL = "file://" + cURL 
   RETURN cURL 
ENDFUNC 
