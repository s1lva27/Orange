<?php
session_start();
require "ligabd.php";

header('Content-Type: application/json');

if (!isset($_SESSION['id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Não autenticado']);
    exit;
}

$currentUserId = $_SESSION['id'];
$query = isset($_GET['q']) ? trim($_GET['q']) : '';

try {
    // Se a query estiver vazia, retorna os últimos utilizadores ativos (excluindo o próprio)
    if (empty($query)) {
        $sql = "SELECT u.id, u.nick, u.nome_completo, p.foto_perfil 
                FROM utilizadores u 
                LEFT JOIN perfis p ON u.id = p.id_utilizador 
                WHERE u.id != ? 
                ORDER BY u.data_criacao DESC 
                LIMIT 10";
        $stmt = $con->prepare($sql);
        
        if (!$stmt) {
            throw new Exception('Erro na preparação da query: ' . $con->error);
        }
        
        $stmt->bind_param("i", $currentUserId);
    } else {
        // Pesquisa por nome ou nick
        $searchTerm = '%' . $query . '%';
        $sql = "SELECT u.id, u.nick, u.nome_completo, p.foto_perfil 
                FROM utilizadores u 
                LEFT JOIN perfis p ON u.id = p.id_utilizador 
                WHERE u.id != ? 
                AND (u.nome_completo LIKE ? OR u.nick LIKE ?)
                ORDER BY 
                    CASE 
                        WHEN u.nome_completo LIKE ? THEN 0
                        WHEN u.nick LIKE ? THEN 1
                        ELSE 2
                    END,
                    u.nome_completo ASC
                LIMIT 15";
        $stmt = $con->prepare($sql);
        
        if (!$stmt) {
            throw new Exception('Erro na preparação da query: ' . $con->error);
        }
        
        $stmt->bind_param("issss", $currentUserId, $searchTerm, $searchTerm, $searchTerm, $searchTerm);
    }

    if (!$stmt->execute()) {
        throw new Exception('Erro na execução da query: ' . $stmt->error);
    }

    $result = $stmt->get_result();
    
    if ($result === false) {
        throw new Exception('Erro ao obter resultado: ' . $stmt->error);
    }

    $users = [];
    while ($row = $result->fetch_assoc()) {
        $users[] = [
            'id' => (int) $row['id'],
            'nick' => $row['nick'],
            'nome_completo' => $row['nome_completo'],
            'foto_perfil' => $row['foto_perfil']
        ];
    }

    echo json_encode($users);

} catch (Exception $e) {
    error_log('Erro em search_users.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Erro interno do servidor']);
}
?>