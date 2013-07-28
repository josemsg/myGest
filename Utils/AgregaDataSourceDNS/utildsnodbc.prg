*!* Añadir un Origen de Datos (DNS) de ODBC
*!* Constantes para configurar DataSources

*!* Agrega un nuevo DataSource DNS
*!* Sintaxis: AddDataSource(tcDriver, tcAttributes)
*!* Valor devuelto:llRetVal
*!* Argumentos:tcDriver, tcAttributes
*!* tcDriver especifica el driver ODBC del DataSource DNS
*!* tcAttributes especifica la cadena de conexión del DataSource DNS
*!*
*!*  Nota: La cadena del driver es terminada con el caracter 0, a su vez, cada opcion de la cadena de conexión debe
*!*        de ser terminada con el caracter 0. Nótese que la cadena de conexión tambien es terminada con el caracter 0
*!*
*!*  Nota: Ejemplos de cadenas
*!*
*!* 'Microsoft Visual FoxPro Driver'
*!* 'DSN=Tabla VFP' + CHR(0) + 'Description=VFP ODBC Driver' + CHR(0) + 'SourceDB=temporal.dbf' + CHR(0) + 'SourceType=DBF'
*!* 'DSN=DataBase VFP' + CHR(0) + 'Description=VFP ODBC Driver' + CHR(0) + 'SourceDB=datos.dbc' + CHR(0) + 'SourceType=DBC'
*!*
*!* 'Microsoft Excel Driver (*.xls)'
*!* 'DSN=Hoja Excel' + CHR(0) + 'Description=Excel ODBC Driver' + CHR(0) + 'FileType=Excel 5.0' + CHR(0) + 'DBQ=temporal.xls' + CHR(0) + 'MaxScanRows=16'
*!*
*!* 'Microsoft Access Driver (*.mdb)'
*!* 'DSN=DataBase MDB' + CHR(0) + 'Description=Access ODBC Driver' + CHR(0) + 'uid=' + CHR(0) + 'pwd=' + CHR(0) + 'DBQ=datos.mdb'
*!*
*!* 'SQL Server'
*!* 'DSN=DataBase SQL' + CHR(0) + 'Description=SQL Server ODBC Driver' + CHR(0) + 'uid=sa' + CHR(0) + 'pwd=' + CHR(0) + 'Database=datos' + CHR(0) + 'Server=local' + CHR(0) + 'Network=default' + CHR(0) + 'address=default'
*!*
#define ODBC_ADD_DSN 4
x = 'Microsoft Access Driver (*.mdb)'
Y = 'DSN=DataBase MDB' + CHR(0) + 'Description=Access ODBC Driver' + CHR(0) + 'uid=' + CHR(0) + 'pwd=' + CHR(0) + 'DBQ=e:\interpruebas\somapach.mdb'
?AddDataSource(x,y)

FUNCTION AddDataSource
    LPARAMETERS tcDriver, tcAttributes
    LOCAL lcDriver, lcAttributes, llRetVal, lnIsAdded
    *!* Instrucciones DECLARE DLL para manipular DataSources
    DECLARE INTEGER SQLConfigDataSource IN ODBCCP32.dll INTEGER hwndParent, INTEGER fRequest, STRING lpszDriver, STRING lpszAttributes
    *!* Valores
    lcDriver    = IIF(EMPTY(tcDriver), 'Microsoft Visual FoxPro Driver', PROPER(tcDriver)) + CHR(0)
    lcAttributes = IIF(EMPTY(tcAttributes), 'DSN=Tabla VFP' + CHR(0) + 'Description=VFP ODBC Driver' + CHR(0) + 'SourceDB=temporal.dbf' + CHR(0) + 'SourceType=DBF', PROPER(tcAttributes)) + CHR(0)
    *!* Agregar el nuevo DataSource DNS
    lnIsAdded = SQLConfigDataSource(0, ODBC_ADD_DSN, lcDriver, lcAttributes)
    *!* Valores
    llRetVal = (lnIsAdded = 1)
    *!* Retorno
    RETURN llRetVal
ENDFUNC



*!* Eliminar un Origen de Datos (DNS) de ODBC
*!* Constantes para configurar DataSources


*!* Suprime Datasource DNS
*!* Sintaxis: DelDataSource(tcDriver, tcAttributes)
*!* Valor devuelto:llRetVal
*!* Argumentos:tcDriver, tcAttributes
*!* tcDriver especifica el driver ODBC del DataSource DNS
*!* tcAttributes especifica la cadena de conexión del DataSource DNS
FUNCTION DelDataSource
    LPARAMETERS tcDriver, tcAttributes
    LOCAL lcDriver, lcAttributes, llRetVal, lnIsRemoved
    *!* Instrucciones DECLARE DLL para manipular DataSources
    DECLARE INTEGER SQLConfigDataSource IN ODBCCP32.dll INTEGER hwndParent, INTEGER fRequest, STRING lpszDriver, STRING lpszAttributes
    *!* Valores
    lcDriver   = IIF(EMPTY(lcDriver), 'Microsoft Visual FoxPro Driver', PROPER(tcDriver)) + CHR(0)
    lcAttributes = IIF(EMPTY(lcAttributes), 'DSN=Tabla VFP' + CHR(0) + 'Description=VFP ODBC Driver' + CHR(0) + 'SourceDB=temporal.dbf' + CHR(0) + 'SourceType=DBF', PROPER(tcAttributes)) + CHR(0)
    *!* Eliminar el DataSource DNS
    lnIsRemoved = SQLConfigDataSource(1, ODBC_REMOVE_DSN,  lcDriver, lcAttributes)
    *!* Valores
    llRetVal = (lnIsRemoved > 0)
    *!* Retorno
    RETURN llRetVal
ENDFUNC