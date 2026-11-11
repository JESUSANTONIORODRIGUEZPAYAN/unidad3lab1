
-- Consultar el RFC anterior y el nuevo
SELECT
    valores_antes ->> 'rfc' AS rfc_anterior,
    valores_despues ->> 'rfc' AS rfc_nuevo
FROM auditoria.cambios_clientes
WHERE id_evento = 1;

-- Identificar los campos que cambiaron
SELECT
    a.id_evento,
    a.momento,
    a.usuario_sesion,
    a.ip_cliente,
    d.key AS campo,
    a.valores_antes ->> d.key AS antes,
    d.value #>> '{}' AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE'
  AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id_evento;

-- Restaurar el RFC anterior
UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;


