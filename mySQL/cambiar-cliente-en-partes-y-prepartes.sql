SET @v_clcode_desde = 282, 
    @v_clcode_hasta = 1873, 
    @v_obra_desde = 41, 
    @v_obra_hasta = 1000020,
    @v_fecha_desde = 2011-04-01,
    @v_fecha_hasta = 2011-12-31;

UPDATE `mypartes`.`pre_partes` SET
    clcode = @v_clcode_hasta,
    obra_id = @v_obra_hasta
    where clcode = @v_clcode_desde and obra_id = @v_obra_desde and
        (fecha >= @v_fecha_desde and fecha <= @v_fecha_hasta);

UPDATE `mypartes`.`partes` SET
    clcode = @v_clcode_hasta,
    obra_id = @v_obra_hasta
    where clcode = @v_clcode_desde and obra_id = @v_obra_desde and
        (fecha >= @v_fecha_desde and fecha <= @v_fecha_hasta);