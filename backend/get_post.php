<?php
include "ligabd.php";

header('Content-Type: application/json');

if (!isset($_GET['id'])) {
    http_response_code(400);
    echo json_encode(['error' => 'ID da publicação não fornecido']);
    exit;
}

$postId = intval($_GET['id']);

if ($postId <= 0) {
    http_response_code(400);
    echo json_encode(['error' => 'ID da publicação inválido']);
    exit;
}

try {
    $sql = "SELECT p.id_publicacao, p.conteudo, p.data_criacao, p.likes, p.tipo,
                   u.id AS id_utilizador, u.nick, u.nome_completo,
                   pr.foto_perfil, pr.ocupacao
            FROM publicacoes p
            JOIN utilizadores u ON p.id_utilizador = u.id
            LEFT JOIN perfis pr ON u.id = pr.id_utilizador
            WHERE p.id_publicacao = ? AND p.deletado_em = '0000-00-00 00:00:00'";
    
    $stmt = $con->prepare($sql);
    
    if (!$stmt) {
        throw new Exception('Erro na preparação da query: ' . $con->error);
    }
    
    $stmt->bind_param("i", $postId);
    
    if (!$stmt->execute()) {
        throw new Exception('Erro na execução da query: ' . $stmt->error);
    }
    
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(['error' => 'Publicação não encontrada']);
        exit;
    }
    
    $post = $result->fetch_assoc();
    
    // Buscar imagens/vídeos da publicação
    $sqlImages = "SELECT url, content_warning, tipo, ordem 
                  FROM publicacao_medias 
                  WHERE publicacao_id = ?
                  ORDER BY ordem ASC";
    $stmtImages = $con->prepare($sqlImages);
    
    if ($stmtImages) {
        $stmtImages->bind_param("i", $postId);
        $stmtImages->execute();
        $resultImages = $stmtImages->get_result();
        
        $images = [];
        while ($row = $resultImages->fetch_assoc()) {
            $images[] = $row;
        }
        
        $post['images'] = $images;
    } else {
        $post['images'] = [];
    }
    
    // Buscar dados da poll se for do tipo poll
    if ($post['tipo'] === 'poll') {
        $sqlPoll = "SELECT p.id, p.pergunta, p.data_expiracao, p.total_votos
                   FROM polls p 
                   WHERE p.publicacao_id = ?";
        $stmtPoll = $con->prepare($sqlPoll);
        
        if ($stmtPoll) {
            $stmtPoll->bind_param("i", $postId);
            $stmtPoll->execute();
            $pollResult = $stmtPoll->get_result();
            
            if ($pollResult->num_rows > 0) {
                $poll = $pollResult->fetch_assoc();
                $poll['expirada'] = strtotime($poll['data_expiracao']) < time();
                
                // Buscar opções da poll
                $sqlOptions = "SELECT opcao_texto, votos 
                              FROM poll_opcoes 
                              WHERE poll_id = ? 
                              ORDER BY ordem ASC";
                $stmtOptions = $con->prepare($sqlOptions);
                
                if ($stmtOptions) {
                    $stmtOptions->bind_param("i", $poll['id']);
                    $stmtOptions->execute();
                    $optionsResult = $stmtOptions->get_result();
                    
                    $options = [];
                    while ($option = $optionsResult->fetch_assoc()) {
                        $options[] = $option;
                    }
                    
                    $poll['opcoes'] = $options;
                }
                
                $post['poll'] = $poll;
            }
        }
    }
    
    echo json_encode($post);
    
} catch (Exception $e) {
    error_log('Erro em get_post.php: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Erro interno do servidor']);
}
?>