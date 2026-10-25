# Manual Teórico-Práctico: Desarrollo Web y Persistencia de Datos — Proyecto SCAR

**Sistema de Control, Administración y Registro (SCAR)**  
**Empresa Beneficiaria:** Dulce Dip  
**Especialidad:** Tecnólogo en Análisis y Desarrollo de Software (ADSO) — SENA  
**Documento Técnico:** Guía Teórico-Práctica Trimestre IV  

---

## 1. Arquitectura Web y Patrón de Diseño

### 1.1 Contextualización Teórica: Patrón MVC y Modelo Cliente-Servidor
El sistema **SCAR** adopta la arquitectura **Cliente-Servidor en 3 Capas**, implementada mediante el patrón de diseño **Modelo-Vista-Controlador (MVC)**:

* **Vista (Frontend):** Responsable de la interfaz de usuario. Construida con **HTML5 semántico**, **CSS3**, **Bootstrap 5** y **JavaScript (ES6)**. Interactúa con el cliente enviando solicitudes HTTP/HTTPS y renderizando las pantallas navegables (Inicio, Catálogo, Carrito, Registro de Ventas).
* **Controlador (Backend):** Desarrollado en **PHP 8.2 (Orientado a Objetos)**. Recibe las peticiones del usuario, procesa las reglas de negocio (validaciones, cálculo de subtotales, gestión de estados de pedidos *Registrado → En Preparación → Listo para Recoger → Entregado*), y coordina las llamadas a la capa de datos.
* **Modelo (Persistencia - Base de Datos):** Gestionado en **MySQL 8.0** en **Tercera Forma Normal (3FN)**. Almacena las 9 tablas del sistema (`roles`, `perfil`, `usuarios`, `categorias`, `productos`, `repartidores`, `ventas`, `detalle_de_ventas`, `domicilios`).

```
+-----------------------------------------------------------------+
|                       CAPA DE PRESENTACIÓN                      |
|                  Navegador Web (Cliente / Usuario)              |
|             HTML5 + CSS3 + Bootstrap 5 + JavaScript             |
+-----------------------------------------------------------------+
                                |  ^
                   Petición HTTP|  | Respuesta HTML/JSON
                                v  |
+-----------------------------------------------------------------+
|                        CAPA DE NEGOCIO                          |
|                 Servidor Web Apache (PHP 8.2 POO)               |
|            Controladores + DAO (Data Access Object)             |
+-----------------------------------------------------------------+
                                |  ^
                      PDO Query |  | Result Set
                                v  |
+-----------------------------------------------------------------+
|                         CAPA DE DATOS                           |
|                  Servidor de Base de Datos                      |
|                 MySQL 8.0 / MariaDB (3FN)                       |
+-----------------------------------------------------------------+
```

### 1.2 Aclaración Técnica: Servidor XAMPP vs. Stack MEAN
Existe una diferenciación conceptual clara entre la infraestructura de ejecución de SCAR y otros stacks del mercado:

* **XAMPP (Apache + MySQL + PHP):** Es el **entorno de servidor local** seleccionado para SCAR. Proporciona el servidor HTTP Apache, el motor relacional MySQL y el intérprete de PHP.
* **MEAN Stack (MongoDB, Express, Angular, Node.js):** Es un stack tecnológico alternativo basado 100% en JavaScript y base de datos NoSQL. **SCAR no utiliza MEAN**, ya que el dominio del negocio de Dulce Dip requiere transacciones ACID estricta en una base de datos relacional MySQL normalizada.

---

## 2. Frontend: HTML5, CSS3, Bootstrap 5 y Paleta de Colores

### 2.1 Paleta de Colores Oficial de SCAR (Dulce Dip)
El diseño visual refleja la identidad corporativa de la marca de queso crema artesanal Dulce Dip:

| Color / Tono | Código Hexadecimal | Uso e Identidad Visual |
| :--- | :--- | :--- |
| **Dorado Dulce Dip** | `#C6AF69` | Color primario, botones de acción principal, resaltados y bordes. |
| **Gris Oscuro Elegante** | `#303A44` | Encabezados principales, textos de contraste y tarjetas. |
| **Verde Bosque Lácteo** | `#2D5B25` | Color secundario, botones de confirmación ("Comprar", "Guardar"). |
| **Verde Oscuro Profundo**| `#182825` | Fondos de navbar, pie de página (footer) y barra superior. |
| **Gris Claro Neutro** | `#F2F2F2` | Fondo general del sitio web y contraste de cajas. |

