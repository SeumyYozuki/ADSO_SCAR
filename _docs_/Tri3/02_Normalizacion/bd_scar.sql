-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-09-2026 a las 01:21:12
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_scar`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `categoria_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental de la categoría',
  `categoria_nombre` varchar(100) NOT NULL COMMENT 'Nombre de la clasificación (sabores, peso, etc)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`categoria_id`, `categoria_nombre`) VALUES
(3, 'Cítricos'),
(4, 'Edición Especial'),
(1, 'Frutos Rojos'),
(2, 'Frutos Tropicales'),
(5, 'Línea Light');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle de ventas`
--

CREATE TABLE `detalle de ventas` (
  `detalle_cantidad` int(11) NOT NULL COMMENT 'Cantidad de unidades vendidas del producto',
  `detalle_precio_historico` decimal(10,2) NOT NULL COMMENT 'Precio unitario congelado al momento exacto de la compra',
  `detalle_subtotal` decimal(10,2) NOT NULL COMMENT 'Valor total del reglón (cantidad x precio histórico)',
  `VENTAS_venta_id` int(11) NOT NULL COMMENT 'Llave foránea e identificadora de la venta asociada',
  `PRODUCTOS_producto_id` int(11) NOT NULL COMMENT 'Lave foránea identificadora del producto comprado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `detalle de ventas`
--

INSERT INTO `detalle de ventas` (`detalle_cantidad`, `detalle_precio_historico`, `detalle_subtotal`, `VENTAS_venta_id`, `PRODUCTOS_producto_id`) VALUES
(2, 12500.00, 25000.00, 1, 1),
(1, 16000.00, 16000.00, 2, 7),
(2, 13000.00, 26000.00, 3, 3),
(1, 14000.00, 14000.00, 3, 9),
(2, 13500.00, 27000.00, 4, 4),
(1, 12500.00, 12500.00, 5, 1),
(1, 13000.00, 13000.00, 5, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `domicilios`
--

CREATE TABLE `domicilios` (
  `domicilio_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental del servicio de entrega',
  `domicilio_direccion` varchar(200) NOT NULL COMMENT 'Dirección de destino del pedido especificada por el cliente',
  `domicilio_costo_envio` decimal(10,2) NOT NULL COMMENT 'Valor o tarifa calculada por el servicio de flete',
  `domicilio_estado` varchar(20) NOT NULL COMMENT 'Valor o tarifa calculada por el servicio de flete',
  `VENTAS_venta_id` int(11) NOT NULL COMMENT 'Llave foránea vinculada a la venta correspondiente en VENTAS',
  `REPARTIDORES_repartidor_id` int(11) DEFAULT NULL COMMENT 'Llave foránea opcional que asigna al repartidor en REPARTIDORES'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `domicilios`
--

