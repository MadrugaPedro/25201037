<?php
/**
 * Abordagem 1 — Regra no JavaScript
 */

require_once __DIR__ . '/config.php';

try {
    
    $stmt = $pdo->query('SELECT id, nome, nota FROM alunos ORDER BY id ASC');
    $alunos = $stmt->fetchAll();

    
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
