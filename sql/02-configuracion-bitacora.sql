-- Actividad 6: Cambios de privilegios y estructura

-- Revocar permiso de actualización
REVOKE UPDATE ON clientes FROM soporte_ana;

-- Conceder permiso de actualización
GRANT UPDATE ON clientes TO app_ventas;

-- Agregar una columna a la tabla
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

-- Crear un rol temporal para comprobar la exposición de contraseñas
CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';

-- Eliminar el rol temporal
DROP ROLE rol_temporal;

-- Consultar las sentencias registradas
SELECT num, linea
FROM dba.bitacora
WHERE linea ILIKE '%REVOKE%'
   OR linea ILIKE '%GRANT%'
   OR linea ILIKE '%ALTER TABLE%'
   OR linea ILIKE '%CREATE ROLE%'
   OR linea ILIKE '%DROP ROLE%'
ORDER BY num;