<?php
/**
 * Conexão com o Banco de Dados MySQL via PDO
 * Roteiro de Atividades — Alunos, Notas e Status
 */

// Configurações do banco de dados
$db_host = 'localhost';
$db_port = '3306';
$db_name = 'escola_db';
$db_user = 'root';
$db_pass = ''; // Por padrão, no XAMPP/WAMP o root não tem senha

// Headers comuns para APIs REST/JSON
header('Content-Type: application/json; charset=UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Responder imediatamente caso seja requisição pre-flight de CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

try {
    $dsn = "mysql:host={$db_host};port={$db_port};dbname={$db_name};charset=utf8mb4";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    $pdo = new PDO($dsn, $db_user, $db_pass, $options);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'erro' => true,
        'mensagem' => 'Falha na conexão com o banco de dados: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}
