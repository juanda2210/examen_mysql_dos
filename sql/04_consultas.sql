-- =========================================================
-- CONSULTAS DEL PROYECTO
-- =========================================================

-- Seleccionamos la base de datos con la que vamos a trabajar
USE eventos_premier;


-- =========================================================
-- CONSULTA 1: RESERVAS EN UN RANGO DE FECHAS
-- =========================================================
-- El proyecto pide utilizar BETWEEN.
--
-- En este ejemplo vamos a buscar las reservas cuya
-- fecha de inicio esté entre el 20 y el 31 de agosto
-- de 2026.
--
-- BETWEEN significa:
-- "mayor o igual que el primer valor y menor o igual
-- que el segundo valor".
SELECT
    id_reserva,
    fecha_inicio,
    fecha_fin,
    horas,
    total,
    estado,
    id_cliente,
    id_salon
FROM reservas

-- Filtramos las reservas que comienzan dentro del rango
-- indicado.
WHERE fecha_inicio BETWEEN '2026-08-20 00:00:00'
                       AND '2026-08-31 23:59:59';


-- =========================================================
-- CONSULTA 2: SALONES CON CAPACIDAD MAYOR A X
-- Y QUE ESTÉN DISPONIBLES
-- =========================================================
-- Aquí queremos encontrar salones que cumplan
-- DOS condiciones al mismo tiempo:
--
-- 1. Que tengan capacidad mayor a 100 personas.
-- 2. Que su estado sea "Disponible".
--
-- Para combinar ambas condiciones utilizamos AND.

SELECT
    id_salon,
    nombre,
    capacidad,
    precio_hora,
    estado,
    id_encargado
FROM salones

-- Primera condición:
-- capacidad mayor a 100 personas.
WHERE capacidad > 100

-- Segunda condición:
-- el salón debe estar disponible.
AND estado = 'Disponible';


-- =========================================================
-- CONSULTA 3: CLIENTES CORPORATIVOS CON MÁS DE 3 RESERVAS
-- =========================================================
-- Queremos encontrar clientes que:
--
-- 1. Sean de tipo "Corporativo".
-- 2. Tengan más de 3 reservas.
--
-- Para contar las reservas utilizamos COUNT().
-- Como queremos agrupar las reservas por cliente,
-- utilizamos GROUP BY.
-- Y como queremos quedarnos únicamente con los clientes
-- que tengan más de 3 reservas, utilizamos HAVING.

SELECT
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.tipo_cliente,

    -- COUNT(*) cuenta cuántas reservas tiene cada cliente.
    COUNT(r.id_reserva) AS cantidad_reservas

FROM clientes AS c

-- Relacionamos cada cliente con sus reservas.
-- LEFT JOIN permite conservar al cliente aunque no tenga
-- reservas. Después, HAVING se encargará del filtro.
LEFT JOIN reservas AS r
    ON c.id_cliente = r.id_cliente

-- Primero filtramos solamente los clientes corporativos.
WHERE c.tipo_cliente = 'Corporativo'

-- Agrupamos todas las reservas pertenecientes al mismo cliente.
GROUP BY
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.tipo_cliente

-- Finalmente nos quedamos únicamente con los clientes
-- que tengan más de 3 reservas.
HAVING COUNT(r.id_reserva) > 3;