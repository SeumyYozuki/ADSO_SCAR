-- =============================================================================
-- PROYECTO SCAR - SISTEMA DE CONTROL Y ADMINISTRACIÓN DE REPOSITORIO (DULCE DIP)
-- ARCHIVO: 06_dml.sql
-- DESCRIPCIÓN: Sentencias DML para la inserción de datos de prueba en 'bd_scar'.
-- MOTOR: MySQL 8.0 / MariaDB (InnoDB)
-- =============================================================================

USE bd_scar;

-- Desactivar temporalmente la verificación de llaves foráneas para inserción masiva limpia
SET FOREIGN_KEY_CHECKS = 0;

-- 1. INSERCIÓN DE ROLES
INSERT INTO roles (rol_id, rol_nombre) VALUES
(1, 'Administrador'),
(2, 'Vendedor'),
(3, 'Repartidor'),
(4, 'Cliente');

-- 2. INSERCIÓN DE PERFILES (DATOS PERSONALES)
INSERT INTO perfil (perfil_id, nombre, apellido, cedula, correo, telefono, direccion, foto) VALUES
(1, 'Albeiro', 'Ramos', '1010123456', 'admin@dulcedip.com', '3001112233', 'Calle 45 # 12-34, Bogotá', 'perfil_admin.png'),
(2, 'Neila', 'Bello', '1020987654', 'neila.bello@dulcedip.com', '3102223344', 'Carrera 15 # 80-20, Bogotá', 'perfil_vendedor.png'),
(3, 'Carlos', 'Pérez', '1030555444', 'carlos.reparto@dulcedip.com', '3203334455', 'Transversal 3 # 45-12, Bogotá', 'perfil_repartidor.png'),
(4, 'Diana', 'Gómez', '1040777888', 'diana.gomez@gmail.com', '3154445566', 'Calle 100 # 19-50 Apt 502, Bogotá', 'perfil_cliente1.png'),
(5, 'Jorge', 'Martínez', '1050333222', 'jorge.martinez@hotmail.com', '3185556677', 'Carrera 7 # 120-15, Bogotá', 'perfil_cliente2.png');

-- 3. INSERCIÓN DE USUARIOS (CREDENCIALES Y SEGURIDAD)
-- Contraseñas encriptadas con algoritmo Bcrypt (equivalente a hash de seguridad)
INSERT INTO usuarios (usuario_id, correo_recuperacion, password, estado, ROLES_rol_id, PERFIL_perfil_id) VALUES
(1, 'recupera.admin@dulcedip.com', '$2y$10$e8T8f4Kx.Z3uK0/vUj9n2.YQZ9fJv.8uFvG5Q.N2k0r.w3mK2x2aG', 'Activo', 1, 1),
(2, 'recupera.neila@dulcedip.com', '$2y$10$e8T8f4Kx.Z3uK0/vUj9n2.YQZ9fJv.8uFvG5Q.N2k0r.w3mK2x2aG', 'Activo', 2, 2),
(3, 'recupera.carlos@dulcedip.com', '$2y$10$e8T8f4Kx.Z3uK0/vUj9n2.YQZ9fJv.8uFvG5Q.N2k0r.w3mK2x2aG', 'Activo', 3, 3),
(4, 'recupera.diana@gmail.com', '$2y$10$e8T8f4Kx.Z3uK0/vUj9n2.YQZ9fJv.8uFvG5Q.N2k0r.w3mK2x2aG', 'Activo', 4, 4),
(5, 'recupera.jorge@hotmail.com', '$2y$10$e8T8f4Kx.Z3uK0/vUj9n2.YQZ9fJv.8uFvG5Q.N2k0r.w3mK2x2aG', 'Activo', 4, 5);

-- 4. INSERCIÓN DE CATEGORÍAS
INSERT INTO categorias (categoria_id, categoria_nombre) VALUES
(1, 'Queso Crema 130g'),
(2, 'Queso Crema 230g');

-- 5. INSERCIÓN DE PRODUCTOS
INSERT INTO productos (producto_id, producto_codigo, producto_nombre, producto_precio, producto_stock, producto_peso, CATEGORIAS_categoria_id) VALUES
(1, 'QC-FEI-130', 'Queso Crema Feijoa 130g', 10000.00, 50, '130g', 1),
(2, 'QC-CAF-130', 'Queso Crema Café 130g', 10000.00, 40, '130g', 1),
(3, 'QC-MAR-130', 'Queso Crema Maracuyá 130g', 10000.00, 35, '130g', 1),
(4, 'QC-FEI-230', 'Queso Crema Feijoa 230g', 20000.00, 30, '230g', 2),
(5, 'QC-CAF-230', 'Queso Crema Café 230g', 20000.00, 25, '230g', 2),
(6, 'QC-MAR-230', 'Queso Crema Maracuyá 230g', 20000.00, 20, '230g', 2);

-- 6. INSERCIÓN DE REPARTIDORES
INSERT INTO repartidores (repartidor_id, vehiculo, placa, repartidor_estado, USUARIOS_usuario_id) VALUES
(1, 'Motocicleta Honda CB125', 'XYZ-123', 'Disponible', 3);

-- 7. INSERCIÓN DE VENTAS (PEDIDOS HISTÓRICOS Y ACTUALES)
INSERT INTO ventas (venta_id, venta_fecha, venta_metodo_pago, venta_total, venta_estado, USUARIOS_usuario_id) VALUES
(101, '2026-10-25 10:30:00', 'Nequi', 40000.00, 'Completado', 4),
(102, '2026-10-26 14:15:00', 'Daviplata', 30000.00, 'Completado', 5),
(103, '2026-11-10 09:00:00', 'Efectivo', 20000.00, 'Pendiente', 4);

-- 8. INSERCIÓN DE DETALLE DE VENTAS
INSERT INTO detalle_de_ventas (VENTAS_venta_id, PRODUCTOS_producto_id, detalle_cantidad, detalle_precio_historico, detalle_subtotal) VALUES
(101, 1, 2, 10000.00, 20000.00), -- 2 u. Feijoa 130g
(101, 5, 1, 20000.00, 20000.00), -- 1 u. Café 230g
(102, 2, 1, 10000.00, 10000.00), -- 1 u. Café 130g
(102, 4, 1, 20000.00, 20000.00), -- 1 u. Feijoa 230g
(103, 6, 1, 20000.00, 20000.00); -- 1 u. Maracuyá 230g

-- 9. INSERCIÓN DE DOMICILIOS
INSERT INTO domicilios (domicilio_id, domicilio_direccion, domicilio_costo_envio, domicilio_estado, VENTAS_venta_id, REPARTIDORES_repartidor_id) VALUES
(1, 'Calle 100 # 19-50 Apt 502, Bogotá', 5000.00, 'Entregado', 101, 1),
(2, 'Carrera 7 # 120-15, Bogotá', 6000.00, 'Entregado', 102, 1),
(3, 'Calle 100 # 19-50 Apt 502, Bogotá', 5000.00, 'Pendiente', 103, NULL);

-- Reactivar la verificación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- Fin del archivo 06_dml.sql
