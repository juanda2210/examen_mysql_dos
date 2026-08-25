-- =========================================================
-- FUNCIONES ADICIONALES DEL PROYECTO
-- EVENTOS PREMIER S.A.S.
-- =========================================================
--
-- Estas funciones agregan funcionalidades adicionales al
-- sistema de gestión de reservas.
--
-- Las funciones que crearemos son:
--
-- 1. calcular_descuento_cliente()
--    Calcula el porcentaje de descuento según el tipo
--    de cliente.
--
-- 2. obtener_horas_reserva()
--    Calcula la duración de una reserva en horas.
--
-- 3. contar_reservas_salon()
--    Indica cuántas reservas ha tenido un salón.
--
-- Cada función permite explorar diferentes características
-- de MySQL:
--
-- - Condicionales IF
-- - Consultas SELECT dentro de funciones
-- - Manejo de fechas y horas
-- - TIMESTAMPDIFF
-- - COUNT
-- - Variables locales
-- - Parámetros de entrada
-- =========================================================


-- =========================================================
-- SELECCIONAMOS LA BASE DE DATOS
-- =========================================================

USE eventos_premier;


-- =========================================================
-- FUNCIÓN 1:
-- calcular_descuento_cliente
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos determinar automáticamente qué porcentaje de
-- descuento puede recibir un cliente dependiendo de su
-- tipo.
--
-- En nuestro sistema existen diferentes tipos de clientes.
--
-- Para este ejemplo utilizaremos:
--
-- Cliente Individual  -> 0% de descuento
-- Cliente Corporativo -> 10% de descuento
--
-- La función recibe el ID del cliente y consulta su tipo
-- directamente en la tabla clientes.
--
-- Después utiliza una condición IF para determinar el
-- porcentaje correspondiente.
--
-- =========================================================
--
-- PARÁMETRO:
--
-- p_id_cliente
-- Es el ID del cliente que queremos consultar.
--
-- RETORNO:
--
-- DECIMAL(5,2)
-- Devuelve el porcentaje de descuento.
--
-- =========================================================


DELIMITER //

CREATE FUNCTION calcular_descuento_cliente(
    p_id_cliente INT
)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN

    -- Variable donde almacenaremos el tipo de cliente.
    DECLARE tipo_cliente VARCHAR(30);

    -- Variable donde almacenaremos el descuento.
    DECLARE descuento DECIMAL(5,2);


    -- Buscamos el tipo de cliente utilizando su ID.
    SELECT tipo_cliente
    INTO tipo_cliente
    FROM clientes
    WHERE id_cliente = p_id_cliente;


    -- Si el cliente es corporativo recibe un descuento
    -- del 10%.
    IF tipo_cliente = 'Corporativo' THEN

        SET descuento = 10.00;

    -- Si no es corporativo, asumimos que es un cliente
    -- individual y no recibe descuento.
    ELSE

        SET descuento = 0.00;

    END IF;


    -- Devolvemos el porcentaje de descuento calculado.
    RETURN descuento;

END //

DELIMITER ;


-- =========================================================
-- EJEMPLOS DE USO:
-- =========================================================
--
-- Consultar el descuento del cliente con ID 1:
--
-- SELECT calcular_descuento_cliente(1);
--
-- Ejemplo de resultado:
--
-- 10.00
--
-- Esto significa que el cliente tiene un descuento del 10%.
-- =========================================================



-- =========================================================
-- FUNCIÓN 2:
-- obtener_horas_reserva
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos saber cuántas horas dura una reserva.
--
-- La tabla reservas almacena la fecha y hora de inicio
-- y la fecha y hora de finalización.
--
-- Esta función recibe el ID de una reserva y calcula la
-- diferencia entre ambas fechas.
--
-- Para realizar el cálculo utilizamos TIMESTAMPDIFF().
--
-- Primero obtenemos la diferencia en minutos y después
-- dividimos entre 60 para convertirla a horas.
--
-- Por ejemplo:
--
-- Inicio:
-- 2026-08-25 08:00:00
--
-- Fin:
-- 2026-08-25 13:00:00
--
-- Resultado:
-- 5 horas
--
-- =========================================================
--
-- PARÁMETRO:
--
-- p_id_reserva
-- Es el ID de la reserva que queremos consultar.
--
-- RETORNO:
--
-- DECIMAL(10,2)
-- Devuelve la duración de la reserva expresada en horas.
--
-- =========================================================


DELIMITER //

