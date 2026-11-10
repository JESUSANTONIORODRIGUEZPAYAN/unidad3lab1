--Paso 1. Ejecutar la configuración

ALTER SYSTEM SET logging_collector = on;

SELECT name, setting, pending_restart
FROM pg_settings
WHERE name = 'logging_collector';

--Paso 2. Comprobar el colector y obtener el archivo\

SELECT name, setting, source
FROM pg_settings
WHERE name = 'logging_collector';

SELECT pg_current_logfile();

--Paso 3. Leer la bitácora

SELECT linea
FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n') AS linea;

--Paso 4. Crear el esquema y la vista
CREATE SCHEMA dba;

REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(
    pg_read_file(pg_current_logfile()),
    E'\n'
)
WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';

--Paso 5. Probar la vista

SELECT num, linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 10;



SELECT name, setting, source
FROM pg_settings
WHERE name = 'logging_collector';


SELECT pg_current_logfile();


SHOW server_encoding;

SHOW client_encoding;

SELECT pg_read_binary_file(pg_current_logfile()) IS NOT NULL
AS archivo_disponible;

SELECT convert_from(
    pg_read_binary_file(pg_current_logfile()),
    'LATIN1'
) IS NOT NULL AS lectura_correcta;


SELECT linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'LATIN1'
    ),
    E'\n'
) AS linea;

CREATE SCHEMA dba;

REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'LATIN1'
    ),
    E'\n'
)
WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';
-- vista de bitacora 
SELECT table_schema, table_name
FROM information_schema.views
WHERE table_schema = 'dba';

CREATE OR REPLACE VIEW dba.bitacora AS
SELECT t.n AS num, t.linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'LATIN1'
    ),
    E'\n'
)
WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';

-------------------------------------------------------------------
DROP VIEW dba.bitacora;

CREATE VIEW dba.bitacora AS
SELECT
    t.n AS num,
    t.linea COLLATE "default" AS linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'LATIN1'
    ),
    E'\n'
)
WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';


SELECT num, linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 10;

SELECT linea
FROM dba.bitacora
WHERE linea ILIKE '%update%';


SELECT linea
FROM dba.bitacora
WHERE linea ~ '(FATAL|ERROR)';