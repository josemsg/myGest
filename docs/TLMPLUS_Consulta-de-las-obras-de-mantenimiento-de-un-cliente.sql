select cod_obr,cod_cli,des_obr from PUB.obras where OBRAS.cod_cli=%lnCodigo% AND ( OBRAS.des_obr>='[MNT]' AND OBRAS.des_obr<='[MNT]zzzz')