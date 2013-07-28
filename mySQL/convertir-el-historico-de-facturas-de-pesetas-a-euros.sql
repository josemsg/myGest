/* Convertir de pesetas a euros en el historico de facturas */

UPDATE hist_facs SET
	base0 = round(base0 / 166.386,2),
    base1 = round(base1 / 166.386,2),
    base2 = round(base2 / 166.386,2),
    base3 = round(base3 / 166.386,2),
    base4 = round(base4 / 166.386,2),
    iva1 = round(iva1 / 166.386,2),
    iva2 = round(iva2 / 166.386,2),
    iva3 = round(iva3 / 166.386,2),
    iva4 = round(iva4 / 166.386,2),
	rec1 = round(rec1 / 166.386,2),
    rec2 = round(rec2 / 166.386,2),
    rec3 = round(rec3 / 166.386,2),
    rec4 = round(rec4 / 166.386,2),
    total = round(total / 166.386,2),
    cobrado = round(cobrado / 166.386,2)
    WHERE year <= 2001 ;

UPDATE hist_facline SET
	precio = round(precio / 166.386,2),
    importe = round(importe / 166.386,2),
    imp_pv = round(imp_pv / 166.386,2)
    WHERE year <= 2001 ;

commit;