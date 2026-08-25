DELIMITER //

CREATE FUNCTION verificar_disponibilidad(
    salon_id INT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME
)
RETURNS INT

-- El resultado puede cambiar dependiendo
-- de las reservas existentes.
NOT DETERMINISTIC

-- La función lee información de la base de datos,
-- específicamente de la tabla reservas.
READS SQL DATA

BEGIN

    -- Guardará la cantidad de reservas que
    -- se cruzan con el horario consultado.
    DECLARE cantidad_reservas INT;


    -- Contamos las reservas que cumplen las condiciones.
    SELECT COUNT(*)
    INTO cantidad_reservas
    FROM reservas

    -- Debe ser el salón que estamos consultando.
    WHERE id_salon = salon_id

      -- Solo consideramos reservas activas.
      AND estado = 'Activa'

      -- El inicio de una reserva existente debe ser
      -- anterior al final del nuevo horario.
      AND fecha_inicio < fecha_fin

      -- El final de una reserva existente debe ser
      -- posterior al inicio del nuevo horario.
      AND fecha_fin > fecha_inicio;


    -- Si existe al menos una reserva que se cruza,
    -- el salón está ocupado.
    IF cantidad_reservas > 0 THEN

        RETURN 0;

    ELSE

        -- Si no existe ninguna reserva que se cruce,
        -- el salón está disponible.
        RETURN 1;

    END IF;

END //


-- Restauramos el delimitador normal
DELIMITER ;