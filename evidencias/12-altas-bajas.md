# Actividad 13 — Altas y bajas

## Objetivo
Comprobar que el sistema de auditoría registre las operaciones de inserción y eliminación de clientes, conservando evidencia de los datos.

## Procedimiento
1. Se insertó el cliente Pedro Ruiz en la tabla `clientes`.
2. Se eliminó el registro de Pedro Ruiz.
3. Se consultó la tabla `auditoria.cambios_clientes`.
4. Se verificó que las operaciones INSERT y DELETE quedaron registradas.

## Resultado
La bitácora registró correctamente las operaciones realizadas:

- Evento 3: INSERT de Pedro Ruiz.
- Evento 4: DELETE de Pedro Ruiz.

Aunque el cliente fue eliminado de la tabla original, sus datos permanecen guardados en la auditoría.

## Análisis

1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?

La evidencia queda en la tabla `auditoria.cambios_clientes`, específicamente en la columna `valores_despues` del evento INSERT y en `valores_antes` del evento DELETE. Allí se conserva la información del cliente.

2. ¿Por qué ip_cliente está vacía en los eventos 2 y 3 del ejemplo?

Porque las operaciones se realizaron mediante una conexión local que puede utilizar un socket y no una conexión TCP/IP. En nuestro caso, pgAdmin utilizó `::1`, que es la dirección de loopback IPv6.

3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?

El conflicto es que la política de retención busca eliminar los datos personales cuando ya no sean necesarios, pero la auditoría conserva información para investigar cambios y eliminaciones. Este conflicto debe resolverlo el responsable de la base de datos junto con el área de seguridad y el responsable de protección de datos, estableciendo cuánto tiempo se conserva la auditoría y quién puede consultarla.
