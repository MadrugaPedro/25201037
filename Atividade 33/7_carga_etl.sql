USE aeroporto_dw;

SET @inicio = (SELECT CAST(DATE_FORMAT(MIN(data_partida), '%Y-%m-%d %H:00:00') AS DATETIME) FROM aeroporto_lab.voo);
SET @fim = (SELECT CAST(DATE_FORMAT(MAX(data_partida), '%Y-%m-%d %H:00:00') AS DATETIME) FROM aeroporto_lab.voo);

INSERT IGNORE INTO dim_tempo (data_hora, data, ano, mes, ano_mes, dia, dia_semana, hora)
SELECT h,
       DATE(h),
       YEAR(h),
       MONTH(h),
       DATE_FORMAT(h, '%Y-%m'),
       DAY(h),
       ELT(WEEKDAY(h) + 1, 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'),
       HOUR(h)
FROM (
    SELECT @inicio + INTERVAL n HOUR AS h
    FROM (
        SELECT u1.d + 10 * u2.d + 100 * u3.d + 1000 * u4.d + 10000 * u5.d AS n
        FROM (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS u1,
             (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS u2,
             (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS u3,
             (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS u4,
             (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS u5
    ) nums
    WHERE n <= TIMESTAMPDIFF(HOUR, @inicio, @fim)
) horas;

INSERT IGNORE INTO dim_destino (codigo_iata, nome_cidade)
SELECT codigo, MIN(TRIM(SUBSTRING_INDEX(destino, '(', 1)))
FROM (
    SELECT destino,
           COALESCE(REGEXP_REPLACE(REGEXP_SUBSTR(destino, '[(][A-Z]{3}[)]'), '[()]', ''), 'N/D') AS codigo
    FROM aeroporto_lab.voo
    WHERE deleted_at IS NULL
) x
GROUP BY codigo;

INSERT IGNORE INTO dim_companhia (codigo_iata, nome_companhia)
SELECT codigo,
       CASE codigo
           WHEN 'LA' THEN 'LATAM'
           WHEN 'G3' THEN 'GOL'
           WHEN 'AD' THEN 'Azul'
           ELSE codigo
       END
FROM (
    SELECT DISTINCT UPPER(LEFT(numero, 2)) AS codigo
    FROM aeroporto_lab.voo
    WHERE deleted_at IS NULL
) x;

INSERT IGNORE INTO dim_aeroporto (codigo_iata, nome_aeroporto)
SELECT codigo, MIN(nome)
FROM (
    SELECT COALESCE(REGEXP_REPLACE(REGEXP_SUBSTR(aeroporto_origem, '[(][A-Z]{3}[)]'), '[()]', ''), 'N/D') AS codigo,
           COALESCE(aeroporto_origem, 'N/D') AS nome
    FROM aeroporto_lab.voo
    WHERE deleted_at IS NULL
) x
GROUP BY codigo;

DELETE f
FROM fato_voo f
JOIN aeroporto_lab.voo v ON v.id = f.voo_id_oltp
WHERE v.deleted_at IS NOT NULL;

INSERT INTO fato_voo (voo_id_oltp, numero_voo, sk_tempo, sk_destino, sk_companhia, sk_aeroporto, qtd_voos, passageiros)
SELECT v.id,
       v.numero,
       t.sk_tempo,
       d.sk_destino,
       c.sk_companhia,
       a.sk_aeroporto,
       1,
       NULL
FROM aeroporto_lab.voo v
JOIN dim_tempo t
  ON t.data_hora = DATE_FORMAT(v.data_partida, '%Y-%m-%d %H:00:00')
JOIN dim_destino d
  ON d.codigo_iata = COALESCE(REGEXP_REPLACE(REGEXP_SUBSTR(v.destino, '[(][A-Z]{3}[)]'), '[()]', ''), 'N/D')
JOIN dim_companhia c
  ON c.codigo_iata = UPPER(LEFT(v.numero, 2))
JOIN dim_aeroporto a
  ON a.codigo_iata = COALESCE(REGEXP_REPLACE(REGEXP_SUBSTR(v.aeroporto_origem, '[(][A-Z]{3}[)]'), '[()]', ''), 'N/D')
WHERE v.deleted_at IS NULL
  AND v.id > (SELECT ultimo_id FROM tabela_controle WHERE nome = 'voo');

UPDATE tabela_controle
SET ultimo_id = (SELECT COALESCE(MAX(id), 0) FROM aeroporto_lab.voo)
WHERE nome = 'voo';
