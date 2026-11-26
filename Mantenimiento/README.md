
# Mantenimiento de LostFind

## Objetivo

Garantizar la continuidad operativa del sistema mediante procedimientos de respaldo, restauración y mantenimiento de la base de datos MySQL y los archivos subidos por los usuarios.

## Herramientas utilizadas

- PowerShell.
- MySQL y mysqldump.
- MySQL Workbench.
- Programador de tareas de Windows.

## Archivos de mantenimiento

- respaldo.ps1: script de respaldo automatizado.
- restauracion.md: procedimiento de restauración.
- tarea_programada.xml: configuración de la tarea programada.

## Plan de mantenimiento

| Actividad | Frecuencia |
|---|---|
| Respaldo de la base de datos y archivos | Diaria |
| Revisión de registros | Semanal |
| Verificación del almacenamiento | Semanal |
| Prueba de restauración | Mensual |
| Atención de errores | Cuando ocurra una incidencia |

## Consideraciones de seguridad

Los respaldos, fotografías, credenciales y registros privados no deben publicarse en el repositorio de GitHub.
