# Fichas dos painéis

## PAINEL 1: Destinos mais frequentes do aeroporto

- **Pergunta de negócio:** quais destinos recebem mais voos a partir do aeroporto?
- **Indicador (medida):** `COUNT(*)` de voos (`qtd_voos`)
- **Dimensões usadas:** dim_destino, dim_tempo
- **Filtros do painel:** ano, mês, companhia
- **Gráfico sugerido:** barras horizontais, top 10, ordenadas do maior para o menor
- **Operação OLAP:** ( ) roll up  ( ) drill down  (X) slice  ( ) dice  ( ) pivot

## PAINEL 2: Passageiros por mês

- **Pergunta de negócio:** como evolui o total de passageiros ao longo dos meses?
- **Indicador (medida):** `SUM(passageiros)` (lacuna: medida inexistente no OLTP)
- **Dimensões usadas:** dim_tempo (ano, mês)
- **Filtros do painel:** ano, destino, companhia
- **Gráfico sugerido:** linha, com o eixo x em mês
- **Operação OLAP:** (X) roll up  ( ) drill down  ( ) slice  ( ) dice  ( ) pivot

## PAINEL 3: Número de voos

- **Pergunta de negócio:** quantos voos houve no período?
- **Indicador (medida):** `COUNT(*)` de voos, em formato de KPI
- **Dimensões usadas:** dim_tempo, dim_aeroporto (origem)
- **Filtros do painel:** período, aeroporto de origem
- **Gráfico sugerido:** cartão KPI com o total e, abaixo, linha mensal
- **Operação OLAP:** (X) roll up  ( ) drill down  ( ) slice  ( ) dice  ( ) pivot

## PAINEL 4: Companhia aérea mais atuante

- **Pergunta de negócio:** qual companhia tem mais voos e qual é a sua participação no total?
- **Indicador (medida):** `COUNT(*)` por companhia e participação percentual (`qtd / total`, calculada na consulta)
- **Dimensões usadas:** dim_companhia, dim_tempo, dim_destino (opcional)
- **Filtros do painel:** período, destino
- **Gráfico sugerido:** barras ordenadas ou rosca de participação
- **Operação OLAP:** ( ) roll up  ( ) drill down  ( ) slice  (X) dice  ( ) pivot

## PAINEL 5 (livre): Pico de partidas por dia da semana e hora

- **Pergunta de negócio:** em quais dias e horários há mais partidas, para dimensionar equipes e portões?
- **Indicador (medida):** `COUNT(*)` de voos
- **Dimensões usadas:** dim_tempo (dia_semana, hora)
- **Filtros do painel:** mês, companhia
- **Gráfico sugerido:** mapa de calor (dia da semana × hora)
- **Operação OLAP:** ( ) roll up  (X) drill down  ( ) slice  ( ) dice  ( ) pivot
