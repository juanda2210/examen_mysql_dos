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
        NEW.monto
    );

END //

DELIMITER ;




INSERT INTO pagos (
    fecha_pago,
    monto,
    metodo_pago,
    id_reserva
)
VALUES (
    NOW(),
    500000,
    'Transferencia',
    1
);



SELECT *
FROM auditoria_pagos;