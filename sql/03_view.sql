-- =========================================================
-- VISTA: vista_resumen_reservas
-- =========================================================

-- Seleccionamos la base de datos
USE eventos_premier;


-- Creamos una vista y le damos el nombre
-- "vista_resumen_reservas".
--
-- La consulta que escribamos después de AS será
-- la consulta que quedará guardada dentro de la vista.
CREATE VIEW vista_resumen_reservas AS

SELECT

    -- Nombre del cliente que realizó la reserva
    c.nombre_completo AS cliente,

    -- Nombre del salón reservado
    s.nombre AS salon,

    -- Fecha y hora en que comienza la reserva
    r.fecha_inicio,

    -- Fecha y hora en que termina la reserva
    r.fecha_fin,

    -- Valor total de la reserva
    r.total,

    -- Estado actual de la reserva
    r.estado

-- Comenzamos desde la tabla reservas porque
-- esta es la información principal que queremos resumir.
FROM reservas AS r


-- Relacionamos cada reserva con su cliente.
-- r.id_cliente corresponde a c.id_cliente.
INNER JOIN clientes AS c
    ON r.id_cliente = c.id_cliente


-- Relacionamos cada reserva con el salón reservado.
-- r.id_salon corresponde a s.id_salon.
INNER JOIN salones AS s
    ON r.id_salon = s.id_salon;