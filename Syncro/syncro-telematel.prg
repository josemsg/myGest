*//-----------------------------------------------------------------------------
*//-----------------------------------------------------------------------------
*//- Syncro-Telematel.prg-------------------------------------------------------
*//- Función:   Sincronizar las tablas de Telematel con las tablas en la -------
*//-            base de datos de mySQL------------------------------------------
*//-            Las tablas están escritas en los registros de la tabla local----
*//-              syncro-tablas.dbf --------------------------------------------
*//-            Al final obtendremos un fichero script SQL, que ejecutaremos----
*//-            mediante: mysql -u root -p xxxxxx < file.sql -------------------
*//-----------------------------------------------------------------------------
*//-----------------------------------------------------------------------------
*//-----------------------------------------------------------------------------

*__ PASOS A SEGUIR
*__ 1. Inicializar variables: Localización del fichero tablas, etc.
*__ 2. Abrir conexiones a las bases de Telematel y de mySQL
*__ 3. Abrir la tabla: syncro-tablas.dbf
*__ 4. Recorrer los registros de la tabla.
*__     4.1. Ir añadiendo al string cada script SQL de cada tabla.
*__ 5. Una vez acabado el bucle ejecutar el script contra la base de datos
*__    en este caso "myPartes"
*__     5.1. Para ejecutar el script antes un BEGIN TRANSACTION;
*__     5.2. Si ha ido todo bien COMMIT; y si no ROLLBACK TRANSACTION;

            