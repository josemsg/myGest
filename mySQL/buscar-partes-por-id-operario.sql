set @myoper = 29;

select id, id_parte, id_operario1, id_operario2, id_operario3, fecha
 from partes
 where id_operario1 = @myoper or id_operario2 = @myoper or id_operario3 = @myoper;