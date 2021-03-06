* MLdbdoc.prg
* Documents structure of any database
LPARAMETERS pcDatabase, pcDataPath

LOCAL lcCurDir

lcCurDir = CURDIR()
SET DEFAULT TO i:\micodigo\mygest\utils,i:\micodigo\mygest\data

IF VARTYPE(pcDataBase)<>"C"
	pcDataBase = "myData"
ENDIF
IF VARTYPE(pcDataPath)<>"C"
	pcDataPath = "i:\micodigo\mygest\data\"
ENDIF

* Open output file
pcTextFile = pcDatabase + ".TXT"
SET ALTERNATE TO (pcTextFile)
SET ALTERNATE ON

* Close any open tables
CLOSE TABLES
CLOSE DATABASE

* Open database
OPEN DATABASE (pcDataPath+pcDatabase)

* Get table names
pnTables = ADBOBJECTS(laTables, "TABLE")
* Sort in alphabetical order
=ASORT(laTables)

* Process all tables
FOR pnTableCount = 1 TO pnTables
   * Open next table
   pcTableName = laTables[pnTableCount]
   USE (pcTableName)
   * Store field properties in array
   pnFields = AFIELDS(laFields)

   ? "Structure for table:  " + UPPER(DBGETPROP(pcTableName, "TABLE", "PATH")) +;
     " (" + PROPER(pcTableName) + ")"
   ? "Number of records:    " + LTRIM(STR(RECCOUNT()))
   ? "Date of last update:  " + DTOC(LUPDATE())
   ? "Memo file block size: " + LTRIM(STR(SET("BLOCKSIZE")))
   ? "Code Page:            " + LTRIM(STR(CPCURRENT()))
   ? "Num"+CHR(9)+"Field Name"+CHR(9)+"Type"+CHR(9)+"Width"+CHR(9)+"Dec"+CHR(9)+"Nulls"+CHR(9)+"Default"

   * List field data
   FOR pnFieldCount = 1 TO pnFields
      ?  pnFieldCount PICTURE "999"                             && Field number
      ?? CHR(9)
      ?? PADR(ALLTRIM(laFields[pnFieldCount, 1]), 25)                    && Name
      ?? CHR(9)
      ?? laFields[pnFieldCount, 2]                              && Data type
      ?? CHR(9)
      ?? laFields[pnFieldCount, 3] PICTURE "999"                && Width
      ?? laFields[pnFieldCount, 4] PICTURE "99999"              && Decimals
      ?? CHR(9)
      ?? IIF(laFields[pnFieldCount, 5], "Yes", "No")+CHR(9)       && Nulls ok?
      ?? laFields[pnFieldCount, 9]                              && Default
   ENDFOR
   ?  "-----" AT 36
   ?  RECSIZE() AT 36 PICTURE "99999"
   ?
   ?
   
   ************** IF 1=0
   
   * List additional field information
   ?  "Additional Field Information:"
   FOR pnFieldCount = 1 TO pnFields
      pcFieldName = pcTableName + "." + laFields[pnFieldCount, 1]
      pcComment = DBGETPROP(pcFieldName, "FIELD", "Comment")
      pcCaption = DBGETPROP(pcFieldName, "FIELD", "Caption")
      pcValid = DBGETPROP(pcFieldName, "FIELD", "RuleExpression")
      pcMessage = DBGETPROP(pcFieldName, "FIELD", "RuleText")

      IF NOT EMPTY(pcComment + pcCaption + pcValid + pcMessage)
         ?
         ? laFields[pnFieldCount, 1]
         IF NOT EMPTY(pcComment)
            ?  "   Comment:    "
            ?? pcComment PICTURE "@V60"
         ENDIF   
         IF NOT EMPTY(pcCaption)
            ?  "   Caption:    "
            ?? pcCaption
         ENDIF   
         IF NOT EMPTY(pcValid)
            ?  "   Validation: "
            ?? pcValid PICTURE "@V60"
         ENDIF   
         IF NOT EMPTY(pcMessage)
            ?  "   Error Message: "
            ?? pcMessage PICTURE "@V60"
         ENDIF   
      ENDIF
   ENDFOR   

   * List additional table information
   ?
   ?
   ?  "Additional Table Information:"
   ?
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "Comment"))
      ?  "Comment:        "
      ?? DBGETPROP(pcTableName, "TABLE", "Comment") PICTURE "@V60"
   ENDIF
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "RuleExpression"))
      ?  "Validation:     "
      ?? DBGETPROP(pcTableName, "TABLE", "RuleExpression") PICTURE "@V60"
   ENDIF
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "RuleText"))
      ?  "Error Message:  "
      ?? DBGETPROP(pcTableName, "TABLE", "RuleText") PICTURE "@V60"
   ENDIF
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "InsertTrigger"))
      ?  "Insert Trigger: "
      ?? DBGETPROP(pcTableName, "TABLE", "InsertTrigger") PICTURE "@V60"
   ENDIF
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "UpdateTrigger"))
      ?  "Update Trigger: "
      ?? DBGETPROP(pcTableName, "TABLE", "UpdateTrigger") PICTURE "@V60"
   ENDIF
   IF NOT EMPTY(DBGETPROP(pcTableName, "TABLE", "DeleteTrigger"))
      ?  "Delete Trigger: "
      ?? DBGETPROP(pcTableName, "TABLE", "DeleteTrigger") PICTURE "@V60"
   ENDIF
   
   ***************** ENDIF
      
   IF TAGCOUNT() > 0
      ?
      ? "Indexes:"
      ?  "  Type       Tag Name            Key Expression"
      FOR pnCounter = 1 TO TAGCOUNT()
         ?  "  "
         DO CASE
            CASE PRIMARY(pnCounter)
               ?? "Primary    "
            CASE CANDIDATE(pnCounter)
               ?? "Candidate  "
            CASE UNIQUE(pnCounter)
               ?? "Unique     "
            OTHERWISE
               ?? "Regular    "
         ENDCASE            
         ?? PADR(TAG(pnCounter),20)
         ?? KEY(pnCounter) PICTURE "@V50"
      ENDFOR
   ENDIF
   ?
   ?
