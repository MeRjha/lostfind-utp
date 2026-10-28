# LostFind

Sistema web de gestión de objetos perdidos y encontrados para universidades, desarrollado como proyecto del curso Integrador I de la Universidad Tecnológica del Perú (UTP).

Permite a los estudiantes reportar objetos perdidos, consultar los objetos encontrados por la universidad y ver las posibles coincidencias, calculadas automáticamente con un motor de similitud basado en IA.

**Versión actual:** [v0.3.0](../../releases/tag/v0.3.0) (APF3)

## Funcionalidades

- Inicio de sesión con correo institucional (Estudiante, Personal SAE y Docente).
- Reporte de objetos perdidos con categoría, color, marca, descripción, lugar y foto opcional.
- Consulta de reportes realizados y cambio de su estado.
- Listado de objetos encontrados por sede.
- Coincidencias entre objetos perdidos y encontrados, ordenadas por porcentaje de similitud (motor con IA).
- Ficha detallada de cada coincidencia.
- Generación de la constancia de solicitud de reclamo en Word.
- Notificaciones en el encabezado.

## Tecnologías

| Capa | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Web | Servlets y JSP (Jakarta EE 10), HTML, CSS y JavaScript |
| Servidor | Apache Tomcat 10 o superior |
| Base de datos | MySQL 8 |
| Librerías | Google Guava, Apache POI, Apache Commons, Gson, SLF4J/Logback, MySQL Connector/J |
| Pruebas | JUnit 4.13.2 y hamcrest 1.3 |
| IDE | NetBeans (proyecto Ant) |

## Arquitectura

El código sigue una arquitectura por capas (MVC) con patrón DAO:

```
src/java/
├── Objetos/      Modelo (Usuario, Estudiante, PersonalSAE, Docente, Objeto,
│                 ObjetoPerdido, ObjetoEncontrado, Coincidencia, Reporte, Sede)
├── ClasesDAO/    Acceso a datos (6 DAO con PreparedStatement)
├── Gestiones/    Lógica de negocio (autenticación y motor de coincidencias)
├── Servlets/     Controladores
└── Singlenton/   Conexión a la base de datos (patrón Singleton)
web/              Vistas JSP, estilos y scripts
DataBase/         Script SQL de la base de datos
libs/             Librerías compartidas (incluye JUnit para las pruebas)
test/             Pruebas unitarias y de integración
```

## Requisitos

- JDK 21
- NetBeans con soporte para Tomcat (o cualquier IDE que despliegue proyectos Ant)
- Apache Tomcat 10 o superior
- MySQL 8
- Una clave de API de Gemini para el motor de coincidencias (variable `GEMINI_API`)

## Instalación y ejecución

1. **Clonar el repositorio** en la carpeta indicada (ver *Notas de configuración*):
   ```
   git clone https://github.com/MeRjha/lostfind-utp.git
   ```
   Ruta esperada: `C:\Users\<tu-usuario>\Documents\NetBeansProjects\lostfind-utp`

2. **Crear la base de datos.** Con MySQL en ejecución, importar el script:
   ```
   mysql -u root -p < DataBase/LostFind.sql
   ```
   El script crea la base `bd_lostfind` y carga los datos de prueba.

3. **Configurar la conexión.** La conexión está definida en `src/java/Singlenton/ConexionBD.java`:
   `jdbc:mysql://localhost:3306/Bd_LostFind` con usuario `root` y contraseña `root`. Ajústala a tu instalación de MySQL si es distinta.

4. **Definir la variable de entorno `GEMINI_API`** con tu clave de API, y reiniciar el IDE para que la tome.

5. **Abrir el proyecto en NetBeans** (*File → Open Project*), configurar Tomcat como servidor y ejecutarlo (*Run*).

6. **Ingresar a la aplicación:**
   ```
   http://localhost:8080/LostFind_Final_/
   ```
   (cambia el puerto si tu Tomcat usa otro).

### Usuarios de prueba

| Rol | Correo | Contraseña |
|---|---|---|
| Estudiante | carlos@utp.edu.pe | Demo1234 |
| Personal SAE | maria@utp.edu.pe | Demo1234 |
| Docente | luis@utp.edu.pe | Demo1234 |

## Pruebas

El proyecto incluye 12 pruebas con JUnit 4:

- `test/Objetos/ObjetosModeloTest.java`: 8 pruebas unitarias del modelo.
- `test/Gestiones/GestionAutenticacionTest.java`: 4 pruebas de integración de la autenticación (requieren MySQL con la base cargada).

Para ejecutarlas: clic derecho en el proyecto → **Test** (NetBeans).

## Flujo de trabajo con Git

- `main`: versión estable, publicada con etiquetas (`v0.3.0`).
- `develop`: integración del trabajo del equipo.
- `feature/*` y `fix/*`: una rama por integrante o tema.
- Todo cambio se incorpora mediante *pull request*.
- Mensajes de commit con prefijos: `feat`, `fix`, `chore`, `test` y `merge`.

## Notas de configuración

- **Ubicación de las imágenes.** Las fotos de los reportes se guardan en `Documents/NetBeansProjects/lostfind-utp/web/Imagenes` dentro de la carpeta del usuario, y el motor de coincidencias las lee de una ruta fija. Por eso el proyecto debe clonarse en esa ubicación; si no, las coincidencias se calculan solo con el texto de la descripción.
- **Contraseñas y credenciales.** En esta versión las contraseñas de los usuarios de prueba se guardan en texto plano y las credenciales de MySQL están en `ConexionBD.java`. Están pendientes para una próxima versión.

## Estado del proyecto

Pendientes para las próximas versiones:

- Almacenar las contraseñas con hash y sacar las credenciales del código.
- Validación de solicitudes de reclamo por el Personal SAE.
- Reportes estadísticos por sede.
- Ampliar las pruebas automatizadas a los DAO y servlets.

## Equipo

| Integrantes |
|---|
| Jhair Meza |
| Anghela Callo |
| Axel Chumpitaz |
| Ariana Flores |
