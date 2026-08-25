USE eventos_premier;

-- Eliminamos las funciones si ya existen
DROP FUNCTION IF EXISTS calcular_total_reserva;
DROP FUNCTION IF EXISTS verificar_disponibilidad;


-- Cambiamos temporalmente el delimitador
DELIMITER //


-- =========================================================
-- FUNCIÓN 1: calcular_total_reserva
-- =========================================================

CREATE FUNCTION calcular_total_reserva(
    precio_hora DECIMAL(10,2),
    horas DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)

-- Para los mismos valores de entrada,
-- siempre devuelve el mismo resultado.
DETERMINISTIC

BEGIN

    -- Variable para guardar el subtotal.
    DECLARE subtotal DECIMAL(12,2);

    -- Variable para guardar el total con IVA.
    DECLARE total DECIMAL(12,2);


    -- Precio por hora × cantidad de horas.
    SET subtotal = precio_hora * horas;


    -- Agregamos el 19% de IVA.
    SET total = subtotal * 1.19;


    -- Devolvemos el total.
    RETURN total;

END //

-- DOMINIO PROYECTO: 

DELIMITER //

CREATE FUNCTION calcular_total_reserva_dos (
	precio_hora DECIMAL (10,2),
    horas DECIMAL (10,2)
)

RETURNS DECIMAL (12,2)
DETERMINISTIC

BEGIN
	DECLARE total_sin_iva DECIMAL (12,2);
    DECLARE total_a_pagar DECIMAL (12,2);
    
    SET total_sin_iva = precio_hora * horas;
    SET total_a_pagar = total_sin_iva * 1.19;
    
    RETURN total_a_pagar;
END //

DELIMITER ;


-- =========================================================
-- FUNCIÓN 2: verificar_disponibilidad
-- =========================================================

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