-- ============================================================
-- PROYECTO SCAR (DULCE DIP) - SCRIPT DE PROCEDIMIENTOS (PROCEDURES)
-- Archivo: 10_procedures.sql
-- ============================================================

USE bd_scar;

DROP PROCEDURE IF EXISTS sp_registrar_venta_con_domicilio;
DROP PROCEDURE IF EXISTS sp_asignar_repartidor;

DELIMITER //

-- 1. Procedimiento almacenado para registrar venta y su domicilio
CREATE PROCEDURE sp_registrar_venta_con_domicilio(
    IN p_usuario_id INT,
    IN p_metodo_pago VARCHAR(50),
    IN p_total DECIMAL(10,2),
    IN p_direccion_entrega VARCHAR(200),
    IN p_costo_envio DECIMAL(10,2)
)
BEGIN
    DECLARE v_venta_id INT;
    
    START TRANSACTION;
    
    INSERT INTO VENTAS (venta_fecha, venta_metodo_pago, venta_total, venta_estado, USUARIOS_usuario_id)
    VALUES (NOW(), p_metodo_pago, p_total, 'CONFIRMADO', p_usuario_id);
    
    SET v_venta_id = LAST_INSERT_ID();
    
    INSERT INTO DOMICILIOS (domicilio_direccion, domicilio_costo_envio, domicilio_estado, REPARTIDORES_repartidor_id, VENTAS_venta_id)
    VALUES (p_direccion_entrega, p_costo_envio, 'PENDIENTE', NULL, v_venta_id);
    
    COMMIT;
END //

-- 2. Procedimiento para asignar repartidor a un domicilio
CREATE PROCEDURE sp_asignar_repartidor(
    IN p_domicilio_id INT,
    IN p_repartidor_id INT
)
BEGIN
    UPDATE DOMICILIOS 
    SET REPARTIDORES_repartidor_id = p_repartidor_id,
        domicilio_estado = 'EN_RUTA'
    WHERE domicilio_id = p_domicilio_id;
    
    UPDATE REPARTIDORES 
    SET repartidor_estado = 'EN_RUTA'
    WHERE repartidor_id = p_repartidor_id;
END //

DELIMITER ;
