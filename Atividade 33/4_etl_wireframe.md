# ETL e wireframe

## ETL

- **Extract:** `SELECT ... FROM voo WHERE deleted_at IS NULL`. Voos excluídos por soft delete ficam de fora. A carga é incremental pelo `id`.
- **Transform:** separar código IATA e nome da cidade de `"Brasília (BSB)"`; extrair a companhia dos dois primeiros caracteres de `numero`; quebrar `data_partida` em ano, mês, dia da semana e hora; tratar `aeroporto_origem` nulo (registros antigos, a preencher com `backfill_origem.php`); manter passageiros nulos quando não houver dado, sem converter para zero.
- **Load:** primeiro `dim_tempo`, `dim_destino`, `dim_companhia` e `dim_aeroporto`; depois `fato_voo`, buscando cada chave substituta pela chave natural.

## Wireframe: Painel 1, Destinos mais frequentes

```
+-----------------------------------------------------------+
| PAINEL: Destinos mais frequentes                          |
| Filtros:  [Ano ▼]   [Mês ▼]   [Companhia ▼]               |
+-----------------------------------------------------------+
|  INDICADOR PRINCIPAL             |                        |
|  Total de voos no período        |  Top 10 destinos       |
|      [  KPI  ]                   |  (barras horizontais)  |
|                                  |                        |
+-----------------------------------------------------------+
|  Evolução mensal de voos (linha)                          |
|  ___/\____/\______                                        |
+-----------------------------------------------------------+
```
