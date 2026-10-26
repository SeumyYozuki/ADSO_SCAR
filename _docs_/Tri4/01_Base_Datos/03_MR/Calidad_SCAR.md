# Modelo Relacional de la Base de Datos - Proyecto SCAR (`bd_scar`)

Este documento presenta la especificación del **Modelo Relacional en Notación Crow's Foot (Patas de Gallo)** para el proyecto **SCAR** (Sistema de Control, Administración y Registro de Dulce Dip), desarrollado bajo los criterios de calidad de la norma **ISO/IEC 25010** y normalizado formalmente en **Tercera Forma Normal (3FN)**.

---

## 1. Especificación de Tablas, Llaves y Cardinalidades

El modelo está compuesto por **9 tablas relacionales** diseñadas para garantizar la integridad referencial y eliminar la redundancia de datos:

| Tabla | Llave Primaria (PK) | Llaves Foráneas (FK) y Restricciones (UQ) | Descripción y Propósito |
| :--- | :--- | :--- | :--- |
| **`roles`** | `rol_id` | `rol_nombre` (UQ) | Catálogo de perfiles de acceso (ADMINISTRADOR, VENDEDOR, REPARTIDOR, CLIENTE). |
| **`perfil`** | `perfil_id` | `cedula` (UQ), `correo` (UQ) | Almacena los datos personales básicos de los usuarios de forma aislada. |
| **`usuarios`** | `usuario_id` | `ROLES_rol_id` (FK), `PERFIL_perfil_id` (FK, UQ) | Credenciales de autenticación, hash de clave y estado del acceso. |
| **`categorias`** | `categoria_id` | `categoria_nombre` (UQ) | Clasificación de productos (Queso Crema 130g, Queso Crema 230g). |
| **`productos`** | `producto_id` | `CATEGORIAS_categoria_id` (FK), `producto_codigo` (UQ) | Catálogo de sabores de queso crema con stock diario y precio unitario. |
| **`repartidores`** | `repartidor_id` | `USUARIOS_usuario_id` (FK, UQ) | Datos específicos de logística (vehículo, placa) vinculados al usuario. |
| **`ventas`** | `venta_id` | `USUARIOS_usuario_id` (FK) | Encargos y transacciones realizadas con su estado de preparación/entrega. |
| **`detalle_de_ventas`** | `(VENTAS_venta_id, PRODUCTOS_producto_id)` | Clave Compuesta (FK a `ventas` y `productos`) | Tabla de ruptura M:N que congela el precio histórico de cada producto vendido. |
| **`domicilios`** | `domicilio_id` | `VENTAS_venta_id` (FK, UQ), `REPARTIDORES_repartidor_id` (FK opcional - NULL) | Gestión de dirección de entrega o recogida en tienda y costo de flete. |

---

## 2. Reglas de Integridad Referencial

Para evitar registros huérfanos y garantizar la consistencia en el motor MySQL, se definieron las siguientes acciones de integridad referencial:

* **`ON UPDATE CASCADE` (Actualización en Cascada):** Si se modifica un identificador primario en una tabla padre (ej. `categoria_id` o `rol_id`), las tablas hijas actualizan sus llaves foráneas de forma automática.
* **`ON DELETE RESTRICT` (Restricción de Borrado):** Impide la eliminación accidental de un registro padre si existen registros asociados en tablas hijas (por ejemplo, no se puede eliminar un producto si ya existen ventas registradas con ese ítem).
* **`ON DELETE SET NULL` (Establecer a Nulo):** Aplicado a `REPARTIDORES_repartidor_id` en la tabla `domicilios`. Si un repartidor es dado de baja en el sistema, el historial de domicilios entregados por él no se borra, sino que la casilla del repartidor pasa a valor `NULL`.

---

## 3. Criterios de Calidad del Software (ISO/IEC 25010)

El diseño del Modelo Relacional cumple con los pilares del estándar de calidad **ISO/IEC 25010**:

1. **Idoneidad Funcional e Integridad:**
   * Garantiza la persistencia completa del ciclo de compras sin inconsistencias.
   * Congela el valor del producto al momento de la transacción en `detalle_precio_historico`, protegiendo la contabilidad frente a futuros cambios de precios en la tabla `productos`.
2. **Mantenibilidad y Modularidad:**
   * La estructura en **3FN** evita la duplicidad de información personal, reduciendo el acoplamiento y facilitando la actualización de esquemas.
3. **Seguridad y Confidencialidad:**
   * La relación 1:1 entre `perfil` y `usuarios` independiza los datos públicos de las credenciales de acceso.
   * Restricciones `UNIQUE` en campos críticos (`cedula`, `correo`, `producto_codigo`) evitan duplicaciones por error de usuario o ataques.

---

## 4. Diagrama del Modelo Relacional
![Modelo Relacional SCAR 3FN](modelo_relacional_3fn.png)
