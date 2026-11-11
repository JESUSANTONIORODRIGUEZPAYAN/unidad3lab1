# Actividad 17. Reconstrucción de la cronología

## 1. Cronología de eventos


| # | Fecha y hora (GMT) | Usuario | Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente |
|---|---|---|---|---|---|---|---|
| 1 | 2026-11-10 03:53:43 | app_ventas | No aplica | Acceso | Falló la autenticación del usuario desde 127.0.0.1. | No | Bitácora 03:53:43 |
| 2 | 2026-11-10 03:53:48 | usuario_inexistente | No aplica | Acceso | Se intentó ingresar con un usuario inexistente desde 127.0.0.1. | No | Bitácora 03:53:48 |
| 3 | 2026-11-10 03:59:41 | postgres | No aplica | Privilegio | Se revocó el permiso UPDATE a soporte_ana sobre clientes. | Sí, sin error registrado | Bitácora 03:59:41 |
| 4 | 2026-11-10 03:59:43 | postgres | No aplica | Privilegio | Se concedió el permiso UPDATE a app_ventas sobre clientes. | Sí, sin error registrado | Bitácora 03:59:43 |
| 5 | 2026-11-10 03:59:45 | postgres | No aplica | Estructura | Se agregó la columna segmento a la tabla clientes. | Sí, sin error registrado | Bitácora 03:59:45 |
| 6 | 2026-11-10 04:07:32 | app_ventas | 3 | Datos | Se ejecutó una sentencia para establecer el teléfono en 6679990000. | Sentencia registrada; resultado no confirmado | Bitácora 04:07:32 |
| 7 | 2026-11-11 02:33:30 | app_ventas | 3 | Datos | Se cambió el RFC de GAMA780912XYZ a GAMA780912ZZZ. | Sí | id_evento 1 |
| 8 | 2026-11-11 02:36:20 | postgres | 3 | Datos | Se cambió el RFC de GAMA780912ZZZ a GAMA780912XYZ. | Sí | id_evento 2 |
| 9 | 2026-11-11 02:42:54 | postgres | 6 | Datos | Se insertó el cliente Pedro Ruiz. | Sí | id_evento 3 |
| 10 | 2026-11-11 02:43:01 | postgres | 6 | Datos | Se eliminó el cliente Pedro Ruiz. | Sí | id_evento 4 |
| 11 | 2026-11-11 02:47:03 | app_ventas | No aplica | Error | Intentó deshabilitar el trigger, pero recibió un error de permisos. | No | Bitácora 02:47:03 |
| 12 | 2026-11-11 02:47:37 | postgres | No aplica | Configuración | Se registró la deshabilitación del trigger de auditoría. | Sí, sin error registrado | Bitácora 02:47:37 |
| 13 | 2026-11-11 02:52:42 | postgres | 1, 2, 3, 4 y 5 | Datos | Se actualizaron los registros de los clientes; la tabla de auditoría registró cinco actualizaciones. | Sí | id_evento 5 al 9 |

## 2. Respuestas a las preguntas de Dirección

### 1. ¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?

- Actividad 3: No hay evidencia suficiente en los registros consultados para identificar con seguridad quién realizó el cambio.
- Actividad 7: No hay evidencia suficiente de un cambio de RFC. La bitácora sí muestra una sentencia de actualización del teléfono ejecutada por app_ventas, pero no demuestra un cambio de RFC.
- Actividad 12: El usuario app_ventas cambió el RFC del cliente 3. La tabla de auditoría lo confirma en el evento 1.
- Actividad 14: La evidencia disponible apunta al usuario postgres, que deshabilitó el trigger y posteriormente ejecutó una actualización. El cambio de RFC no quedó registrado como evento propio porque el trigger estaba deshabilitado.

### 2. ¿Quién cambió el teléfono?

La bitácora muestra que app_ventas ejecutó una sentencia para establecer el teléfono del cliente 3 en 6679990000 el 10 de noviembre a las 04:07:32 GMT.

Sin embargo, no hay evidencia suficiente para confirmar que el valor realmente cambió, porque en los registros de auditoría disponibles el teléfono anterior y el posterior aparecen iguales: 6679990000.

### 3. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?

Sí. La bitácora muestra dos intentos de autenticación fallidos:

- app_ventas, el 10 de noviembre a las 03:53:43 GMT, desde 127.0.0.1.
- usuario_inexistente, el 10 de noviembre a las 03:53:48 GMT, desde 127.0.0.1.

También aparecen errores de permisos de soporte_ana y app_ventas, pero estos corresponden a operaciones rechazadas después de intentar acceder a la base de datos, no a fallos de autenticación.

### 4. ¿Qué valor tenía el RFC antes de cada cambio?

- Actividad 3: No hay evidencia suficiente para determinar el valor anterior.
- Actividad 7: No hay evidencia de un cambio de RFC que permita identificar el valor anterior.
- Actividad 12: El valor anterior era GAMA780912XYZ y el nuevo fue GAMA780912ZZZ.
- Actividad 14: No hay evidencia directa del valor inmediatamente anterior al cambio realizado con el trigger deshabilitado. El valor GAMA780912GHI ya aparece en el evento 9 como valor anterior y posterior de una actualización posterior.

## 3. Huecos y limitaciones de la evidencia

No todos los cambios quedaron registrados en la tabla de auditoría. Cuando el trigger estaba deshabilitado, una modificación podía realizarse sin generar un evento en `auditoria.cambios_clientes`.

También existen sentencias registradas en la bitácora cuyo resultado no se puede confirmar únicamente con la línea que muestra su ejecución. Por eso no se asignaron horas ni usuarios a eventos que no tienen evidencia suficiente.

## 4. Conclusión

Al comparar la bitácora con la tabla de auditoría fue posible reconstruir varios accesos, cambios de privilegios, modificaciones de estructura y operaciones sobre clientes.

Se identificaron intentos de autenticación fallidos, cambios de RFC realizados por app_ventas y postgres, y una modificación que no quedó registrada directamente porque el trigger de auditoría estaba deshabilitado.

La práctica demuestra que es importante conservar tanto la bitácora del servidor como la tabla de auditoría, ya que juntas permiten investigar mejor lo ocurrido, aunque también existen huecos cuando los mecanismos de registro no están activos.