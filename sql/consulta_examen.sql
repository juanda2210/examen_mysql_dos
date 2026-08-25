SELECT
    c.nombre_completo AS nombre_cliente,
    s.nombre AS nombre_salon,
    p.monto AS total_pagado

FROM pagos p


INNER JOIN reservas r
    ON p.id_reserva = r.id_reserva


INNER JOIN clientes c
    ON r.id_cliente = c.id_cliente


INNER JOIN salones s
    ON r.id_salon = s.id_salon


WHERE p.metodo_pago = 'Transferencia'


ORDER BY
    p.monto DESC;