ENDFOR

* Open database as a table
pcDBCName = pcDatabase + ".DBC"
USE (pcDataPath+pcDBCName) AGAIN
* Get view names
pnViews = ADBOBJECTS(laViews, "VIEW")

llError = .F.
* Sort in alphabetical order

ON ERROR llError = .T.
=ASORT(laViews)
ON ERROR

IF !llError
   * Process all Views
   FOR pnViewCount = 1 TO pnViews
      pcViewName = laViews[pnViewCount]
      IF DBGETPROP(pcViewName, "View", "SourceType") = 1
         ? "Local View: "
      ELSE
         ? "Remote View: "
      ENDIF
      ?? pcViewName
      ?
      ? "SQL Statement: "
      ? DBGETPROP(pcViewName, "View", "SQL") FUNCTION "@V70"
      ?
      IF DBGETPROP(pcViewName, "View", "SourceType") = 2
         ? "Connection: " + DBGETPROP(pcViewName, "View", "ConnectName")
         IF DBGETPROP(pcViewName, "View", "ShareConnection")
            ?? "  (Can be shared)"
         ELSE
            ?? "  (Cannot be shared)"
         ENDIF
         ?
         ? "Number of records to fetch at a time:   " + LTRIM(STR(DBGETPROP(pcViewName, "View", "FetchSize")))
         ? "Maximum number of records to fetch:     " + LTRIM(STR(DBGETPROP(pcViewName, "View", "MaxRecords")))
         ? "Use Memo when Character field length >= " + LTRIM(STR(DBGETPROP(pcViewName, "View", "UseMemoSize")))
         ? "Number of records in a batch update:    " + LTRIM(STR(DBGETPROP(pcViewName, "View", "BatchUpdateCount")))
         ? "Fetch Memo fields:                      " + IIF(DBGETPROP(pcViewName, "View", "FetchMemo"), "Yes", "No")
         ?
         LOCATE FOR ObjectType = "View" AND UPPER(ObjectName) = pcViewName
         pcParentID = ObjectID
         pcUpdateable = ""
         SCAN FOR ParentID = pcParentID AND ObjectType = "Field"
            pcFieldName = pcViewName + "." + TRIM(ObjectName)
            IF DBGETPROP(pcFieldName, "FIELD", "Updatable")
               pcUpdateName = DBGETPROP(pcFieldName, "FIELD", "UpdateName")
               pcUpdateable = pcUpdateable + pcUpdateName + ", "
            ENDIF
         ENDSCAN
         IF LEN(pcUpdateable) = 0
            ? "No Updateable Fields"
         ELSE
            ? "Updateable Fields: "
            ? "   "
            ?? LEFT(pcUpdateable, LEN(pcUpdateable)-2) FUNCTION "@V80"
            ?
            ? "SQL WHERE clause includes "
            pcWhereType = DBGETPROP(pcViewName, "View", "WhereType")
            DO CASE
               CASE pcWhereType = 1
                  ?? "key fields only"      
               CASE pcWhereType = 2
                  ?? "key and updateable fields"      
               CASE pcWhereType = 3
                  ?? "key and modified fields"      
               CASE pcWhereType = 4
                  ?? "key and timestamp fields"      
            ENDCASE
            ? "Update using " + IIF(DBGETPROP(pcViewName, "View", "UpdateType") = 1, "SQL UPDATE", "SQL DELETE then INSERT")
         ENDIF   
      ENDIF   
      ?
      ?
   ENDFOR
ENDIF

CLOSE DATABASE
CLOSE ALTERNATE

RETURN

* End of program MLdbdoc.prg
