-- =========================================================
-- CONSULTAS ADICIONALES DEL PROYECTO
-- EVENTOS PREMIER S.A.S.
-- =========================================================
--
-- Estas consultas permiten obtener información útil para
-- analizar el funcionamiento del sistema de reservas.
--
-- CONSULTA 1:
-- Identificar los salones con mayor cantidad de reservas.
--
-- CONSULTA 2:
-- Identificar los clientes con mayor cantidad de reservas.
--
-- CONSULTA 3:
-- Calcular los ingresos generados por cada salón.
--
-- Con estas consultas podemos obtener información
-- estadística y administrativa a partir de los datos
-- almacenados en la base de datos.
-- =========================================================


-- =========================================================
-- CONSULTA 1:
-- SALONES CON MAYOR CANTIDAD DE RESERVAS
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos saber cuáles son los salones que han sido
-- reservados con mayor frecuencia.
--
-- Para conseguirlo:
--
-- 1. Unimos la tabla salones con reservas.
-- 2. Agrupamos los resultados por salón.
-- 3. Contamos la cantidad de reservas.
-- 4. Ordenamos de mayor a menor.
--
-- Esto permite identificar cuáles son los salones con
-- mayor demanda.
-- =========================================================

SELECT
    s.id_salon,
    s.nombre,
    COUNT(r.id_reserva) AS cantidad_reservas
FROM salones s
LEFT JOIN reservas r
    ON s.id_salon = r.id_salon
GROUP BY
    s.id_salon,
    s.nombre
ORDER BY
    cantidad_reservas DESC;


-- =========================================================
-- CONSULTA 2:
-- CLIENTES CON MAYOR CANTIDAD DE RESERVAS
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos identificar cuáles son los clientes que han
-- realizado más reservas en Eventos Premier.
--
-- Para conseguirlo:
--
-- 1. Unimos clientes con reservas.
-- 2. Agrupamos las reservas por cliente.
-- 3. Contamos cuántas reservas tiene cada cliente.
-- 4. Ordenamos de mayor a menor.
--
-- Esta consulta puede ser útil para identificar clientes
-- frecuentes y posteriormente crear estrategias comerciales
-- o beneficios para ellos.
-- =========================================================

SELECT
    c.id_cliente,
    c.nombre_completo,
    c.tipo_cliente,
    COUNT(r.id_reserva) AS cantidad_reservas
FROM clientes c
INNER JOIN reservas r
    ON c.id_cliente = r.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre_completo,
    c.tipo_cliente
ORDER BY
    cantidad_reservas DESC;


-- =========================================================
-- CONSULTA 3:
-- INGRESOS GENERADOS POR CADA SALÓN
-- =========================================================
--
-- ¿Qué queremos conseguir?
--
-- Queremos conocer cuánto dinero ha generado cada salón
-- a través de las reservas registradas.
--
-- Para conseguirlo:
--
-- 1. Unimos salones con reservas.
-- 2. Agrupamos las reservas según el salón.
-- 3. Utilizamos SUM() para sumar el total de las reservas.
-- 4. Ordenamos los salones desde el que más ingresos
--    genera hasta el que menos.
--
-- Esta información puede utilizarse para analizar el
-- rendimiento económico de cada salón.
-- =========================================================

SELECT
    s.id_salon,
    s.nombre,
    COUNT(r.id_reserva) AS cantidad_reservas,
    SUM(r.total) AS ingresos_totales
FROM salones s
INNER JOIN reservas r
    ON s.id_salon = r.id_salon
GROUP BY
    s.id_salon,
    s.nombre
ORDER BY
    ingresos_totales DESC;


-- =========================================================
-- RESUMEN DE LAS CONSULTAS
-- =========================================================
--
-- CONSULTA 1:
-- Salones con mayor cantidad de reservas.
--
-- Conceptos:
-- - LEFT JOIN
-- - COUNT()
-- - GROUP BY
-- - ORDER BY
--
--
-- CONSULTA 2:
-- Clientes con mayor cantidad de reservas.
--
-- Conceptos:
-- - INNER JOIN
-- - COUNT()
-- - GROUP BY
-- - ORDER BY
--
--
-- CONSULTA 3:
-- Ingresos generados por cada salón.
--
-- Conceptos:
-- - INNER JOIN
-- - COUNT()
-- - SUM()
-- - GROUP BY
-- - ORDER BY
--
-- =========================================================
-- Con estas consultas podemos explorar tres aspectos
-- diferentes del sistema:
--
-- 1. DEMANDA:
--    ¿Qué salones se reservan más?
--
-- 2. CLIENTES:
--    ¿Qué clientes realizan más reservas?
--
-- 3. INGRESOS:
--    ¿Qué salones generan más dinero?
--
-- De esta manera, las consultas no solamente recuperan
-- información, sino que también permiten realizar un
-- pequeño análisis administrativo del negocio.
-- =========================================================