-- =============================================================================
-- PROYECTO SCAR - SISTEMA DE CONTROL Y ADMINISTRACIÓN DE REPOSITORIO (DULCE DIP)
-- ARCHIVO: 07_consultas_generales.sql
-- DESCRIPCIÓN: Consultas de selección general (SELECT * FROM) para verificación de tablas.
-- =============================================================================

USE bd_scar;

-- 1. CONSULTA GENERAL DE ROLES
SELECT * FROM roles;

-- 2. CONSULTA GENERAL DE PERFILES
SELECT * FROM perfil;

-- 3. CONSULTA GENERAL DE USUARIOS
SELECT * FROM usuarios;

-- 4. CONSULTA GENERAL DE CATEGORÍAS
SELECT * FROM categorias;

-- 5. CONSULTA GENERAL DE PRODUCTOS
SELECT * FROM productos;

-- 6. CONSULTA GENERAL DE REPARTIDORES
SELECT * FROM repartidores;

-- 7. CONSULTA GENERAL DE VENTAS
SELECT * FROM ventas;

-- 8. CONSULTA GENERAL DE DETALLE DE VENTAS
SELECT * FROM detalle_de_ventas;

-- 9. CONSULTA GENERAL DE DOMICILIOS
SELECT * FROM domicilios;
