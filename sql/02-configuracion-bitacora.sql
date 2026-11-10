-- Actividad 4: Configuración de la bitácora

ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;

ALTER SYSTEM SET log_line_prefix =
'%m [%p] user=%u db=%d app=%a client=%h ';

ALTER SYSTEM SET log_statement = 'ddl';

SELECT pg_reload_conf();

-- Verificar la configuración
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN (
    'log_connections',
    'log_line_prefix',
    'log_statement'
);

-- Consultar las últimas líneas de la bitácora
SELECT num, linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 6;

-- Buscar mensajes de cambio de parámetros
SELECT num, linea
FROM dba.bitacora
WHERE linea ILIKE '%parameter%'
ORDER BY num DESC;

-- Consultar conexiones registradas
SELECT num, linea
FROM dba.bitacora
WHERE linea ILIKE '%conexión%'
ORDER BY num DESC
LIMIT 10;