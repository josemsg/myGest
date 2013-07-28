*__ KEY DE WWW.PISCINASPEPE.COM
*__ ABQIAAAAog2gRKWiTrTyhRy_LiOSMBQt3CArMHW29XRsjpvPnyXIXu-PrhQCVFYeyQHq75BfsolwMk5eGYeHdw

DO MainProcedure

PROCEDURE MainProcedure
PUBLIC oMiForm
oMiForm = CREATEOBJECT("MiForm")
oMiForm.SHOW
RETURN
ENDPROC

DEFINE CLASS MiForm AS FORM
  HEIGHT = 365
  WIDTH = 475
  AUTOCENTER = .T.
  CAPTION = "Ejemplo con Google Maps"
  NAME = "MiForm"
  SetPoint = ""
  SHOWWINDOW = 2

  ADD OBJECT cboDescrip AS COMBOBOX WITH ;
    ROWSOURCETYPE = 6, ROWSOURCE = "MisLugares.descri", ;
    HEIGHT = 24, LEFT = 12, TOP = 12, WIDTH = 330, ;
    STYLE = 2, NAME = "cboDescrip"

  ADD OBJECT cmdMostrar AS COMMANDBUTTON WITH ;
    TOP = 10, LEFT = 350, HEIGHT = 27, WIDTH = 112, ;
    CAPTION = "Mostrar mapa", NAME = "cmdMostrar"

  ADD OBJECT oleIE AS OLECONTROL WITH ;
    TOP = 48, LEFT = 12, HEIGHT = 300, WIDTH = 450, anchor = 240, ;
    NAME = "oleIE", OLECLASS = "Shell.Explorer.2"

  PROCEDURE LOAD
    SYS(2333,1)
    THIS.SetPoint = SET("Point")
    SET POINT TO .
    SET SAFETY OFF
    *-- Creo el cursor con los datos
    CREATE CURSOR MisLugares (Descri C(40), Lat N(12,6), Lon N(12,6), Zoom I(4))
    INSERT INTO MisLugares VALUES ("Dar Mazel", 38.900576233863830, 1.294841766357422, 20)
    INSERT INTO MisLugares VALUES ("Robert", 39.000933766365050, 1.310076713562012, 20)
    INSERT INTO MisLugares VALUES ("Casa David", 38.960646986961360, 1.281259059906006, 20)
    INSERT INTO MisLugares VALUES ("Torre Eiffel (Francia)", 48.858333, 2.295000, 17)
    INSERT INTO MisLugares VALUES ("Basílica de San Pedro (Vaticano)", 41.902102, 12.456400, 17)
    INSERT INTO MisLugares VALUES ("Estatua de la  Libertad (EEUU)", 40.689360, -74.044400, 17)
    INSERT INTO MisLugares VALUES ("Estadio Monumental (Argentina)", -34.545277, -58.449722, 17)
    INSERT INTO MisLugares VALUES ("Estadio Azteca (Mexico)", 19.302900, -99.150400, 17)
    INSERT INTO MisLugares VALUES ("Estadio Camp Nou (España)", 41.380906, 2.123330, 17)
    INSERT INTO MisLugares VALUES ("Cementerio de aviones (EEUU)", 32.174247, -110.855874, 14)
  ENDPROC

  PROCEDURE DESTROY
    SET POINT TO (THIS.SetPoint)
  ENDPROC

  PROCEDURE cboDescrip.INIT
    THIS.LISTINDEX = 1
  ENDPROC

  PROCEDURE cmdMostrar.CLICK
    TEXT TO lcHtml NOSHOW TEXTMERGE
    <html> <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps</title>
    <script src="http://maps.google.com/maps?file=api&v=2&key=123" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    function load()
    { if (GBrowserIsCompatible())
      { var map = new GMap2(document.getElementById("map"),G_SATELLITE_MAP);
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      map.addControl(new GOverviewMapControl());
      
      var point = new GLatLng(<<ALLTRIM(STR(MisLugares.Lat,12,6))>>, <<ALLTRIM(STR(MisLugares.Lon,12,6))>>);
		map.setCenter(point, <<TRANSFORM(MisLugares.Zoom)>>);
		map.setMapType(G_HYBRID_MAP);
		var marker = new GMarker(point);
		map.addOverlay(marker);
		marker.openInfoWindowHtml('<<MisLugares.Descri>>');
    } }
    //]]> </script> </head>
    <body scroll="no" bgcolor="#CCCCCC" topmargin="0" leftmargin="0"
    onload="load()" onunload="GUnload()">
    <div id="map" style="width:100%;height:100%"></div>
    </body> </html>
    ENDTEXT
    STRTOFILE(lcHtml,"MiHtml.htm")
    THISFORM.oleIE.Navigate2(FULLPATH("MiHtml.htm"))
  ENDPROC

ENDDEFINE