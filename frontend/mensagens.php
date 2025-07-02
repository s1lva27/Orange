<?php
session_start();
require "../backend/ligabd.php";

// Verificar se o utilizador está autenticado
if (!isset($_SESSION["id"])) {
    header("Location: login.php");
    exit();
}

$currentUserId = $_SESSION["id"];

// Buscar conversas do utilizador
$sqlConversas = "SELECT c.id, c.utilizador1_id, c.utilizador2_id, c.ultima_atividade,
                        u1.nick as nick1, u1.nome_completo as nome1, p1.foto_perfil as foto1,
                        u2.nick as nick2, u2.nome_completo as nome2, p2.foto_perfil as foto2,
                        (SELECT conteudo FROM mensagens WHERE conversa_id = c.id ORDER BY data_envio DESC LIMIT 1) as ultima_mensagem,
                        (SELECT tipo_mensagem FROM mensagens WHERE conversa_id = c.id ORDER BY data_envio DESC LIMIT 1) as tipo_ultima_mensagem,
                        (SELECT COUNT(*) FROM mensagens WHERE conversa_id = c.id AND remetente_id != $currentUserId AND lida = 0) as mensagens_nao_lidas
                 FROM conversas c
                 JOIN utilizadores u1 ON c.utilizador1_id = u1.id
                 JOIN utilizadores u2 ON c.utilizador2_id = u2.id
                 LEFT JOIN perfis p1 ON u1.id = p1.id_utilizador
                 LEFT JOIN perfis p2 ON u2.id = p2.id_utilizador
                 WHERE c.utilizador1_id = $currentUserId OR c.utilizador2_id = $currentUserId
                 ORDER BY c.ultima_atividade DESC";

$resultConversas = mysqli_query($con, $sqlConversas);
?>

<!DOCTYPE html>
<html lang="pt">

