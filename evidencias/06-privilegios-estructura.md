# Actividad 6. Cambios de privilegios y estructura

## Objetivo
Comprobar que PostgreSQL registra los cambios de privilegios, las modificaciones de estructura y la creación y eliminación de roles.

## Procedimiento
Se realizaron cinco operaciones en la base de datos `comercial`:

1. Se revocó el permiso UPDATE al usuario `soporte_ana`.
2. Se concedió el permiso UPDATE al usuario `app_ventas`.
3. Se agregó la columna `segmento` a la tabla `clientes`.
4. Se creó el rol temporal `rol_temporal` con una contraseña ficticia.
5. Se eliminó el rol temporal.

Después se consultó la bitácora para localizar las sentencias registradas.

## Resultados
Se encontraron las cinco operaciones en la bitácora:

- REVOKE: línea 35.
- GRANT: línea 36.
- ALTER TABLE: línea 38.
- CREATE ROLE: línea 42.
- DROP ROLE: línea 44.

También se comprobó que la contraseña del rol temporal quedó registrada en texto claro.

## Análisis

1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

- REVOKE: cambio de privilegios porque quita un permiso.
- GRANT: cambio de privilegios porque concede un permiso.
- ALTER TABLE: cambio de estructura porque modifica la tabla agregando una columna.

2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?

Porque PostgreSQL incluye estas operaciones de administración de privilegios entre las sentencias que registra con la configuración DDL. Así se pueden revisar los cambios de permisos realizados en la base de datos.

3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.

Solamente los administradores autorizados y el personal responsable de auditoría deberían poder leer las bitácoras. Las contraseñas son información confidencial y deben protegerse, evitando escribirlas directamente en sentencias que puedan quedar registradas. También se deben aplicar permisos restringidos y proteger los archivos de configuración y registros.

## Conclusión
Con esta actividad comprobé que PostgreSQL registra los cambios de privilegios y de estructura cuando se configura `log_statement = 'ddl'`. También observé que registrar sentencias puede representar un riesgo cuando contienen contraseñas, por lo que es importante proteger los secretos y limitar el acceso a las bitácoras.