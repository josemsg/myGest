*!*	TLMPLUS: gmempr, v_gttesoc, gmclidel, gmdirenv, goobrcer, goparlin
*!*	TLMPLUS1-2: gvfacab, gofacobr, gvallin, gofalind, gopaend

*!*	GVFACAB-GVALLIN: cod_ent, num_fac, cod_def
*!*	GVFACAB-GMDIRENV: cod_cen, cod_cli, cli_amb
*!*	GVFACAB-GOFACOBR: cod_ent, cod_def, num_fac
*!*	GVFACAB-GMEMPR: cod_ent, cod_del
*!*	GVFACAB-V_GTTESOC: cod_del, cod_ent, num_fac
*!*	GVFACAB-GMCLIDEL: cod_del, cod_ent, cod_cli, cli_amb

*!*	GVALLIN-GOFALIND: cod_ent, cod_del, id_gvallin
*!*	GVALLIN-GOOBRCER: cod_del, cod_ent, cod_ocer

*!*	GOFALIND-GOPARLIN: cod_oprl, aoo_oprt, cod_ab1, cod_ent,
*!*	                   cod_del, cod_oprt
*!*	GOFALIND-GOPAEND: cod_del, cod_ent, id_gopaend, cod_opec


*__ GVFACAB-GVALLIN: cod_ent, num_fac, cod_def
*__ GVFACAB-GOFACOBR: cod_ent, cod_def, num_fac
*__ GVALLIN-GOFALIND: cod_ent, cod_del, id_gvallin
*__ GOFALIND-GOPAEND: cod_del, cod_ent, id_gopaend, cod_opec
SET POINT TO ","
SET SEPARATOR TO "."
SET DATE TO DMY
SET CENTURY ON

LOCAL cmd AS String
LOCAL cWhere AS String

cWhere = [facab.fec_fac BETWEEN '2011-06-01' AND '2011-06-10']

TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
SELECT
		facab.num_fac, facab.fec_fac, facab.cod_cli, facab.raz_cli, facab.cod_via, facab.dir_cli, facab.num_cli, facab.ref_fac, facab.tip_fac, facab.dpo_cli, facab.pob_cli, facab.cif_cli,
		facab.tot_imp, facab.cod_sas, facab.bas_fac, facab.iva_fac, facab.iiv_fac,
		facab.cod_fpg,
		fobr.cod_obr,
		lin.id_gvallin, lin.lin_fac, lin.tip_lin, lin.det_art, lin.can_abl, lin.pvp_abl, lin.importe, lin.texto,
		fal.des_fde, fal.icer_fde, fal.ccer_fde, fal.cod_fde, fal.cod_oprl, fal.aoo_oprt, fal.cod_ab1, fal.cod_ent, fal.cod_del, fal.cod_oprt,
		pae.ord_oped, pae.des_oped, pae.can_oped, pae.pvp_oped, pae.dt1_oped, pae.dt2_oped, imp_oped
	FROM pub.gvfacab facab
		LEFT OUTER JOIN pub.gofacobr fobr
		ON fobr.cod_ent = facab.cod_ent
			AND fobr.num_fac = facab.num_fac
			AND fobr.cod_def = facab.cod_def
		LEFT OUTER JOIN pub.gvallin lin
		ON lin.cod_ent = facab.cod_ent
			AND lin.num_fac = facab.num_fac
			AND lin.cod_def = facab.cod_def
		LEFT OUTER JOIN pub.gofalind fal
		ON fal.cod_ent = lin.cod_ent
			AND fal.cod_del = lin.cod_del
			AND fal.id_gvallin = lin.id_gvallin
		LEFT OUTER JOIN pub.gopaend pae
		ON pae.cod_del = fal.cod_del
			AND pae.cod_ent = fal.cod_ent
			AND pae.id_gopaend = fal.id_gopaend
			AND pae.cod_opec = fal.cod_opec
	WHERE fobr.cod_obr <> 0 
		AND <<cWhere>>
	ORDER BY facab.num_fac, lin.lin_fac
ENDTEXT
*__ AND facab.cod_cli = 1843
*__ facab.fec_fac BETWEEN '2011-06-20' AND '2011-06-30'

_screen.oConTLMPLUS1.sqlexec(cmd, "miCRS")

*__ Cargar los efectos de las facturas
TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
SELECT
		facab.num_fac,
		tesoc.efc_ppg, tesoc.fvt_ppg, tesoc.ivt_ppg, tesoc.est_ppg
	FROM pub.gvfacab facab
		INNER JOIN pub.gmtesoc tesoc
		ON tesoc.cod_ent = facab.cod_ent
			AND tesoc.num_fac = facab.num_fac
			AND tesoc.cod_def = facab.cod_def
			AND tesoc.cod_cli = facab.cod_cli
			AND tesoc.cli_amb = facab.cli_amb
	WHERE <<cWhere>>
	ORDER BY facab.num_fac, tesoc.fvt_ppg
