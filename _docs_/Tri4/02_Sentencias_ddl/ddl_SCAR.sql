-- =============================================================================
-- PROYECTO SCAR - SISTEMA DE CONTROL Y ADMINISTRACIÓN DE REPOSITORIO (DULCE DIP)
-- ARCHIVO: 05_ddl.sql
-- DESCRIPCIÓN: Sentencias DDL para la creación física de la Base de Datos 'bd_scar' en 3FN.
-- MOTOR: MySQL 8.0 / MariaDB (InnoDB)
-- =============================================================================

-- 1. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
DROP DATABASE IF EXISTS bd_scar;
CREATE DATABASE IF NOT EXISTS bd_scar 
  DEFAULT CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE bd_scar;

-- Desactivar temporalmente la verificación de llaves foráneas para una creación limpia
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- TABLA 1: roles (Módulo de Seguridad)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
    rol_id INT AUTO_INCREMENT PRIMARY KEY,
    rol_nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 2: perfil (Módulo de Usuarios - Datos Personales)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS perfil;
CREATE TABLE perfil (
    perfil_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    foto VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 3: usuarios (Módulo de Seguridad - Credenciales de Acceso)
-- Relaciones: 
--  - 1:N con roles (Non-Identifying)
--  - 1:1 con perfil (Non-Identifying, UNIQUE FK)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    correo_recuperacion VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    estado ENUM('Activo', 'Inactivo', 'Bloqueado') NOT NULL DEFAULT 'Activo',
    ROLES_rol_id INT NOT NULL,
    PERFIL_perfil_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_usuarios_roles 
        FOREIGN KEY (ROLES_rol_id) REFERENCES roles(rol_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_usuarios_perfil 
        FOREIGN KEY (PERFIL_perfil_id) REFERENCES perfil(perfil_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 4: categorias (Módulo de Productos)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 5: productos (Módulo de Catálogo e Inventario)
-- Relación 1:N con categorias (Non-Identifying)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_codigo VARCHAR(30) NOT NULL UNIQUE,
    producto_nombre VARCHAR(100) NOT NULL,
    producto_precio DECIMAL(10,2) NOT NULL,
    producto_stock INT NOT NULL DEFAULT 0,
    producto_peso VARCHAR(20) NOT NULL,
    CATEGORIAS_categoria_id INT NOT NULL,
    CONSTRAINT fk_productos_categorias 
        FOREIGN KEY (CATEGORIAS_categoria_id) REFERENCES categorias(categoria_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 6: repartidores (Módulo Logístico)
-- Relación 1:1 con usuarios (Non-Identifying, UNIQUE FK)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS repartidores;
CREATE TABLE repartidores (
    repartidor_id INT AUTO_INCREMENT PRIMARY KEY,
    vehiculo VARCHAR(50) NOT NULL,
    placa VARCHAR(15) NOT NULL UNIQUE,
    repartidor_estado ENUM('Disponible', 'En Ruta', 'No Disponible') NOT NULL DEFAULT 'Disponible',
    USUARIOS_usuario_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_repartidores_usuarios 
        FOREIGN KEY (USUARIOS_usuario_id) REFERENCES usuarios(usuario_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 7: ventas (Módulo de Transacciones / Pedidos)
-- Relación 1:N con usuarios (Non-Identifying)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS ventas;
CREATE TABLE ventas (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    venta_fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    venta_metodo_pago ENUM('Nequi', 'Daviplata', 'Efectivo', 'Transferencia') NOT NULL,
    venta_total DECIMAL(10,2) NOT NULL,
    venta_estado ENUM('Pendiente', 'Pagado', 'Completado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    USUARIOS_usuario_id INT NOT NULL,
    CONSTRAINT fk_ventas_usuarios 
        FOREIGN KEY (USUARIOS_usuario_id) REFERENCES usuarios(usuario_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 8: detalle_de_ventas (Tabla Intermedia N:M)
-- Relaciones Identificativas (Identifying Relationships):
--  - PK Compuesta por (VENTAS_venta_id, PRODUCTOS_producto_id)
--  - detalle_precio_historico: Preserva el precio exacto al momento de la venta
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS detalle_de_ventas;
CREATE TABLE detalle_de_ventas (
    VENTAS_venta_id INT NOT NULL,
    PRODUCTOS_producto_id INT NOT NULL,
    detalle_cantidad INT NOT NULL,
    detalle_precio_historico DECIMAL(10,2) NOT NULL,
    detalle_subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (VENTAS_venta_id, PRODUCTOS_producto_id),
    CONSTRAINT fk_detalle_ventas 
        FOREIGN KEY (VENTAS_venta_id) REFERENCES ventas(venta_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_productos 
        FOREIGN KEY (PRODUCTOS_producto_id) REFERENCES productos(producto_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- TABLA 9: domicilios (Módulo de Despacho y Entrega)
-- Relaciones:
--  - 1:1 con ventas (Non-Identifying, UNIQUE FK)
--  - 0..1:N con repartidores (Non-Identifying, Nullable FK)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS domicilios;
CREATE TABLE domicilios (
    domicilio_id INT AUTO_INCREMENT PRIMARY KEY,
    domicilio_direccion VARCHAR(150) NOT NULL,
    domicilio_costo_envio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    domicilio_estado ENUM('Pendiente', 'En Camino', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    VENTAS_venta_id INT NOT NULL UNIQUE,
    REPARTIDORES_repartidor_id INT NULL,
    CONSTRAINT fk_domicilios_ventas 
        FOREIGN KEY (VENTAS_venta_id) REFERENCES ventas(venta_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_domicilios_repartidores 
        FOREIGN KEY (REPARTIDORES_repartidor_id) REFERENCES repartidores(repartidor_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reactivar la verificación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;

-- Fin del archivo 05_ddl.sql
