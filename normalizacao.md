# Atividade — Normalização do Banco de Dados

## 1. Banco de dados utilizado
O banco de dados analisado refere-se ao projeto `aeroporto`, cujo estado inicial correspondia ao script da Aula 8.

## 2. Comparação com o SQL da Aula 8

Analisando o arquivo `sql_aula_8.sql`, identificamos os seguintes problemas estruturais:
* **Inconsistência de DDL e VIEW:** A view `aeroporto` tenta buscar colunas semânticas (`id_passageiro`, `nome`, `passaporte`, `cpf`, `idade`) na `table1`, mas a `table1` foi criada com colunas genéricas (`idtable`, `table1col`, etc.) e em menor quantidade.
* **Falta de Chaves Primárias (PK):** Nenhuma das tabelas possuía a restrição `PRIMARY KEY`.
* **Falta de Relacionamentos (FK):** Não havia chaves estrangeiras conectando as entidades.
* **Nomenclatura Genérica:** Uso de `table1` e `Table2`, o que dificulta a manutenção e não representa o modelo de negócios.

Para fins desta normalização, corrigimos a semântica adotando `table1` como **`passageiro`** (conforme ditava a View) e `Table2` como **`voo`** (assumindo o contexto do aeroporto para criar o relacionamento).

---

## 3. Aplicação das Formas Normais

### Fluxo de Normalização
```text
SQL da Aula 8 (Nomes genéricos, sem PKs, inconsistências)
      ↓
     1FN (Atomicidade, chaves primárias definidas, nomes semânticos)
      ↓
     2FN (Análise de dependência parcial)
      ↓
     3FN (Remoção de dependência transitiva: idade -> data_nascimento)
      ↓
     4FN (Análise de dependência multivalorada)
      ↓
     5FN (Análise de dependência de junção)
      ↓
Modelo final normalizado (com relacionamentos corretos)