ENDTEXT
_screen.oConTLMPLUS1.sqlexec(cmd, "crsEfectos")

*__ Agrupar los vencimientos por factura
CREATE CURSOR miEfectos (num_fac I, vencimientos C(250))

SELECT distinc num_fac FROM crsEfectos ORDER BY num_fac INTO CURSOR crsNumFac
SCAN ALL
	SELECT crsEfectos
	lcFechas = ""
	SCAN ALL FOR crsEfectos.num_fac = crsNumFac.num_fac
		lcFechas = lcFechas + " " + DTOC(crsEfectos.fvt_ppg)
	ENDSCAN
	lcFechas = SUBSTR(lcFechas, 2)
	INSERT INTO miEfectos (num_fac, vencimientos) VALUES (crsNumFac.num_fac, lcFechas)
	SELECT crsNumFac
ENDSCAN

*!*	GOFALIND-GOPARLIN: cod_oprl, aoo_oprt, cod_ab1, cod_ent,
*!*	                   cod_del, cod_oprt
SELECT distinct id_gvallin, cod_oprl, aoo_oprt, cod_ab1, cod_ent, cod_del, cod_oprt, ;
		cod_fpg ;
	FROM miCRS ;
	WHERE cod_obr <> 0 ;
	ORDER BY miCrs.id_gvallin ;
	INTO CURSOR crsGvallin
	
SELECT distinct cod_oprt FROM crsGvallin ;
	WHERE cod_oprt>0 AND NOT ISNULL(cod_oprt) AND aoo_oprt = "A" ;  &&Solo P. administracion
	ORDER BY cod_oprt ;
	INTO CURSOR crsGoparlin

*__ Poner los nº de partes en una cadena separada por comas
LOCAL cad as String, cad1 as String
STORE "" TO cad, cad1

SELECT crsGoparlin
SCAN ALL
	cad = cad + "," + ALLTRIM(STR(crsGoparlin.cod_oprt))
ENDSCAN

IF NOT EMPTY(cad)
	cad1 = "ctr.cod_oprt in ("+SUBSTR(cad,2)+")"		&& Copia para los contratos
	*__ Quitar la primera coma
	cad = "AND plin.cod_oprt in ("+SUBSTR(cad,2)+")"
ENDIF

TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
	SELECT
		plin.cod_oprt, plin.ord_oprl, plin.cod_art, plin.des_oprl, plin.can_oprl, plin.cod_uea, plin.pvp_oprl, plin.dt1_oprl, plin.dt2_oprl, plin.imp_oprl
	FROM pub.goparlin plin
	WHERE plin.aoo_oprt = 'A' <<cad>>
	ORDER BY plin.cod_oprt, plin.ord_oprl
ENDTEXT
_screen.oConTLMPLUS.sqlexec(cmd, "crsGoparlin")

*__ Obtener las lineas de contratos
TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
	SELECT
		ctr.cod_oprt, ctr.cod_fea
	FROM pub.atalbctr ctr
	WHERE <<cad1>>
	ORDER BY ctr.cod_oprt, ctr.cod_fea
ENDTEXT
_screen.oConTLMPLUS1.sqlexec(cmd, "crsContratos")

*__ Obtener las FORMAS DE PAGO
TEXT TO cmd NOSHOW TEXTMERGE PRETEXT 1+2+4+8
	SELECT
		cod_fpg, nom_fpg
	FROM pub.gmfopag
	ORDER BY cod_fpg
ENDTEXT
_screen.oConTLMPLUS.sqlexec(cmd, "crsGmfopag")

*__ Unir los dos cursores
SET ENGINEBEHAVIOR 70
SELECT miCRS.*, ;
		plin.ord_oprl, plin.cod_art, plin.des_oprl, plin.can_oprl, plin.cod_uea, plin.pvp_oprl, plin.dt1_oprl, plin.dt2_oprl, plin.imp_oprl, ;
		pag.nom_fpg, efe.vencimientos, ctr.cod_fea ;
	 FROM miCRS ;
	 LEFT OUTER JOIN crsGoparlin plin ;
		ON plin.cod_oprt = miCRS.cod_oprt ;
	 LEFT OUTER JOIN crsGmfopag pag ;
	 	ON pag.cod_fpg = miCRS.cod_fpg ;
	 LEFT OUTER JOIN miEfectos efe ;
	 	ON efe.num_fac = miCRS.num_fac ;
	 LEFT OUTER JOIN crsContratos ctr ;
	 	ON ctr.cod_oprt = miCRS.cod_oprt ;
	ORDER BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt, plin.ord_oprl ;
	GROUP BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt, plin.ord_oprl ;
	INTO CURSOR miCRS
	
**ORDER BY miCRS.num_fac, miCRS.lin_fac, miCRS.cod_oprt ;

IF USED("miCRS")
	SELECT micrs
	brow last
ENDIF

