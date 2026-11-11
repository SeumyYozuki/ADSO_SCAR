-- ============================================================
-- PROYECTO SCAR (DULCE DIP) - SCRIPT DE DISPARADORES (TRIGGERS)
-- Archivo: 11_triggers.sql
-- ============================================================

USE bd_scar;

DROP TRIGGER IF EXISTS tg_descontar_stock_tras_venta;
DROP TRIGGER IF EXISTS tg_restaurar_stock_cancelacion;

DELIMITER //

-- 1. Trigger para descontar inventario automáticamente tras agregar detalle de venta
CREATE TRIGGER tg_descontar_stock_tras_venta
AFTER INSERT ON DETALLE_DE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS 
    SET producto_stock = producto_stock - NEW.detalle_cantidad,
        producto_estado = IF(producto_stock - NEW.detalle_cantidad <= 0, 'Agotado', 'Disponible')
    WHERE producto_id = NEW.PRODUCTOS_producto_id;
END //

-- 2. Trigger para devolver stock si la venta es cancelada
CREATE TRIGGER tg_restaurar_stock_cancelacion
AFTER UPDATE ON VENTAS
FOR EACH ROW
BEGIN
    IF NEW.venta_estado = 'CANCELADO' AND OLD.venta_estado != 'CANCELADO' THEN
        UPDATE PRODUCTOS p
        INNER JOIN DETALLE_DE_VENTAS dv ON p.producto_id = dv.PRODUCTOS_producto_id
        SET p.producto_stock = p.producto_stock + dv.detalle_cantidad,
            p.producto_estado = 'Disponible'
        WHERE dv.VENTAS_venta_id = NEW.venta_id;
    END IF;
END //

DELIMITER ;
