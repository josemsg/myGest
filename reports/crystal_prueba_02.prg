SET STEP on

Local loCrystalApplication, loCrystalReport, loCrystalReportPara 
Local loExport 
Local lnTableCount 

*!* create a crystal report instance. 
loCrystalApplication = createObject('crystalRunTime.Application') 

*!* open the report you need. 
loCrystalReport = loCrystalApplication.openReport("T:\Personal Reports\clientes.rpt") 

*!* suppress the logon information 
*!* change the logon information programmatically 
*!* scan all the tables/view in the report. 
lnTableCount = loCrystalReport.Database.Tables.Count 
for lni = 1 to lnTableCount 
	With loCrystalReport.Database.Tables(lni) 

	*!* Save the current location name for later use. 
	lcTableName = .Location 

	*!* Change the table's logon info to correct one. 
	*!* first is the ODBC data source name. 
	*!* second is the databas name 
	*!* third is the login id. 
	*!* fourth is the password 
	.SetLogonInfo("tlmplus", "tlmplus", "userSQL", "userSQL") 
	*!* Change the table's location to follow format 
	*!* If you just change the table's logon info, 
	*!* it still using the old database 
	*!* full name (database.owner.table) 
	
	.Location = "myDatabase.dbo.myTable" 

	EndWith 
Next lni 

*!* if the report contains parameter, issue the follow codes. 
loCrystalReportPara = loCrystalReport.ParameterFields() 

*!* first parameter 
loCrystalReportPara.item(1).setCurrentValue(1) 
*!* second parameter ....n 
loCrystalReportPara.item(2).setCurrentValue(10) 

*!* print the report to printer with print dialog box. 
loCrystalReport.PrintOut(.t.) 

*!* to export the report to pdf format 
*!* use the below code. 

loExport = loCrystalReport.ExportOptions() 

With loExport 
&& crEFTPortableDocFormat = 31 
.FormatType = 31 
.DestinationType = 1 && Disk 
.DiskFileName = "T:\Personal Reports\clientes.PDF" &&result report in disk 
EndWith 

*!* suppress the export dialog box. 
loCrystalReport.export(.f.)