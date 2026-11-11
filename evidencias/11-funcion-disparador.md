
1. ¿Por qué se revocan los permisos PUBLIC si el trigger sigue funcionando?

Porque queremos evitar que cualquier usuario pueda ejecutar directamente la función. El trigger puede utilizarla cuando ocurre una operación en la tabla, aunque el usuario que realiza el cambio no tenga permiso para ejecutarla directamente.

2. ¿Qué pasaría si la función no tuviera SECURITY DEFINER?

La función se ejecutaría con los permisos del usuario que realiza la operación. Si ese usuario no tiene permiso para insertar registros en la tabla de auditoría, el trigger podría fallar y también impedir la modificación del cliente.

3. ¿Se registró la creación del esquema, tabla, función y trigger? ¿Por qué?

Sí. En la bitácora aparecen las instrucciones de creación del esquema, la tabla, la función y el trigger. Esto permite identificar las operaciones realizadas sobre la estructura de la base de datos.