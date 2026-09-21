# Atividade — Regras de Integridade do Banco de Dados

## 1. Banco de dados utilizado
O banco de dados utilizado foi o do **Sistema de Gestão Aeroportuária**, mantido ao longo do semestre. O sistema controla a operação de companhias aéreas e aeroportos, englobando o cadastro de passageiros, frota de aeronaves, agendamento de voos e a emissão de passagens com alocação exclusiva de assentos.

---

## 2. Identificação das regras de integridade

* **Integridade de Entidade:**
  * **Problema evitado:** Ausência de identificadores únicos para registros, permitindo tuplas idênticas e ambiguidades de localização.
  * **Implementação:** Restrição `PRIMARY KEY` associada ao recurso `AUTO_INCREMENT` nas chaves primárias (`id_passageiro`, `id_aeronave`, `id_voo`, `id_passagem`).

* **Integridade Referencial:**
  * **Problema evitado:** Registros órfãos, voos atribuídos a aeronaves inexistentes, ou remoção acidental de aeronaves com viagens pendentes.
  * **Implementação:** Restrição `FOREIGN KEY`:
    * Na tabela `voo` referenciando `aeronave(id_aeronave)` com ação referencial `ON DELETE RESTRICT` e `ON UPDATE CASCADE`.
    * Na tabela `passagem` referenciando `voo(id_voo)` com `ON DELETE CASCADE` e `passageiro(id_passageiro)` com `ON DELETE RESTRICT`.

* **Restrições de Unicidade:**
  * **Problema evitado:** Cadastro repetido do mesmo passageiro com mesmo documento e venda simultânea do mesmo assento para passageiros distintos no mesmo voo (*overbooking* local).
  * **Implementação:** Cláusula `UNIQUE` no campo `cpf` da tabela `passageiro` e restrição única composta `UNIQUE (id_voo, assento)` na tabela `passagem`.

* **Obrigatoriedade de Preenchimento:**
  * **Problema evitado:** Campos vitais deixados em branco, o que quebraria relatórios de voo e emissão de bilhetes.
  * **Implementação:** Restrição `NOT NULL` em colunas essenciais como rotas, nomes, datas e tarifas.

* **Integridade de Domínio:**
  * **Problema evitado:** Entrada de dados ilógicos, como aeronaves sem capacidade, passagens com valor zerado/negativo ou status de voo arbitrários.
  * **Implementação:** Restrições `CHECK` e atribuição de data automática via `DEFAULT CURRENT_TIMESTAMP`.

---

## 3. Aplicação das regras de integridade

| Tabela | Atributo / Alvo | Restrição Utilizada | Justificativa Técnica |
| :--- | :--- | :--- | :--- |
| `passageiro` | `id_passageiro` | `PRIMARY KEY AUTO_INCREMENT` | Identificação unívoca da entidade passageiro. |
| `passageiro` | `cpf` | `NOT NULL UNIQUE` | Obrigatoriedade e garantia de unicidade de documento por passageiro. |
| `aeronave` | `capacidade` | `CHECK (capacidade > 0)` | Integridade de domínio; previne cadastro de aviões sem capacidade de passageiros. |
| `voo` | `id_aeronave` | `FOREIGN KEY ... ON DELETE RESTRICT` | Integridade referencial; impede a deleção de aeronave vinculada a voos. |
| `voo` | `status` | `CHECK (status IN (...))` | Limita os valores aos estados de ciclo de vida definidos no sistema. |
| `passagem` | `(id_voo, assento)` | `UNIQUE` | Regra de negócio: impede o mesmo assento de ser vendido mais de uma vez no mesmo voo. |
| `passagem` | `valor` | `CHECK (valor > 0)` | Integridade de domínio; inviabiliza passagens gratuitas sem autorização ou com preço negativo. |

---

## 4. Regras de negócio implementadas

1. **Unicidade de Identificação do Passageiro:** Um mesmo CPF não pode ser associado a dois registros distintos (`UNIQUE(cpf)`).
2. **Capacidade Operacional Válida:** Nenhuma aeronave pode ser registrada com capacidade menor ou igual a zero assentos (`CHECK (capacidade > 0)`).
3. **Bloqueio de Duplicidade de Assento por Voo:** O sistema não admite que o mesmo assento (ex: '12A') seja alocado mais de uma vez para o mesmo voo (`UNIQUE (id_voo, assento)`).
4. **Validade Tarifária:** O preço da passagem deve ser estritamente superior a zero (`CHECK (valor > 0)`).
5. **Padronização de Ciclo de Vida do Voo:** O status deve ser estritamente: `'Agendado'`, `'Em voo'`, `'Atrasado'`, `'Cancelado'` ou `'Concluído'`.

---

## 5. Testes das regras de integridade

### Teste 1: Prevenção de Duplicidade de Assento no Mesmo Voo (`UNIQUE` composta)
* **Situação testada:** Tentativa de venda do mesmo assento (`'12A'`) para dois passageiros no mesmo voo (`id_voo = 1`).
* **Comando SQL utilizado:**
  ```sql
  -- Primeira compra (sucesso):
  INSERT INTO passagem (id_voo, id_passageiro, assento, valor) VALUES (1, 1, '12A', 450.00);

  -- Segunda compra (conflito de assento):
  INSERT INTO passagem (id_voo, id_passageiro, assento, valor) VALUES (1, 2, '12A', 500.00);
