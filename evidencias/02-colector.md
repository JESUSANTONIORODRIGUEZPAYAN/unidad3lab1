# Evidencia 02 — Colector y vista de bitácora

## Procedimiento

Se comprobó que `logging_collector` estaba activado. Después se consultó la ruta del archivo vigente mediante `pg_current_logfile()`.

La ruta obtenida fue:

`log/postgresql-2026-11-09_000000.log`

Al intentar leer el archivo con `pg_read_file()` se presentó un error de codificación UTF8. Para solucionarlo se utilizó `pg_read_binary_file()` junto con `convert_from(..., 'LATIN1')`.

Posteriormente se creó el esquema `dba` y la vista `dba.bitacora`, que consulta las líneas del archivo y ordenarlas mediante un número de línea.

## Consultas de comprobación

Se probaron consultas para:
- Mostrar las últimas diez líneas de la bitácora.
- Buscar eventos que contengan UPDATE.
- Buscar registros que contengan FATAL o ERROR.

La búsqueda de errores encontró registros relacionados con intentos de autenticación, roles existentes y errores de consultas SQL.

### Resultado de la búsqueda de UPDATE

La consulta para buscar sentencias UPDATE no devolvió resultados. Esto se debe a que la configuración inicial tenía `log_statement = none`, por lo que PostgreSQL todavía no registraba las sentencias SQL normales.

Este resultado demuestra la importancia de configurar correctamente las bitácoras para poder auditar las operaciones realizadas en la base de datos.

## Preguntas y respuestas

1. ¿Por qué logging_collector requiere reinicio y log_statement solo recarga?

Porque el colector necesita iniciar un proceso interno de PostgreSQL, mientras que log_statement puede aplicar su cambio al recargar la configuración.

2. ¿Qué ventaja tiene leer la bitácora con SQL y qué riesgo introduce?

Permite consultar y filtrar los registros desde pgAdmin sin acceder directamente a los archivos del sistema operativo. El riesgo es que se puede exponer información sensible si usuarios no autorizados tienen acceso.

3. ¿Quién debería poder consultar dba.bitacora?

Solamente el administrador de PostgreSQL y el personal autorizado para realizar auditorías.

## Resultado

Se consiguió activar y comprobar el colector, localizar el archivo de bitácora y crear una vista funcional para consultar sus registros.

## Conclusión

Con esta actividad aprendí a consultar los registros del servidor PostgreSQL directamente desde SQL. También comprobé que las bitácoras permiten identificar errores y revisar los eventos que ocurren en el servidor.