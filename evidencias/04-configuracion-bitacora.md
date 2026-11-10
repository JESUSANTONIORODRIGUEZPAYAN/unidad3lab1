# Actividad 4. Configurar la bitácora

## Objetivo
Configurar PostgreSQL para registrar las conexiones, desconexiones y sentencias de definición de objetos, además de identificar al usuario, la base de datos, la aplicación y el cliente.

## Procedimiento
1. Me conecté a la base de datos `comercial` como administrador.
2. Activé `log_connections` y `log_disconnections`.
3. Configuré `log_line_prefix` para mostrar información de las conexiones.
4. Configuré `log_statement` con el valor `ddl`.
5. Ejecuté `pg_reload_conf()` para aplicar los cambios.
6. Consulté `pg_settings` para verificar los valores.
7. Consulté la vista `dba.bitacora` para revisar los registros.

## Resultados
Los tres parámetros quedaron configurados correctamente:

- `log_connections`: on.
- `log_line_prefix`: `%m [%p] user=%u db=%d app=%a client=%h`.
- `log_statement`: ddl.

La consulta de la bitácora mostró conexiones de PostgreSQL desde el equipo local, identificando al usuario `postgres`, la base de datos `comercial`, la aplicación pgAdmin 4 y el método de autenticación SCRAM-SHA-256.

La búsqueda de mensajes que contienen `parameter` no devolvió resultados.

## Análisis

1. ¿Por qué el proceso que registra el cambio es el principal y no tu sesión?

Porque los cambios de configuración se aplican desde el proceso principal del servidor PostgreSQL. Este proceso recibe la señal de recarga y registra los cambios aplicados.

2. ¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'? ¿Quedaría rastro?

Si se aplica el cambio, PostgreSQL dejaría de registrar las sentencias SQL. Sin embargo, si el registro de cambios de configuración está funcionando, podría quedar evidencia de que el parámetro cambió a `none`.

3. ¿Por qué no se recomienda editar postgresql.auto.conf a mano?

Porque PostgreSQL administra ese archivo mediante `ALTER SYSTEM`. Modificarlo manualmente puede provocar errores de configuración y dificultar el control de los cambios.

## Conclusión
Con esta actividad configuré la bitácora de PostgreSQL para registrar las conexiones e identificar información de los usuarios y aplicaciones. También comprobé que los cambios se aplicaron correctamente mediante las consultas de verificación.