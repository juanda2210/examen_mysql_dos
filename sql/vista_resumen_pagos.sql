USE eventos_premier;

SELECT * FROM pagos;

CREATE VIEW vista_resumen_pagos AS

SELECT
	c.nombre_completo AS cliente,
    s.nombre AS salon,
    p.metodo_pago,
    p.fecha_pago,
    p.monto

FROM reservas AS r

INNER JOIN clientes AS c
	ON r.id_cliente = c.id_cliente

INNER JOIN salones AS s
	ON r.id_salon = s.id_salon

INNER JOIN pagos AS p;
    ON r.id_reserva = p.id_reserva

SELECT * FROM vista_resumen_pagos;