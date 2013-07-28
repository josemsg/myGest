SET STEP ON 

LOCAL oCR AS CRAXDRT.Application
LOCAL oRpt AS CRAXDRT.Report
LOCAL oDB AS CRAXDRT.Database
LOCAL ocDBT AS CRAXDRT.DatabaseTables
LOCAL oDBT AS CRAXDRT.DatabaseTable
LOCAL oExp AS CRAXDRT.ExportOptions
LOCAL ocParm AS CRAXDRT.ParameterFieldDefinitions
LOCAL oParm AS CRAXDRT.ParameterFieldDefinition

oCR = CREATEOBJECT("CrystalRuntime.Application")
oRpt = oCR.OpenReport("T:\Personal Reports\clientes.RPT")

* Create the Database object
oDB = oRpt.Database()
* Get a references to the DatabaseTables collection
ocDBT = oDB.Tables()
* Get a reference to the DatabaseTable object for table 1
oDBT = ocDBT.Item(1)
* This one works for a DSN
*oDBT.SetLogOnInfo("TazODBCRuntime")

IF oRPt.HasSavedData
	oRPT.DiscardSavedData()
ENDIF

* Parametros
ocParm = oRpt.ParameterFields()
oParm = ocParm.Item(1)
*WAIT WINDOW ocParm.Item(1).Name
oParm.SetCurrentValue(500)
oParm = ocParm.Item(2)
*WAIT WINDOW ocParm.Item(2).Name
oParm.SetCurrentValue(1000)

*oRpt.ReadRecords()

oExp = oRpt.ExportOptions()
oExp.DestinationType = 1 && crEDTDiskFile
oExp.FormatType = 31 && PDF   27 && crEFTExcel70
oExp.DiskFileName = "T:\Personal Reports\clientes.PDF"


oRpt.Export(.F.)

RETURN


SYS(2335, 1)

LOCAL oCR AS CRAXDRT.Application.11
LOCAL oRpt AS CRAXDRT.Report
LOCAL oDB AS CRAXDRT.Database
LOCAL ocDBT AS CRAXDRT.DatabaseTables
LOCAL oDBT AS CRAXDRT.DatabaseTable
LOCAL ocParm AS CRAXDRT.ParameterFieldDefinitions
LOCAL oParm AS CRAXDRT.ParameterFieldDefinition

oCR = CREATEOBJECT("CrystalRuntime.Application.11")
oRpt = oCR.OpenReport("T:\Personal Reports\clientes.RPT")
* Create the Database object
oDB = oRpt.Database()
* Get a references to the DatabaseTables collection
ocDBT = oDB.Tables()
* Get a reference to the DatabaseTable object for table 1
oDBT = ocDBT.Item(1)
* This one works for a DSN
*oDBT.SetLogOnInfo("TazODBCRuntime")

IF oRPt.HasSavedData
	oRPT.DiscardSavedData()
ENDIF

* Get the Special Message Parameter
*!*	ocParm = oRpt.ParameterFields()
*!*	oParm = ocParm.Item(1)
*oParm.SetCurrentValue("This is the runtime special message")
oRpt.PrintOut()