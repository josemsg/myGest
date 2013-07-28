*
*    Library of routines to manipulate OpenOffice.org.
*
*
* http://kosh.datateamsys.com/~danny/OOo/VisualFoxPro-OOo/LibOOo-2003-11-17-01.prg

*############################################################
*    Public API
*    High level routines.
*############################################################


* Return .T. if OpenOffice.org is installed.
* Return .F. if not installed.
FUNCTION OOoIsInstalled()
    LOCAL oServiceManager
    oServiceManager = .NULL.

    LOCAL cOldErrHandler
    cOldErrHandler = ON( "ERROR" )
    ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
        oServiceManager = OOoGetServiceManager()
    ON ERROR &cOldErrHandler
    
    * If we could create a Service Manager,
    *  then OpenOffice.org must be installed.
    RETURN NOT ISNULL( oServiceManager )
ENDFUNC




* Easy way to create a new Draw document.
FUNCTION OOoCreateNewDrawDocument()
    LOCAL oDrawDoc
    oDrawDoc = OOoOpenURL( "private:factory/sdraw" )
    RETURN oDrawDoc
ENDFUNC


* Easy way to create a new Writer document.
FUNCTION OOoCreateNewWriterDocument()
    LOCAL oWriterDoc
    oWriterDoc = OOoOpenURL( "private:factory/swriter" )
    RETURN oWriterDoc
ENDFUNC


* Easy way to create a new Calc document.
FUNCTION OOoCreateNewCalcDocument()
    LOCAL oCalcDoc
    oCalcDoc = OOoOpenURL( "private:factory/scalc" )
    RETURN oCalcDoc
ENDFUNC


* Easy way to create a new Impress document.
FUNCTION OOoCreateNewImpressDocument()
    LOCAL oImpressDoc
    oImpressDoc = OOoOpenURL( "private:factory/simpress" )
    RETURN oImpressDoc
ENDFUNC



FUNCTION OOoOpenFile( cFilename )
    LOCAL cURL
    cURL = OOoConvertToURL( cFilename )
    
    LOCAL oDoc
    oDoc = OOoOpenURL( cURL )
    RETURN oDoc
ENDFUNC


PROCEDURE OOoTerminateProgram()
    LOCAL oDesktop
    oDesktop = OOoGetDesktop()
    oDesktop.Terminate()
    
    =__OOoReleaseCachedVars()
ENDPROC


