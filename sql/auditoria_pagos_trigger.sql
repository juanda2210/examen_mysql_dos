CREATE TABLE IF NOT EXISTS auditoria_pagos (
    id_auditoria INT AUTO_INCREMENT,
    id_pago INT NOT NULL,
    fecha DATETIME NOT NULL,
    usuario_responsable VARCHAR(50) NOT NULL,
    valor_pagado DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_auditoria)
);



DELIMITER //

CREATE TRIGGER auditoria_pagos_trigger
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN


    INSERT INTO auditoria_pagos (
        id_pago,
        fecha,
        usuario_responsable,
        valor_pagado
    )
    VALUES (
        NEW.id_pago,
        NOW(),
        'admin',
        NEW.valor_pagado
    );

END //

DELIMITER ;


-- =========================================================
-- 3. PRUEBA DEL TRIGGER
-- =========================================================
--
-- Primero registramos un nuevo pago.
--
-- IMPORTANTE:
-- Ajusta los valores de acuerdo con las columnas reales
-- de tu tabla pagos.
-- =========================================================

INSERT INTO pagos (
    id_reserva,
    valor_pagado,
    metodo_pago
)
VALUES (
    1,
    500000,
    'Transferencia'
);


-- =========================================================
-- 4. VERIFICAMOS LA AUDITORÍA
-- =========================================================
--
-- Si el trigger funcionó correctamente, después del INSERT
-- anterior aparecerá automáticamente un nuevo registro
-- en auditoria_pagos.
-- =========================================================

SELECT *
FROM auditoria_pagos;