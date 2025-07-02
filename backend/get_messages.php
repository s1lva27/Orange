<?php
session_start();
require "ligabd.php";

header('Content-Type: application/json');

// Verificar autenticação primeiro
if (!isset($_SESSION['id'])) {
    echo json_encode(['success' => false, 'message' => 'Não autenticado']);
    exit;
}

if (!isset($_GET['conversation_id'])) {
    echo json_encode(['success' => false, 'message' => 'ID da conversa não fornecido']);
    exit;
}

$currentUserId = $_SESSION['id'];
$conversationId = intval($_GET['conversation_id']);
$afterId = isset($_GET['after_id']) ? intval($_GET['after_id']) : 0;

// Verificar se o utilizador faz parte da conversa
$sqlCheck = "SELECT utilizador1_id, utilizador2_id FROM conversas 
             WHERE id = ? AND (utilizador1_id = ? OR utilizador2_id = ?)";
$stmtCheck = $con->prepare($sqlCheck);
$stmtCheck->bind_param("iii", $conversationId, $currentUserId, $currentUserId);
$stmtCheck->execute();
$result = $stmtCheck->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => false, 'message' => 'Conversa não encontrada']);
    exit;
}

$conversation = $result->fetch_assoc();
$otherUserId = ($conversation['utilizador1_id'] == $currentUserId) ?
    $conversation['utilizador2_id'] : $conversation['utilizador1_id'];

// Buscar informações do outro utilizador (apenas se não for uma requisição de novas mensagens)
$otherUser = null;
if ($afterId == 0) {
    $sqlUser = "SELECT u.id, u.nick, u.nome_completo, p.foto_perfil 
                FROM utilizadores u 
                LEFT JOIN perfis p ON u.id = p.id_utilizador 
                WHERE u.id = ?";
    $stmtUser = $con->prepare($sqlUser);
    $stmtUser->bind_param("i", $otherUserId);
    $stmtUser->execute();
    $otherUser = $stmtUser->get_result()->fetch_assoc();
}

// Buscar mensagens
$sqlMessages = "SELECT *, COALESCE(tipo_mensagem, 'text') as tipo_mensagem FROM mensagens 
                WHERE conversa_id = ?";

// Se afterId for fornecido, buscar apenas mensagens mais recentes
if ($afterId > 0) {
    $sqlMessages .= " AND id > ?";
}

$sqlMessages .= " ORDER BY data_envio ASC";

if ($afterId > 0) {
    $stmtMessages = $con->prepare($sqlMessages);
    $stmtMessages->bind_param("ii", $conversationId, $afterId);
} else {
    $stmtMessages = $con->prepare($sqlMessages);
    $stmtMessages->bind_param("i", $conversationId);
}

$stmtMessages->execute();
$result = $stmtMessages->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    $messages[] = $row;
}

// Contar mensagens não lidas (apenas se não for uma requisição de novas mensagens)
$unreadCount = 0;
if ($afterId == 0) {
    $sqlUnread = "SELECT COUNT(*) as unread_count FROM mensagens 
                  WHERE conversa_id = ? AND remetente_id != ? AND lida = 0";
    $stmtUnread = $con->prepare($sqlUnread);
    $stmtUnread->bind_param("ii", $conversationId, $currentUserId);
    $stmtUnread->execute();
    $unreadResult = $stmtUnread->get_result()->fetch_assoc();
    $unreadCount = $unreadResult['unread_count'];
}

$response = [
    'success' => true,
    'messages' => $messages
];

// Adicionar informações do outro utilizador apenas se for a primeira carga
if ($otherUser) {
    $response['other_user'] = $otherUser;
    $response['unread_count'] = $unreadCount;
}

echo json_encode($response);
?>