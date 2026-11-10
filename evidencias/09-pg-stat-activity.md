# Actividad 9. Sesiones activas con pg_stat_activity

## Objetivo

Observar las sesiones activas de PostgreSQL mediante `pg_stat_activity` y relacionarlas con los registros de la bitácora.

## Procedimiento

1. Se abrió una segunda terminal de PowerShell y se ejecutó una consulta de larga duración utilizando el usuario `soporte_ana`.
2. Se utilizó `SELECT pg_sleep(90)` para mantener la sesión activa durante 90 segundos.
3. Desde pgAdmin, conectado como administrador, se consultó la vista `pg_stat_activity`.
4. Se identificó la sesión del usuario `soporte_ana`, con la aplicación `reporte-mensual`.
5. Se obtuvo el PID `25004` y se buscó en la bitácora mediante ese identificador.
6. Después de terminar la consulta, se volvió a consultar `pg_stat_activity` y se comprobó que el PID ya no aparecía.

## Resultado

La sesión encontrada tuvo los siguientes datos:

| Campo       | Resultado |
|---          |---        |
| PID         | 25004     |
| Usuario     | soporte_ana |
| Aplicación  | reporte-mensual |
| Dirección del cliente | 127.0.0.1 |
| Estado      | active |
| Consulta    | SELECT pg_sleep(90) |

En la bitácora se encontraron los registros de conexión, autenticación y autorización correspondientes al PID `25004`.

Después de terminar los 90 segundos, el PID dejó de aparecer en `pg_stat_activity`, pero los registros de conexión permanecieron en la bitácora.

## Análisis

1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

La columna `pid` de `pg_stat_activity`, porque ese mismo identificador aparece entre corchetes en las líneas de la bitácora.

2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

La bitácora de PostgreSQL conserva los registros de conexión y desconexión, aunque la sesión ya no aparezca en `pg_stat_activity`.

3. ¿Por qué client_addr aparece vacío en la sesión del administrador?

Porque la sesión del administrador puede ser una conexión local mediante un socket, en lugar de una conexión TCP/IP. Por eso PostgreSQL no muestra una dirección IP para esa sesión.

## Conclusión

Con esta actividad comprobé que `pg_stat_activity` permite observar las sesiones que están conectadas actualmente a PostgreSQL. También aprendí que el PID permite relacionar una sesión con sus registros en la bitácora y que estos registros pueden conservar evidencia incluso después de que la sesión termina.