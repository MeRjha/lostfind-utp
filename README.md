
# LostFind

Sistema web de gestión de objetos perdidos y encontrados desarrollado para la Universidad Tecnológica del Perú (UTP), como proyecto del curso Integrador I: Sistemas Software.

LostFind centraliza el registro, la búsqueda y la recuperación de objetos perdidos mediante un motor de coincidencias basado en inteligencia artificial. Asimismo, facilita la gestión de solicitudes de reclamo y el seguimiento de objetos por parte del Servicio de Atención al Estudiante (SAE).

**Versión:** Proyecto Final - 2026.

## Funcionalidades

### Estudiantes y docentes

- Inicio de sesión con correo institucional.
- Registro de objetos perdidos con fotografía opcional.
- Consulta y seguimiento de reportes realizados.
- Consulta de objetos encontrados por sede.
- Comparación inteligente de objetos mediante Gemini.
- Visualización de porcentajes de similitud.
- Consulta detallada de coincidencias.
- Registro de solicitudes de reclamo.
- Presentación de evidencias de propiedad.
- Generación de constancias de reclamo en Word.
- Consulta de notificaciones.

### Personal SAE

- Panel principal de administración.
- Registro de objetos encontrados.
- Gestión y seguimiento de objetos.
- Gestión de solicitudes de reclamo.
- Aprobación y rechazo de reclamos.
- Gestión de notificaciones.
- Consulta de reportes y estadísticas.

## Tecnologías utilizadas

| Recurso | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Frontend | HTML, CSS, JavaScript y JSP |
| Backend | Java Servlets y Jakarta EE |
| Servidor | Apache Tomcat 10.1 |
| Base de datos | MySQL 8 |
| Inteligencia artificial | API de Gemini |
| Librerías | Google Guava, Apache POI, Apache Commons Lang, Gson y MySQL Connector/J |
| Construcción y despliegue | Apache Ant y Maven |
| Monitoreo | SLF4J, Logback y Apache Tomcat Manager |
| Pruebas | JUnit 4 y Hamcrest |
| Mantenimiento | PowerShell, mysqldump y Programador de tareas de Windows |
| Documentación técnica | Javadoc |
| Control de versiones | Git y GitHub |
| IDE | Apache NetBeans |

## Arquitectura del sistema

LostFind utiliza el patrón MVC (Modelo-Vista-Controlador), el patrón DAO para separar el acceso a datos y el patrón Singleton para centralizar la gestión de conexiones.

También aplica principios SOLID para favorecer la organización, reutilización y mantenimiento del código.

### Estructura del proyecto

```text
lostfind-utp/
├── DataBase/
├── libs/
├── Mantenimiento/
├── nbproject/
├── src/
│   └── java/
│       ├── Objetos/
│       ├── ClasesDAO/
│       ├── Gestiones/
│       ├── Servlets/
│       └── Singlenton/
├── test/
├── web/
├── .gitignore
├── build.xml
├── pom.xml
└── README.md
```

### Organización de los componentes

- **Objetos:** clases del modelo de datos.
- **ClasesDAO:** operaciones de acceso a MySQL.
- **Gestiones:** lógica de negocio y comparación inteligente.
- **Servlets:** procesamiento de solicitudes y controladores.
- **Singlenton:** gestión de conexiones y almacenamiento de archivos.
- **web:** interfaces gráficas, estilos y scripts.
- **DataBase:** script SQL de la base de datos.
- **libs:** librerías utilizadas por el proyecto.
- **test:** pruebas automatizadas.
- **Mantenimiento:** scripts y procedimientos de respaldo y restauración.

## Requisitos

- JDK 21.
- Apache NetBeans.
- Apache Tomcat 10.1.
- Apache Maven.
- MySQL 8.
- MySQL Workbench.
- Git.
- Clave de API de Gemini.
- PowerShell para el mantenimiento en Windows.

## Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/MeRjha/lostfind-utp.git
cd lostfind-utp
```

### 2. Configurar la base de datos

Importar el archivo:

```text
DataBase/LostFind.sql
```

El script permite crear la estructura de la base de datos `bd_lostfind` y cargar los datos de prueba.

### 3. Configurar la conexión

Configurar los parámetros de conexión a MySQL utilizados por:

```text
src/java/Singlenton/ConexionBD.java
```

Las credenciales deben corresponder al entorno local y mantenerse protegidas.

### 4. Configurar Gemini

Crear la variable de entorno:

```text
GEMINI_API
```

Asignar una clave válida de la API de Gemini y reiniciar el entorno de desarrollo o servidor.

### 5. Ejecutar la aplicación

Abrir el proyecto en Apache NetBeans, configurar Apache Tomcat como servidor y ejecutar mediante la opción Run.

Acceder a:

```text
http://localhost:8080/LostFind_Final_/
```

El puerto puede variar según la configuración del servidor.

## Usuarios de prueba

| Rol | Correo | Contraseña de prueba |
|---|---|---|
| Estudiante | carlos@utp.edu.pe | Demo1234 |
| Personal SAE | maria@utp.edu.pe | Demo1234 |
| Docente | luis@utp.edu.pe | Demo1234 |

Estas cuentas están destinadas exclusivamente al entorno de pruebas.

## Almacenamiento de archivos

Las fotografías y evidencias subidas por los usuarios se almacenan en una carpeta externa al proyecto.

La ubicación predeterminada es:

```text
C:\Users\<usuario>\LostFind_uploads
```

También puede configurarse mediante la variable de entorno:

```text
LOSTFIND_UPLOADS
```

Esta configuración permite conservar los archivos durante los procesos de despliegue y mantenimiento.

## Pruebas de software

El proyecto cuenta con pruebas unitarias, de integración, funcionales y de seguridad.

Las pruebas automatizadas desarrolladas con JUnit se distribuyen de la siguiente manera:

| Clase de prueba | Casos |
|---|---:|
| ObjetosModeloTest | 8 |
| GestionAutenticacionTest | 4 |
| ReclamoModeloTest | 4 |
| SolicitudReclamoDAOTest | 8 |
| NotificacionDAOTest | 3 |
| SubidasTest | 3 |
| Total | 30 |

La ejecución documentada de las 30 pruebas automatizadas obtuvo resultados satisfactorios, sin fallos ni errores.

Para ejecutar las pruebas desde NetBeans, seleccionar el proyecto y utilizar la opción Test.

Las pruebas de integración requieren una conexión activa con MySQL.

## Seguridad

La seguridad del sistema contempla los siguientes mecanismos:

- Autenticación de usuarios.
- Control de acceso según el rol.
- Gestión y validación de sesiones.
- Consultas parametrizadas mediante PreparedStatement.
- Validación de campos obligatorios.
- Restricción de formatos y tamaños de archivos.
- Protección de rutas de almacenamiento.
- Protección de contraseñas y credenciales.
- Uso de variables de entorno para claves externas.
- Registro de eventos e incidencias.

Las pruebas de seguridad y sus resultados se documentan en el informe final del proyecto.

## Despliegue

LostFind utiliza Apache Maven para la construcción del archivo WAR y Apache Tomcat para el despliegue de la aplicación web.

Para construir el proyecto:

```bash
mvn clean package
```

El archivo WAR generado se encuentra en la carpeta:

```text
target/
```

El archivo debe desplegarse en Apache Tomcat, verificando previamente la configuración de MySQL y las variables de entorno necesarias.

El plan de despliegue contempla la preparación del entorno, construcción, instalación, validación del funcionamiento y recuperación ante errores.

## Monitoreo

El monitoreo de LostFind utiliza SLF4J, Logback y Apache Tomcat Manager.

### Niveles de registro

| Nivel | Descripción |
|---|---|
| INFO | Operaciones ejecutadas correctamente. |
| WARN | Advertencias y situaciones anómalas. |
| ERROR | Errores durante la ejecución. |
| DEBUG | Información técnica del procesamiento. |

### Indicadores de monitoreo

- Disponibilidad de la aplicación.
- Tiempos de respuesta.
- Solicitudes y errores HTTP.
- Consumo de memoria de la JVM.
- Hilos de ejecución.
- Incidencias del sistema.

El plan de monitoreo permite realizar comprobaciones periódicas y detectar problemas de funcionamiento.

## Mantenimiento

El mantenimiento de LostFind contempla la automatización de respaldos de la base de datos MySQL y de los archivos subidos por los usuarios.

Los procedimientos se organizan en la carpeta:

```text
Mantenimiento/
```

### Archivos de mantenimiento

| Archivo | Descripción |
|---|---|
| respaldo.ps1 | Script de respaldo automatizado. |
| restauracion.md | Procedimiento de restauración. |
| tarea_programada.xml | Configuración de la tarea programada. |
| README.md | Documentación del mantenimiento. |

Los respaldos incluyen:

- Exportación de la base de datos mediante mysqldump.
- Copia de las fotografías y archivos subidos.
- Organización de respaldos mediante fecha y hora.
- Registro de resultados en un archivo log.

La recuperación de la información se verifica mediante la restauración en una base de datos independiente, evitando modificar los registros originales.

### Plan de mantenimiento

| Actividad | Frecuencia |
|---|---|
| Respaldo de la base de datos y archivos | Diaria |
| Revisión de registros de ejecución | Semanal |
| Verificación del espacio disponible | Semanal |
| Prueba de restauración | Mensual |
| Revisión de respaldos antiguos | Mensual |
| Corrección de errores | Cuando ocurra una incidencia |

## Documentación técnica

La documentación técnica comprende:

- Diagramas de arquitectura MVC.
- Diagramas de clases DAO.
- Aplicación de principios SOLID.
- Documentación de clases y métodos mediante Javadoc.
- Informes de pruebas de software y seguridad.
- Plan de despliegue.
- Plan de monitoreo.
- Plan de mantenimiento.

## Control de versiones

El proyecto utiliza Git y GitHub para gestionar el desarrollo colaborativo.

### Organización de ramas

- `main`: rama principal.
- `develop`: rama de integración.
- `feature/*`: desarrollo de funcionalidades.
- `fix/*`: corrección de errores.

Los cambios se incorporan mediante pull requests.

### Convenciones de commits

- `feat`: incorporación de funcionalidades.
- `fix`: corrección de errores.
- `docs`: actualización de documentación.
- `test`: incorporación de pruebas.
- `chore`: tareas de configuración y mantenimiento.

## Equipo de desarrollo

| Integrante | Responsabilidad |
|---|---|
| Ariana Flores Papel | Backend y pruebas |
| Jhair Meza Acledo | Frontend |
| Axel Chumpitaz Muñoz | Arquitectura, despliegue y monitoreo |
| Anghela Callo Valdivia | Mantenimiento y organización del informe |

## Información académica

- **Universidad:** Universidad Tecnológica del Perú.
- **Carrera:** Ingeniería de Sistemas e Informática.
- **Curso:** Integrador I: Sistemas Software.
- **Docente:** Hebert Alfonso Fajardo Casma.
- **Entrega:** Proyecto Final.
- **Año:** 2026.
