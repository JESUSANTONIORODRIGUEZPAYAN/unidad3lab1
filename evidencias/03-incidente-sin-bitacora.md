# Actividad 3. Incidente sin bitácora

## Objetivo
Simular un cambio no autorizado o reportado en el RFC de un cliente y comprobar si PostgreSQL permite identificar quién realizó la modificación.

## Procedimiento
1. Se realizó una conexión a la base de datos `comercial` utilizando el usuario `app_ventas`.
2. Se ejecutó la siguiente sentencia:

```sql
UPDATE clientes
SET rfc = 'GAMA780912XXX'
WHERE id = 3;
```

3. PostgreSQL respondió `UPDATE 1`, indicando que el registro fue modificado correctamente.
4. Se consultó la tabla `clientes` y se comprobó que el RFC de María García cambió a `GAMA780912XXX`.
5. Se buscó en la bitácora información relacionada con `UPDATE` y `app_ventas`. Se encontraron registros anteriores de un error al crear el rol, pero no evidencia del cambio del RFC.

## Análisis del incidente

1. ¿Se puede demostrar quién modificó el RFC?

No. Aunque se comprobó que el RFC cambió, la bitácora no registró la sentencia UPDATE ni la conexión del usuario que realizó el cambio.

2. ¿Se puede demostrar que soporte_ana no realizó el cambio?

No mediante la bitácora, porque no se registraron las conexiones ni las modificaciones. Sin embargo, el usuario `soporte_ana` solamente tiene permiso de consulta (SELECT), por lo que sus permisos no le permiten modificar los registros.

3. ¿Los permisos de la Unidad II evitaron el cambio? ¿Debieron hacerlo?

No lo evitaron porque `app_ventas` tiene permisos SELECT y UPDATE sobre la tabla clientes. Si la aplicación necesita modificar información, estos permisos permiten hacerlo. Se deberían limitar los permisos a las operaciones y columnas que realmente necesita cada usuario.

4. ¿Qué se debió configurar antes del incidente?

Se debieron activar los registros de conexiones y desconexiones, configurar `log_statement` para registrar las modificaciones y utilizar una auditoría que guarde quién realizó cada cambio, cuándo lo hizo y qué información modificó.

## Resultado
Se comprobó que el RFC del cliente con ID 3 fue modificado correctamente. Sin embargo, no fue posible identificar al responsable mediante la bitácora, debido a que la configuración inicial no registraba las conexiones ni las sentencias SQL.

## Conclusión
Esta actividad demuestra la importancia de configurar correctamente las bitácoras en PostgreSQL. Los permisos ayudan a limitar las acciones de cada usuario, pero también es necesario contar con registros de auditoría para investigar los cambios realizados en la base de datos.