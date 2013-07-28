#DEFINE lAdditive .T.
#DEFINE CR        CHR(10)
#DEFINE cTab      CHR(9)
#DEFINE vfpYesNo  4

DEFINE CLASS FoxToXML AS CUSTOM
    cFileName = ""
    sFileName = ""

    PROCEDURE BOTH
        LPARAMETER cTableName

        IF !EMPTY(cTableName)
            RETURN THIS.UseThisData(cTableName)
        ENDIF

        IF THIS.CheckAlias()
            THIS.xml
            THIS.xsl
        ENDIF
    ENDPROC

    PROCEDURE XML
        LPARAMETER cTableName

        THIS.UseThisData(cTableName)
        IF THIS.CheckALIAS()
            SET TEXTMERGE ON NOSHOW
            SET TEXTMERGE TO (THIS.cFileName) NOSHOW
            \\<?xml version="1.0" encoding="ISO-8859-1"?>
            \<<'<?xml-stylesheet type="text/xsl" href="'+ THIS.sFileName +'"?>'>>
            \<<CHR(60)+ALIAS()+"_table"+CHR(62)>>
            SCAN
            \<<CHR(60)+ALIAS()+CHR(62)>>
                FOR iFields = 1 TO FCOUNT()
                    cField = FIELD(iFields)
                    \<<"    "+CHR(60) + TRIM(cField)+CHR(62)+CHR(60)+"![CDATA[">>
                    m.mvalu = IIF(VARTYPE(&cField) = "G", "General Field", ;
                        IIF(VARTYPE(&cField) = "L", IIF(&cField, "T", "F"), &cField))
                    \\<<m.mvalu>>
                    \\<<"]]"+CHR(62)+CHR(60)+"/"+TRIM(cField)+CHR(62)>>
                NEXT
            \<<CHR(60)+"/"+ ALIAS()+CHR(62)>>
            ENDSCAN
            \<<CHR(60)+"/"+ ALIAS()+"_table"+CHR(62)>>
            SET TEXTMERGE TO
            SET TEXTMERGE OFF

            RETURN .T.
        ELSE
            RETURN .F.
        ENDIF
    ENDPROC

    PROCEDURE XSL
        *** This section creates the XSL document
        *** This particular stylesheet presents the data in a table format.
        LPARAMETER cTableName

        THIS.UseThisData(cTableName)
        IF THIS.CheckAlias()
            STRTOFILE(;
                "<?xml version='1.0'?>" +CR+;
                THIS.pTab(1)+"<xsl:stylesheet xmlns:xsl='http://www.w3.org/TR/WD-xsl'>" +CR+;
                THIS.pTab(2)+"<xsl:template match='/'>" +CR+;
                THIS.pTab(3)+"<HTML>" +CR+;
                THIS.pTab(3)+"<HEAD>"+CR+;
                THIS.pTab(3)+"<TITLE>"+ALIAS()+ "</TITLE>" +CR+;
                THIS.pTab(3)+"<H2>"+ALIAS()+ " Information</H2>" +CR+;
                THIS.pTab(3)+"</HEAD>"+CR+;
                THIS.pTab(4)+"<BODY BGCOLOR = 'white'>" +CR+;
                THIS.pTab(5)+"<TABLE BORDER= '1' bgcolor='#FFFFF0'>" +CR+;
                THIS.pTab(6)+"<TR>" +CR, THIS.sFileName)

            FOR iFields = 1 TO FCOUNT()
                cField = FIELDS(iFields)
                STRTOFILE(THIS.pTab(6)+"<TD><b>"+ cField+ "</b></TD>" +CR, THIS.sFileName, lAdditive)
            ENDFOR iFields
            STRTOFILE(THIS.pTab(6)+"</TR>" +CR, THIS.sFileName, lAdditive)

            STRTOFILE(THIS.pTab(6) + "<xsl:for-each select='" + ALIAS() + "_table/" + ALIAS() + "'>" +;
                CR + THIS.pTab(6)+"<TR>"+CR, THIS.sFileName, lAdditive)

            FOR iFields = 1 TO FCOUNT()
                cField = FIELDS(iFields)
                STRTOFILE(THIS.pTab(7)+"<TD><xsl:value-of select='"+ cField+ "'/></TD>"+CR, THIS.sFileName, lAdditive)
            ENDFOR iFields

            STRTOFILE(THIS.pTab(6)+"</TR>"+CR, THIS.sFileName, lAdditive)
            STRTOFILE(THIS.pTab(6)+"</xsl:for-each>"+CR+;
                THIS.pTab(5)+"</TABLE>"+CR+;
                THIS.pTab(4)+"</BODY>"+CR+;
                THIS.pTab(3)+"</HTML>"+CR+;
                THIS.pTab(2)+"</xsl:template>"+CR+;
                THIS.pTab(1)+"</xsl:stylesheet>", THIS.sFileName, lAdditive)
            RETURN .T.
        ELSE
            RETURN .F.
        ENDIF
    ENDPROC

    PROCEDURE pTab
        *** Tab Procedure
        *** THIS procedure puts in the tabs -- strictly for source file readability
        LPARAM nTab
        cTabString = ""
        FOR itab = 1 TO nTab
            cTabString = cTab + cTabString
        ENDFOR
        RETURN cTabString
        ***
    ENDPROC

    PROCEDURE UseThisData
        *** THIS procedure is used to verify that a table has been specified
        *** and exists if a table or cursor is not currently open.
        LPARAMETER cTableName
        IF !EMPTY(cTableName) AND FILE(cTableName + ".dbf")
            IF !USED(cTableName)
                USE &cTableName IN 0
            ELSE
                SELECT &cTableName
            ENDIF
            RETURN .T.
        ELSE
            RETURN .F.
        ENDIF
    ENDPROC

    PROCEDURE CheckAlias
        *** If there is no data source then the program will terminate
        IF EMPTY(ALIAS())
            RETURN .F.
        ELSE
            *** Uses the name of the current ALIAS() as the XML & XSL filenames
            THIS.cFileName = ALIAS()+ ".xml"
            THIS.sFileName = ALIAS()+ ".xsl"
            RETURN .T.
        ENDIF
    ENDPROC
ENDDEFINE
