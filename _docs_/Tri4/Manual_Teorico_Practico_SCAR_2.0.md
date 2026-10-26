# Manual Teórico-Práctico de Desarrollo Web y Persistencia — Proyecto SCAR (Dulce Dip)

**Programa de Formación:** Análisis y Desarrollo de Software (ADSO) - SENA  
**Proyecto:** Sistema de Control de Almacén y Recepción (SCAR) — Microempresa Dulce Dip  
**Stack Tecnológico:** HTML5, CSS3, Bootstrap 5, JavaScript Vanilla, PHP 8.2 (POO / PDO), MySQL 8.0 (3FN)  
**Entorno de Servidor:** XAMPP (Apache + MySQL/MariaDB + PHP)  

---

## 1. Arquitectura de Software y Patrón de Diseño

### 1.1 Arquitectura Cliente-Servidor en 3 Capas
El proyecto **SCAR** implementa una arquitectura web en tres capas para garantizar la separación de responsabilidades y la mantenibilidad del sistema:

1. **Capa de Presentación (Frontend):** Responsable de la interfaz gráfica de usuario. Construida con HTML5 semántico, CSS3, Bootstrap 5 y JavaScript. Procesa la interacción del cliente en navegadores web.
2. **Capa de Lógica de Negocio (Backend):** Implementada en PHP 8.2 bajo el paradigma de Programación Orientada a Objetos (POO). Procesa las peticiones HTTP, aplica reglas de negocio (cálculo de totales, gestión de inventarios) y orquesta la comunicación.
3. **Capa de Persistencia (Base de Datos):** Gestionada en MySQL 8.0 sobre un modelo relacional estricto en Tercera Forma Normal (3FN).

### 1.2 Patrón de Diseño Modelo-Vista-Controlador (MVC)
* **Modelo (`Model`):** Representa las entidades del dominio (`Producto.php`, `Usuario.php`, `Venta.php`) y encapsula la lógica de acceso a datos utilizando el patrón **DAO (Data Access Object)**.
* **Vista (`View`):** Plantillas de interfaz (`index.php`, `catalogo.php`, `gestion_inventario.php`) que renderizan los datos al usuario.
* **Controlador (`Controller`):** Clases PHP (`ProductoController.php`, `VentaController.php`) que reciben las solicitudes del usuario, invocan los métodos del modelo y seleccionan la vista correspondiente.

### 1.3 Aclaración Técnica: XAMPP vs. Stack MEAN
* **XAMPP:** Es la suite de servidor local que integra el servidor web Apache, el motor de base de datos MySQL/MariaDB y el intérprete PHP. **No es un patrón arquitectónico**, sino la infraestructura de servidor donde se despliega SCAR.
* **Descarte del Stack MEAN (MongoDB, Express, Angular, Node):** Se descartó la arquitectura NoSQL orientada a documentos debido a que el modelo de negocio de Dulce Dip exige **consistencia transaccional estricta (ACID)** para el control de inventario de queso crema (130g y 230g) y ventas, lo cual se garantiza eficientemente con MySQL relacional en 3FN.

---

## 2. Desarrollo Frontend (HTML5, CSS3, Bootstrap 5 y JavaScript)

### 2.1 Paleta de Colores Oficial de Dulce Dip
Para el diseño de la interfaz de SCAR se definió una paleta cromática basada en la identidad visual de la microempresa:

| Color | Código Hex | Uso en el Sistema |
| :--- | :--- | :--- |
| **Dorado / Mostaza** | `#C6AF69` | Botones principales, acentuación de tarjetas y elementos destacados. |
| **Azul Oscuro / Gris** | `#303A44` | Barras de navegación (Navbar), encabezados principales y pie de página. |
| **Verde Oliva** | `#2D5B25` | Mensajes de éxito, badges de estado disponible y confirmaciones. |
| **Verde Oscuro Fondo** | `#182825` | Contenedores primarios, fondos oscuros y pie de página secundario. |
| **Gris Claro** | `#F2F2F2` | Fondo general de la aplicación, fondo de tarjetas y contenedores de texto. |

### 2.2 Maquetación Responsiva con Bootstrap 5
El catálogo de productos utiliza el sistema de rejilla (*Grid System*) de Bootstrap 5 para adaptarse a dispositivos móviles y de escritorio:

```html
<div class="container my-4">
    <div class="row g-4">
        <!-- Tarjeta de Producto: Queso Crema Feijoa 130g -->
        <div class="col-12 col-md-6 col-lg-4">
            <div class="card h-100 shadow-sm" style="background-color: #F2F2F2; border-color: #C6AF69;">
                <img src="assets/img/feijoa_130g.jpg" class="card-img-top" alt="Queso Crema Feijoa">
                <div class="card-body">
                    <h5 class="card-title" style="color: #303A44;">Queso Crema Feijoa 130g</h5>
                    <p class="card-text text-muted">Sabor artesanal con trozos de fruta natural.</p>
                    <span class="badge bg-success" style="background-color: #2D5B25 !important;">$10.000 COP</span>
                </div>
                <div class="card-footer bg-transparent border-0 text-end">
                    <button class="btn text-white" style="background-color: #C6AF69;">Añadir al Pedido</button>
                </div>
            </div>
        </div>
    </div>
</div>
```

