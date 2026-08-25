-- =========================================================
-- TRIGGERS ADICIONALES DEL PROYECTO
-- =========================================================
-- Estos triggers agregan funcionalidades adicionales al
-- sistema de gestión de reservas de Eventos Premier S.A.S.
--
-- TRIGGER 1:
-- Calcula automáticamente el total de una reserva.
--
-- TRIGGER 2:
-- Valida que las fechas de una reserva sean correctas.
--
-- TRIGGER 3:
-- Registra automáticamente la creación de nuevos clientes
-- en una tabla de historial.
-- =========================================================


-- =========================================================
-- TRIGGER 1:
-- calcular_total_automatico
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Cada vez que se registre una nueva reserva, queremos que
-- el sistema calcule automáticamente el valor total.
--
-- Para realizar el cálculo necesitamos:
--
-- 1. Obtener el precio por hora del salón.
-- 2. Calcular cuántas horas dura la reserva.
-- 3. Multiplicar el precio por las horas reservadas.
-- 4. Aplicar el IVA del 19%.
--
-- De esta manera, el usuario NO necesita introducir
-- manualmente el valor total de la reserva.
--
-- Utilizamos BEFORE INSERT porque queremos calcular el
-- valor ANTES de que el registro sea almacenado.
--
-- NEW representa los valores que se están intentando
-- insertar en la tabla reservas.
-- =========================================================

DELIMITER //

CREATE TRIGGER calcular_total_automatico
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN

    -- Variable donde almacenaremos el precio por hora
    -- correspondiente al salón seleccionado.
    DECLARE precio DECIMAL(10,2);

    -- Variable donde almacenaremos la duración de la reserva.
    DECLARE horas DECIMAL(10,2);


    -- Buscamos el precio por hora del salón que se está
    -- utilizando en la nueva reserva.
    --
    -- NEW.id_salon representa el salón de la nueva reserva.
    SELECT precio_hora
    INTO precio
    FROM salones
    WHERE id_salon = NEW.id_salon;


    -- Calculamos la duración de la reserva.
    --
    -- TIMESTAMPDIFF(MINUTE, ...) obtiene la diferencia
    -- entre las fechas en minutos.
    --
    -- Después dividimos entre 60 para convertir los
    -- minutos en horas.
    SET horas =
        TIMESTAMPDIFF(
            MINUTE,
            NEW.fecha_inicio,
            NEW.fecha_fin
        ) / 60;


    -- Calculamos el valor total.
    --
    -- precio × horas × 1.19
    --
    -- El 1.19 representa el precio original más el 19%
    -- correspondiente al IVA.
    SET NEW.total = precio * horas * 1.19;

END //

DELIMITER ;


-- =========================================================
-- TRIGGER 2:
-- validar_fechas_reserva
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Queremos evitar que se registren reservas con fechas
-- incorrectas.
--
-- Por ejemplo:
--
-- fecha_inicio = 25/08/2026 18:00
-- fecha_fin    = 25/08/2026 16:00
--
-- Esta reserva no tiene sentido porque termina antes
-- de comenzar.
--
-- También debemos impedir que la fecha de inicio y la
-- fecha de finalización sean exactamente iguales.
--
-- Utilizamos BEFORE INSERT porque queremos realizar la
-- validación ANTES de guardar la reserva.
--
-- Si la condición es incorrecta utilizamos SIGNAL para
-- detener la operación y mostrar un mensaje de error.
-- =========================================================

DELIMITER //

CREATE TRIGGER validar_fechas_reserva
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN

    -- Verificamos que la fecha de finalización sea
    -- posterior a la fecha de inicio.
    IF NEW.fecha_fin <= NEW.fecha_inicio THEN

        -- SIGNAL permite generar un error personalizado
        -- y cancelar la inserción de la reserva.
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'La fecha de finalización debe ser posterior a la fecha de inicio';

    END IF;

END //

DELIMITER ;


-- =========================================================
-- TRIGGER 3:
-- registrar_nuevo_cliente
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Queremos mantener un pequeño historial de los clientes
-- que son registrados en el sistema.
--
-- Para esto utilizaremos una tabla adicional llamada
-- historial_clientes.
--
-- Cada vez que se cree un nuevo cliente, el trigger
-- registrará automáticamente:
--
-- - El ID del cliente.
-- - La acción realizada.
-- - La fecha y hora del registro.
--
-- Utilizamos AFTER INSERT porque primero queremos que el
-- cliente sea creado correctamente y, después, registrar
-- la acción en el historial.
--
-- En este trigger también utilizamos NEW para obtener
-- información del nuevo cliente.
-- =========================================================


-- =========================================================
-- TABLA DE HISTORIAL
-- =========================================================
-- Esta tabla almacenará las acciones relacionadas con
-- el registro de nuevos clientes.
-- =========================================================

CREATE TABLE IF NOT EXISTS historial_clientes (
    id_historial INT AUTO_INCREMENT,
    id_cliente INT,
    accion VARCHAR(50),
    fecha DATETIME,

    PRIMARY KEY (id_historial)
);


-- =========================================================
-- CREACIÓN DEL TRIGGER
-- =========================================================

DELIMITER //

CREATE TRIGGER registrar_nuevo_cliente
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN

    -- Registramos automáticamente la creación del cliente
    -- en la tabla historial_clientes.
    INSERT INTO historial_clientes
    (
        id_cliente,
        accion,
        fecha
    )
    VALUES
    (
        NEW.id_cliente,
        'Cliente registrado',
        NOW()
    );

END //

DELIMITER ;


-- =========================================================
-- RESUMEN DE LOS TRIGGERS
-- =========================================================
--
-- 1. calcular_total_automatico
--
--    Evento: BEFORE INSERT
--    Tabla: reservas
--    Función:
--    Calcula automáticamente el total de la reserva.
--
--    Conceptos utilizados:
--    - BEFORE INSERT
--    - NEW
--    - DECLARE
--    - SELECT INTO
--    - TIMESTAMPDIFF
--
--
-- 2. validar_fechas_reserva
--
--    Evento: BEFORE INSERT
--    Tabla: reservas
--    Función:
--    Evita registrar reservas con fechas incorrectas.
--
--    Conceptos utilizados:
--    - BEFORE INSERT
--    - NEW
--    - IF
--    - SIGNAL
--    - SQLSTATE
--
--
-- 3. registrar_nuevo_cliente
--
--    Evento: AFTER INSERT
--    Tabla: clientes
--    Función:
--    Registra automáticamente la creación de un cliente
--    en una tabla de historial.
--
--    Conceptos utilizados:
--    - AFTER INSERT
--    - NEW
--    - INSERT automático
--    - NOW()
--    - Tabla de auditoría/historial
--
-- =========================================================
-- Con estos tres ejemplos tenemos diferentes usos de los
-- triggers:
--
-- AUTOMATIZACIÓN:
-- El sistema calcula información automáticamente.
--
-- VALIDACIÓN:
-- El sistema impide operaciones incorrectas.
--
-- AUDITORÍA:
-- El sistema conserva un historial de determinadas acciones.
-- =========================================================