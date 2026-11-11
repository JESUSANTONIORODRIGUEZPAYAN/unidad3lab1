# Laboratorio de auditoría y bitácora en PostgreSQL

## Descripción
En esta práctica se configuró PostgreSQL 17 para registrar conexiones, desconexiones, errores y operaciones realizadas en la base de datos `comercial`.

También se implementó un mecanismo de auditoría mediante una tabla, una función y un trigger para guardar los cambios realizados en los registros de clientes.

## Objetivo
Identificar quién realiza cambios en la base de datos, cuándo los realiza y qué valores tenían los datos antes y después de una modificación.

## Estructura del proyecto

- `sql/`: contiene los scripts SQL utilizados durante la práctica.
- `evidencias/`: contiene los archivos de evidencia, la bitácora exportada, su hash y la cronología de eventos.
- `informe.md`: contiene el desarrollo de la práctica, los resultados y las conclusiones.

## Herramientas utilizadas
- PostgreSQL 17.
- pgAdmin 4.
- PowerShell.
- SQL.

## Resultados
Se configuró el registro del servidor, se creó una auditoría de cambios sobre la tabla `clientes` y se analizaron diferentes eventos, incluyendo accesos fallidos, modificaciones de datos y errores de permisos.

También se exportó la bitácora y se calculó su hash SHA-256 para comprobar su integridad.

## Autor
Jesús Rodríguez

## Institución
Universidad Autónoma de Sinaloa
Facultad de Informática Culiacán