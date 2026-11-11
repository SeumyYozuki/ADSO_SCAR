-- ============================================================
-- PROYECTO SCAR (DULCE DIP) - SCRIPT DE VISTAS (VIEWS)
-- Archivo: 09_views.sql
-- ============================================================

USE bd_scar;

DROP VIEW IF EXISTS v_catalogo_productos_activos;
DROP VIEW IF EXISTS v_resumen_ventas_clientes;
DROP VIEW IF EXISTS v_domicilios_pendientes_despacho;

-- 1. Vista de catálogo activo
CREATE VIEW v_catalogo_productos_activos AS
SELECT 
    p.producto_id,
    p.producto_codigo,
    p.producto_nombre,
    c.categoria_nombre,
    p.producto_precio,
    p.producto_stock,
    p.producto_peso,
    p.producto_estado
FROM PRODUCTOS p
INNER JOIN CATEGORIAS c ON p.CATEGORIAS_categoria_id = c.categoria_id
WHERE p.producto_estado = 'Disponible' AND p.producto_stock > 0;

-- 2. Vista de resumen de ventas por cliente
CREATE VIEW v_resumen_ventas_clientes AS
SELECT 
    u.usuario_id,
    p.perfil_nombre,
    p.perfil_apellido,
    p.perfil_correo,
    COUNT(v.venta_id) AS total_compras_realizadas,
    IFNULL(SUM(v.venta_total), 0.00) AS monto_total_invertido
FROM USUARIOS u
INNER JOIN PERFIL p ON u.PERFIL_perfil_id = p.perfil_id
LEFT JOIN VENTAS v ON u.usuario_id = v.USUARIOS_usuario_id
GROUP BY u.usuario_id, p.perfil_nombre, p.perfil_apellido, p.perfil_correo;

-- 3. Vista de domicilios pendientes por despachar
CREATE VIEW v_domicilios_pendientes_despacho AS
SELECT 
    d.domicilio_id,
    v.venta_id,
    v.venta_fecha,
    p.perfil_nombre AS cliente_nombre,
    p.perfil_apellido AS cliente_apellido,
    p.perfil_telefono AS cliente_telefono,
    d.domicilio_direccion,
    d.domicilio_costo_envio,
    d.domicilio_estado,
    r.repartidor_nombre AS repartidor_asignado
FROM DOMICILIOS d
INNER JOIN VENTAS v ON d.VENTAS_venta_id = v.venta_id
INNER JOIN USUARIOS u ON v.USUARIOS_usuario_id = u.usuario_id
INNER JOIN PERFIL p ON u.PERFIL_perfil_id = p.perfil_id
LEFT JOIN REPARTIDORES r ON d.REPARTIDORES_repartidor_id = r.repartidor_id
WHERE d.domicilio_estado IN ('PENDIENTE', 'EN_RUTA');
