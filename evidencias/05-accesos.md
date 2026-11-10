# Actividad 5. Accesos exitosos y fallidos

## Objetivo
Generar conexiones exitosas y fallidas a PostgreSQL para identificar cómo se registran los intentos de autenticación en la bitácora.

## Procedimiento
Se realizaron tres intentos de conexión por red a la base de datos `comercial`:

1. Usuario `app_ventas` con contraseña incorrecta.
2. Usuario `usuario_inexistente` con una contraseña cualquiera.
3. Usuario `app_ventas` con la contraseña correcta y el nombre de aplicación `app-ventas-web`.

En el tercer intento se ejecutó `SELECT count(*) FROM clientes` y se obtuvo un resultado de 5 registros.

Después se consultó la bitácora utilizando la dirección del cliente `127.0.0.1`.

## Resultados

- El primer intento falló por contraseña incorrecta.
- El segundo intento falló porque el rol `usuario_inexistente` no existe.
- El tercer intento fue exitoso y permitió consultar los registros de la tabla `clientes`.
- PostgreSQL registró las conexiones, la autenticación, la autorización y la desconexión.

## Análisis

1. La bitácora registra el usuario app_ventas en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?

No. Solamente demuestra que se intentó conectar utilizando el nombre de usuario `app_ventas` desde la dirección registrada. No demuestra que realmente haya sido la aplicación de ventas, porque el nombre de aplicación aparece como desconocido.

2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?

PostgreSQL registra un detalle que indica que el rol `usuario_inexistente` no existe. Esta información aparece en la bitácora para ayudar al administrador a investigar los errores. Al cliente se le muestra un mensaje más general de autenticación fallida para no revelar información innecesaria sobre los usuarios existentes.

3. ¿Por qué app=[unknown] en el intento fallido, pero app=app-ventas-web en la desconexión?

En los intentos fallidos no se proporcionó el nombre de la aplicación. En el intento exitoso sí se envió `application_name=app-ventas-web`. Por eso aparece el nombre de la aplicación cuando PostgreSQL registra la desconexión.

4. ¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.

Muchos intentos de autenticación fallidos en poco tiempo, desde una misma dirección IP y utilizando diferentes contraseñas o nombres de usuario, podrían indicar un ataque de fuerza bruta.

Consulta para contar los intentos fallidos por usuario:

```sql
SELECT
    substring(linea FROM 'user=([^ ]+)') AS usuario,
    COUNT(*) AS intentos_fallidos
FROM dba.bitacora
WHERE linea LIKE '%client=127.0.0.1%'
  AND linea ILIKE '%FATAL%'
GROUP BY usuario
ORDER BY intentos_fallidos DESC;
```

## Conclusión
Con esta actividad comprobé que PostgreSQL puede registrar los intentos de conexión exitosos y fallidos. La bitácora permite identificar el usuario utilizado, la dirección del cliente y los motivos de los errores de autenticación. Esta información ayuda a detectar posibles intentos de acceso no autorizado.