* Convert a local filename to an OOo URL.
FUNCTION OOoConvertToURL( cFilename )
    * Ensure leading slash.
    IF LEFT( cFilename, 1 ) != "/"
        cFileName = "/" + cFileName
    ENDIF
    
    LOCAL cURL
    cURL = CHRTRAN( cFilename, "\", "/" )    && change backslashes to forward slashes.
    cURL = "file://" + cURL
    RETURN cURL
ENDFUNC




*############################################################
*    Draw specific tools
*############################################################


* Page zero is the first page.
* Once you have a drawing document, obtain one of its pages.
FUNCTION OOoGetDrawPage( oDrawDoc, nPageNum )
    LOCAL oPages
    oPages = oDrawDoc.GetDrawPages()
    LOCAL oPage
    oPage = oPages.GetByIndex( nPageNum )
    RETURN oPage
ENDFUNC


* Given a draw document, create a shape.
* The shape must be added to the draw page, by calling
*  the draw page's Add() method.
* The oPosition and oSize arguments are optional, but you may
*  pass a Point and Size struct for these arguments.

FUNCTION OOoMakeRectangleShape( oDrawDoc, oPosition, oSize )
    LOCAL oShape
    oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.RectangleShape", oPosition, oSize )
    RETURN oShape
ENDFUNC

FUNCTION OOoMakeEllipseShape( oDrawDoc, oPosition, oSize )
    LOCAL oShape
    oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.EllipseShape", oPosition, oSize )
    RETURN oShape
ENDFUNC

FUNCTION OOoMakeLineShape( oDrawDoc, oPosition, oSize )
    LOCAL oShape
    oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.LineShape", oPosition, oSize )
    RETURN oShape
ENDFUNC

FUNCTION OOoMakeTextShape( oDrawDoc, oPosition, oSize )
    LOCAL oShape
    oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.TextShape", oPosition, oSize )
    RETURN oShape
ENDFUNC


* Create and return a Point struct.
FUNCTION OOoPosition( nX, nY )
    LOCAL oPoint
    oPoint = OOoCreateStruct( "com.sun.star.awt.Point" )
    oPoint.X = nX
    oPoint.Y = nY
    RETURN oPoint
ENDFUNC

* Create and return a Size struct.
FUNCTION OOoSize( nWidth, nHeight )
    LOCAL oSize
    oSize = OOoCreateStruct( "com.sun.star.awt.Size" )
    oSize.Width = nWidth
    oSize.Height = nHeight
    RETURN oSize
ENDFUNC


* Given a shape, alter its position.
PROCEDURE OOoSetPosition( oShape, nX, nY )
    LOCAL oPosition
    oPosition = oShape.Position
    oPosition.X = nX
    oPosition.Y = nY
    oShape.Position = oPosition
ENDPROC

* Given a shape, alter its size.
PROCEDURE OOoSetSize( oShape, nWidth, nHeight )
    LOCAL oSize
    oSize = oShape.Size
    oSize.Width = nWidth
    oSize.Height = nHeight
    oShape.Size = oSize
ENDPROC


* Given a draw document, create a shape.
* Optional:  oPosition, oSize can receive a Point or Size struct.
FUNCTION OOoMakeShape( oDrawDoc, cShapeClassName, oPosition, oSize )
    LOCAL oShape
    oShape = oDrawDoc.CreateInstance( cShapeClassName )
    
    IF (TYPE([oPosition])="O")  AND  (NOT ISNULL( oPosition ))
        oShape.Position = oPosition
    ENDIF
    IF (TYPE([oSize])="O")  AND  (NOT ISNULL( oSize ))
        oShape.Size = oSize
    ENDIF
    
    RETURN oShape
ENDFUNC



*############################################################
*    Color conversion utilities
*    --------------------------
*    Visual FoxPro and OpenOffice.org do not represent
*     color values the same way.
*    Conversion routines in both directions are provided
*     to keep things easy.
*    In addition, extremely convenient HSV routines are provided.
*    See LibGraphics for discussion of HSV color model.
*############################################################


* Similar to VFP's built in RGB() function.
* Pass in R,G,B values and out comes an OpenOffice.org color value.
* Note that this is DIFFERENT from how VFP constructs color values.
FUNCTION OOoRGB( nRed, nGreen, nBlue )
    RETURN BITOR( BITOR( BITLSHIFT( nRed, 16 ), BITLSHIFT( nGreen, 8 ) ), nBlue )
ENDFUNC

* Translate between a Visual FoxPro color and an OpenOffice.org color
*  by using a simple formula.
* Pass in a VFP color, out comes an OOo color.  And vice versa.
FUNCTION OOoColor( nColor )
    LOCAL nTranslatedColor
    nTranslatedColor = (INT( nColor / 65536 )) + (INT( INT( nColor / 256 ) % 256 ) * 256) + (INT( nColor % 256 ) * 65536)
    RETURN nTranslatedColor
ENDFUNC

* Extract the Red component from an OpenOffice.org color.
* SImilar to the RGBRed() function in LibGraphics.
FUNCTION OOoRed( nOOoColor )
*    RETURN INT( nOOoColor / 65536 )
    RETURN BITRSHIFT( BITAND( nOOoColor, 0x00FF0000 ), 16 )
ENDFUNC

* Extract the Green component from an OpenOffice.org color.
* SImilar to the RGBGreen() function in LibGraphics.
FUNCTION OOoGreen( nOOoColor )
*    RETURN INT( INT( nOOoColor / 256 ) % 256 )
    RETURN BITRSHIFT( BITAND( nOOoColor, 0x0000FF00 ), 8 )
ENDFUNC

* Extract the Blue component from an OpenOffice.org color.
* SImilar to the RGBBlue() function in LibGraphics.
FUNCTION OOoBlue( nOOoColor )
*    RETURN INT( nOOoColor % 256 )
    RETURN BITAND( nOOoColor, 0x000000FF )
ENDFUNC

* Convenient way to construct an OOo color from HSV components.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.
FUNCTION OOoHSV( nHue, nSaturation, nBrightness )
    LOCAL nColor
    nColor = MakeHSVColor( nHue * 6.0, nSaturation, nBrightness )
    nColor = OOoColor( nColor )
    RETURN nColor
ENDFUNC

* Convenient way to extract the Hue component from an OOo color.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.
FUNCTION OOoHue( nOOoColor )
    RETURN HSVHue( OOoColor( nOOoColor ) ) / 6.0
ENDFUNC

* Convenient way to extract the Saturation component from an OOo color.
* See LibGraphics for information about HSV.
FUNCTION OOoSaturation( nOOoColor )
    RETURN HSVSaturation( OOoColor( nOOoColor ) )
ENDFUNC

* Convenient way to extract the Brightness component from an OOo color.
* See LibGraphics for information about HSV.
FUNCTION OOoBrightness( nOOoColor )
    RETURN HSVValue( OOoColor( nOOoColor ) )
ENDFUNC



*############################################################



PROCEDURE DoNothing__ErrorHandler( pnError, pcErrMessage, pnLineNo, pcProgramFileSys16, pcProgram, pcErrorParamSys2018 )
ENDPROC


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


*!*    * Return an instance of com.sun.star.reflection.CoreReflection.
*!*    * Cache it in a global variable.
*!*    * Create it if not already cached.
*!*    FUNCTION OOoGetCoreReflection()
*!*        IF (TYPE([goOOoCoreReflection])!="O")  OR  ISNULL( goOOoCoreReflection )
*!*            PUBLIC goOOoCoreReflection
*!*            goOOoCoreReflection = OOoServiceManager_CreateInstance( "com.sun.star.reflection.CoreReflection" )
*!*            COMARRAY( goOOoCoreReflection, 10 )
*!*        ENDIF
*!*        RETURN goOOoCoreReflection
*!*    ENDFUNC


*!*    * Create a UNO struct object and return it.
*!*    * This routine is now obsolete.
*!*    * See a superior implementation of this routine elsewhere
*!*    *  which uses the Bridge_GetStruct() feature of the OLE-UNO bridge.
*!*    FUNCTION OOoCreateStruct( cTypeName )
*!*        * Ask service manager for a CoreReflection object.
*!*        LOCAL oCoreReflection
*!*        oCoreReflection = OOoGetCoreReflection()
*!*        
*!*        * Get the IDL Class for the type name.
*!*        LOCAL oXIdlClass
*!*        oXIdlClass = .NULL.

*!*        LOCAL cOldErrHandler
*!*        cOldErrHandler = ON( "ERROR" )
*!*        ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
*!*            oXIdlClass = oCoreReflection.forName( cTypeName )
*!*        ON ERROR &cOldErrHandler
*!*        
*!*        IF ISNULL( oXIdlClass )
*!*            =__OOoReleaseCachedVars()
*!*            oCoreReflection = OOoGetCoreReflection()
*!*            oXIdlClass = oCoreReflection.forName( cTypeName )
*!*        ENDIF
*!*        
*!*        * Create a variable to hold the created Struct.
*!*        * Assign it some initial value.
*!*        LOCAL oStruct
*!*        oStruct = CREATEOBJECT( "relation" ) && assign some kind of object initially

*!*        * Ask the class definition to create an instance.
*!*        oXIdlClass.CreateObject( @oStruct )
*!*        
*!*        RETURN oStruct
*!*    ENDFUNC


* Create a com.sun.star.beans.PropertyValue struct and return it.
FUNCTION OOoPropertyValue( cName, uValue, nHandle, nState )
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



* Open or Create a document from it's URL.
* New documents are created by URL's such as:
*    private:factory/sdraw
*    private:factory/swriter
*    private:factory/scalc
*    private:factory/simpress
FUNCTION OOoOpenURL( cURL )
*    LOCAL oPropertyValue
*    oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )

*    LOCAL ARRAY aNoArgs[1]
*    aNoArgs[1] = oPropertyValue
*    aNoArgs[1].Name = "ReadOnly"
*    aNoArgs[1].Value = .F.

    * These two lines replace the alternate version above,
    *  which are left commented for the insight they provide.
    LOCAL ARRAY aNoArgs[1]
    aNoArgs[1] = OOoPropertyValue( "Hidden", .F. )
    
    LOCAL oDesktop
    oDesktop = OOoGetDesktop()

    LOCAL oDoc
    oDoc = oDesktop.LoadComponentFromUrl( cURL, "_blank", 0, @ aNoargs )
    
    * Make sure that arrays passed to this document are passed zero based.
    COMARRAY( oDoc, 10 )
    
    RETURN oDoc
ENDFUNC


PROCEDURE __OOoReleaseCachedVars()
    RELEASE goOOoServiceManager, goOOoDesktop, goOOoCoreReflection
ENDPROC



*############################################################


* Experimental stuff



*SET PROCEDURE TO LibOOo ADDITIVE
*oDoc = OOoOpenFile( GetDesktopFolderPathname() + "test.sxw" )


* This is an attempt to print a document.
PROCEDURE PrintExperiment( oDoc )
    LOCAL ARRAY aArgs[1]
    aArgs[1] = OOoPropertyValue( "CopyCount", 1, -1, 0 )
