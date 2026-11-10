# Actividad 8. Errores y operaciones rechazadas

## Objetivo

Identificar cómo PostgreSQL registra las operaciones rechazadas por falta de permisos o por dependencias existentes en la base de datos.

## Procedimiento

1. Se intentó eliminar el registro con ID 5 utilizando el usuario `soporte_ana` desde PowerShell.
2. PostgreSQL rechazó la operación porque el usuario no tiene permisos para ejecutar `DELETE` sobre la tabla `clientes`.
3. Después, desde pgAdmin y utilizando el administrador `postgres`, se intentó eliminar el rol `soporte_ana`.
4. PostgreSQL rechazó la eliminación porque el rol todavía tiene privilegios asignados sobre la tabla `clientes`.
5. Finalmente, se consultó la vista `dba.bitacora` para localizar los errores y sus detalles.

## Resultado

En la bitácora se encontraron los siguientes registros:

- Línea 70: error de permiso denegado para `soporte_ana` al intentar eliminar un registro.
- Línea 74: error al intentar eliminar el rol `soporte_ana`.
- Línea 75: detalle que indica que existen privilegios para la tabla `clientes`.

Las dos operaciones fueron rechazadas y no se realizaron los cambios solicitados.

## Análisis

1. ¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos?

No causó ningún daño porque PostgreSQL rechazó la operación al no tener los permisos necesarios. De todos modos, debe auditarse porque permite identificar intentos de operaciones no autorizadas y detectar posibles acciones sospechosas.

2. ¿Qué diferencia hay entre un error de autorización y uno de autenticación?

Un error de autenticación ocurre cuando un usuario no puede demostrar su identidad, por ejemplo, cuando escribe una contraseña incorrecta. Un error de autorización ocurre cuando el usuario logra entrar a la base de datos, pero intenta realizar una operación para la que no tiene permisos.

3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?

Indica que primero se deben revisar y retirar los privilegios y dependencias que tiene el usuario sobre los objetos de la base de datos. Después de quitar esas dependencias, se puede eliminar el rol.

## Conclusión

Con esta actividad comprobé que PostgreSQL registra los errores cuando un usuario intenta realizar operaciones sin autorización o cuando existen dependencias que impiden eliminar un rol. La bitácora permite revisar estos intentos y ayuda a mantener la seguridad de la base de datos.