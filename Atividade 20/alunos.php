<?php
/**
 * Abordagem 2 (Final) — Regra de Negócio no Backend 
 */

require_once __DIR__ . '/config.php';

$metodo = $_SERVER['REQUEST_METHOD'];


if ($metodo === 'POST') {
    
    $dados = json_decode(file_get_contents('php://input'), true);
    if (!$dados) {
        $dados = $_POST;
    }

    $nome = isset($dados['nome']) ? trim($dados['nome']) : '';
    $nota = isset($dados['nota']) ? filter_var($dados['nota'], FILTER_VALIDATE_FLOAT) : false;

    
    if (empty($nome) || mb_strlen($nome) < 2) {
        http_response_code(400);
        echo json_encode([
            'erro' => true,
            'mensagem' => 'O nome do aluno é obrigatório e deve ter ao menos 2 caracteres.'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    if ($nota === false || $nota < 0 || $nota > 10) {
        http_response_code(400);
        echo json_encode([
            'erro' => true,
            'mensagem' => 'A nota deve ser um número decimal válido entre 0 e 10.'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }

    try {
        $stmt = $pdo->prepare('INSERT INTO alunos (nome, nota) VALUES (:nome, :nota)');
        $stmt->execute([
            ':nome' => $nome,
            ':nota' => $nota
        ]);

        $novoId = (int) $pdo->lastInsertId();

        
        $status = ($nota >= 7.0) ? 'Aprovado' : 'Reprovado';

        http_response_code(201);
        echo json_encode([
            'sucesso' => true,
            'mensagem' => 'Aluno cadastrado com sucesso!',
            'aluno' => [
                'id' => $novoId,
                'nome' => $nome,
                'nota' => $nota,
                'status' => $status
            ]
        ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'erro' => true,
            'mensagem' => 'Erro ao cadastrar aluno: ' . $e->getMessage()
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }
}


if ($metodo === 'GET') {
    try {
        
        $versao = isset($_GET['versao']) ? (int) $_GET['versao'] : 2;

        $stmt = $pdo->query('SELECT id, nome, nota FROM alunos ORDER BY id ASC');
        $alunos = $stmt->fetchAll();

        $resultado = array_map(function ($aluno) use ($versao) {
            $nota = (float) $aluno['nota'];
            $item = [
                'id'   => (int) $aluno['id'],
                'nome' => $aluno['nome'],
                'nota' => $nota
            ];

            
            if ($versao !== 1) {
                
                $item['status'] = ($nota >= 7.0) ? 'Aprovado' : 'Reprovado';
            }

            return $item;
        }, $alunos);

        echo json_encode($resultado, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            'erro' => true,
            'mensagem' => 'Erro ao consultar alunos: ' . $e->getMessage()
        ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }
    exit;
}


http_response_code(405);
echo json_encode(['erro' => true, 'mensagem' => 'Método não permitido.'], JSON_UNESCAPED_UNICODE);
