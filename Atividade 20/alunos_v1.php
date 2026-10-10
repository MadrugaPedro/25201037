<?php
/**
 * Abordagem 1 — Regra no JavaScript
 * Este endpoint retorna apenas os dados brutos da tabela alunos (id, nome, nota).
 * O cálculo de aprovação/reprovação NÃO é feito aqui, ficando a cargo do JavaScript no cliente.
 */

require_once __DIR__ . '/config.php';

try {
    // Consulta todos os alunos cadastrados
    $stmt = $pdo->query('SELECT id, nome, nota FROM alunos ORDER BY id ASC');
    $alunos = $stmt->fetchAll();

    // Normaliza os tipos de dados (float na nota, int no id)
    $resultado = array_map(function ($aluno) {
        return [
            'id'    => (int) $aluno['id'],
            'nome'  => $aluno['nome'],
            'nota'  => (float) $aluno['nota']
        ];
    }, $alunos);

    echo json_encode($resultado, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'erro' => true,
        'mensagem' => 'Erro ao consultar alunos: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}
