
# Procedimiento de restauración de LostFind

## 1. Objetivo

Recuperar la información de la base de datos MySQL y los archivos subidos por los usuarios mediante las copias de seguridad generadas por el script respaldo.ps1.

## 2. Herramientas necesarias

- MySQL Server.
- MySQL Workbench.
- Windows PowerShell.
- Copia de seguridad generada por respaldo.ps1.

## 3. Identificación del respaldo

El script genera una carpeta identificada mediante la fecha y hora de ejecución.

Cada respaldo contiene:

- bd_lostfind.sql: estructura y registros de la base de datos.
- uploads/: fotografías y archivos subidos por los usuarios.

Se debe seleccionar un respaldo finalizado correctamente, verificando el archivo respaldo.log y evitando utilizar carpetas con la extensión .incompleto.

## 4. Creación de una base de datos de restauración

Abrir MySQL Workbench y conectarse al servidor MySQL.

Para realizar una restauración de prueba sin modificar la base de datos original, ejecutar:

```sql
CREATE DATABASE IF NOT EXISTS bd_lostfind_restauracion;
```

Antes de importar el respaldo, verificar que el esquema de restauración esté vacío y que el archivo SQL no contenga instrucciones que redirijan la importación a la base de datos original.

## 5. Restauración de la base de datos

1. Abrir MySQL Workbench.
2. Seleccionar Server > Data Import.
3. Seleccionar Import from Self-Contained File.
4. Buscar el archivo bd_lostfind.sql del respaldo.
5. Seleccionar bd_lostfind_restauracion como esquema de destino.
6. Presionar Start Import.
7. Verificar que la importación finalice correctamente.

## 6. Verificación de los registros

Seleccionar el esquema restaurado:

```sql
USE bd_lostfind_restauracion;

SHOW TABLES;
```

Consultar las tablas correspondientes y comprobar que los registros respaldados se hayan recuperado correctamente.

## 7. Verificación de archivos subidos

Abrir la carpeta uploads del respaldo y comprobar que las fotografías y archivos correspondientes a los registros recuperados se encuentren disponibles.

En una recuperación operativa, los archivos deberán copiarse a la ubicación configurada mediante LOSTFIND_UPLOADS o a la carpeta predeterminada LostFind_uploads, previa protección de los archivos existentes.

## 8. Evidencia de la prueba realizada

El 21 de noviembre de 2026 se realizó una prueba de respaldo y restauración de LostFind.

Se utilizó el respaldo generado a las 11:17:28 y se restauró la información en el esquema independiente bd_lostfind_restauracion.

Se verificó:

- La recuperación del reporte n.º 19.
- El nombre del objeto: Mochila negra - Prueba de respaldo.
- La conservación del estado del reporte.
- La disponibilidad de la fotografía en los archivos respaldados.
- La conservación de la base de datos original.

## 9. Consideraciones de seguridad

- No publicar archivos de respaldo en GitHub.
- No publicar credenciales de MySQL.
- Verificar la integridad de los respaldos antes de restaurarlos.
- Realizar pruebas periódicas de restauración.
- Evitar modificar la base de datos original durante las pruebas.
