-- =========================================================
-- CONSULTA:
-- CREAR TABLA DE CLIENTES FRECUENTES
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos crear una nueva tabla llamada
-- clientes_frecuentes.
--
-- Esta tabla almacenará información resumida de los
-- clientes que han realizado 3 o más reservas.
--
-- De esta manera podemos identificar fácilmente a los
-- clientes que utilizan frecuentemente el servicio.
--
-- La información se obtiene directamente de las tablas
-- clientes y reservas.
-- =========================================================


-- =========================================================
-- 1. CREACIÓN DE LA NUEVA TABLA
-- =========================================================

CREATE TABLE clientes_frecuentes AS

SELECT
    c.id_cliente,
    c.nombre_completo,
    c.tipo_cliente,
    COUNT(r.id_reserva) AS cantidad_reservas,
    SUM(r.total) AS total_gastado

FROM clientes c

INNER JOIN reservas r
    ON c.id_cliente = r.id_cliente

-- Agrupamos la información por cada cliente.
GROUP BY
    c.id_cliente,
    c.nombre_completo,
    c.tipo_cliente

-- Solo incluimos clientes que tengan 3 o más reservas.
HAVING COUNT(r.id_reserva) >= 3;


-- =========================================================
-- 2. CONSULTAR LA NUEVA TABLA
-- =========================================================
--
-- Una vez creada la tabla podemos consultar la información
-- almacenada en ella como cualquier otra tabla.
-- =========================================================

SELECT *
FROM clientes_frecuentes;