### 2.2 Maquetación Semántica en HTML5 y Componentes Bootstrap 5
Las vistas del prototipo navegable cumplen con los estándares de accesibilidad y diseño responsivo (*Mobile First*):

* **Estructura Semántica:** Uso obligatorio de etiquetas `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<aside>` y `<footer>`.
* **Sistema de Rejilla (Grid System):** Uso de contenedores `.container-fluid`, `.row` y columnas `.col-12 .col-md-4 .col-lg-3` para adaptarse a dispositivos móviles, tablets y computadores de escritorio.
* **Componentes Bootstrap:**
  * `.navbar-expand-lg` para el menú de navegación con branding de Dulce Dip.
  * `.card` para la exhibición del catálogo de productos (Queso Crema Feijoa, Café, Durazno de 130g y 230g).
  * `.modal` para la confirmación de la orden de compra y fecha/hora de recogida en tienda.
  * `.badge` para los estados del pedido (`REGISTRADO`, `EN PREPARACIÓN`, `LISTO PARA RECOGER`).

---

## 3. Backend: Programación Orientada a Objetos (POO) en PHP 8.2

### 3.1 Principios POO Aplicados en SCAR
El backend de SCAR implementa los pilares de la Programación Orientada a Objetos:

1. **Encapsulamiento:** Atributos marcados como `private` o `protected` con métodos evaluadores `getter` y `setter`.
2. **Abstracción:** Representación de entidades del mundo real en clases (`Producto`, `Venta`, `Usuario`, `Perfil`).
3. **Herencia y Polimorfismo:** Clases base y especializadas para la gestión de usuarios y roles.

### 3.2 Patrones de Diseño Implementados: Singleton y DAO

#### A. Patrón Singleton (`Conexion.php`)
Garantiza que exista una única instancia de la conexión a la base de datos MySQL en todo el ciclo de vida de la ejecución PHP, optimizando recursos de memoria:

```php
<?php
// config/Conexion.php
class Conexion {
    private static $instancia = null;
    private $pdo;

    private $host = 'localhost';
    private $db   = 'bd_scar';
    private $user = 'root';
    private $pass = '';
    private $charset = 'utf8mb4';

    private function __construct() {
        $dsn = "mysql:host={$this->host};dbname={$this->db};charset={$this->charset}";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $this->pdo = new PDO($dsn, $this->user, $this->pass, $options);
        } catch (PDOException $e) {
            die("Error de conexión en SCAR: " . $e->getMessage());
        }
    }

    public static function getInstancia() {
        if (self::$instancia === null) {
            self::$instancia = new Conexion();
        }
        return self::$instancia->pdo;
    }
}
?>
```

#### B. Modelo de Entidad `Producto.php`
```php
<?php
// models/Producto.php
class Producto {
    private $id;
    private $codigo;
    private $nombre;
    private $precio;
    private $stock;
    private $categoriaId;

    public function __construct($id, $codigo, $nombre, $precio, $stock, $categoriaId) {
        $this->id = $id;
        $this->codigo = $codigo;
        $this->nombre = $nombre;
        $this->precio = $precio;
        $this->stock = $stock;
        $this->categoriaId = $categoriaId;
    }

    public function getId() { return $this->id; }
    public function getNombre() { return $this->nombre; }
    public function getPrecio() { return $this->precio; }
    public function getStock() { return $this->stock; }
}
?>
```

#### C. Patrón DAO (`ProductoDAO.php`) — Data Access Object
Aísla la lógica de persistencia de datos de la lógica de presentación:

```php
<?php
// dao/ProductoDAO.php
require_once __DIR__ . '/../config/Conexion.php';
require_once __DIR__ . '/../models/Producto.php';

class ProductoDAO {
    private $db;

    public function __construct() {
        $this->db = Conexion::getInstancia();
    }

    public function listarDisponibles() {
        $sql = "SELECT * FROM productos WHERE producto_estado = 'DISPONIBLE'";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        
        $productos = [];
        while ($row = $stmt->fetch()) {
            $productos[] = new Producto(
                $row['producto_id'],
                $row['producto_codigo'],
                $row['producto_nombre'],
                $row['producto_precio'],
                $row['producto_stock'],
                $row['CATEGORIAS_categoria_id']
            );
        }
        return $productos;
    }
}
?>
```

---

## 4. Base de Datos y Persistencia: MySQL 8.0 en 3FN y PDO

### 4.1 Mapeo Relacional de las 9 Tablas (`bd_scar`)
La base de datos en Tercera Forma Normal elimina redundancias y garantiza integridad referencial:

