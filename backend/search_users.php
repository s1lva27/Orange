<?php
session_start();
require "ligabd.php";

header('Content-Type: application/json');

if (!isset($_SESSION['id'])) {
    echo json_encode(['error' => 'Não autenticado']);
    exit;
}

$currentUserId = $_SESSION['id'];
$query = isset($_GET['q']) ? trim($_GET['q']) : '';

// Se a query estiver vazia, retorna os últimos utilizadores ativos
if (empty($query)) {
    $sql = "SELECT u.id, u.nick, u.nome_completo, p.foto_perfil 
            FROM utilizadores u 
            LEFT JOIN perfis p ON u.id = p.id_utilizador 
            WHERE u.id != ? 
            ORDER BY u.ultimo_login DESC 
            LIMIT 10";
    $stmt = $con->prepare($sql);
    $stmt->bind_param("i", $currentUserId);
} else {
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
            END
        LIMIT 10";
    $stmt = $con->prepare($sql);
    $stmt->bind_param("issss", $currentUserId, $searchTerm, $searchTerm, $searchTerm, $searchTerm);
}

$stmt->execute();
$result = $stmt->get_result();

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode($users);
?>