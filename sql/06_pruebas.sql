-- =========================================================
-- PRUEBAS DEL PROYECTO
-- =========================================================

-- Seleccionamos la base de datos
USE eventos_premier;


-- =========================================================
-- 1. PRUEBAS DE LAS FUNCIONES
-- =========================================================

-- ---------------------------------------------------------
-- PRUEBA 1.1: calcular_total_reserva
-- ---------------------------------------------------------
-- Vamos a probar la función con:
-- Precio por hora = 150000
-- Horas = 4
--
-- Subtotal:
-- 150000 × 4 = 600000
--
-- IVA:
-- 600000 × 19% = 114000
--
-- Total esperado:
-- 714000

SELECT calcular_total_reserva(150000, 4) AS total_calculado;

SELECT caluclar_total_reserva_dos(150000, 4) AS total_calculado_dos;


-- ---------------------------------------------------------
-- PRUEBA 1.2: verificar_disponibilidad
-- ---------------------------------------------------------

-- Primero probamos un horario que SABEMOS que está ocupado.
--
-- La reserva número 5 corresponde al salón 2 y está activa:
-- 2026-08-28 09:00 → 2026-08-28 15:00
--
-- Vamos a consultar un horario que se cruza con ella:
-- 2026-08-28 10:00 → 2026-08-28 12:00
--
-- Resultado esperado:
-- 0 = ocupado

SELECT verificar_disponibilidad(
    2,
    '2026-08-28 10:00:00',
    '2026-08-28 12:00:00'
) AS disponibilidad;


-- Ahora probamos un horario que NO se cruza con
-- ninguna reserva activa del salón 2.
--
-- Resultado esperado:
-- 1 = disponible

SELECT verificar_disponibilidad(
    2,
    '2026-10-01 10:00:00',
    '2026-10-01 14:00:00'
) AS disponibilidad;


-- =========================================================
-- 2. PRUEBAS DE LOS TRIGGERS
-- =========================================================


-- ---------------------------------------------------------
-- PRUEBA 2.1: actualizar_estado_salon_trigger
-- ---------------------------------------------------------

-- Primero comprobamos el estado actual del salón 1.
-- Debe estar "Disponible" según nuestros datos iniciales.

SELECT
    id_salon,
    nombre,
    estado
FROM salones
WHERE id_salon = 1;


-- Creamos una reserva de prueba para el salón 1.
--
-- Al hacer este INSERT, el trigger
-- actualizar_estado_salon_trigger debería ejecutarse
-- automáticamente y cambiar el salón a "Ocupado".

INSERT INTO reservas (
    fecha_inicio,
    fecha_fin,
    horas,
    total,
    estado,
    id_cliente,
    id_salon
)
VALUES (
    '2026-10-10 10:00:00',
    '2026-10-10 14:00:00',
    4,
    calcular_total_reserva(150000, 4),
    'Activa',
    1,
    1
);


-- Comprobamos nuevamente el estado del salón 1.
--
-- Resultado esperado:
-- Ocupado

SELECT
    id_salon,
    nombre,
    estado
FROM salones
WHERE id_salon = 1;


-- ---------------------------------------------------------
-- PRUEBA 2.2: liberar_salon_trigger
-- ---------------------------------------------------------

-- Eliminamos la reserva de prueba que acabamos
-- de crear.
--
-- El trigger liberar_salon_trigger debería ejecutarse
-- automáticamente y cambiar el salón nuevamente
-- a "Disponible".

DELETE FROM reservas
WHERE fecha_inicio = '2026-10-10 10:00:00'
  AND id_salon = 1;


-- Comprobamos nuevamente el estado.
--
-- Resultado esperado:
-- Disponible

SELECT
    id_salon,
    nombre,
    estado
FROM salones
WHERE id_salon = 1;


-- ---------------------------------------------------------
-- PRUEBA 2.3: auditoria_precios_trigger
-- ---------------------------------------------------------

-- Primero consultamos el precio actual del salón 1.

SELECT
    id_salon,
    nombre,
    precio_hora
FROM salones
WHERE id_salon = 1;


-- Cambiamos el precio del salón 1.
--
-- El trigger auditoria_precios_trigger debería detectar
-- el cambio y guardar automáticamente:
--   - salón
--   - usuario
--   - fecha
--   - precio anterior
--   - precio nuevo

UPDATE salones
SET precio_hora = 180000
WHERE id_salon = 1;


-- Comprobamos el precio nuevo.

SELECT
    id_salon,
    nombre,
    precio_hora
FROM salones
WHERE id_salon = 1;


-- Ahora consultamos la tabla de auditoría.
--
-- Debemos encontrar un registro con:
-- valor_anterior = 150000
-- valor_nuevo = 180000

SELECT
    id_auditoria,
    id_salon,
    usuario,
    fecha,
    valor_anterior,
    valor_nuevo
FROM auditoria_precios
WHERE id_salon = 1
ORDER BY id_auditoria DESC
LIMIT 1;


-- =========================================================
-- 3. PRUEBA DE LA VISTA
-- =========================================================

-- La vista ya contiene un JOIN entre:
--   reservas
--   clientes
--   salones
--
-- Por lo tanto, podemos consultar toda esa información
-- simplemente utilizando el nombre de la vista.

SELECT *
FROM vista_resumen_reservas;


-- También podemos utilizar condiciones sobre la vista.
-- Por ejemplo, mostrar únicamente las reservas activas.

SELECT *
FROM vista_resumen_reservas
WHERE estado = 'Activa';


-- =========================================================
-- 4. PRUEBAS DE LAS CONSULTAS
-- =========================================================


-- ---------------------------------------------------------
-- PRUEBA 4.1: reservas en un rango de fechas
-- ---------------------------------------------------------
-- Buscamos reservas que comiencen entre:
-- 20 de agosto de 2026
-- y 31 de agosto de 2026

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
WHERE fecha_inicio BETWEEN '2026-08-20 00:00:00'
                       AND '2026-08-31 23:59:59';


-- ---------------------------------------------------------
-- PRUEBA 4.2: salones con capacidad mayor a 100
-- y estado Disponible
-- ---------------------------------------------------------

SELECT
    id_salon,
    nombre,
    capacidad,
    precio_hora,
    estado
FROM salones
WHERE capacidad > 100
AND estado = 'Disponible';


-- ---------------------------------------------------------
-- PRUEBA 4.3: clientes corporativos con más de 3 reservas
-- ---------------------------------------------------------

SELECT
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.tipo_cliente,
    COUNT(r.id_reserva) AS cantidad_reservas
FROM clientes AS c
LEFT JOIN reservas AS r
    ON c.id_cliente = r.id_cliente
WHERE c.tipo_cliente = 'Corporativo'
GROUP BY
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.tipo_cliente
HAVING COUNT(r.id_reserva) > 3;