1. **`roles`**: Perfiles de acceso (`ADMINISTRADOR`, `VENDEDOR`, `REPARTIDOR`, `CLIENTE`).
2. **`perfil`**: Datos personales aislados (`nombre`, `apellido`, `cedula`, `correo`, `telefono`, `direccion`).
3. **`usuarios`**: Credenciales de acceso encriptadas (`correo_recuperacion`, `password` con Bcrypt).
4. **`categorias`**: Clasificación de catálogo (`Queso Crema 130g`, `Queso Crema 230g`).
5. **`productos`**: Catálogo de sabores y stock diario de producción artesanal.
6. **`repartidores`**: Datos logísticos (`vehiculo`, `placa`).
7. **`ventas`**: Registro de encargos y ciclo de estados del pedido.
8. **`detalle_de_ventas`**: Tabla de ruptura M:N con congelamiento de `precio_historico`.
9. **`domicilios`**: Programación de recogida en tienda (costo `$0.00`) o flete.

### 4.2 Seguridad en Persistencia: Prepared Statements en PDO
Para prevenir ataques de **Inyección SQL**, todas las consultas parametrizadas en PHP utilizan sentencias preparadas:

```php
// Ejemplo de inserción segura de venta
public function registrarVenta($usuarioId, $metodoPago, $total) {
    $sql = "INSERT INTO ventas (venta_fecha, venta_metodo_pago, venta_total, venta_estado, USUARIOS_usuario_id) 
            VALUES (NOW(), :metodo, :total, 'REGISTRADO', :usuario_id)";
    $stmt = $this->db->prepare($sql);
    $stmt->bindParam(':metodo', $metodoPago);
    $stmt->bindParam(':total', $total);
    $stmt->bindParam(':usuario_id', $usuarioId);
    return $stmt->execute();
}
```

---

## 5. Cuestionario Teórico-Práctico para Sustentación (SENA)

A continuación se presentan 5 preguntas clave de evaluación técnica con las respuestas respaldadas para la defensa del proyecto ante los instructores:

### Pregunta 1: ¿Por qué el proyecto SCAR utiliza la arquitectura MVC y cómo se refleja en el código?
**Respuesta:** MVC permite separar la interfaz gráfica (Vistas HTML/Bootstrap) de la lógica del negocio (Controladores PHP) y del acceso a datos (Modelos/DAO y MySQL). Esto facilita el mantenimiento, la escalabilidad y permite que modificaciones en el diseño visual no afecten las reglas de negocio ni la estructura de la base de datos.

### Pregunta 2: ¿Cómo responde el sistema SCAR al modelo de negocio de Dulce Dip si no hay inventario estático en bodega?
**Respuesta:** Dulce Dip opera bajo un modelo de producción bajo pedido (*Make-to-Order*). En SCAR, la casilla `producto_stock` representa la capacidad máxima de producción diaria del taller artesanal. Al realizarse una compra, el estado de la venta cambia a `REGISTRADO`, alertando a Doña Neila para elaborar el producto el mismo día. Al finalizar, el estado pasa a `LISTO PARA RECOGER`, notificando al cliente para retirar en tienda.

### Pregunta 3: ¿Por qué se separó la tabla `perfil` de la tabla `usuarios` en la base de datos?
**Respuesta:** Se separaron para cumplir estrictamente con la **Tercera Forma Normal (3FN)**. Los datos personales (nombre, cédula, teléfono) dependen de la persona física (`perfil`), mientras que las credenciales (clave encriptada, correo de recuperación, estado) pertenecen a la cuenta de acceso (`usuarios`). Esto evita redundancia y permite que un perfil mantenga integridad aunque cambien las credenciales.

### Pregunta 4: ¿Qué medidas de seguridad implementa SCAR en el manejo de contraseñas y base de datos?
**Respuesta:** En el backend, las contraseñas se encriptan con algoritmos de hash seguros mediante `password_hash()` (Bcrypt). En la capa de datos, se utilizan exclusivamente **Prepared Statements con PDO**, lo que neutraliza cualquier intento de Inyección SQL al separar los comandos SQL de los valores enviados por el usuario.

### Pregunta 5: ¿Por qué XAMPP no es un patrón arquitectónico?
**Respuesta:** XAMPP es un paquete de software que integra un entorno de servidor local (Apache, MariaDB/MySQL, PHP, Perl). No es un patrón arquitectónico. El patrón arquitectónico de SCAR es **MVC (Modelo-Vista-Controlador)** desplegado sobre una arquitectura Cliente-Servidor.
