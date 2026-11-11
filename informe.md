# Informe final — Laboratorio de auditoría y bitácora en PostgreSQL

## 1. Despliegue y situación inicial

Para realizar la práctica utilicé PostgreSQL 17 instalado en Windows y la herramienta pgAdmin 4 para administrar el servidor y ejecutar las consultas SQL.

Trabajé con la base de datos `comercial`, donde se encuentra la tabla `clientes`. Primero revisé la configuración de registro del servidor y comprobé que PostgreSQL tenía habilitado el recolector de registros (`logging_collector`), pero la información que se guardaba inicialmente no era suficiente para responder todas las preguntas de Dirección.

La configuración inicial utilizaba un prefijo de registro sencillo (`%t`) y no tenía habilitado el registro de conexiones y desconexiones. Además, el registro de sentencias DDL no permitía conocer todos los cambios realizados sobre los datos.

Por este motivo, era necesario mejorar la configuración para identificar a los usuarios, las aplicaciones, las direcciones de conexión y las operaciones realizadas.

## 2. Configuración aplicada

Para mejorar el registro del servidor modifiqué los siguientes parámetros:

| Parámetro | Valor aplicado | Función |
|---|---|---|
| `logging_collector` | `on` | Permite recopilar los registros del servidor en archivos. |
| `log_connections` | `on` | Registra los intentos y las conexiones al servidor. |
| `log_disconnections` | `on` | Registra las desconexiones de los usuarios. |
| `log_destination` | `stderr` | Envía los mensajes de registro al flujo de errores estándar. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h` | Agrega fecha, proceso, usuario, base de datos, aplicación y dirección del cliente. |
| `log_timezone` | `GMT` | Establece la zona horaria utilizada en los registros. |
| `log_statement` | `mod` | Registra las sentencias que modifican datos, como INSERT, UPDATE y DELETE. |

Para aplicar los cambios utilicé instrucciones `ALTER SYSTEM` y después una recarga de la configuración con `pg_reload_conf()`.

La recarga permitió aplicar los parámetros modificables sin tener que reiniciar el servidor. El recolector de registros ya estaba habilitado, por lo que no fue necesario modificarlo para iniciar su funcionamiento.

Esta configuración permitió obtener más información sobre las conexiones, los errores y las operaciones realizadas en la base de datos.

## 3. Eventos observados

Durante las pruebas pude observar diferentes tipos de eventos en la bitácora:

- Accesos: se registraron intentos de autenticación. Por ejemplo, el usuario `app_ventas` tuvo un intento fallido desde `127.0.0.1`.
- Desconexiones: PostgreSQL registró cuándo terminaron algunas sesiones y su duración.
- Privilegios:se registró la revocación del permiso UPDATE a `soporte_ana` y la concesión de ese permiso a `app_ventas`.
- Estructura: se registró la creación de la columna `segmento` en la tabla `clientes`.
- Modificaciones de datos: se registraron sentencias UPDATE, incluyendo el cambio del RFC del cliente 3.
- Errores: se registraron operaciones rechazadas por falta de permisos, así como intentos de autenticación fallidos.

Un ejemplo importante fue el intento de `soporte_ana` de realizar una operación sin tener los permisos necesarios. PostgreSQL registró el error de permiso denegado, lo que permitió identificar qué usuario intentó realizar la operación.

## 4. Auditoría del dato

Además de la bitácora del servidor, implementé una auditoría mediante una tabla llamada `auditoria.cambios_clientes`.

Esta tabla almacena información de las operaciones realizadas sobre la tabla `clientes`, incluyendo:

- Identificador del evento.
- Fecha y hora.
- Usuario de sesión.
- Usuario efectivo.
- Aplicación que realizó la operación.
- Dirección IP del cliente.
- Tipo de operación.
- Identificador del cliente afectado.
- Valores anteriores.
- Valores posteriores.

Para registrar los cambios creé la función `auditoria.registrar_cambio_cliente()` y el trigger `trg_auditoria_clientes`, que se ejecuta después de operaciones INSERT, UPDATE y DELETE.

La función utiliza `SECURITY DEFINER`, por lo que se ejecuta con los permisos de su propietario. Esto permite que el trigger pueda guardar los eventos en el esquema de auditoría aunque el usuario de la aplicación no tenga permisos directos para modificar esa tabla.

También fue importante utilizar `session_user`, porque permite identificar al usuario que inició la sesión. En una prueba, cuando `app_ventas` realizó un cambio, la auditoría mostró `session_user = app_ventas` y `current_user = postgres`, debido a que la función se ejecutaba con los permisos de su propietario.

Resultado del incidente auditado:

En la actividad 12 se registró un cambio del RFC del cliente 3. El valor anterior era `GAMA780912XYZ` y el nuevo valor fue `GAMA780912ZZZ`. La tabla de auditoría identificó a `app_ventas` como usuario de sesión.

Después se registró otro cambio realizado por `postgres`, donde el RFC volvió de `GAMA780912ZZZ` a `GAMA780912XYZ`.

También se comprobó una limitación importante: cuando el trigger fue deshabilitado, se realizó una modificación del RFC que no generó su correspondiente evento de auditoría. Esto demuestra que la tabla de auditoría depende de que el trigger permanezca activo.

## 5. Limitaciones

Aunque la configuración permitió obtener más información, también encontré algunas limitaciones:

1. Las lecturas SELECT no quedan registradas con la configuración `log_statement = 'mod'`. Por eso no es posible conocer todas las consultas de lectura realizadas por los usuarios.
2. Cuando se realizan muchas modificaciones, el volumen de registros puede crecer rápidamente y ocupar espacio en el servidor.
3. Un administrador con privilegios suficientes puede modificar la configuración, deshabilitar triggers o alterar los mecanismos de auditoría.
4. Si el trigger está deshabilitado, los cambios realizados durante ese periodo pueden no aparecer en la tabla de auditoría.
5. No todas las sentencias que aparecen en la bitácora demuestran por sí solas que una operación terminó correctamente. Es necesario comparar los registros con otras evidencias.

Por estas razones, considero importante mantener controles de acceso, respaldos y revisiones periódicas de los registros.

## 6. Riesgos de la bitácora

Durante la práctica observé que los registros pueden contener información sensible. Por ejemplo, una sentencia de creación o modificación de usuarios puede incluir una contraseña escrita en el comando.

Esto representa un riesgo porque una persona que tenga acceso a los archivos de registro podría consultar información que no debería conocer.

Para reducir este riesgo, durante la exportación de la bitácora sustituí la contraseña temporal `Temporal_Practica_2026` por `<REDACTED>`.

También exporté el archivo como `evidencias/bitacora-lab01.log` y calculé su hash SHA-256, guardándolo en `evidencias/bitacora-lab01.sha256`.

El hash no evita que alguien modifique el archivo, pero permite detectar cambios cuando se compara con el valor original que se conserva de manera segura.

Otros riesgos son la pérdida de los registros por fallas del servidor, la eliminación accidental, el acceso de personas no autorizadas y la posibilidad de que un administrador o atacante con suficientes privilegios modifique o elimine las evidencias.

Por eso considero conveniente conservar una copia de los registros en una ubicación separada y protegida.

## 7. Cronología y conclusión

Con la información de la bitácora y la tabla `auditoria.cambios_clientes` reconstruí una cronología de eventos que incluye intentos de acceso fallidos, cambios de privilegios, modificaciones de estructura, operaciones sobre clientes y errores de permisos.

También identifiqué que hubo intentos fallidos de autenticación para los usuarios `app_ventas` y `usuario_inexistente`, ambos desde `127.0.0.1`.

**¿Con esta configuración puede demostrarse quién cambió un dato sensible y qué valor tenía antes?**

Considero que sí, siempre que los mecanismos de auditoría estén activos y que el cambio haya quedado registrado correctamente. La tabla de auditoría permite identificar al usuario de sesión, el cliente afectado y los valores anteriores y posteriores. La bitácora complementa esta información con detalles de la conexión, la aplicación y los errores.

Sin embargo, no se puede garantizar que todos los cambios queden registrados. En esta práctica se comprobó que al deshabilitar el trigger fue posible realizar una modificación sin que apareciera como un evento normal en la tabla de auditoría.

Por lo tanto, la combinación de bitácora y auditoría permite investigar mejor los cambios realizados, pero es necesario proteger los registros, controlar los privilegios de administración y verificar que los mecanismos de auditoría permanezcan activos.

En conclusión, esta práctica me permitió comprender que no basta con guardar los cambios de una base de datos. También es importante registrar quién los realiza, cuándo ocurren, desde dónde se conectan y qué valores tenían los datos antes de modificarse.



## 8. Preguntas de reflexión

1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque la auditoría debe estar funcionando antes de que ocurra el incidente. Si se configura después, no puede recuperar los cambios que no se registraron anteriormente. En la práctica vimos que cuando el trigger estaba deshabilitado, el cambio realizado no quedó registrado en la tabla de auditoría.

2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Porque el servidor es quien conoce directamente las conexiones, errores y operaciones que ocurren en la base de datos. Si la bitácora depende únicamente del mecanismo de despliegue, algunas actividades realizadas directamente desde pgAdmin u otras aplicaciones podrían no quedar registradas.

3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?

Porque `log_statement` permite decidir qué sentencias se registran, mientras que el prefijo agrega información para identificar quién las ejecutó, cuándo ocurrió y desde qué aplicación o dirección IP. Si no tenemos un buen prefijo, podemos encontrar una sentencia, pero no tener suficiente información para relacionarla con un usuario o una conexión.

**4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?**

Registrar la sentencia permite conocer qué comando SQL se ejecutó, por ejemplo, un UPDATE. En cambio, registrar el cambio en el dato permite conocer qué información tenía el registro antes y qué información tiene después. En mi práctica, la bitácora mostró la sentencia que modificó el RFC y la tabla de auditoría permitió identificar el valor anterior y el nuevo.

5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?

`pg_stat_activity` permite consultar las sesiones que están activas en ese momento, sus usuarios, aplicaciones, direcciones IP y consultas en ejecución. La bitácora, por otro lado, conserva registros de eventos que ya ocurrieron, como conexiones, desconexiones, errores y sentencias registradas. Por eso ambas herramientas se complementan.

6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?

El administrador no debería ser la única persona encargada de controlar su propia auditoría. Lo recomendable es enviar los registros a un servidor externo protegido, donde el administrador de la base de datos no pueda modificarlos ni eliminarlos. También se pueden utilizar controles de acceso, respaldos y revisiones independientes para detectar cambios en la configuración o en los mecanismos de auditoría.