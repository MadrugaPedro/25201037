# Modelo estrela: Painéis do Aeroporto

## Grão

Uma linha de `fato_voo` representa um voo ativo, identificado pelo número e pela data de partida, saindo do aeroporto de origem em direção a um destino.

## Medidas

| Medida | Tipo | Observação |
|---|---|---|
| `qtd_voos` | Aditiva | Vale 1 por linha; soma com `COUNT(*)`. |
| `passageiros` | Aditiva | Lacuna: não existe no OLTP. |
| `taxa_ocupação` | Não aditiva | Não somar percentuais. Calcular como `SUM(passageiros) / SUM(capacidade)` na consulta. Depende de dado inexistente. |

Não há medida semiaditiva neste modelo.

## Dimensões

- **dim_tempo** (sk_tempo, data, dia, mes, ano, ano_mes, dia_semana, hora). Uma linha por hora do calendário.
- **dim_destino** (sk_destino, codigo_iata, nome_cidade). Origem: campo `destino`.
- **dim_companhia** (sk_companhia, codigo_iata, nome). Não existe no OLTP; derivada do prefixo de `numero` (LA = LATAM, G3 = GOL).
- **dim_aeroporto** (sk_aeroporto, codigo_iata, nome). Origem: campo `aeroporto_origem`.
- **Degenerada:** `numero_voo`, mantida na própria fato.

## Estrela

```
                 dim_tempo
                     |
dim_companhia ── fato_voo ── dim_destino
                     |
                dim_aeroporto (origem)
```

## Uma única fato atende aos cinco painéis?

Sim, desde que passageiros sejam registrados por voo.

- Os painéis 1, 3, 4 e 5 usam apenas a contagem de voos e cabem na fato de grão "um voo".
- O painel 2 usa `passageiros`, que é aditiva e pode ficar no mesmo grão se o dado vier por voo.
- Se passageiros vierem por bilhete ou por passageiro, o grão muda e é preciso uma segunda fato (`fato_embarque`, grão "um passageiro por voo"). Misturar os dois grãos na mesma tabela faria `COUNT(*)` contar passageiros como voos.