*    aArgs[1] = OOoPropertyValue( "Collate", .F. )
    
    oDoc.Print( @ aArgs )
ENDPROC


*############################################################


PROCEDURE TestOOoDraw()
    * Create a drawing.
    LOCAL oDoc
    oDoc = OOoCreateNewDrawDocument()
    
    * Get the first page of the drawing.
    LOCAL oPage
    oPage = OOoGetDrawPage( oDoc, 0 )
    
    LOCAL nHue, nSaturation, nBrightness
    LOCAL nRow, nCol
    LOCAL oShape

    * Now let's draw some rectangles.

    *-----
    *    Notes about HSV color notation.
    * Imagine hue is a "rainbow" of colors, from 0.0 to 1.0.
    * 0.0 is red, then you progress to orange, yellow, green, blue, purple, and
    *  then back to red again.  (Not like a real rainbow.)  1.0 is red also.
    * HSV colors are easy for HUMANS, while RGB colors are easy for COMPUTERS.
    * Quick, what is the RGB for Pink?  Brown?
    * In HSV, you would think Pink is a low-saturation red at full brightness,
    *  thus you could say H=0.0, S=0.5, B=1.0; and that's off the top of my head.
    * Brown is a low brightness Orange, so H=0.0888, S=1.0, B=0.6; right out of thin air.
    * Need a highly contrasting color?  Easy in HSV coordinates.
    * Just pick the opposite hue, maybe maximize saturation (opposite of other color),
    *  and maybe also a min or max brightness.  Can't easily come up with highly
    *  contrasting colors in RGB coordinates in RGB space.
    * Need to "soften" colors?  Take each HSV coordinate, and lower the saturation
    *  by 10 %.
    * Need to "darken" colors?  Lower the brightness of each pixel by 10 %.
    *-----
    
    * Let's vary the hue and saturation, while keeping the brightness constant.
    * But you could vary any two parameters, while keeping the third constant.
    
    nBrightness = 1.0 && full brightness
    FOR nRow = 0 TO 9
        FOR nCol = 0 TO 9
            * Create a shape
            oShape = OOoMakeRectangleShape( oDoc )
            * Calculate color
            nHue = nCol / 9 && hue varies *across* by column
            nSaturation = nRow / 9 && saturation varies *down* by row
            * set color of shape
            * oShape.FillColor = OOoRGB( 255, 255, 255 )
            oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
            * Position and size the shape
            OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
            OOoSetPosition( oShape, 1000 + nCol * 600, 1000 + nRow * 600 )
            * Add shape to page
            oPage.Add( oShape )
        ENDFOR
    ENDFOR


    * Let's vary the hue and saturation, while keeping the brightness constant.
    * This time, we'll use less-brightness
    * But you could vary any two parameters, while keeping the third constant.
    
    nBrightness = 0.7 && less brightness
    FOR nRow = 0 TO 9
        FOR nCol = 0 TO 9
            * Create a shape
            oShape = OOoMakeRectangleShape( oDoc )
            * Calculate color
            nHue = nCol / 9 && hue varies *across* by column
            nSaturation = nRow / 9 && saturation varies *down* by row
            * set color of shape
            oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
            * Position and size the shape
            OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
            OOoSetPosition( oShape, 9000 + nCol * 600, 1000 + nRow * 600 )
            * Add shape to page
            oPage.Add( oShape )
        ENDFOR
    ENDFOR


    * Let's vary the hue and brightness, while keeping the saturation constant.
    * But you could vary any two parameters, while keeping the third constant.
    
    nSaturation = 1.0 && full saturation
    FOR nRow = 0 TO 9
        FOR nCol = 0 TO 9
            * Create a shape
            oShape = OOoMakeRectangleShape( oDoc )
            * Calculate color
            nHue = nRow / 9 && hue varies *down* by row
            nBrightness = nCol / 9 && brightness varies *across* by column
            * set color of shape
            oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
            * Position and size the shape
            OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
            OOoSetPosition( oShape, 1000 + nCol * 600, 9000 + nRow * 600 )
            * Add shape to page
            oPage.Add( oShape )
        ENDFOR
    ENDFOR


    * Let's vary the saturation and brightness, while keeping the hue constant.
    * The hue will be yellow.
    * But you could vary any two parameters, while keeping the third constant.

    nHue = 0.1666 && yellow
    FOR nRow = 0 TO 9
        FOR nCol = 0 TO 9
            * Create a shape
            oShape = OOoMakeRectangleShape( oDoc )
            * Calculate color
            nSaturation = nRow / 9 && saturation varies *down* by row
            nBrightness = nCol / 9 && brightness varies *across* by column
            * set color of shape
            oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
            * Position and size the shape
            OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
            OOoSetPosition( oShape, 9000 + nCol * 600, 9000 + nRow * 600 )
            * Add shape to page
            oPage.Add( oShape )
        ENDFOR
    ENDFOR
    
    
    * Gee, you don't suppose someone out there could take the knowledge represented
    *  by this code and figure out how to make OpenOffice.org draw bar charts?
    
