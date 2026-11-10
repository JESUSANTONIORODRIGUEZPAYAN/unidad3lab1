# Actividad 10. Diseño y creación del registro de auditoría

## Objetivo

Diseñar y crear una tabla de auditoría para guardar información sobre los cambios realizados en los registros de clientes, incluyendo el usuario, la fecha, la aplicación y los valores anteriores y posteriores.

## Procedimiento

1. Se creó el esquema `auditoria`.
2. Se revocaron los permisos públicos sobre el esquema.
3. Se creó la tabla `auditoria.cambios_clientes` con los 10 campos solicitados.
4. Se consultó `information_schema.columns` para comprobar que todos los campos se crearon correctamente.

## Diseño de los campos

| Campo | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
|---|---|---|---|
| id_evento | BIGSERIAL | ¿Qué evento de auditoría es? | No, porque identifica cada evento. |
| momento | TIMESTAMPTZ | ¿Cuándo ocurrió el cambio? | No, porque todo evento debe tener fecha y hora. |
| usuario_sesion | TEXT | ¿Qué usuario inició la sesión? | No, porque permite identificar quién se conectó. |
| usuario_efectivo | TEXT | ¿Qué usuario ejecutó realmente la operación? | No, porque permite identificar al usuario efectivo. |
| aplicacion | TEXT | ¿Desde qué aplicación se realizó? | Sí, porque puede no proporcionarse un nombre de aplicación. |
| ip_cliente | INET | ¿Desde qué dirección se conectó? | Sí, porque algunas conexiones locales no tienen dirección IP. |
| operacion | TEXT | ¿Qué tipo de operación se realizó? | No, porque debe indicar la acción auditada. |
| id_cliente | BIGINT | ¿Qué cliente fue afectado? | Sí, porque no todas las operaciones necesariamente corresponden a un cliente específico. |
| valores_antes | JSONB | ¿Cómo estaban los datos antes del cambio? | Sí, porque en una operación INSERT no existe un estado anterior. |
| valores_despues | JSONB | ¿Cómo quedaron los datos después del cambio? | Sí, porque en una operación DELETE no existe un estado posterior. |

## Resultado

La tabla `auditoria.cambios_clientes` se creó correctamente. La consulta a `information_schema.columns` mostró los 10 campos con sus tipos de datos y restricciones de nulidad correspondientes.

## Análisis

1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?

Porque `TIMESTAMPTZ` permite manejar fechas y horas considerando las zonas horarias. Esto ayuda a identificar correctamente cuándo ocurrió un evento aunque se consulte desde otra zona horaria.

2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?

Porque permite conservar todos los datos del cliente antes y después de la modificación. También facilita consultar la información aunque en el futuro se agreguen o cambien columnas en la tabla original.

3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

Significa que la tabla contiene información sensible de los clientes y debe clasificarse como información confidencial. Su acceso debe limitarse únicamente a usuarios autorizados, evitando que cualquier persona pueda consultar o modificar esos datos.

## Conclusión

Con esta actividad creé una estructura separada para almacenar los eventos de auditoría. También comprobé que los campos permiten registrar información sobre el usuario, la aplicación, la dirección IP y los valores anteriores y posteriores de los clientes.