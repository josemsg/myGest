@CLS
@ECHO OFF
ECHO Instalando nueva versión del programa
"C:\Archivos de programa\7-Zip\7z.exe" x myGest-local.7z -x!my7UnZip.cmd -r -y
if errorlevel 0 goto correcto
if errorlevel 1 echo Error nº 1 - Warning, algún fichero no se ha podido procesar
if errorlevel 2 echo Error nº 2 - Error Fatal
if errorlevel 7 echo Error nº 7 - Error de Línea de comandos
if errorlevel 8 echo Error nº 8 - Error no hay suficiente memoria
if errorlevel 255 echo Error nº 255 - El usuario detuvo el proceso
pause
goto fin

:correcto
Echo proceso correcto


:fin