INSERT INTO `domicilios` (`domicilio_id`, `domicilio_direccion`, `domicilio_costo_envio`, `domicilio_estado`, `VENTAS_venta_id`, `REPARTIDORES_repartidor_id`) VALUES
(1, 'Carrera 4 # 5-6, Apto 101', 5000.00, 'Entregado', 1, 1),
(2, 'Avenida 7 # 8-9, Casa 4', 4500.00, 'Entregado', 2, 2),
(3, 'Transversal 10 # 11-12', 6000.00, 'En Ruta', 3, 2),
(4, 'Carrera 4 # 5-6, Apto 101', 5000.00, 'Cancelado', 4, 1),
(5, 'Avenida 7 # 8-9, Casa 4', 4500.00, 'Asignado', 5, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `producto_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental del producto',
  `producto_codigo` varchar(50) NOT NULL COMMENT 'Código alfanumérico único (SKU) de inventario (ej. DUL-QC-001)',
  `producto_nombre` varchar(100) NOT NULL COMMENT 'Nombre comercial del dulce o producto',
  `producto_descripción` varchar(225) DEFAULT NULL COMMENT 'Detalles de ingredientes, presentación y características del producto',
  `producto_precio` decimal(10,2) NOT NULL COMMENT 'Precio de venta unitario en pesos colombianos ($ COP)',
  `producto_stock` int(11) NOT NULL COMMENT 'Cantidad de unidades físicas disponibles en inventario',
  `producto_peso` decimal(8,2) DEFAULT NULL COMMENT 'Peso neto del producto expresado en gramos',
  `producto_imagen` varchar(225) DEFAULT NULL COMMENT 'Ruta de archivo o URL de la imagen del producto',
  `producto_estado` varchar(20) NOT NULL COMMENT 'Disponibilidad comercial del ítem (Disponible/agotado)',
  `CATEGORIAS_categoria_id` int(11) NOT NULL COMMENT 'Llave foránea que referencia la categoría asociada en CATEGORIAS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`producto_id`, `producto_codigo`, `producto_nombre`, `producto_descripción`, `producto_precio`, `producto_stock`, `producto_peso`, `producto_imagen`, `producto_estado`, `CATEGORIAS_categoria_id`) VALUES
(1, 'QC-FR-001', 'Queso Crema de Fresa', 'Queso crema untable con trozos naturales de fresa.', 12500.00, 50, 250.00, '/img/fresa.jpg', 'Disponible', 1),
(2, 'QC-FR-002', 'Queso Crema de Mora', 'Queso crema suave con deliciosa jalea de mora.', 12500.00, 40, 250.00, '/img/mora.jpg', 'Disponible', 1),
(3, 'QC-FT-001', 'Queso Crema de Mango', 'Exquisito queso crema con pulpa de mango dulce.', 13000.00, 30, 250.00, '/img/mango.jpg', 'Disponible', 2),
(4, 'QC-FT-002', 'Queso Crema de Maracuyá', 'Equilibrio perfecto entre dulce y el ácido del maracuyá.', 13500.00, 20, 250.00, '/img/maracuya.jpg', 'Disponible', 2),
(5, 'QC-CI-001', 'Queso Crema de Limón', 'Queso crema con ralladura y zumo de limón fresco.', 11500.00, 35, 250.00, '/img/limon.jpg', 'Disponible', 3),
(6, 'QC-CI-002', 'Queso Crema de Naranja', 'Queso crema con toques cítricos de naranja.', 11500.00, 0, 250.00, '/img/naranja.jpg', 'Agotado', 3),
(7, 'QC-EE-001', 'Queso Crema Frutos del Bosque', 'Mezcla premium de arándanos, frambuesas y moras.', 16000.00, 25, 300.00, '/img/bosque.jpg', 'Disponible', 4),
(8, 'QC-EE-002', 'Queso Crema Piña Colada', 'Edición especial con piña y toques de coco rallado.', 15500.00, 10, 300.00, '/img/pinacolada.jpg', 'Disponible', 4),
(9, 'QC-LL-001', 'Queso Crema Fresa Light', 'Bajo en grasa, endulzado con stevia y fresas.', 14000.00, 45, 250.00, '/img/fresalight.jpg', 'Disponible', 5),
(10, 'QC-FT-003', 'Queso Crema de Durazno', 'Queso crema con trocitos de durazno en almíbar.', 13000.00, 60, 250.00, '/img/durazno.jpg', 'Disponible', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `repartidores`
--

CREATE TABLE `repartidores` (
  `repartidor_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental del repartidor',
  `repartidor_nombre` varchar(100) NOT NULL COMMENT 'Nombre completo del repartidor o domiciliario',
  `repartidor_telefono` varchar(20) NOT NULL COMMENT 'Número de teléfono celular para contacto y coordinación',
  `repartidor_estado` varchar(20) NOT NULL COMMENT 'Disponibilidad laboral del domiciliario (DISPONIBLE, EN\\_RUTA, INACTIVO)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `repartidores`
--

INSERT INTO `repartidores` (`repartidor_id`, `repartidor_nombre`, `repartidor_telefono`, `repartidor_estado`) VALUES
(1, 'Carlos Gómez', '3001234567', 'DISPONIBLE'),
(2, 'Luis Martínez', '3109876543', 'EN_RUTA'),
(3, 'Andrés Felipe Ruiz', '3204567890', 'INACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `rol_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental del rol',
  `rol_nombre` varchar(50) NOT NULL COMMENT 'Nombre del perfil de acceso'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`rol_id`, `rol_nombre`) VALUES
(1, 'Administrador'),
(2, 'Cliente'),
(3, 'Empleado_Ventas'),
(4, 'Repartidor_App');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `usuario_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental del usuario',
  `usuario_nombre` varchar(100) NOT NULL COMMENT 'Nombres completos del usuario',
  `usuario_apellido` varchar(100) NOT NULL COMMENT 'Apellidos completos del usuario',
  `usuario_cedula` varchar(20) NOT NULL COMMENT 'Número de documento de identidad del usuario',
  `usuario_correo` varchar(100) NOT NULL COMMENT 'Correo electrónico para autenticación e inicio de sesión',
  `usuario_telefono` varchar(20) NOT NULL COMMENT 'Número telefónico de contacto principal',
  `usuario_direccion` varchar(150) NOT NULL COMMENT 'Dirección de residencia o entrega del usuario',
  `usuario_contraseña` varchar(225) NOT NULL COMMENT 'Clave de acceso encriptada para seguridad',
  `usuario_estado` varchar(20) NOT NULL COMMENT 'Estado de la cuenta en la plataforma (activo/inactivo)',
  `ROLES_rol_id` int(11) NOT NULL COMMENT 'Llave foránea que referencia al rol asignado en la tabla ROLES'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`usuario_id`, `usuario_nombre`, `usuario_apellido`, `usuario_cedula`, `usuario_correo`, `usuario_telefono`, `usuario_direccion`, `usuario_contraseña`, `usuario_estado`, `ROLES_rol_id`) VALUES
(1, 'María', 'Pérez', '1010101010', 'admin@scar.com', '3111111111', 'Calle 1 # 2-3, Local 1', 'hash12345', 'activo', 1),
(2, 'Juan', 'Díaz', '2020202020', 'juan.cliente@mail.com', '3122222222', 'Carrera 4 # 5-6, Apto 101', 'hash67890', 'activo', 2),
(3, 'Ana', 'López', '3030303030', 'ana.lopez@mail.com', '3133333333', 'Avenida 7 # 8-9, Casa 4', 'hashabcde', 'activo', 2),
(4, 'Pedro', 'García', '4040404040', 'pedro.g@mail.com', '3144444444', 'Transversal 10 # 11-12', 'hashfghij', 'activo', 2),
(5, 'Laura', 'Torres', '5050505050', 'laura.t@mail.com', '3155555555', 'Diagonal 13 # 14-15', 'hashklmno', 'inactivo', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `venta_id` int(11) NOT NULL COMMENT 'Identificador único autoincremental de la transacción de venta',
  `venta_fecha` datetime NOT NULL COMMENT 'Fecha y hora exacta de realización del pedido',
  `venta_metodo_pago` varchar(50) NOT NULL COMMENT 'Forma de pago eleccionada (efectivo, Nequi)',
  `venta_total` decimal(10,2) NOT NULL COMMENT 'Monto total consolidado de la venta en COP',
  `venta_estado` varchar(20) NOT NULL COMMENT 'Estado del ciclo del pedido (Pedido, confirmado, entregado, cancelado)',
  `USUARIOS_usuario_id` int(11) NOT NULL COMMENT 'Llave foránea del cliente que realizó la compara en USUARIOS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`venta_id`, `venta_fecha`, `venta_metodo_pago`, `venta_total`, `venta_estado`, `USUARIOS_usuario_id`) VALUES
(1, '2026-09-10 10:30:00', 'Efectivo', 25000.00, 'Entregado', 2),
(2, '2026-09-11 14:15:00', 'Nequi', 16000.00, 'Entregado', 3),
(3, '2026-09-12 09:45:00', 'Nequi', 40000.00, 'Confirmado', 4),
(4, '2026-09-13 16:20:00', 'Efectivo', 27000.00, 'Cancelado', 2),
(5, '2026-09-15 11:00:00', 'Nequi', 25500.00, 'Pedido', 3);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`categoria_id`),
  ADD UNIQUE KEY `categoria_nombre_UNIQUE` (`categoria_nombre`);

--
-- Indices de la tabla `detalle de ventas`
--
ALTER TABLE `detalle de ventas`
  ADD PRIMARY KEY (`VENTAS_venta_id`,`PRODUCTOS_producto_id`),
  ADD KEY `fk_DETALLE DE VENTAS_VENTAS1_idx` (`VENTAS_venta_id`),
  ADD KEY `fk_DETALLE DE VENTAS_PRODUCTOS1_idx` (`PRODUCTOS_producto_id`);

--
-- Indices de la tabla `domicilios`
--
ALTER TABLE `domicilios`
  ADD PRIMARY KEY (`domicilio_id`),
  ADD UNIQUE KEY `VENTAS_venta_id_UNIQUE` (`VENTAS_venta_id`),
  ADD KEY `fk_DOMICILIOS_VENTAS1_idx` (`VENTAS_venta_id`),
  ADD KEY `fk_DOMICILIOS_REPARTIDORES1_idx` (`REPARTIDORES_repartidor_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`producto_id`),
  ADD UNIQUE KEY `producto_codigo_UNIQUE` (`producto_codigo`),
  ADD KEY `fk_PRODUCTOS_CATEGORIAS1_idx` (`CATEGORIAS_categoria_id`);

