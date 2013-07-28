lnClcode = 388
lcWhere = "facab.cod_cli = "+ALLTRIM(STR(lnClcode))

TEXT TO cmd TEXTMERGE PRETEXT 1+2+4+8 NOSHOW
	SELECT
		'A' as AoB, 
		RPAD(t.est_ppg,10,' ') as estado,
		facab.num_fac, facab.fec_fac, facab.ref_fac, facab.tip_fac,
		facab.tot_imp, facab.cod_fpg,
		facab.bru_fac as bas_fac,
		facab.iiv_fac1+facab.iiv_fac2+facab.iiv_fac3 as iva_fac, t.est_ppg,
		t.ivt_ppg
		FROM PUB.gvFacab facab
			LEFT OUTER JOIN PUB.gmtesoc t ON t.num_fac = facab.num_fac AND
				t.cli_amb = facab.cli_amb AND
				t.cod_ent = facab.cod_ent AND
				t.cod_def = facab.cod_def
		WHERE <<lcWhere>>
		ORDER BY facab.fec_fac, facab.num_fac
ENDTEXT
_screen.oConTlmplus1.sqlExec(cmd, "crsFacsA")
*!*	SELECT * FROM crsFacsA ;
*!*		group by fec_fac, num_fac ;
*!*		ORDER BY fec_fac, num_fac ;
*!*		INTO CURSOR crsFacsA