ENDPROC


PROCEDURE TestOOoCalc()
    * Create a spreadsheet.
    LOCAL oDoc
    oDoc = OOoCreateNewCalcDocument()
    
    * Get first sheet
    LOCAL oSheet
    oSheet = oDoc.getSheets().getByIndex( 0 )
    
    * Plug in some stuff...
    oSheet.getCellByPosition( 0, 0 ).setFormula( "Month" )
    oSheet.getCellByPosition( 1, 0 ).setFormula( "Sales" )
    oSheet.getCellByPosition( 0, 1 ).setFormula( "Jan" )
    oSheet.getCellByPosition( 0, 2 ).setFormula( "Feb" )
    oSheet.getCellByPosition( 0, 3 ).setFormula( "Mar" )
    oSheet.getCellByPosition( 0, 4 ).setFormula( "Apr" )
    oSheet.getCellByPosition( 0, 5 ).setFormula( "May" )
    oSheet.getCellByPosition( 0, 6 ).setFormula( "Jun" )
    oSheet.getCellByPosition( 1, 1 ).setValue( 3826 )
    oSheet.getCellByPosition( 1, 2 ).setValue( 3504 )
    oSheet.getCellByPosition( 1, 3 ).setValue( 2961 )
    oSheet.getCellByPosition( 1, 4 ).setValue( 2504 )
    oSheet.getCellByPosition( 1, 5 ).setValue( 2102 )
    oSheet.getCellByPosition( 1, 6 ).setValue( 1756 )
    
    LOCAL ARRAY aOneArg[1]
    LOCAL cFile, cURL
    
*    cFile = GetDesktopFolderPathname()+"example"
    cFile = "c:\example"

    * Now save the spreadsheet.
    cURL = OOoConvertToURL( cFile + ".sxw" )
    aOneArg[1] = OOoPropertyValue( "Overwrite", .T. )
    oDoc.storeToUrl( cURL, @ aOneArg )
    
    * Now save it as Excel
    cURL = OOoConvertToURL( cFile + ".xls" )
    aOneArg[1] = OOoPropertyValue( "FilterName", "MS Excel 97" )
    oDoc.storeToUrl( cURL, @ aOneArg )
ENDPROC




PROCEDURE CreateHueRainbow()
    * Create a drawing.
    LOCAL oDoc
    oDoc = OOoCreateNewDrawDocument()
    
    * Get the first page of the drawing.
    LOCAL oPage
    oPage = OOoGetDrawPage( oDoc, 0 )
    
    LOCAL nHue, nSaturation, nBrightness
    LOCAL nCol
    LOCAL oShape

    * Now let's draw some rectangles.

    * Let's vary the hue and saturation, while keeping the brightness constant.
    * But you could vary any two parameters, while keeping the third constant.
    
    nBrightness = 1.0 && full brightness
    nSaturation = 1.0 && full saturation
    FOR nCol = 0 TO 200
        * Create a shape
        oShape = OOoMakeRectangleShape( oDoc )
        * Calculate color
        nHue = nCol / 200 && hue varies *across* by column
        * set color of shape
        * oShape.FillColor = OOoRGB( 255, 255, 255 )
        oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
        * Position and size the shape
        OOoSetSize( oShape, 52, 2000 ) && 0.05 cm by 2 cm
        OOoSetPosition( oShape, 1000 + nCol * 50, 1000 )
        oShape.LineStyle = 0
        * Add shape to page
        oPage.Add( oShape )
    ENDFOR
    
    LOCAL cFile, cURL
*    cFile = GetDesktopFolderPathname()+"hue rainbow"
    cFile = "c:\hue rainbow"
    cURL = OOoConvertToURL( cFile + ".sxd" )
    LOCAL ARRAY aOneArg[1]
    aOneArg[1] = OOoPropertyValue( "Overwrite", .T. )
    oDoc.storeAsUrl( cURL, @ aOneArg )
*    oDoc.dispose()
ENDPROC