--
-- Indices de la tabla `repartidores`
--
ALTER TABLE `repartidores`
  ADD PRIMARY KEY (`repartidor_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`rol_id`),
  ADD UNIQUE KEY `rol_nombre_UNIQUE` (`rol_nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`usuario_id`),
  ADD UNIQUE KEY `usuario_cedula_UNIQUE` (`usuario_cedula`),
  ADD UNIQUE KEY `usuario_correo_UNIQUE` (`usuario_correo`),
  ADD KEY `fk_USUARIOS_ROLES_idx` (`ROLES_rol_id`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`venta_id`),
  ADD KEY `fk_VENTAS_USUARIOS1_idx` (`USUARIOS_usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `categoria_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental de la categoría', AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `domicilios`
--
ALTER TABLE `domicilios`
  MODIFY `domicilio_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental del servicio de entrega', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `producto_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental del producto', AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `repartidores`
--
ALTER TABLE `repartidores`
  MODIFY `repartidor_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental del repartidor', AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `rol_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental del rol', AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `usuario_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental del usuario', AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `venta_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador único autoincremental de la transacción de venta', AUTO_INCREMENT=16;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle de ventas`
--
ALTER TABLE `detalle de ventas`
  ADD CONSTRAINT `fk_DETALLE DE VENTAS_PRODUCTOS1` FOREIGN KEY (`PRODUCTOS_producto_id`) REFERENCES `productos` (`producto_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_DETALLE DE VENTAS_VENTAS1` FOREIGN KEY (`VENTAS_venta_id`) REFERENCES `ventas` (`venta_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `domicilios`
--
ALTER TABLE `domicilios`
  ADD CONSTRAINT `fk_DOMICILIOS_REPARTIDORES1` FOREIGN KEY (`REPARTIDORES_repartidor_id`) REFERENCES `repartidores` (`repartidor_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_DOMICILIOS_VENTAS1` FOREIGN KEY (`VENTAS_venta_id`) REFERENCES `ventas` (`venta_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_PRODUCTOS_CATEGORIAS1` FOREIGN KEY (`CATEGORIAS_categoria_id`) REFERENCES `categorias` (`categoria_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_USUARIOS_ROLES` FOREIGN KEY (`ROLES_rol_id`) REFERENCES `roles` (`rol_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_VENTAS_USUARIOS1` FOREIGN KEY (`USUARIOS_usuario_id`) REFERENCES `usuarios` (`usuario_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
