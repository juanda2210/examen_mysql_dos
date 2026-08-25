-- =========================================================
-- TRIGGERS DEL PROYECTO
-- =========================================================

-- Seleccionamos la base de datos
USE eventos_premier;

-- Cambiamos temporalmente el delimitador.
-- Esto permite utilizar varios ; dentro de cada trigger.
DELIMITER //


-- =========================================================
-- TRIGGER 1:
-- actualizar_estado_salon_trigger
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Cada vez que se registre una NUEVA RESERVA,
-- el salón reservado debe pasar automáticamente
-- a estado "Ocupado".
--
-- Se ejecuta:
-- AFTER INSERT → después de insertar la reserva.
CREATE TRIGGER actualizar_estado_salon_trigger
AFTER INSERT ON reservas
FOR EACH ROW
BEGIN

    -- Actualizamos el estado del salón que acaba
    -- de ser reservado.
    --
    -- NEW.id_salon representa el salón de la
    -- nueva reserva que acabamos de insertar.
    UPDATE salones

    -- Cambiamos el estado del salón a "Ocupado".
    SET estado = 'Ocupado'

    -- Solo modificamos el salón correspondiente
    -- a la nueva reserva.
    WHERE id_salon = NEW.id_salon;

END //


-- =========================================================
-- TRIGGER 2:
-- liberar_salon_trigger
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Cuando se elimine una reserva,
-- el salón debe volver automáticamente
-- a estado "Disponible".
--
-- Se ejecuta:
-- AFTER DELETE → después de eliminar la reserva.
CREATE TRIGGER liberar_salon_trigger
AFTER DELETE ON reservas
FOR EACH ROW
BEGIN

    -- Actualizamos el estado del salón relacionado
    -- con la reserva que acabamos de eliminar.
    UPDATE salones

    -- El salón vuelve a estar disponible.
    SET estado = 'Disponible'

    -- OLD.id_salon representa el salón que pertenecía
    -- a la reserva antes de ser eliminada.
    WHERE id_salon = OLD.id_salon;

END //


-- =========================================================
-- TRIGGER 3:
-- auditoria_precios_trigger
-- =========================================================
-- ¿Qué queremos conseguir?
--
-- Cuando se modifique el precio por hora de un salón,
-- queremos guardar automáticamente un registro
-- en la tabla auditoria_precios.
--
-- Vamos a guardar:
--   - ID del salón
--   - Usuario que hizo el cambio
--   - Fecha y hora
--   - Precio anterior
--   - Precio nuevo
--
-- Se ejecuta:
-- AFTER UPDATE → después de actualizar el salón.
CREATE TRIGGER auditoria_precios_trigger
AFTER UPDATE ON salones
FOR EACH ROW
BEGIN

    -- Solo queremos registrar cambios cuando
    -- realmente haya cambiado el precio.
    IF OLD.precio_hora <> NEW.precio_hora THEN

        -- Insertamos un nuevo registro en la tabla
        -- de auditoría.
        INSERT INTO auditoria_precios (
            id_salon,
            usuario,
            fecha,
            valor_anterior,
            valor_nuevo
        )

        VALUES (
            -- NEW.id_salon = salón que fue modificado
            NEW.id_salon,

            -- CURRENT_USER() devuelve el usuario de MySQL
            -- que realizó la operación.
            CURRENT_USER(),

            -- Guardamos la fecha y hora actual.
            NOW(),

            -- OLD.precio_hora = precio que tenía antes.
            OLD.precio_hora,

            -- NEW.precio_hora = precio después del cambio.
            NEW.precio_hora
        );

    END IF;

END //


-- Restauramos el delimitador normal de MySQL.
DELIMITER ;