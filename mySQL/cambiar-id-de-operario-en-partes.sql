# Cambiar el id de operario en el fichero de partes
SET @id_nuevo = 1033;
SET @id_viejo = 30;

UPDATE `partes`
	SET `partes`.`id_operario1`= @id_nuevo
    WHERE `partes`.`id_operario1`= @id_viejo;

UPDATE `partes`
	SET `partes`.`id_operario2`= @id_nuevo
    WHERE `partes`.`id_operario2`= @id_viejo;

UPDATE `partes`
	SET `partes`.`id_operario3`= @id_nuevo
    WHERE `partes`.`id_operario3`= @id_viejo;

commit;