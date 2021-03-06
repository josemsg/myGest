*!*	Hace unos d�as, Luis Maria Guayan publico el art�culo Google Maps en un formulario de VFP que mostraba un ejemplo de como acceder a diferentes localizaciones en Google Maps mediante sus coordenadas terrestres
*!*	Al ver y probar el codigo publicado, enseguida me surgio la inquietud de adaptarlo a una b�squeda por la direcci�n postal en lugar de por sus coordenadas que, normalmente, no conozco.
*!*	Luis Maria me remiti� a otro articulo Integrando VFP con Microsoft Virtual Earth que mostraba un ejemplo muy completo de como realizar b�squedas (y muchas m�s cosas) sobre Virtual Earth.
*!*	Como el c�digo de Luis Maria era m�s sencillo (y se ajustaba mejor a mis necesidades), decid� revisar la API de Google Maps para implementar la b�squeda por la direcci�n postal.
*!*	Antes de pasar al c�digo, debo hacer varias aclaraciones sobre �ste:
*!*	En primer lugar, este c�digo puede ser ejecutado con do "MiPrograma.prg" con lo que, al abrirse el formulario, podremos introducir la direcci�n a buscar, o bien podremos ejecutarlo con do "MiPrograma.prg" with "direccion a buscar", con lo que, al abrirse el formulario, se realizar� la b�squeda de la direcci�n introducida directamente.
*!*	En segundo lugar, vereis que al ejecutar el c�digo, el formulario abierto no tiene barra de t�tulo, pero esto no significa que no pueda ser movido. S�lo teneis que pinchar sobre una zona libre del formulario y arrastrar con el rat�n. El truco reside en dos llamadas a la API en el Load del formulario y el evento MouseDown de este.
*!*	Tambien, al hacer las diferentes pruebas, me encontre con que las b�squedas de direcciones que conten�an "e�es" no se realizaban correctamente pero, si las sustitu�a por "enes", la b�squeda era correcta. Ese es el motivo de haber utilizado la funci�n strtran, s�lo a efectos de b�squeda.
*!*	Por �ltimo, mi agradecimiento a todas las personas que en el foro contestaron a mis dudas, y en especial a Luis Maria Guayan, sin cuya colaboraci�n y apoyo, este mi primer art�culo, no habr�a visto nunca la luz.
*!*	Y ahora, el c�digo completo de este ejemplo es el siguiente:

Do MiPrograma With "Puerta de Alcala, Madrid, Espa�a"

*
* MiPrograma.prg
*
Procedure MiPrograma
  Lparameters MiAddress
  Public oMiForm
  oMiForm = Createobject("MiForm", MiAddress)
  oMiForm.Show
  Return
Endproc

Define Class MiForm As Form
  Height = 560
  Width = 625
  AutoCenter = .T.
  Caption = "Ejemplo con Google Maps"
  Name = "MiForm"
  SetPoint = ""
  SetDecimals = 2
  ShowWindow = 0
  TitleBar = 0
  BorderStyle = 2
  Closable = .F.
  MaxButton = .F.
  MinButton = .F.

  Add Object Descrip As TextBox With ;
    HEIGHT = 24, Left = 12, Top = 12, Width = 330, ;
    STYLE = 0, Name = "Descrip", SelectOnEntry = .T., Enabled = .T.

  Add Object cmdMostrar As CommandButton With ;
    TOP = 10, Left = 350, Height = 27, Width = 100, ;
    CAPTION = "Mostrar mapa", Name = "cmdMostrar"

  Add Object cmdCerrar As CommandButton With ;
    TOP = 10, Left = 573, Height = 27, Width = 40, ;
    CAPTION = "Salir", Name = "cmdCerrar"

  Add Object oleIE As OleControl With ;
    TOP = 48, Left = 12, Height = 500, Width = 600, ;
    NAME = "oleIE", OleClass = "Shell.Explorer.2"

  Procedure Load
    Sys(2333,1)
    This.SetPoint = Set("Point")
    This.SetDecimals = Set("Decimals")
    Set Point To .
    Set Decimals To 8
    Set Safety Off
    Declare Integer ReleaseCapture In WIN32API
    Declare Integer SendMessage In WIN32API Integer, Integer, Integer, Integer
  Endproc

  Procedure Init(MiAddress)
    If Type('miaddress')<>'C'
      This.Descrip.Value=''
    Else
      This.Descrip.Value=miaddress
      Thisform.cmdMostrar.Click()
    Endif
  Endproc

  Procedure MouseDown
    Lparameters nButton, nShift, nXCoord, nYCoord
    Local lnHandle
    If nButton = 1
      ReleaseCapture()
      SendMessage(This.HWnd, 0x112, 0xF012,0)
    Endif
  Endproc

  Procedure cmdCerrar.Click
    Set Point To (Thisform.SetPoint)
    Set Decimals To (Thisform.SetDecimals)
    Thisform.Release
  Endproc

  Procedure cmdMostrar.Click
    If Empty(Alltrim(Thisform.Descrip.Value ))
      Thisform.Descrip.SetFocus()
      Return
    Else
      *
      lcClave = "http://maps.google.es/maps?file=api&v=2.x&" + ;
        "key=ABQIAAAAtOjLpIVcO8im8KJFR8pcMhQjskl1-YgiA" + ;
        "_BGX2yRrf7htVrbmBTWZt39_v1rJ4xxwZZCEomegYBo1w" 
TEXT TO lcHtml NOSHOW TEXTMERGE
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>Busqueda en Google Maps</title>
    <script src="<<lcClave>>"
    type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    var map = null
    var geocoder = null
    var address = "<<Strtran(ALLTRIM(ThisForm.Descrip.Value),'�','n',1,10,1)>>"

    function load()
	{ if (GBrowserIsCompatible())
	{ map = new GMap2(document.getElementById("map"),'G_SATELLITE_TYPE');
	map.addControl(new GLargeMapControl());
	map.addControl(new GMapTypeControl());
	map.addControl(new GOverviewMapControl());

	geocoder = new GClientGeocoder();
	geocoder.getLocations(address,addAddressToMap);
	}
	}
	// addAddressToMap() es llamada cuando 'geocoder' devuelve una respuesta.
	// Muestra el mapa y a�ade una marca con una ventana de informacion abierta.
	function addAddressToMap(response) {
	map.clearOverlays();
	if (!response || response.Status.code != 200) {
	alert("No encontrado");
	} else {
	place = response.Placemark[0];
	place1 = place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality
	placedir = place1.Thoroughfare.ThoroughfareName;
	placecpo = place1.PostalCode.PostalCodeNumber;
	placepob = place1.LocalityName;
	point = new GLatLng(place.Point.coordinates[1], place.Point.coordinates[0]);
	map.setCenter(point, 17);
	map.setMapType(G_MAP_TYPE);
	marker = new GMarker(point);
	map.addOverlay(marker);
	marker.openInfoWindowHtml(placedir+ '<br>' + placecpo + ' - '+ placepob);
	}
	}
    //]]>
    </script>
  </head>
  <body  scroll="no" bgcolor="#CCCCCC" topmargin="0" leftmargin="0" onload="load()" onunload="GUnload()">
  <div id="map" style="width: 600px; height: 500px"></div>
  </body>
</html>
ENDTEXT
      *
      Strtofile(lcHtml,"MiHtml.htm")
      Thisform.oleIE.Navigate2(Fullpath("MiHtml.htm"))
    Endif
  Endproc
Enddefine