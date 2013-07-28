
TEXT TO cmd TEXTMERGE PRETEXT 1+2+4+8 NOSHOW
	SELECT
		l.ord_oprl, l.tli_oprl, l.cod_art, 
		LEFT(l.des_oprl,150) AS des_oprl, l.tipo_op, l.can_oprl,
		l.pvp_oprl, l.cod_uea, l.imp_oprl, dt1_oprl,
		c.cod_oprt, c.cod_ab1, c.aoo_oprt, c.coa_oprt, c.fec_oprt, 
    	c.cod_obr, c.ref_oprt, c.tot_oprt, c.cos_oprt, c.fae_oprt, 
    	c.fac_oprt, c.cod_cli, cl.nom_cli, cl.raz_cli, c.cod_ab2,
    	c.imp_oprt, c.usum_oprt, c.fum_oprt
	FROM PUB.goparlin l
	  INNER JOIN PUB.gopartes c ON
		    c.cod_oprt = l.cod_oprt AND
		    c.cod_ent = l.cod_ent AND
		    c.cod_del = l.cod_del AND
		    c.aoo_oprt = l.aoo_oprt AND
		    c.cod_ab1 = l.cod_ab1
	  INNER JOIN PUB.gmclien cl ON
       		 cl.cod_cli = c.cod_cli
	WHERE c.cod_cli IN (1886,1887,1888) AND
		    l.aoo_oprt = 'A' AND
        		(c.fae_oprt = 1 AND c.fac_oprt = 0)
	ORDER BY c.cod_cli, c.fec_oprt, c.cod_oprt, l.ord_oprl
ENDTEXT

_screen.oConTlmPLUS.sqlExec(cmd, "micrs")
BROWSE last