---

## 3. Backend y Programación Orientada a Objetos (POO en PHP 8.2)

### 3.1 Patrón Singleton para la Conexión a Base de Datos (`Conexion.php`)
Garantiza una única instancia de la conexión PDO durante el ciclo de vida de la petición:

```php
<?php
class Conexion {
    private static ?PDO $instancia = null;
    
    private function __construct() {}

    public static function getInstancia(): PDO {
        if (self::$instancia === null) {
            try {
                $host = 'localhost';
                $db   = 'bd_scar';
                $user = 'root';
                $pass = '';
                $charset = 'utf8mb4';
                
                $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
                $options = [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ];
                
                self::$instancia = new PDO($dsn, $user, $pass, $options);
            } catch (PDOException $e) {
                die("Error de conexión a bd_scar: " . $e->getMessage());
            }
        }
        return self::$instancia;
    }
}
?>
```

### 3.2 Patrón Data Access Object (`ProductoDAO.php`)
Separa la lógica de persistencia de la lógica de presentación mediante operaciones CRUD parametrizadas:

```php
<?php
require_once 'Conexion.php';

class ProductoDAO {
    private PDO $db;

    public function __construct() {
        $this->db = Conexion::getInstancia();
    }

    public function listarProductos(): array {
        $sql = "SELECT p.producto_id, p.producto_codigo, p.producto_nombre, 
                       p.producto_precio, p.producto_stock, c.categoria_nombre 
                FROM productos p
                INNER JOIN categorias c ON p.CATEGORIAS_categoria_id = c.categoria_id
                ORDER BY p.producto_nombre ASC";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll();
    }
}
?>
```

---

## 4. Persistencia de Datos y Seguridad (MySQL en 3FN)

### 4.1 Resumen del Esquema Relacional en 3FN
La base de datos `bd_scar` está conformada por 9 tablas en 3FN:
1. `roles`: Definición de perfiles (*Administrador, Vendedor, Repartidor, Cliente*).
2. `perfil`: Datos personales atómicos (*cédula, nombres, apellidos, teléfono*).
3. `usuarios`: Credenciales de acceso y estado del sistema (relación 1:1 con `perfil`).
4. `categorias`: Clasificación de productos (*Queso Crema 130g / 230g*).
5. `productos`: Catálogo con stock, precio y código único.
6. `repartidores`: Datos de vehículo y disponibilidad del personal de entregas.
7. `ventas`: Registro maestro de pedidos de Dulce Dip.
8. `detalle_de_ventas`: Tabla de ruptura (N:M) con `detalle_precio_historico` congelado.
9. `domicilios`: Dirección de entrega y asignación de transporte.

### 4.2 Seguridad y Protección de Datos
* **Consultas Preparadas con PDO:** Todos los parámetros se envían mediante placeholders (`?` o `:param`), eliminando el riesgo de inyección SQL.
* **Encriptación de Contraseñas:** Se utiliza el algoritmo **Bcrypt** mediante `password_hash($pass, PASSWORD_BCRYPT)` y la verificación estricta con `password_verify()`.

---

## 5. Cuestionario Teórico-Práctico para Sustentación SENA

### Pregunta 1: ¿Por qué la base de datos de SCAR separa la tabla `perfil` de la tabla `usuarios`?
**Respuesta:** Cumple con la Tercera Forma Normal (3FN). Los datos personales (cédula, nombres, teléfono) corresponden al perfil de la persona física, mientras que las credenciales (correo de recuperación, hash de contraseña, estado) pertenecen al objeto de seguridad. Esta separación permite reutilizar o cambiar mecanismos de acceso sin duplicar datos personales.

### Pregunta 2: ¿Cuál es la diferencia entre el patrón MVC y el entorno XAMPP?
**Respuesta:** MVC es un patrón de arquitectura de software que organiza el código en tres componentes (Modelo, Vista, Controlador). XAMPP es un entorno de desarrollo local que agrupa el servidor web Apache, la base de datos MySQL y el intérprete PHP para permitir la ejecución del sistema.

### Pregunta 3: ¿Por qué se incluye `detalle_precio_historico` en la tabla `detalle_de_ventas`?
**Respuesta:** Para garantizar la integridad histórica de las ventas. Si el precio de un tarrito de queso crema aumenta en el catálogo de productos, las ventas registradas en el pasado deben mantener el precio al que fueron cobradas originalmente.

### Pregunta 4: ¿Cómo previene SCAR los ataques de Inyección SQL?
**Respuesta:** Mediante el uso de Sentencias Preparadas (Prepared Statements) con la extensión PDO de PHP, asegurando que los datos ingresados por el usuario se traten como literales y no como código ejecutable.

### Pregunta 5: ¿Qué ventaja ofrece el Patrón Singleton en la clase `Conexion.php`?
**Respuesta:** Evita abrir múltiples conexiones innecesarias a MySQL durante una misma petición, optimizando la memoria del servidor y reutilizando un único objeto PDO.
