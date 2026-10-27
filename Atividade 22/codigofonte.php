<?php
class VooModel
{
    private PDO $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }

    public function listarAtivos(): array
    {
        $sql = "SELECT * FROM voos WHERE deleted_at IS NULL ORDER BY partida ASC";
        return $this->pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
    }

    public function buscarAtivoPorId(int $id): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM voos WHERE id = :id AND deleted_at IS NULL");
        $stmt->execute([':id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    public function listarExcluidos(): array
    {
        $sql = "SELECT * FROM voos WHERE deleted_at IS NOT NULL ORDER BY deleted_at DESC";
        return $this->pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
    }

    public function excluir(int $id, int $usuarioId): void
    {
        $this->pdo->beginTransaction();

        try {
            $voo = $this->buscarAtivoPorId($id);
            if (!$voo) {
                throw new Exception("Voo não encontrado ou já excluído.");
            }

            $stmtUpdate = $this->pdo->prepare("UPDATE voos SET deleted_at = NOW() WHERE id = :id");
            $stmtUpdate->execute([':id' => $id]);

            $stmtAudit = $this->pdo->prepare(
                "INSERT INTO auditoria (tabela, registro_id, acao, usuario_id, dados_antes, criado_em)
                 VALUES ('voos', :registro_id, 'SOFT_DELETE', :usuario_id, :dados_antes, NOW())"
            );
            $stmtAudit->execute([
                ':registro_id' => $id,
                ':usuario_id'  => $usuarioId,
                ':dados_antes' => json_encode($voo, JSON_UNESCAPED_UNICODE)
            ]);

            $this->pdo->commit();
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            throw $e;
        }
    }

    public function restaurar(int $id): void
    {
        $stmt = $this->pdo->prepare("UPDATE voos SET deleted_at = NULL WHERE id = :id AND deleted_at IS NOT NULL");
        $stmt->execute([':id' => $id]);
    }
}

class VooController
{
    private VooModel $model;

    public function __construct(VooModel $model)
    {
        $this->model = $model;
        if (session_status() === PHP_SESSION_NONE) session_start();
    }

    public function index(): void
    {
        $voos = $this->model->listarAtivos();
        require 'views/index.php';
    }

    public function excluidos(): void
    {
        $voosExcluidos = $this->model->listarExcluidos();
        require 'views/excluidos.php';
    }

    public function excluir(): void
    {
        $id = (int) ($_POST['id'] ?? 0);
        $usuarioId = (int) ($_SESSION['usuario_id'] ?? 1);

        try {
            $this->model->excluir($id, $usuarioId);
            $_SESSION['mensagem'] = "Voo excluído com sucesso!";
        } catch (Throwable $e) {
            $_SESSION['erro'] = "Erro ao excluir voo: " . $e->getMessage();
        }

        header('Location: /voos');
        exit;
    }

    public function restaurar(): void
    {
        $id = (int) ($_POST['id'] ?? 0);

        try {
            $this->model->restaurar($id);
            $_SESSION['mensagem'] = "Voo restaurado com sucesso!";
        } catch (Throwable $e) {
            $_SESSION['erro'] = "Erro ao restaurar voo: " . $e->getMessage();
        }

        header('Location: /voos/excluidos');
        exit;
    }
}
?>

<h2>Voos Ativos</h2>
<a href="/voos/excluidos">Ver Voos Excluídos (Lixeira)</a>

<table border="1" cellpadding="8" style="margin-top:10px;">
    <tr><th>ID</th><th>Código</th><th>Origem</th><th>Destino</th><th>Partida</th><th>Ação</th></tr>
    <?php foreach ($voos as $v): ?>
    <tr>
        <td><?= $v['id'] ?></td>
        <td><?= htmlspecialchars($v['codigo']) ?></td>
        <td><?= htmlspecialchars($v['origem']) ?></td>
        <td><?= htmlspecialchars($v['destino']) ?></td>
        <td><?= $v['partida'] ?></td>
        <td>
            <form method="POST" action="/voos/excluir" onsubmit="return confirm('Deseja realmente mover este voo para a lixeira?');">
                <input type="hidden" name="id" value="<?= $v['id'] ?>">
                <button type="submit">Excluir</button>
            </form>
        </td>
    </tr>
    <?php endforeach; ?>
</table>

<h2>Voos Excluídos (Lixeira)</h2>
<a href="/voos">&larr; Voltar para Voos Ativos</a>

<table border="1" cellpadding="8" style="margin-top:10px;">
    <tr><th>ID</th><th>Código</th><th>Origem</th><th>Destino</th><th>Excluído em</th><th>Ação</th></tr>
    <?php foreach ($voosExcluidos as $ve): ?>
    <tr>
        <td><?= $ve['id'] ?></td>
        <td><?= htmlspecialchars($ve['codigo']) ?></td>
        <td><?= htmlspecialchars($ve['origem']) ?></td>
        <td><?= htmlspecialchars($ve['destino']) ?></td>
        <td><?= $ve['deleted_at'] ?></td>
        <td>
            <form method="POST" action="/voos/restaurar">
                <input type="hidden" name="id" value="<?= $ve['id'] ?>">
                <button type="submit">Restaurar</button>
            </form>
        </td>
    </tr>
    <?php endforeach; ?>
</table>
