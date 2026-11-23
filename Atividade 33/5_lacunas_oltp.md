# Lacunas do modelo OLTP

1. **Passageiros:** não existe. Sem esse dado, o painel 2 não funciona. Sugestão: coluna `passageiros` em `voo`, ou tabela `embarque` com um registro por voo.
2. **Companhia aérea:** não existe. Hoje aparece só no prefixo de `numero`, o que é frágil. Sugestão: tabela `companhia (codigo_iata, nome)` e chave estrangeira em `voo`.
3. **Aeroportos em texto livre:** `origem` e `destino` são texto, com inconsistências (o placeholder de `criar.php` mostra `São Paulo (GRU)`, enquanto os dados usam `São Paulo (CGH)`). Sugestão: tabela `aeroporto (codigo_iata, cidade, uf)`.
4. **Status do voo:** não há campo de realizado, cancelado ou programado. Sem isso, "número de voos" é ambíguo.
5. **Sem `updated_at`:** a carga incremental só captura inserções. Edições feitas em `editar()` não chegam ao DW.
6. **Sem horário real:** só existe `data_partida`. Não há chegada nem atraso.
7. **Inconsistências no código:**
   - `app/database.sql` ainda usa a coluna `origem` e a insere, mas a migration 004 a remove. O código usa `aeroporto_origem`.
   - `migrate.php` usa o banco `aeroporto_lab`, enquanto `database.sql` cria `aeroporto`.
