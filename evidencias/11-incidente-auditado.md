# Actividad 12 — El incidente auditado

## Objetivo
Comprobar que los cambios realizados por la aplicación queden registrados en la tabla de auditoría y que los usuarios sin autorización no puedan consultar esos registros.

## Procedimiento
1. Se utilizó el usuario `app_ventas` para modificar el RFC de María García.
2. La actualización se realizó correctamente y PostgreSQL respondió `UPDATE 1`.
3. Se intentó consultar la tabla de auditoría con `app_ventas`, pero el acceso fue rechazado por falta de permisos sobre el esquema `auditoria`.
4. Se consultó la auditoría como administrador.
5. Se identificó que el campo modificado fue `rfc`.
6. Se compararon los valores anteriores y posteriores.
7. Se restauró el RFC original.

## Resultado

| Dato | Resultado |
|---|---|
| Usuario de sesión | app_ventas |
| Usuario efectivo | postgres |
| Aplicación | app-ventas-web |
| Dirección IP | 127.0.0.1 |
| Operación | UPDATE |
| Campo modificado | rfc |
| Valor anterior | GAMA780912XYZ |
| Valor nuevo | GAMA780912ZZZ |

La modificación quedó registrada automáticamente en la tabla `auditoria.cambios_clientes`.

## Análisis

1. Compara tu hipótesis de la Actividad 11 con este resultado.

Se comprobó que la función con `SECURITY DEFINER` permite que el trigger registre los cambios utilizando los permisos de su propietario. El usuario original se conserva en `usuario_sesion`, mientras que `usuario_efectivo` muestra a postgres.

2. ¿Qué sentencia UPDATE restauraría el valor anterior?

```sql
UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;
```

3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?

La dirección IP (`ip_cliente`) puede aportar información sobre el origen de la conexión. La columna `aplicacion` identifica el nombre de la aplicación, pero el propio cliente puede establecerlo y modificarlo con facilidad. Por eso, `application_name` no es una prueba fuerte de identidad.

## Conclusión

La actividad permitió comprobar que los cambios realizados por la aplicación quedan registrados con información del usuario, la aplicación, la dirección IP y los valores anteriores y posteriores. También se comprobó que los permisos protegen la información de auditoría contra consultas no autorizadas.