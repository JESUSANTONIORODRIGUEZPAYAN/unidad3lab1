# Actividad 15 — Límites: lecturas y volumen

## Objetivo
Identificar los límites de la auditoría al consultar información sensible y realizar modificaciones masivas en la base de datos.

## Procedimiento
1. Se consultaron el nombre, RFC y teléfono de María García utilizando el usuario `soporte_ana`.
2. Como administrador, se realizó una actualización masiva de la columna `segmento`.
3. Se consultó la bitácora del servidor para buscar la sentencia UPDATE.
4. Se contaron las operaciones registradas en la tabla de auditoría.
5. Se revisó si la lectura realizada por `soporte_ana` quedó registrada.

## Resultado
La consulta de datos sensibles se realizó correctamente, pero no quedó registrada como lectura.

La actualización masiva quedó registrada en la bitácora del servidor. La búsqueda inicial no encontró el texto completo porque la sentencia aparece dividida en varias líneas.

La tabla de auditoría mostró:

| Operación | Registros |
|---|---:|
| DELETE | 1 |
| INSERT | 1 |
| UPDATE | 7 |

La cantidad de registros UPDATE aumentó porque el trigger registra una fila por cada cliente modificado.

## Análisis

**1. Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?**

Se generarían aproximadamente un millón de registros nuevos en la tabla de auditoría, uno por cada fila modificada. Esto aumentaría considerablemente el espacio de almacenamiento y podría afectar el rendimiento de la base de datos.

**2. Propón quién podría autorizar la depuración de auditoria.cambios_clientes.**

La depuración debería ser autorizada por el responsable de seguridad de la información junto con el responsable de protección de datos o el área de cumplimiento. El administrador de la base de datos podría ejecutar la depuración una vez autorizada.

**3. ¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?**

Porque registra todas las consultas realizadas, incluyendo aquellas que contienen información personal como RFC, teléfonos y otros datos privados. Por eso, la bitácora también necesita controles de acceso, protección y políticas de retención.

## Conclusión
La actividad permitió identificar que la auditoría mediante triggers registra modificaciones, pero no las consultas SELECT. También se comprobó que las modificaciones masivas pueden generar muchos registros y aumentar el tamaño de la auditoría. Es importante controlar el acceso, el almacenamiento y la conservación de estos registros.