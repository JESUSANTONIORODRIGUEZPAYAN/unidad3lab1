# Actividad 7. Modificaciones de datos: DDL frente a MOD

## Objetivo

Comparar las configuraciones `ddl` y `mod` de PostgreSQL para observar cómo se registran las modificaciones realizadas en la base de datos.

## Procedimiento

1. Con la configuración `log_statement = 'ddl'`, se modificó el RFC del cliente con ID 3 utilizando el usuario `app_ventas`.
2. Se consultó la bitácora y se comprobó que aparecieron los registros de conexión y desconexión, pero no la sentencia `UPDATE`.
3. Se cambió la configuración a `log_statement = 'mod'` mediante `ALTER SYSTEM` y se recargó la configuración.
4. Se volvió a modificar el teléfono del cliente con ID 3 desde PowerShell utilizando el usuario `app_ventas`.
5. Se consultó nuevamente la bitácora para comprobar el registro de la modificación.

## Resultado

La modificación del teléfono se realizó correctamente y PostgreSQL mostró:

```text
UPDATE 1
Maria Garcia | GAMA780912XYZ
```

En la bitácora apareció el siguiente registro:

```text
sentencia: UPDATE clientes SET telefono = '6679990000' WHERE id = 3
```

Con `ddl` no apareció la sentencia de modificación de datos. Al utilizar `mod`, PostgreSQL sí registró el `UPDATE`.

## Análisis

1. ¿Qué nivel de logging sería necesario para registrar una lectura de RFC? ¿Qué costo tendría?

Se necesitaría utilizar `log_statement = 'all'`, porque esta configuración registra todas las sentencias SQL, incluyendo las consultas `SELECT`. El costo sería generar muchos registros, ocupar más espacio en disco y agregar carga al servidor. También podría registrar información sensible, por lo que se debe proteger la bitácora.

2. ¿Qué información faltaría para revertir con certeza una modificación?

Faltaría conocer el valor anterior del registro, porque la bitácora muestra la sentencia ejecutada, pero no necesariamente guarda los datos que tenía la fila antes del cambio. Para tener esa información se podría utilizar una auditoría con triggers que guarde los valores anteriores y nuevos.

## Conclusión

Con esta actividad comprobé que la configuración `ddl` registra cambios en la estructura de la base de datos, mientras que `mod` también registra modificaciones de datos como `UPDATE`, `INSERT` y `DELETE`. Esto permite tener un mejor seguimiento de las operaciones realizadas en PostgreSQL.