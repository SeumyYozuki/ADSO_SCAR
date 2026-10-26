# Especificación del Modelo Relacional e Integridad Referencial - Proyecto SCAR (Dulce Dip)

Este documento acompaña al diagrama **`MR_SCAR_(3FN).png`** en la carpeta **`01_sql/03_mr/`**. En él se detallan la estructura lógica de las 9 tablas relacionales en **Tercera Forma Normal (3FN)**, las reglas de integridad referencial aplicadas y el cumplimiento de los criterios de calidad bajo el estándar **ISO/IEC 25010** y la Lista de Chequeo del SENA.

---

## 1. Estructura de Tablas en Tercera Forma Normal (3FN)

El modelo relacional está organizado en **4 módulos funcionales**:

### 🔴 Módulo de Usuarios y Seguridad
1. **`ROLES`**
   * `rol_id` (PK, INT, AUTO_INCREMENT)
   * `rol_nombre` (VARCHAR(45), NOT NULL, UNIQUE)
2. **`PERFIL`**
   * `perfil_id` (PK, INT, AUTO_INCREMENT)
   * `nombre` (VARCHAR(60), NOT NULL)
   * `apellido` (VARCHAR(60), NOT NULL)
   * `cedula` (VARCHAR(20), NOT NULL, UNIQUE)
   * `correo` (VARCHAR(100), NOT NULL, UNIQUE)
   * `telefono` (VARCHAR(20), NOT NULL)
   * `direccion` (VARCHAR(150), NOT NULL)
   * `foto` (VARCHAR(255), NULL)
3. **`USUARIOS`**
   * `usuario_id` (PK, INT, AUTO_INCREMENT)
   * `correo_recuperacion` (VARCHAR(100), NOT NULL)
   * `password` (VARCHAR(255), NOT NULL) — *Encriptación Bcrypt*
   * `estado` (ENUM('ACTIVO', 'INACTIVO'), DEFAULT 'ACTIVO')
   * `ROLES_rol_id` (FK, INT, NOT NULL)
   * `PERFIL_perfil_id` (FK, INT, NOT NULL, UNIQUE)

---

### 🟣 Módulo de Catálogo y Productos
4. **`CATEGORIAS`**
   * `categoria_id` (PK, INT, AUTO_INCREMENT)
   * `categoria_nombre` (VARCHAR(50), NOT NULL, UNIQUE) — *Ej. Queso Crema 130g, Queso Crema 230g*
5. **`PRODUCTOS`**
   * `producto_id` (PK, INT, AUTO_INCREMENT)
   * `producto_codigo` (VARCHAR(20), NOT NULL, UNIQUE)
   * `producto_nombre` (VARCHAR(100), NOT NULL) — *Ej. Feijoa, Café, Durazno*
   * `producto_precio` (DECIMAL(10,2), NOT NULL)
   * `producto_stock` (INT, NOT NULL, DEFAULT 0)
   * `producto_peso` (VARCHAR(20), NOT NULL)
   * `CATEGORIAS_categoria_id` (FK, INT, NOT NULL)

---

### 🟡 Módulo de Ventas y Pedidos
6. **`VENTAS`**
   * `venta_id` (PK, INT, AUTO_INCREMENT)
   * `venta_fecha` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP)
   * `venta_metodo_pago` (ENUM('NEQUI', 'DAVIPLATA', 'EFECTIVO', 'TRANSFERENCIA'), NOT NULL)
   * `venta_total` (DECIMAL(10,2), NOT NULL)
   * `venta_estado` (ENUM('PENDIENTE', 'PAGADO', 'EN_PREPARACION', 'DESPACHADO', 'ENTREGADO', 'CANCELADO'), DEFAULT 'PENDIENTE')
   * `USUARIOS_usuario_id` (FK, INT, NOT NULL)
7. **`DETALLE_DE_VENTAS`** *(Entidad de ruptura / Relación Identificativa)*
   * `VENTAS_venta_id` (PK, FK, INT, NOT NULL)
   * `PRODUCTOS_producto_id` (PK, FK, INT, NOT NULL)
   * `detalle_cantidad` (INT, NOT NULL)
   * `detalle_precio_historico` (DECIMAL(10,2), NOT NULL) — *Congela el precio al momento de la venta*
   * `detalle_subtotal` (DECIMAL(10,2), NOT NULL)