CREATE FUNCTION obtener_horas_reserva(
    p_id_reserva INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN

    -- Variables donde almacenaremos las fechas
    -- de inicio y finalización.
    DECLARE fecha_inicio DATETIME;
    DECLARE fecha_fin DATETIME;

    -- Variable donde almacenaremos el resultado.
    DECLARE horas DECIMAL(10,2);


    -- Buscamos las fechas correspondientes a la reserva.
    SELECT
        fecha_inicio,
        fecha_fin
    INTO
        fecha_inicio,
        fecha_fin
    FROM reservas
    WHERE id_reserva = p_id_reserva;


    -- Calculamos la diferencia entre las dos fechas.
    --
    -- TIMESTAMPDIFF calcula la diferencia entre dos valores
    -- de fecha y hora.
    --
    -- Utilizamos MINUTE para obtener primero la diferencia
    -- en minutos.
    --
    -- Después dividimos entre 60 para obtener las horas.
    SET horas =
        TIMESTAMPDIFF(
            MINUTE,
            fecha_inicio,
            fecha_fin
        ) / 60;


    -- Devolvemos la cantidad de horas.
    RETURN horas;

END //

DELIMITER ;


-- =========================================================
-- EJEMPLOS DE USO:
-- =========================================================
--
-- Consultar la duración de la reserva con ID 1:
--
-- SELECT obtener_horas_reserva(1);
--
-- Ejemplo de resultado:
--
-- 5.00
--
-- Esto significa que la reserva tiene una duración
-- de 5 horas.
-- =========================================================



-- =========================================================
-- FUNCIÓN 3:
-- contar_reservas_salon
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos conocer cuántas reservas ha tenido determinado
-- salón.
--
-- Esta función recibe el ID de un salón y consulta la tabla
-- reservas para contar cuántos registros pertenecen a ese
-- salón.
--
-- Para realizar el conteo utilizamos COUNT().
--
-- Esta función puede ser útil para generar estadísticas
-- sobre el uso de los salones.
--
-- Por ejemplo:
--
-- Salón 1 -> 15 reservas
-- Salón 2 -> 8 reservas
-- Salón 3 -> 23 reservas
--
-- =========================================================
--
-- PARÁMETRO:
--
-- p_id_salon
-- Es el ID del salón que queremos consultar.
--
-- RETORNO:
--
-- INT
-- Devuelve el número total de reservas del salón.
--
-- =========================================================


DELIMITER //

CREATE FUNCTION contar_reservas_salon(
    p_id_salon INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN

    -- Variable donde almacenaremos la cantidad
    -- de reservas encontradas.
    DECLARE cantidad_reservas INT;


    -- Contamos todas las reservas asociadas al salón.
    --
    -- COUNT(*) cuenta la cantidad de registros que cumplen
    -- con la condición WHERE.
    SELECT COUNT(*)
    INTO cantidad_reservas
    FROM reservas
    WHERE id_salon = p_id_salon;


    -- Devolvemos la cantidad de reservas.
    RETURN cantidad_reservas;

END //

DELIMITER ;


-- =========================================================
-- EJEMPLOS DE USO:
-- =========================================================
--
-- Consultar cuántas reservas tiene el salón con ID 1:
--
-- SELECT contar_reservas_salon(1);
--
-- Ejemplo de resultado:
--
-- 15
--
-- Esto significa que el salón número 1 tiene 15 reservas
-- registradas en el sistema.
-- =========================================================



-- =========================================================
-- RESUMEN DE LAS FUNCIONES
-- =========================================================
--
-- FUNCIÓN 1:
-- calcular_descuento_cliente()
--
-- ¿Qué hace?
-- Determina el descuento de un cliente según su tipo.
--
-- Conceptos utilizados:
-- - Parámetro IN
-- - SELECT INTO
-- - Variables locales
-- - IF
-- - RETURN
--
--
-- FUNCIÓN 2:
-- obtener_horas_reserva()
--
-- ¿Qué hace?
-- Calcula la duración de una reserva.
--
-- Conceptos utilizados:
-- - Parámetro IN
-- - SELECT INTO
-- - DATETIME
-- - TIMESTAMPDIFF
-- - Operaciones matemáticas
-- - RETURN
--
--
-- FUNCIÓN 3:
-- contar_reservas_salon()
--
-- ¿Qué hace?
-- Cuenta cuántas reservas tiene un salón.
--
-- Conceptos utilizados:
-- - Parámetro IN
-- - SELECT INTO
-- - COUNT()
-- - WHERE
-- - Variables locales
-- - RETURN
--
-- =========================================================
-- CON ESTAS TRES FUNCIONES EXPLORAMOS:
--
-- 1. LÓGICA DE NEGOCIO
--    calcular_descuento_cliente()
--
-- 2. MANEJO DE FECHAS Y HORAS
--    obtener_horas_reserva()
--
-- 3. ESTADÍSTICAS Y AGREGACIÓN
--    contar_reservas_salon()
--
-- Esto permite demostrar que las funciones no solamente
-- sirven para realizar operaciones matemáticas, sino que
-- también pueden consultar información y aplicar lógica
-- sobre los datos almacenados en la base de datos.
-- =========================================================