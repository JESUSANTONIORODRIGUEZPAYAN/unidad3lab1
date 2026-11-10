-- Actividad 10: Diseño y creación del registro de auditoría

CREATE SCHEMA auditoria;

REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;

CREATE TABLE auditoria.cambios_clientes (
    id_evento        BIGSERIAL PRIMARY KEY,
    momento          TIMESTAMPTZ NOT NULL DEFAULT now(),
    usuario_sesion   TEXT NOT NULL DEFAULT session_user,
    usuario_efectivo TEXT NOT NULL DEFAULT current_user,
    aplicacion       TEXT DEFAULT current_setting('application_name'),
    ip_cliente       INET DEFAULT inet_client_addr(),
    operacion        TEXT NOT NULL,
    id_cliente       BIGINT,
    valores_antes    JSONB,
    valores_despues  JSONB
);


SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'auditoria'
  AND table_name = 'cambios_clientes'
ORDER BY ordinal_position;