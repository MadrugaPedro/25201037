SELECT d.nome_cidade, COUNT(*) AS qtd_voos
FROM fato_voo f
JOIN dim_destino d ON d.sk_destino = f.sk_destino
JOIN dim_tempo   t ON t.sk_tempo   = f.sk_tempo
WHERE t.ano = 2026 AND t.mes = 11
GROUP BY d.nome_cidade
ORDER BY qtd_voos DESC
LIMIT 10;

SELECT t.ano, t.mes, SUM(f.passageiros) AS total_passageiros
FROM fato_voo f
JOIN dim_tempo t ON t.sk_tempo = f.sk_tempo
GROUP BY t.ano, t.mes
ORDER BY t.ano, t.mes;

SELECT COUNT(*) AS qtd_voos
FROM fato_voo f
JOIN dim_tempo t ON t.sk_tempo = f.sk_tempo
WHERE t.ano = 2026 AND t.mes = 11;

SELECT c.nome_companhia,
       COUNT(*) AS qtd_voos,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS participacao_pct
FROM fato_voo f
JOIN dim_companhia c ON c.sk_companhia = f.sk_companhia
JOIN dim_tempo     t ON t.sk_tempo     = f.sk_tempo
WHERE t.ano = 2026 AND t.mes = 11
GROUP BY c.nome_companhia
ORDER BY qtd_voos DESC
LIMIT 5;

SELECT t.dia_semana, t.hora, COUNT(*) AS qtd_partidas
FROM fato_voo f
JOIN dim_tempo t ON t.sk_tempo = f.sk_tempo
WHERE t.ano = 2026 AND t.mes = 11
GROUP BY t.dia_semana, t.hora
ORDER BY qtd_partidas DESC
LIMIT 10;
