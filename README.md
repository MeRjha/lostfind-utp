# LostFind

Sistema web de gestión de objetos perdidos y encontrados desarrollado para la Universidad Tecnológica del Perú (UTP), como proyecto del curso Integrador I: Sistemas Software.

LostFind centraliza el registro, la búsqueda y la recuperación de objetos perdidos mediante un motor de coincidencias basado en inteligencia artificial. Asimismo, facilita la gestión de solicitudes de reclamo y el seguimiento de objetos por parte del Servicio de Atención al Estudiante (SAE).

**Versión:** Proyecto Final - 2026.

## Funcionalidades

### Estudiantes y docentes

- Inicio de sesión con correo institucional.
- Registro de objetos perdidos y sus características, incluida la fotografía.
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

También incorpora prácticas relacionadas con los principios SOLID para favorecer la organización, reutilización y mantenimiento del código, con oportunidades de mejora en la arquitectura.

### Estructura del proyecto

```text
lostfind-utp/
├── DataBase/
├── docs/
│   ├── javadoc/
│   └── evidencias/
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
- **docs/javadoc:** documentación HTML generada mediante Javadoc.
- **docs/evidencias:** capturas de construcción, despliegue, monitoreo, pruebas y Javadoc.

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
git switch develop
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

El nombre del esquema utilizado en las conexiones JDBC debe coincidir con `bd_lostfind`, definido en el script SQL.

Se unificaron los nombres del esquema en ConexionBD y de la tabla `sede` en UsuarioDAO para evitar incompatibilidades en sistemas sensibles a mayúsculas y minúsculas.

Las credenciales deben corresponder al entorno local y mantenerse protegidas. La externalización de las credenciales de conexión constituye una oportunidad de mejora.

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

Estas cuentas están destinadas exclusivamente al entorno local de pruebas y no deben utilizarse en producción.

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

El proyecto cuenta con pruebas unitarias, de integración y funcionales. La evaluación de seguridad se documenta por separado en el informe final, según las evidencias disponibles.

Las pruebas automatizadas desarrolladas con JUnit se distribuyen de la siguiente manera:

| Clase de prueba | Casos |
|---|---:|
| ObjetosModeloTest | 8 |
| GestionAutenticacionTest | 4 |
| ReclamoModeloTest | 4 |
| SolicitudReclamoDAOTest | 8 |
| NotificacionDAOTest | 3 |
| SubidasTest | 3 |
| **Total** | **30** |

La ejecución documentada en el entorno de laboratorio del 25 de noviembre de 2026 obtuvo 30 pruebas aprobadas, sin fallos ni errores, después de corregir los nombres del esquema y la tabla de MySQL.

Para ejecutar las pruebas desde NetBeans, seleccionar el proyecto y utilizar la opción Test.

Las pruebas de integración requieren una conexión activa con MySQL.

**Evidencia:** [Resultados de las pruebas automatizadas](docs/evidencias/mysql-pruebas.png).

Los resultados corresponden a la ejecución documentada en laboratorio y deben verificarse nuevamente después de realizar modificaciones en el sistema.

## Seguridad

La seguridad del sistema contempla los siguientes mecanismos:

- Autenticación de usuarios.
- Control de acceso según el rol.
- Gestión y validación de sesiones.
- Consultas parametrizadas mediante PreparedStatement.
- Validación de campos obligatorios.
- Restricción de formatos y tamaños de archivos.
- Protección de rutas de almacenamiento.
- Uso de variables de entorno para claves externas.
- Registro de eventos e incidencias.

El almacenamiento seguro de contraseñas mediante algoritmos de hash y la externalización de las credenciales de MySQL constituyen oportunidades de mejora.

Las pruebas de seguridad y sus resultados deben sustentarse mediante las evidencias correspondientes del informe final.

## Despliegue

LostFind incluye el archivo `pom.xml` para la construcción mediante Apache Maven con Java 21 y el empaquetado WAR, además de su configuración original de Apache Ant.

### Construcción mediante Maven

Para ejecutar las pruebas y construir el proyecto con MySQL configurado y los datos de prueba disponibles:

```bash
mvn clean package
```

Para generar únicamente el archivo WAR, omitiendo la ejecución de pruebas:

```bash
mvn -DskipTests clean package
```

El archivo generado se encuentra en:

```text
target/LostFind_Final_.war
```

### Despliegue en Apache Tomcat

1. Configurar MySQL y las variables de entorno necesarias.
2. Generar el archivo WAR mediante Maven.
3. Copiar el archivo WAR a la carpeta webapps de Apache Tomcat.
4. Iniciar el servidor de aplicaciones.
5. Verificar el acceso al contexto de LostFind.
6. Comprobar el funcionamiento de las funcionalidades principales.

El contexto de despliegue corresponde a:

```text
/LostFind_Final_/
```

El puerto depende de la configuración del servidor.

Durante la validación realizada el 25 de noviembre de 2026 se compilaron satisfactoriamente 47 archivos fuente y se generó el archivo WAR, obteniendo el resultado BUILD SUCCESS.

Posteriormente, se verificó el despliegue de la aplicación mediante Apache Tomcat.

### Evidencias de despliegue

- [Construcción exitosa mediante Maven](docs/evidencias/maven-construccion.png).
- [Despliegue del archivo WAR en Apache Tomcat](docs/evidencias/tomcat-despliegue.png).
- [Verificación de MySQL y pruebas automatizadas](docs/evidencias/mysql-pruebas.png).

El plan de despliegue contempla la preparación del entorno, construcción, instalación, validación del funcionamiento y recuperación ante errores.

La compilación y las pruebas deben repetirse sobre la versión actual antes de confirmar su funcionamiento.

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

### Resultados del monitoreo

El 25 de noviembre de 2026 se realizaron mediciones de rendimiento en un entorno local, obteniendo los siguientes resultados:

| Ruta evaluada | Respuestas HTTP 200 | Tiempo mediano | Tiempo máximo |
|---|---:|---:|---:|
| Página de inicio | 10 de 10 | 1,1 ms | 1,9 ms |
| Consulta de objetos encontrados | 10 de 10 | 3,6 ms | 10,1 ms |
| Consulta de reportes realizados | 10 de 10 | 2,0 ms | 2,8 ms |

Las 30 solicitudes evaluadas obtuvieron respuestas HTTP satisfactorias.

Asimismo, Apache Tomcat Manager permitió consultar el estado de la JVM, los hilos de ejecución y los contadores de solicitudes y errores.

Los resultados constituyen una línea base de rendimiento en el entorno local y no representan una prueba de carga con múltiples usuarios concurrentes.

### Plan de monitoreo

| Actividad | Frecuencia propuesta |
|---|---|
| Verificación de disponibilidad | Diaria y después de cada despliegue |
| Revisión de registros WARN y ERROR | Diaria |
| Medición de tiempos de respuesta | Semanal |
| Supervisión de memoria e hilos | Diaria |
| Verificación de la conexión con MySQL | Después de cada despliegue o incidencia |
| Registro de incidencias | Cuando ocurra una incidencia |
| Validación de correcciones | Después de resolver cada incidencia |

### Evidencias de monitoreo

- [Registros de eventos mediante Logback](docs/evidencias/logback-registros.png).
- [Resultados del monitoreo mediante Apache Tomcat Manager](docs/evidencias/tomcat-monitoreo.png).

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

| Actividad | Frecuencia propuesta |
|---|---|
| Respaldo de la base de datos y archivos | Diaria |
| Revisión de registros de ejecución | Semanal |
| Verificación del espacio disponible | Semanal |
| Prueba de restauración | Mensual |
| Revisión de respaldos antiguos | Mensual |
| Corrección de errores | Cuando ocurra una incidencia |

Las frecuencias corresponden al plan propuesto de mantenimiento. La ejecución programada documentada se realizó mediante una tarea configurada para una sola ejecución.

Para consultar los procedimientos completos, acceder a la [documentación de mantenimiento](Mantenimiento/README.md).

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

### Documentación mediante Javadoc

La documentación técnica del código fuente fue generada satisfactoriamente mediante Javadoc en Apache NetBeans.

Los paquetes documentados son:

| Paquete | Descripción |
|---|---|
| ClasesDAO | Componentes de acceso a la base de datos. |
| Gestiones | Componentes de lógica de negocio y comparación inteligente. |
| Objetos | Clases correspondientes al modelo del sistema. |
| Servlets | Controladores de las solicitudes web. |
| Singlenton | Gestión de conexiones y almacenamiento de archivos. |

### Consultar la documentación

La documentación HTML completa se encuentra en:

```text
docs/javadoc/
```

Para visualizarla correctamente:

1. Descargar o clonar el repositorio.
2. Ingresar en la carpeta docs/javadoc.
3. Abrir el archivo index.html mediante un navegador web.
4. Consultar los paquetes, clases, constructores y métodos disponibles.

Se deben conservar todos los archivos y subcarpetas generados para garantizar el funcionamiento de los estilos, enlaces y herramientas de búsqueda.

**Directorio de documentación:** [Javadoc de LostFind](docs/javadoc/).

### Evidencias de Javadoc

- [Generación exitosa de Javadoc](docs/evidencias/javadoc-generacion.png).
- [Visualización de los paquetes documentados](docs/evidencias/javadoc-paquetes.png).

## Evidencias técnicas

Las evidencias correspondientes al despliegue, monitoreo, pruebas automatizadas y documentación técnica se encuentran organizadas en:

[docs/evidencias/](docs/evidencias/)

| Evidencia | Archivo |
|---|---|
| Construcción mediante Maven | [maven-construccion.png](docs/evidencias/maven-construccion.png) |
| Despliegue en Apache Tomcat | [tomcat-despliegue.png](docs/evidencias/tomcat-despliegue.png) |
| Registros de Logback | [logback-registros.png](docs/evidencias/logback-registros.png) |
| Monitoreo del servidor | [tomcat-monitoreo.png](docs/evidencias/tomcat-monitoreo.png) |
| Verificación de MySQL y pruebas | [mysql-pruebas.png](docs/evidencias/mysql-pruebas.png) |
| Generación de Javadoc | [javadoc-generacion.png](docs/evidencias/javadoc-generacion.png) |
| Visualización de Javadoc | [javadoc-paquetes.png](docs/evidencias/javadoc-paquetes.png) |

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
- `build`: configuración de construcción y empaquetado.
- `chore`: tareas de configuración y mantenimiento.

## Equipo de desarrollo

| Integrante | Responsabilidad |
|---|---|
| Ariana Flores Papel | Backend y pruebas |
| Jhair Meza Acledo | Frontend |
| Axel Chumpitaz Muñoz | Arquitectura, buenas prácticas, documentación técnica, despliegue y monitoreo |
| Anghela Callo Valdivia | Mantenimiento, control de versiones y organización del informe |

## Información académica

- **Universidad:** Universidad Tecnológica del Perú.
- **Carrera:** Ingeniería de Sistemas e Informática.
- **Curso:** Integrador I: Sistemas Software.
- **Docente:** Hebert Alfonso Fajardo Casma.
- **Entrega:** Proyecto Final.
- **Año:** 2026.
