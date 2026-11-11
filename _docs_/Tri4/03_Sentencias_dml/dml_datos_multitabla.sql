-- =============================================================================
-- PROYECTO SCAR - SISTEMA DE CONTROL Y ADMINISTRACIÓN DE REPOSITORIO (DULCE DIP)
-- ARCHIVO: 08_consultas_especificas.sql
-- DESCRIPCIÓN: Consultas específicas traducidas desde preguntas de negocio de Dulce Dip.
-- =============================================================================

USE bd_scar;

-- -----------------------------------------------------------------------------
-- PREGUNTA 1 (MARKETING): 
-- "¿Cuáles son los nombres, teléfonos y correos de los clientes registrados para una campaña de WhatsApp/Email?"
-- -----------------------------------------------------------------------------
SELECT p.nombre, p.apellido, p.telefono, p.correo
FROM perfil p
JOIN usuarios u ON p.perfil_id = u.PERFIL_perfil_id
WHERE u.ROLES_rol_id = 4; -- Rol 4 = Cliente

-- -----------------------------------------------------------------------------
-- PREGUNTA 2 (INVENTARIO): 
-- "¿Qué productos tienen un stock menor o igual a 30 unidades y requieren reabastecimiento?"
-- -----------------------------------------------------------------------------
SELECT producto_codigo, producto_nombre, producto_stock, producto_precio
FROM productos
WHERE producto_stock <= 30
ORDER BY producto_stock ASC;

-- -----------------------------------------------------------------------------
-- PREGUNTA 3 (LOGÍSTICA Y DESPACHOS): 
-- "¿Cuáles son los pedidos pendientes de entrega junto con su dirección y cliente de destino?"
-- -----------------------------------------------------------------------------
SELECT v.venta_id, v.venta_fecha, d.domicilio_direccion, d.domicilio_estado, p.nombre, p.apellido, p.telefono
FROM ventas v
JOIN domicilios d ON v.venta_id = d.VENTAS_venta_id
JOIN usuarios u ON v.USUARIOS_usuario_id = u.usuario_id
JOIN perfil p ON u.PERFIL_perfil_id = p.perfil_id
WHERE d.domicilio_estado = 'Pendiente';

-- -----------------------------------------------------------------------------
-- PREGUNTA 4 (REPORTES DE VENTAS / DETALLE MULTITABLA): 
-- "¿Qué productos y en qué cantidad se vendieron en el pedido N° 101, indicando el precio histórico y subtotal?"
-- -----------------------------------------------------------------------------
SELECT v.venta_id, pr.producto_nombre, dv.detalle_cantidad, dv.detalle_precio_historico, dv.detalle_subtotal
FROM ventas v
JOIN detalle_de_ventas dv ON v.venta_id = dv.VENTAS_venta_id
JOIN productos pr ON dv.PRODUCTOS_producto_id = pr.producto_id
WHERE v.venta_id = 101;

-- -----------------------------------------------------------------------------
-- PREGUNTA 5 (ACTUALIZACIÓN SEGURA - UPDATE CON WHERE): 
-- "Actualizar la dirección del perfil del cliente Diana Gómez tras su solicitud de cambio"
-- -----------------------------------------------------------------------------
UPDATE perfil 
SET direccion = 'Calle 100 # 19-50 Apt 601, Bogotá'
WHERE cedula = '1040777888';

-- -----------------------------------------------------------------------------
-- PREGUNTA 6 (ELIMINACIÓN SEGURA CON RESTRICCIÓN - DELETE CON WHERE): 
-- "Intento de cancelación/eliminación de un borrador de venta sin detalles asociados"
-- -----------------------------------------------------------------------------
DELETE FROM ventas 
WHERE venta_id = 103 AND venta_estado = 'Pendiente';
