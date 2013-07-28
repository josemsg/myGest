# Actualizar el codigo y los nombres de clientes en partes desde clientes
UPDATE partes, clientes
	SET partes.clcode = clientes.codigo,
    	partes.nombre_comercial = clientes.nombre_comercial,
        partes.nombre_fiscal = clientes.nombre_fiscal
    WHERE clientes.id = partes.id_cliente

commit;