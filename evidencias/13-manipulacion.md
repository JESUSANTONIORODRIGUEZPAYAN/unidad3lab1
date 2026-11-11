# Actividad 14 — Intentar manipular la auditoría

## Objetivo
Comprobar si un usuario de la aplicación puede eliminar registros de auditoría o desactivar el trigger que registra los cambios.

## Procedimiento
1. Desde la cuenta `app_ventas` se intentó eliminar el contenido de `auditoria.cambios_clientes`.
2. También se intentó desactivar el trigger `trg_auditoria_clientes`.
3. Ambos intentos fueron rechazados por falta de permisos.
4. Desde la cuenta administradora `postgres` se desactivó temporalmente el trigger.
5. Se modificó el RFC de María García a `GAMA780912GHI`.
6. Se volvió a activar el trigger.
7. Se consultó el conteo de registros de auditoría y la bitácora del servidor.

## Resultado
El usuario `app_ventas` no pudo eliminar los registros ni desactivar el trigger.

Sin embargo, el administrador pudo desactivar temporalmente el trigger y modificar el RFC de María García.

El conteo de auditorías permaneció en 4 registros, aunque el RFC cambió a `GAMA780912GHI`.

La bitácora del servidor conservó evidencia de las operaciones realizadas, incluyendo el intento de desactivación y las instrucciones ejecutadas por el administrador.

## Análisis

1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?

La comparación entre el dato actual de la tabla `clientes` y los registros de `auditoria.cambios_clientes` permite detectar que hubo una modificación que no generó un nuevo evento. La bitácora del servidor también conserva evidencia de que el trigger fue desactivado.

2. ¿Qué control administrativo (no técnico) reduciría este riesgo?

Establecer que las modificaciones administrativas sean autorizadas y revisadas por otra persona. También se deben realizar revisiones periódicas y separar las responsabilidades de administración y auditoría.

3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.

La actividad demuestra que una sola persona con permisos de administrador puede modificar los datos y desactivar el mecanismo de auditoría. Por eso, las funciones deben separarse entre quien administra la base de datos y quien supervisa o protege las evidencias, evitando que una sola persona tenga control completo.

## Conclusión
Se comprobó que la auditoría protege los registros contra usuarios con permisos limitados, pero no puede garantizar por sí sola la protección frente a un administrador con control total. Por eso es importante conservar las bitácoras en un sistema externo y aplicar separación de funciones.