---

### 🟢 Módulo de Logística y Domicilios
8. **`REPARTIDORES`**
   * `repartidor_id` (PK, INT, AUTO_INCREMENT)
   * `vehiculo` (VARCHAR(45), NOT NULL)
   * `placa` (VARCHAR(15), NOT NULL)
   * `repartidor_estado` (ENUM('DISPONIBLE', 'EN_RUTA', 'INACTIVO'), DEFAULT 'DISPONIBLE')
   * `USUARIOS_usuario_id` (FK, INT, NOT NULL, UNIQUE)
9. **`DOMICILIOS`**
   * `domicilio_id` (PK, INT, AUTO_INCREMENT)
   * `domicilio_direccion` (VARCHAR(150), NOT NULL) — *Dirección de entrega específica del pedido*
   * `domicilio_costo_envio` (DECIMAL(10,2), NOT NULL, DEFAULT 0.00)
   * `domicilio_estado` (ENUM('PENDIENTE', 'EN_CAMINO', 'ENTREGADO', 'CANCELADO'), DEFAULT 'PENDIENTE')
   * `VENTAS_venta_id` (FK, INT, NOT NULL, UNIQUE)
   * `REPARTIDORES_repartidor_id` (FK, INT, NULL) — *Opcional (NULL para recogida en tienda)*

---

## 2. Reglas de Integridad Referencial

Para garantizar la estabilidad transaccional de la base de datos `bd_scar`, se implementan las siguientes políticas de clave foránea (`FOREIGN KEY`):

| Tabla Origen (Padre) | Tabla Destino (Hijo) | Columna FK | Regla `ON UPDATE` | Regla `ON DELETE` | Justificación del Negocio |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`ROLES`** | `USUARIOS` | `ROLES_rol_id` | `CASCADE` | `RESTRICT` | No se permite eliminar un rol si existen usuarios asignados a él. |
| **`PERFIL`** | `USUARIOS` | `PERFIL_perfil_id` | `CASCADE` | `RESTRICT` | Un perfil de persona no puede eliminarse mientras tenga usuario activo. |
| **`CATEGORIAS`** | `PRODUCTOS` | `CATEGORIAS_categoria_id` | `CASCADE` | `RESTRICT` | Impide borrar una categoría si contiene productos registrados. |
| **`USUARIOS`** | `VENTAS` | `USUARIOS_usuario_id` | `CASCADE` | `RESTRICT` | Protege el historial contable; una venta no se borra si el usuario se da de baja. |
| **`VENTAS`** | `DETALLE_DE_VENTAS` | `VENTAS_venta_id` | `CASCADE` | `CASCADE` | Si se anula formalmente un pedido, se eliminan sus líneas de detalle asociadas. |
| **`PRODUCTOS`** | `DETALLE_DE_VENTAS` | `PRODUCTOS_producto_id` | `CASCADE` | `RESTRICT` | Un producto no puede ser borrado si ya figura en ventas pasadas. |
| **`VENTAS`** | `DOMICILIOS` | `VENTAS_venta_id` | `CASCADE` | `CASCADE` | El registro de envío o recogida se elimina junto con el pedido correspondiente. |
| **`REPARTIDORES`** | `DOMICILIOS` | `REPARTIDORES_repartidor_id` | `CASCADE` | `SET NULL` | Si un repartidor se desvincula, la entrega conserva su historial sin perder el pedido. |

---

## 3. Evaluación de Calidad bajo ISO/IEC 25010

El diseño del Modelo Relacional cumple con los pilares de calidad de software:

1. **Idoneidad Funcional:** Satisface el 100% de los casos de uso del proyecto SCAR (gestión de catálogo, pedidos de queso crema, congelamiento de precios históricos y despacho/recogida).
2. **Integridad de Datos:** Previene registros huérfanos e inconsistencias transaccionales mediante llaves primarias compuestas y restricciones `FOREIGN KEY` normadas.
3. **Mantenibilidad (Normalización 3FN):** Al estar en Tercera Forma Normal, la base de datos es fácilmente escalable, elimina redundancias indeseadas y simplifica el mantenimiento del código SQL.
4. **Seguridad y Confidencialidad:** Aísla las credenciales de acceso de los datos personales sensibles y utiliza campos preparados para hashing seguro de contraseñas (`Bcrypt`).