<head>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mensagens - Orange</title>
    <link rel="stylesheet" href="css/app.css">
    <link rel="stylesheet" href="css/style_index.css">
    <link rel="stylesheet" href="css/style_mensagens.css">
    <link rel="icon" type="image/x-icon" href="images/favicon/favicon_orange.png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .messages-loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: var(--text-muted);
        }

        .messages-loading i {
            font-size: 2rem;
            margin-bottom: 1rem;
            animation: spin 1s linear infinite;
        }

        .error-loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: var(--color-danger);
            text-align: center;
            padding: 2rem;
        }

        .error-loading i {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .error-loading button {
            margin-top: 1rem;
            padding: 0.5rem 1rem;
            background: var(--color-primary);
            color: white;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
        }

        .message {
            margin-bottom: var(--space-md);
            opacity: 1;
            transform: translateY(0);
            transition: opacity 0.2s ease, transform 0.2s ease;
        }

        .message.loading {
            opacity: 0.7;
        }

        .message.new-message {
            animation: slideInMessage 0.3s ease-out;
        }

        @keyframes slideInMessage {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .messages-container {
            scroll-behavior: smooth;
            min-height: 200px;
        }

        .typing-indicator {
            display: none;
            padding: var(--space-sm);
            color: var(--text-muted);
            font-style: italic;
            font-size: 0.9rem;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 0.6;
            }
            50% {
                opacity: 1;
            }
        }

        .connection-status {
            position: fixed;
            top: 70px;
            right: 20px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            z-index: 1000;
            transition: all 0.3s ease;
            display: none;
        }

        .connection-status.online {
            background: #10b981;
            color: white;
        }

        .connection-status.offline {
            background: #ef4444;
            color: white;
        }

        .search-users {
            position: relative;
        }

        .search-users::before {
            content: "\f002";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 2;
            pointer-events: none;
        }

        .search-users input {
            width: 100%;
            padding: var(--space-md) var(--space-md) var(--space-md) 45px;
            border: 1px solid var(--border-light);
            border-radius: var(--radius-md);
            background: var(--bg-input);
            color: var(--text-light);
            font-size: 1rem;
            margin-bottom: var(--space-md);
            transition: border-color 0.2s ease;
        }

        .search-users input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 2px rgba(255, 87, 34, 0.2);
        }

        .message.unread {
            background: rgba(255, 87, 34, 0.05);
            border-left: 3px solid var(--color-primary);
            padding-left: calc(var(--space-md) - 3px);
        }

        .messages-loading {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: var(--text-muted);
        }

        .messages-loading i {
            animation: spin 1s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }

        .chat-area {
            contain: layout style paint;
        }

        .messages-container {
            contain: layout style paint;
            will-change: scroll-position;
        }

        /* Indicador de mensagem sendo enviada */
        .message-sending {
            opacity: 0.7;
            position: relative;
        }

        .message-sending::after {
            content: '';
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            width: 12px;
            height: 12px;
            border: 2px solid var(--color-primary);
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        /* Status de entrega */
        .message-status {
            font-size: 0.7rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .message-status.delivered {
            color: var(--color-primary);
        }

        /* Estilo para publicações partilhadas clicáveis */
        .shared-post {
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .shared-post:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            border-color: var(--color-primary);
        }

        .shared-post::after {
            content: '';
            position: absolute;
            top: 8px;
            right: 8px;
            width: 20px;
            height: 20px;
            background: var(--color-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: white;
            opacity: 0;
            transition: all var(--transition-normal);
            z-index: 10;
        }

        .shared-post:hover::after {
            opacity: 1;
            content: "👁";
        }

        .shared-post-clickable-hint {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background: rgba(255, 87, 34, 0.9);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 500;
            opacity: 0;
            transition: opacity 0.2s ease;
        }

        .shared-post:hover .shared-post-clickable-hint {
            opacity: 1;
        }
    </style>
</head>

<body>
    <?php require "parciais/header.php" ?>

    <!-- Status de conexão -->
    <div id="connectionStatus" class="connection-status">
        <i class="fas fa-wifi"></i> Conectado
    </div>

    <div class="container">
        <?php require("parciais/sidebar.php"); ?>

        <main class="messages-container">
            <div class="messages-layout">
                <!-- Lista de Conversas -->
                <div class="conversations-list">
                    <div class="conversations-header">
                        <h2><i class="fas fa-comments"></i> Mensagens</h2>
                        <button class="new-message-btn" onclick="openNewMessageModal()">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>

                    <div class="conversations" id="conversationsList">
                        <?php if (mysqli_num_rows($resultConversas) > 0): ?>
                            <?php while ($conversa = mysqli_fetch_assoc($resultConversas)): ?>
                                <?php
                                // Determinar qual é o outro utilizador
                                $outroUtilizador = ($conversa['utilizador1_id'] == $currentUserId) ?
                                    ['id' => $conversa['utilizador2_id'], 'nick' => $conversa['nick2'], 'nome' => $conversa['nome2'], 'foto' => $conversa['foto2']] :
                                    ['id' => $conversa['utilizador1_id'], 'nick' => $conversa['nick1'], 'nome' => $conversa['nome1'], 'foto' => $conversa['foto1']];
                                
                                // Determinar o texto da última mensagem
                                $ultimaMensagem = 'Iniciar conversa...';
                                if ($conversa['ultima_mensagem']) {
                                    if ($conversa['tipo_ultima_mensagem'] === 'shared_post') {
                                        $ultimaMensagem = '📤 Publicação partilhada';
                                    } else {
                                        $ultimaMensagem = htmlspecialchars(substr($conversa['ultima_mensagem'], 0, 50));
                                        if (strlen($conversa['ultima_mensagem']) > 50) {
                                            $ultimaMensagem .= '...';
                                        }
                                    }
                                }
                                ?>
                                <div class="conversation-item" data-conversation-id="<?php echo $conversa['id']; ?>"
                                    onclick="openConversation(<?php echo $conversa['id']; ?>, <?php echo $outroUtilizador['id']; ?>)">
                                    <img src="images/perfil/<?php echo $outroUtilizador['foto'] ?: 'default-profile.jpg'; ?>"
                                        alt="<?php echo htmlspecialchars($outroUtilizador['nome']); ?>"
                                        class="conversation-avatar">
                                    <div class="conversation-info">
                                        <div class="conversation-header">
                                            <h4><?php echo htmlspecialchars($outroUtilizador['nome']); ?></h4>
                                            <span class="conversation-time">
                                                <?php echo date('H:i', strtotime($conversa['ultima_atividade'])); ?>
                                            </span>
                                        </div>
                                        <p class="last-message"><?php echo $ultimaMensagem; ?></p>
                                    </div>
                                    <?php if ($conversa['mensagens_nao_lidas'] > 0): ?>
                                        <div class="unread-badge"><?php echo $conversa['mensagens_nao_lidas']; ?></div>
                                    <?php endif; ?>
                                </div>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <div class="no-conversations">
                                <i class="fas fa-comments"></i>
                                <h3>Nenhuma conversa ainda</h3>
                                <p>Comece uma nova conversa com alguém!</p>
                                <button class="start-conversation-btn" onclick="openNewMessageModal()">
                                    Iniciar Conversa
                                </button>
                            </div>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Área de Chat -->
                <div class="chat-area" id="chatArea">
                    <div class="no-chat-selected">
                        <i class="fas fa-comments"></i>
                        <h3>Selecione uma conversa</h3>
                        <p>Escolha uma conversa da lista para começar a enviar mensagens</p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Nova Mensagem -->
    <div id="newMessageModal" class="modal-overlay" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Nova Mensagem</h3>
                <button class="close-btn" onclick="closeNewMessageModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="search-users">
                    <input type="text" id="userSearch" placeholder="Pesquisar utilizadores..." onkeyup="searchUsers()">
                    <div id="userResults" class="user-results"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const AppState = {
            currentConversationId: null,
            currentOtherUserId: null,
            messagePolling: null,
            conversationPolling: null,
            lastMessageId: 0,
            lastConversationUpdate: null,
            isTyping: false,
            typingTimeout: null,
            connectionStatus: 'online',
            messagesCache: new Map(),
            isLoadingMessages: false,
            updatingConversations: false,
            currentUserId: <?php echo $currentUserId; ?>,
            pendingMessages: new Map()
        };

        document.addEventListener('DOMContentLoaded', function () {
            startConversationPolling();
            checkConnection();
        });

        function startConversationPolling() {
            if (AppState.conversationPolling) {
                clearInterval(AppState.conversationPolling);
            }

            AppState.conversationPolling = setInterval(() => {
                if (document.visibilityState === 'visible' && !AppState.updatingConversations) {
                    updateConversationsList();
                }
            }, 3000);
        }

        function startMessagePolling() {
            if (AppState.messagePolling) {
                clearInterval(AppState.messagePolling);
            }

            AppState.messagePolling = setInterval(() => {
                if (document.visibilityState === 'visible' && 
                    AppState.currentConversationId && 
                    !AppState.isLoadingMessages) {
                    loadNewMessages();
                }
            }, 1000);
        }

        function checkConnection() {
            const statusEl = document.getElementById('connectionStatus');

            if (navigator.onLine) {
                if (AppState.connectionStatus !== 'online') {
                    AppState.connectionStatus = 'online';
                    statusEl.className = 'connection-status online';
                    statusEl.innerHTML = '<i class="fas fa-wifi"></i> Conectado';
                    statusEl.style.display = 'block';
                    setTimeout(() => statusEl.style.display = 'none', 2000);
                    
                    startConversationPolling();
                    if (AppState.currentConversationId) {
                        startMessagePolling();
                    }
                }
            } else {
                AppState.connectionStatus = 'offline';
                statusEl.className = 'connection-status offline';
                statusEl.innerHTML = '<i class="fas fa-wifi-slash"></i> Sem conexão';
                statusEl.style.display = 'block';
                
                if (AppState.messagePolling) clearInterval(AppState.messagePolling);
                if (AppState.conversationPolling) clearInterval(AppState.conversationPolling);
            }
        }

        setInterval(checkConnection, 5000);
        window.addEventListener('online', checkConnection);
        window.addEventListener('offline', checkConnection);

        function openConversation(conversationId, otherUserId) {
            if (AppState.currentConversationId === conversationId) return;

            if (AppState.messagePolling) {
                clearInterval(AppState.messagePolling);
            }

            AppState.currentConversationId = conversationId;
            AppState.currentOtherUserId = otherUserId;
            AppState.lastMessageId = 0;

            document.querySelectorAll('.conversation-item').forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('data-conversation-id') == conversationId) {
                    item.classList.add('active');
                }
            });

            const chatArea = document.getElementById('chatArea');
            chatArea.innerHTML = `
                <div class="messages-loading">
                    <i class="fas fa-spinner"></i> Carregando conversa...
                </div>
            `;

            loadMessages(true);
            startMessagePolling();
            markMessagesAsRead(conversationId);
        }

        function loadMessages(scrollToBottom = true) {
            if (!AppState.currentConversationId || AppState.isLoadingMessages) return;

            AppState.isLoadingMessages = true;

            fetch(`../backend/get_messages.php?conversation_id=${AppState.currentConversationId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro na resposta do servidor');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        displayMessages(data.messages, data.other_user, scrollToBottom);
                        
                        if (data.messages.length > 0) {
                            AppState.lastMessageId = Math.max(...data.messages.map(m => parseInt(m.id)));
                        }
                    } else {
                        throw new Error(data.message || 'Erro ao carregar mensagens');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    const chatArea = document.getElementById('chatArea');
                    chatArea.innerHTML = `
                        <div class="error-loading">
                            <i class="fas fa-exclamation-triangle"></i>
                            <p>Erro ao carregar mensagens</p>
                            <button onclick="loadMessages(true)">Tentar novamente</button>
                        </div>
                    `;
                })
                .finally(() => {
                    AppState.isLoadingMessages = false;
                });
        }

        function loadNewMessages() {
            if (!AppState.currentConversationId || AppState.isLoadingMessages) return;

            fetch(`../backend/get_messages.php?conversation_id=${AppState.currentConversationId}&after_id=${AppState.lastMessageId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.messages.length > 0) {
                        const messagesContainer = document.getElementById('messagesContainer');
                        if (!messagesContainer) return;

                        const wasScrolledToBottom = isScrolledToBottom(messagesContainer);
                        
                        data.messages.forEach(message => {
                            const messageElement = createMessageElement(message);
                            messageElement.classList.add('new-message');
                            messagesContainer.appendChild(messageElement);
                            
                            AppState.lastMessageId = Math.max(AppState.lastMessageId, parseInt(message.id));
                        });

                        if (wasScrolledToBottom) {
                            scrollToBottomSmooth();
                        }

                        markMessagesAsRead(AppState.currentConversationId);
                    }
                })
                .catch(error => {
                    console.error('Erro ao carregar novas mensagens:', error);
                });
        }

        function createMessageElement(message) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${message.remetente_id == AppState.currentUserId ? 'sent' : 'received'}`;
            
            if (message.tipo_mensagem === 'shared_post') {
                const shareData = JSON.parse(message.conteudo);
                messageDiv.innerHTML = createSharedPostHTML(shareData);
            } else {
                messageDiv.innerHTML = `
                    <div class="message-content">
                        <p>${escapeHtml(message.conteudo)}</p>
                        <span class="message-time">${formatTime(message.data_envio)}</span>
                    </div>
                `;
            }
            
            return messageDiv;
        }

        function createSharedPostHTML(shareData) {
            let content = '<div class="message-content">';
            
            // Mensagem de partilha
            if (shareData.message) {
                content += `
                    <div class="share-message">
                        <div class="share-message-author">${shareData.shared_by.name} partilhou:</div>
                        ${escapeHtml(shareData.message)}
                    </div>
                `;
            }
            
            // Publicação partilhada - CLICÁVEL para ir para a publicação original
            const postLink = shareData.post_link || `publicacao.php?id=${shareData.post.id}`;
            content += `<div class="shared-post shared-post-interactive" onclick="goToOriginalPost('${postLink}')">`;
            
            // Header da publicação
            content += `
                <div class="shared-post-header">
                    <img src="images/perfil/${shareData.post.author.photo || 'default-profile.jpg'}" 
                         alt="${shareData.post.author.name}" class="shared-post-avatar">
                    <div class="shared-post-author">
                        <h5>${shareData.post.author.name}</h5>
                        <p>@${shareData.post.author.nick}</p>
                    </div>
                    <div class="shared-post-date">${formatTime(shareData.post.date)}</div>
                </div>
            `;
            
            // Conteúdo da publicação
            content += '<div class="shared-post-content">';
            
            if (shareData.post.content) {
                content += `<p class="shared-post-text">${escapeHtml(shareData.post.content)}</p>`;
            }
            
            // Mídias
            if (shareData.post.medias && shareData.post.medias.length > 0) {
                content += createSharedMediaHTML(shareData.post.medias);
            }
            
            // Poll
            if (shareData.post.poll) {
                content += createSharedPollHTML(shareData.post.poll);
            }
            
            content += '</div>'; // shared-post-content
            
            // Stats da publicação
            content += `
                <div class="shared-post-stats">
                    <div class="shared-post-likes">
                        <i class="fas fa-thumbs-up"></i>
                        <span>${shareData.post.likes}</span>
                    </div>
                    <div class="shared-post-date">${formatTime(shareData.post.date)}</div>
                </div>
            `;
            
            // Hint de clique
            content += '<div class="shared-post-clickable-hint">Clique para ver</div>';
            
            content += '</div>'; // shared-post
            content += `<span class="message-time">${formatTime(shareData.timestamp)}</span>`;
            content += '</div>'; // message-content
            
            return content;
        }

        // Função para ir para a publicação original
        function goToOriginalPost(postLink) {
            // Abrir em nova aba para não perder a conversa
            window.open(postLink, '_blank');
        }

        function createSharedMediaHTML(medias) {
            if (!medias || medias.length === 0) return '';
            
            const mediaCount = medias.length;
            let gridClass = 'single';
            
            if (mediaCount === 2) gridClass = 'double';
            else if (mediaCount === 3) gridClass = 'triple';
            else if (mediaCount >= 4) gridClass = 'quad';
            
            let html = `<div class="shared-post-media"><div class="shared-post-media-grid ${gridClass}">`;
            
            const displayCount = Math.min(mediaCount, 4);
            
            for (let i = 0; i < displayCount; i++) {
                const media = medias[i];
                html += '<div class="shared-post-media-item">';
                
                if (media.tipo === 'video') {
                    html += `
                        <video muted preload="metadata">
                            <source src="images/publicacoes/${media.url}" type="video/mp4">
                        </video>
                        <div class="video-play-overlay">
                            <i class="fas fa-play"></i>
                        </div>
                    `;
                } else {
                    html += `<img src="images/publicacoes/${media.url}" alt="Imagem partilhada" loading="lazy">`;
                }
                
                if (i === 3 && mediaCount > 4) {
                    html += `<div class="shared-post-media-more">+${mediaCount - 4}</div>`;
                }
                
                html += '</div>';
            }
            
            html += '</div></div>';
            return html;
        }

        function createSharedPollHTML(poll) {
            if (!poll) return '';
            
            let html = '<div class="shared-post-poll">';
            html += `<div class="shared-poll-question">${escapeHtml(poll.pergunta)}</div>`;
            
            if (poll.opcoes && poll.opcoes.length > 0) {
                poll.opcoes.forEach(opcao => {
                    const percentage = poll.total_votos > 0 ? 
                        Math.round((opcao.votos / poll.total_votos) * 100) : 0;
                    
                    html += `
                        <div class="shared-poll-option">
                            <div class="shared-poll-option-progress" style="width: ${percentage}%"></div>
                            <div class="shared-poll-option-content">
                                <span class="shared-poll-option-text">${escapeHtml(opcao.opcao_texto)}</span>
                                <span class="shared-poll-option-percentage">${percentage}%</span>
                            </div>
                        </div>
                    `;
                });
            }
            
            html += `
                <div class="shared-poll-meta">
                    <span>${poll.total_votos} voto${poll.total_votos !== 1 ? 's' : ''}</span>
                    <span class="shared-poll-status ${poll.expirada ? 'expired' : 'active'}">
                        ${poll.expirada ? 'Encerrada' : 'Ativa'}
                    </span>
                </div>
            `;
            
            html += '</div>';
            return html;
        }

        function markMessagesAsRead(conversationId) {
            fetch('../backend/mark_messages_read.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `conversation_id=${conversationId}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.marked_as_read > 0) {
                        const event = new CustomEvent('unreadCountUpdated', {
                            detail: { 
                                change: -data.marked_as_read,
                                newCount: data.new_unread_count || 0
                            }
                        });
                        document.dispatchEvent(event);

                        localStorage.setItem('unreadCountUpdate', JSON.stringify({
                            newCount: data.new_unread_count || 0,
                            timestamp: Date.now()
                        }));

                        updateConversationBadge(conversationId, 0);
                    }
                });
        }

        function updateConversationBadge(conversationId, newCount) {
            const badge = document.querySelector(`[data-conversation-id="${conversationId}"] .unread-badge`);
            if (!badge) return;

            if (newCount > 0) {
                badge.textContent = newCount;
                badge.style.display = 'flex';
            } else {
                badge.style.display = 'none';
            }
        }

        function displayMessages(messages, otherUser, scrollToBottom = true) {
            const chatArea = document.getElementById('chatArea');

            const chatHeader = `
                <div class="chat-header">
                    <img src="images/perfil/${otherUser.foto_perfil || 'default-profile.jpg'}" 
                         alt="${otherUser.nome_completo}" class="chat-avatar">
                    <div class="chat-user-info">
                        <h3>${otherUser.nome_completo}</h3>
                        <p>@${otherUser.nick}</p>
                    </div>
                </div>
                <div class="messages-container" id="messagesContainer">
                    ${generateMessagesHTML(messages)}
                </div>
                <div class="typing-indicator" id="typingIndicator">
                    <i class="fas fa-ellipsis-h"></i> Digitando...
                </div>
                <div class="message-input-container">
                    <form onsubmit="sendMessage(event)">
                        <input type="text" id="messageInput" placeholder="Escreva uma mensagem..." required>
                        <button type="submit"><i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            `;

            chatArea.innerHTML = chatHeader;

            if (scrollToBottom) {
                setTimeout(() => {
                    const container = document.getElementById('messagesContainer');
                    if (container) {
                        container.scrollTop = container.scrollHeight;
                    }
                }, 100);
            }
        }

        function generateMessagesHTML(messages) {
            return messages.map(message => {
                if (message.tipo_mensagem === 'shared_post') {
                    const shareData = JSON.parse(message.conteudo);
                    return `
                        <div class="message ${message.remetente_id == AppState.currentUserId ? 'sent' : 'received'}">
                            ${createSharedPostHTML(shareData)}
                        </div>
                    `;
                } else {
                    return `
                        <div class="message ${message.remetente_id == AppState.currentUserId ? 'sent' : 'received'}">
                            <div class="message-content">
                                <p>${escapeHtml(message.conteudo)}</p>
                                <span class="message-time">${formatTime(message.data_envio)}</span>
                            </div>
                        </div>
                    `;
                }
            }).join('');
        }

        function isScrolledToBottom(element) {
            return element.scrollHeight - element.clientHeight <= element.scrollTop + 1;
        }

        function scrollToBottomSmooth() {
            const messagesContainer = document.getElementById('messagesContainer');
            if (messagesContainer) {
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function sendMessage(event) {
            event.preventDefault();

            const messageInput = document.getElementById('messageInput');
            const content = messageInput.value.trim();

            if (!content || !AppState.currentConversationId) return;

            const tempId = 'temp_' + Date.now();
            messageInput.value = '';
            addTemporaryMessage(content, tempId);

            fetch('../backend/send_message.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `conversation_id=${AppState.currentConversationId}&content=${encodeURIComponent(content)}`
            })
                .then(response => response.json())
                .then(data => {
                    removeTemporaryMessage(tempId);
                    
                    if (data.success) {
                        updateConversationsList();
                    } else {
                        messageInput.value = content;
                        showErrorMessage('Erro ao enviar mensagem. Tente novamente.');
                    }
                })
                .catch(error => {
                    console.error('Erro ao enviar mensagem:', error);
                    removeTemporaryMessage(tempId);
                    messageInput.value = content;
                    showErrorMessage('Erro ao enviar mensagem. Verifique sua conexão.');
                });
        }

        function addTemporaryMessage(content, tempId) {
            const messagesContainer = document.getElementById('messagesContainer');
            if (messagesContainer) {
                const tempMessage = document.createElement('div');
                tempMessage.className = 'message sent message-sending';
                tempMessage.id = tempId;
                tempMessage.innerHTML = `
                    <div class="message-content">
                        <p>${escapeHtml(content)}</p>
                        <span class="message-time">Enviando...</span>
                    </div>
                `;
                messagesContainer.appendChild(tempMessage);
                scrollToBottomSmooth();
            }
        }

        function removeTemporaryMessage(tempId) {
            const tempMessage = document.getElementById(tempId);
            if (tempMessage) {
                tempMessage.remove();
            }
        }

        function showErrorMessage(message) {
            console.error(message);
        }

        function openNewMessageModal() {
            document.getElementById('newMessageModal').style.display = 'flex';
            document.getElementById('userSearch').focus();
            document.body.style.overflow = 'hidden';
        }

        function closeNewMessageModal() {
            document.getElementById('newMessageModal').style.display = 'none';
            document.getElementById('userSearch').value = '';
            document.getElementById('userResults').innerHTML = '';
            document.body.style.overflow = 'auto';
        }

        function searchUsers() {
            const query = document.getElementById('userSearch').value.trim();

            if (query.length < 2) {
                document.getElementById('userResults').innerHTML = '';
                return;
            }

            fetch(`../backend/search_users.php?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(users => {
                    const resultsDiv = document.getElementById('userResults');
                    resultsDiv.innerHTML = users.map(user => `
                        <div class="user-result" onclick="startConversation(${user.id})">
                            <img src="images/perfil/${user.foto_perfil || 'default-profile.jpg'}" 
                                 alt="${user.nome_completo}" class="user-avatar">
                            <div class="user-info">
                                <h4>${user.nome_completo}</h4>
                                <p>@${user.nick}</p>
                            </div>
                        </div>
                    `).join('');
                })
                .catch(error => {
                    console.error('Erro na pesquisa:', error);
                });
        }

        function startConversation(userId) {
            fetch('../backend/create_conversation.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `other_user_id=${userId}`
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro na rede');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        closeNewMessageModal();
                        updateConversationsList();
                        setTimeout(() => {
                            openConversation(data.conversation_id, data.other_user.id);
                        }, 500);
                    } else {
                        alert(data.message || 'Erro ao criar conversa');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro de conexão. A conversa pode ter sido criada - verifique sua lista de conversas.');
                });
        }

        function updateConversationsList() {
            if (AppState.updatingConversations) return;
            AppState.updatingConversations = true;

            fetch(`../backend/get_conversations.php`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const conversationsList = document.getElementById('conversationsList');
                        const currentHTML = conversationsList.innerHTML;
                        let newHTML = '';

                        if (data.conversations.length === 0) {
                            newHTML = `
                                <div class="no-conversations">
                                    <i class="fas fa-comments"></i>
                                    <h3>Nenhuma conversa ainda</h3>
                                    <p>Comece uma nova conversa com alguém!</p>
                                    <button class="start-conversation-btn" onclick="openNewMessageModal()">
                                        Iniciar Conversa
                                    </button>
                                </div>
                            `;
                        } else {
                            newHTML = data.conversations.map(conversation => {
                                const otherUser = conversation.other_user;
                                const isActive = AppState.currentConversationId == conversation.id ? 'active' : '';
                                
                                // Determinar texto da última mensagem
                                let lastMessageText = 'Iniciar conversa...';
                                if (conversation.ultima_mensagem) {
                                    // Verificar se é uma publicação partilhada
                                    try {
                                        const shareData = JSON.parse(conversation.ultima_mensagem);
                                        if (shareData.type === 'shared_post') {
                                            lastMessageText = '📤 Publicação partilhada';
                                        } else {
                                            lastMessageText = escapeHtml(conversation.ultima_mensagem.substring(0, 50));
                                            if (conversation.ultima_mensagem.length > 50) lastMessageText += '...';
                                        }
                                    } catch (e) {
                                        // Se não for JSON, é uma mensagem normal
                                        lastMessageText = escapeHtml(conversation.ultima_mensagem.substring(0, 50));
                                        if (conversation.ultima_mensagem.length > 50) lastMessageText += '...';
                                    }
                                }
                                
                                return `
                                    <div class="conversation-item ${isActive}" data-conversation-id="${conversation.id}" onclick="openConversation(${conversation.id}, ${otherUser.id})">
                                        <img src="images/perfil/${otherUser.foto || 'default-profile.jpg'}" 
                                             alt="${otherUser.nome}" class="conversation-avatar">
                                        <div class="conversation-info">
                                            <div class="conversation-header">
                                                <h4>${otherUser.nome}</h4>
                                                <span class="conversation-time">
                                                    ${formatTime(conversation.ultima_atividade)}
                                                </span>
                                            </div>
                                            <p class="last-message">${lastMessageText}</p>
                                        </div>
                                        ${conversation.mensagens_nao_lidas > 0 ?
                                            `<div class="unread-badge">${conversation.mensagens_nao_lidas}</div>` : ''}
                                    </div>
                                `;
                            }).join('');
                        }

                        if (currentHTML !== newHTML) {
                            conversationsList.innerHTML = newHTML;
                        }
                    }
                })
                .catch(error => {
                    console.error('Erro ao atualizar lista de conversas:', error);
                })
                .finally(() => {
                    AppState.updatingConversations = false;
                });
        }

        function formatTime(dateString) {
            const date = new Date(dateString);
            const now = new Date();
            const diffInHours = (now - date) / (1000 * 60 * 60);

            if (diffInHours < 24) {
                return date.toLocaleTimeString('pt-PT', { hour: '2-digit', minute: '2-digit' });
            } else {
                return date.toLocaleDateString('pt-PT', { day: '2-digit', month: '2-digit' });
            }
        }

        // Event listeners
        document.getElementById('newMessageModal').addEventListener('click', function (e) {
            if (e.target === this) {
                closeNewMessageModal();
            }
        });

        window.addEventListener('beforeunload', function () {
            if (AppState.messagePolling) clearInterval(AppState.messagePolling);
            if (AppState.conversationPolling) clearInterval(AppState.conversationPolling);
        });

        document.addEventListener('visibilitychange', function () {
            if (document.visibilityState === 'hidden') {
                if (AppState.messagePolling) clearInterval(AppState.messagePolling);
                if (AppState.conversationPolling) clearInterval(AppState.conversationPolling);
            } else {
                startConversationPolling();
                if (AppState.currentConversationId) {
                    startMessagePolling();
                }
            }
        });

        let searchTimeout;
        document.getElementById('userSearch').addEventListener('input', function () {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(searchUsers, 300);
        });
    </script>
</body>

</html>