select gmclien.cod_cli, gmensad.cod_msg, gmensa.nom_msg from pub.gmclien, pub.gmensad, pub.gmensa where (gmensad.cua_msg=gmclien.cod_cli and gmensa.cod_msg=gmensad.cod_msg) and gmclien.cod_cli = 624
