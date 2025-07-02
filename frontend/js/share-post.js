// ==========================================================================
// Orange Social Network - Share Post JavaScript
// ==========================================================================

class SharePostManager {
    constructor() {
        this.modal = null;
        this.currentPostId = null;
        this.selectedUsers = new Set();
        this.allUsers = [];
        this.filteredUsers = [];
        this.isLoading = false;
        this.init();
    }

    init() {
        this.createModal();
        this.bindEvents();
    }

    createModal() {
        const modalHTML = `
            <div id="sharePostModal" class="share-modal-overlay">
                <div class="share-modal">
                    <div class="share-modal-header">
                        <h3 class="share-modal-title">
                            <i class="fas fa-share"></i>
                            Partilhar Publicação
                        </h3>
                        <button class="share-close-btn" onclick="sharePostManager.closeModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    
                    <div class="share-modal-body">
                        <!-- Preview da publicação -->
                        <div class="share-post-preview" id="sharePostPreview">
                            <!-- Conteúdo será preenchido dinamicamente -->
                        </div>
                        
                        <!-- Mensagem opcional -->
                        <div class="share-message-group">
                            <label class="share-message-label">Adicionar mensagem (opcional)</label>
                            <textarea 
                                id="shareMessage" 
                                class="share-message-input" 
                                placeholder="Escreva uma mensagem para acompanhar a publicação..."
                                maxlength="500"
                            ></textarea>
                        </div>
                        
                        <!-- Seleção de utilizadores -->
                        <div class="share-users-section">
                            <label class="share-users-label">
                                Selecionar destinatários
                                <span id="shareSelectedCount" class="share-selected-count" style="display: none;">0</span>
                            </label>
                            
                            <div class="share-search-container">
                                <input 
                                    type="text" 
                                    id="shareSearchInput" 
                                    class="share-search-input" 
                                    placeholder="Pesquisar utilizadores..."
                                >
                            </div>
                            
                            <div class="share-users-list" id="shareUsersList">
                                <div class="share-loading active">
                                    <i class="fas fa-spinner"></i>
                                    Carregando utilizadores...
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="share-modal-footer">
                        <div class="share-selected-info">
                            <i class="fas fa-users"></i>
                            <span id="shareSelectedInfo">Nenhum utilizador selecionado</span>
                        </div>
                        
                        <div class="share-modal-actions">
                            <button class="share-cancel-btn" onclick="sharePostManager.closeModal()">
                                Cancelar
                            </button>
                            <button class="share-send-btn" id="shareSendBtn" onclick="sharePostManager.sendShares()" disabled>
                                <i class="fas fa-paper-plane"></i>
                                Partilhar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);
        this.modal = document.getElementById('sharePostModal');
    }

    bindEvents() {
        // Pesquisa de utilizadores
        const searchInput = document.getElementById('shareSearchInput');
        searchInput.addEventListener('input', (e) => {
            this.filterUsers(e.target.value);
        });

        // Fechar modal ao clicar fora
        this.modal.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.closeModal();
            }
        });

        // Tecla ESC para fechar
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.modal.classList.contains('active')) {
                this.closeModal();
            }
        });
    }
    async loadUsers() {
        const usersList = document.getElementById('shareUsersList');
        usersList.innerHTML = '<div class="share-loading active"><i class="fas fa-spinner"></i> Carregando utilizadores...</div>';

        try {
            // Buscar conversas do utilizador
            const response = await fetch('../backend/get_conversations.php');
            if (!response.ok) throw new Error('Erro ao carregar conversas');

            const data = await response.json();

            if (!data.success || !data.conversations) {
                throw new Error('Nenhuma conversa encontrada');
            }

            // Processar os dados para extrair os utilizadores
            this.allUsers = data.conversations.map(conv => {
                // Garantir que temos os dados mínimos necessários
                if (!conv.other_user || !conv.other_user.id) {
                    return null;
                }

                return {
                    id: conv.other_user.id,
                    nome_completo: conv.other_user.nome || conv.other_user.nick || 'Utilizador',
                    nick: conv.other_user.nick || 'user' + conv.other_user.id,
                    foto_perfil: conv.other_user.foto || 'default-profile.jpg'
                };
            }).filter(user => user !== null); // Remover nulls se houver

            this.filteredUsers = [...this.allUsers];

            if (this.allUsers.length === 0) {
                this.showNoUsersMessage("Você ainda não tem conversas com outros utilizadores");
            } else {
                this.renderUsers();
            }
        } catch (error) {
            console.error('Erro ao carregar utilizadores:', error);
            this.showNoUsersMessage(error.message || 'Erro ao carregar utilizadores');
        }
    }

    // Adicione este método para mostrar mensagens de erro personalizadas
    showNoUsersMessage(message = 'Nenhum utilizador encontrado') {
        const usersList = document.getElementById('shareUsersList');
        usersList.innerHTML = `
        <div class="share-no-users">
            <i class="fas fa-users-slash"></i>
            <p>${this.escapeHtml(message)}</p>
            <small>Tente novamente mais tarde</small>
        </div>
    `;
    }

    // Adicionar esta função à classe SharePostManager
    async loadPostPreview(postId) {
        try {
            const response = await fetch(`../backend/get_post.php?id=${postId}`);
            const post = await response.json();

            if (post.error) {
                throw new Error(post.error);
            }

            // Obter mídias da publicação
            const mediaResponse = await fetch(`../backend/get_post_images?id=${postId}`);
            const medias = await mediaResponse.json();

            // Obter dados da enquete se for do tipo poll
            let pollHTML = '';
            if (post.tipo === 'poll') {
                const pollResponse = await fetch(`../backend/get_poll_data.php?post_id=${postId}`);
                const pollData = await pollResponse.json();

                if (pollData && !pollData.error) {
                    pollHTML = `
                    <div class="share-poll-preview">
                        <h4 class="share-poll-question">${this.escapeHtml(pollData.poll.pergunta)}</h4>
                        <div class="share-poll-options">
                            ${pollData.opcoes.map(opcao => `
                                <div class="share-poll-option">
                                    <div class="share-poll-option-bar" style="width: ${opcao.percentagem}%"></div>
                                    <span class="share-poll-option-text">${this.escapeHtml(opcao.texto)}</span>
                                    <span class="share-poll-option-percent">${opcao.percentagem}%</span>
                                </div>
                            `).join('')}
                        </div>
                        <div class="share-poll-meta">
                            <span class="share-poll-total">${pollData.poll.total_votos} votos</span>
                            <span class="share-poll-status ${pollData.poll.expirada ? 'expired' : 'active'}">
                                ${pollData.poll.expirada ? 'Enquete encerrada' : 'Enquete ativa'}
                            </span>
                        </div>
                    </div>
                `;
                }
            }

            // Construir HTML para mídias
            let mediaHTML = '';
            if (medias.length > 0) {
                const imageMedias = medias.filter(m => m.tipo === 'image');
                const videoMedias = medias.filter(m => m.tipo === 'video');

                if (imageMedias.length > 0) {
                    mediaHTML += `
                    <div class="share-media-preview">
                        <div class="share-media-count">
                            <i class="fas fa-images"></i>
                            ${imageMedias.length} ${imageMedias.length > 1 ? 'imagens' : 'imagem'}
                        </div>
                        <img src="images/publicacoes/${imageMedias[0].url}" 
                             alt="Preview" class="share-media-thumbnail">
                    </div>
                `;
                }

                if (videoMedias.length > 0) {
                    mediaHTML += `
                    <div class="share-media-preview">
                        <div class="share-media-count">
                            <i class="fas fa-video"></i>
                            ${videoMedias.length} ${videoMedias.length > 1 ? 'vídeos' : 'vídeo'}
                        </div>
                        <video class="share-media-thumbnail" muted playsinline>
                            <source src="images/publicacoes/${videoMedias[0].url}" type="video/mp4">
                        </video>
                    </div>
                `;
                }
            }

            const previewHTML = `
            <div class="share-post-preview-header">
                <img src="images/perfil/${post.foto_perfil || 'default-profile.jpg'}" 
                     alt="${post.nick}" class="share-post-preview-avatar">
                <div class="share-post-preview-info">
                    <h4>${post.nick}</h4>
                    <p>${this.formatDate(post.data_criacao)}</p>
                </div>
            </div>
            ${post.conteudo ? `<p class="share-post-preview-content">${this.escapeHtml(post.conteudo)}</p>` : ''}
            ${pollHTML}
            ${mediaHTML}
        `;

            document.getElementById('sharePostPreview').innerHTML = previewHTML;

            // Inicializar player de vídeo se existir
            const video = document.querySelector('.share-media-thumbnail');
            if (video) {
                video.volume = 0;
                video.addEventListener('click', () => {
                    if (video.paused) {
                        video.play();
                    } else {
                        video.pause();
                    }
                });
            }
        } catch (error) {
            console.error('Erro ao carregar preview:', error);
            document.getElementById('sharePostPreview').innerHTML = `
            <p style="color: var(--color-danger); text-align: center;">
                Erro ao carregar preview da publicação
            </p>
        `;
        }
    }
    async openModal(postId) {
        this.currentPostId = postId;
        this.selectedUsers.clear();
        this.updateSelectedCount();

        // Limpar campos
        document.getElementById('shareMessage').value = '';
        document.getElementById('shareSearchInput').value = '';

        // Mostrar modal
        this.modal.classList.add('active');
        document.body.style.overflow = 'hidden';

        // Carregar preview da publicação
        await this.loadPostPreview(postId);

        // Carregar utilizadores
        await this.loadUsers();
    }

    closeModal() {
        this.modal.classList.remove('active');
        document.body.style.overflow = 'auto';
        this.currentPostId = null;
        this.selectedUsers.clear();
        this.allUsers = [];
        this.filteredUsers = [];
    }

    async loadPostPreview(postId) {
        try {
            const response = await fetch(`../backend/get_post.php?id=${postId}`);
            const post = await response.json();

            if (post.error) {
                throw new Error(post.error);
            }

            const previewHTML = `
                <div class="share-post-preview-header">
                    <img src="images/perfil/${post.foto_perfil || 'default-profile.jpg'}" 
                         alt="${post.nick}" class="share-post-preview-avatar">
                    <div class="share-post-preview-info">
                        <h4>${post.nick}</h4>
                        <p>${this.formatDate(post.data_criacao)}</p>
                    </div>
                </div>
                ${post.conteudo ? `<p class="share-post-preview-content">${this.escapeHtml(post.conteudo)}</p>` : ''}
            `;

            document.getElementById('sharePostPreview').innerHTML = previewHTML;
        } catch (error) {
            console.error('Erro ao carregar preview:', error);
            document.getElementById('sharePostPreview').innerHTML = `
                <p style="color: var(--color-danger); text-align: center;">
                    Erro ao carregar preview da publicação
                </p>
            `;
        }
    }
    // Adicione este método para mostrar mensagem quando não há utilizadores
    showNoUsersMessage() {
        const usersList = document.getElementById('shareUsersList');
        usersList.innerHTML = `
        <div class="share-no-users">
            <i class="fas fa-users-slash"></i>
            <p>Nenhum utilizador encontrado</p>
            <small>Tente pesquisar com termos diferentes</small>
        </div>
    `;
    }

    async loadUsers() {
        const usersList = document.getElementById('shareUsersList');

        try {
            const response = await fetch('../backend/search_users.php?q=');
            const users = await response.json();

            this.allUsers = users;
            this.filteredUsers = users;
            this.renderUsers();
        } catch (error) {
            console.error('Erro ao carregar utilizadores:', error);
            usersList.innerHTML = `
                <div class="share-no-users">
                    <i class="fas fa-exclamation-triangle"></i>
                    <p>Erro ao carregar utilizadores</p>
                </div>
            `;
        }
    }

    filterUsers(searchTerm) {
        const term = searchTerm.toLowerCase().trim();
        const usersList = document.getElementById('shareUsersList');

        if (term === '') {
            this.filteredUsers = this.allUsers;
        } else {
            this.filteredUsers = this.allUsers.filter(user => {
                const fullName = user.nome_completo?.toLowerCase() || '';
                const nick = user.nick?.toLowerCase() || '';
                return fullName.includes(term) || nick.includes(term);
            });
        }

        if (this.filteredUsers.length === 0) {
            this.showNoUsersMessage();
        } else {
            this.renderUsers();
        }
    }

    renderUsers() {
        const usersList = document.getElementById('shareUsersList');

        if (this.filteredUsers.length === 0) {
            usersList.innerHTML = `
            <div class="share-no-users">
                <i class="fas fa-users-slash"></i>
                <p>Nenhum utilizador encontrado</p>
                <small>Tente pesquisar com termos diferentes</small>
            </div>
        `;
            return;
        }

        const usersHTML = this.filteredUsers.map(user => `
        <div class="share-user-item ${this.selectedUsers.has(user.id) ? 'selected' : ''}" 
             onclick="sharePostManager.toggleUser(${user.id})">
            <input type="checkbox" 
                   class="share-user-checkbox" 
                   ${this.selectedUsers.has(user.id) ? 'checked' : ''}
                   onchange="sharePostManager.toggleUser(${user.id})"
                   onclick="event.stopPropagation()">
            <img src="images/perfil/${user.foto_perfil || 'default-profile.jpg'}" 
                 alt="${user.nome_completo}" class="share-user-avatar">
            <div class="share-user-info">
                <h4 class="share-user-name">${this.escapeHtml(user.nome_completo)}</h4>
                <p class="share-user-nick">@${this.escapeHtml(user.nick)}</p>
            </div>
        </div>
    `).join('');

        usersList.innerHTML = usersHTML;
    }



    toggleUser(userId) {
        if (this.selectedUsers.has(userId)) {
            this.selectedUsers.delete(userId);
        } else {
            this.selectedUsers.add(userId);
        }

        this.updateSelectedCount();
        this.renderUsers();
    }

    updateSelectedCount() {
        const count = this.selectedUsers.size;
        const countElement = document.getElementById('shareSelectedCount');
        const infoElement = document.getElementById('shareSelectedInfo');
        const sendBtn = document.getElementById('shareSendBtn');

        countElement.textContent = count;
        countElement.style.display = count > 0 ? 'inline' : 'none';

        if (count === 0) {
            infoElement.textContent = 'Nenhum utilizador selecionado';
            sendBtn.disabled = true;
        } else if (count === 1) {
            infoElement.textContent = '1 utilizador selecionado';
            sendBtn.disabled = false;
        } else {
            infoElement.textContent = `${count} utilizadores selecionados`;
            sendBtn.disabled = false;
        }
    }

    async sendShares() {
        if (this.isLoading || this.selectedUsers.size === 0) return;

        this.isLoading = true;
        const sendBtn = document.getElementById('shareSendBtn');
        const originalText = sendBtn.innerHTML;

        sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...';
        sendBtn.disabled = true;

        try {
            const formData = new FormData();
            formData.append('post_id', this.currentPostId);
            formData.append('user_ids', JSON.stringify(Array.from(this.selectedUsers)));
            formData.append('message', document.getElementById('shareMessage').value);

            const response = await fetch('../backend/share_post.php', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();

            if (result.success) {
                this.showToast(`Publicação partilhada com ${result.shared_count} utilizador(es)!`, 'success');
                this.closeModal();

                // Animação de sucesso no botão de partilha original
                const shareButton = document.querySelector(`[data-post-id="${this.currentPostId}"] .share-btn`);
                if (shareButton) {
                    shareButton.classList.add('share-success-animation');
                    setTimeout(() => {
                        shareButton.classList.remove('share-success-animation');
                    }, 600);
                }
            } else {
                this.showToast(result.message || 'Erro ao partilhar publicação', 'error');
            }
        } catch (error) {
            console.error('Erro ao partilhar:', error);
            this.showToast('Erro de conexão. Tente novamente.', 'error');
        } finally {
            this.isLoading = false;
            sendBtn.innerHTML = originalText;
            sendBtn.disabled = this.selectedUsers.size === 0;
        }
    }

    showToast(message, type = 'info') {
        // Usar o sistema de toast existente se disponível
        if (typeof showToast === 'function') {
            showToast(message);
        } else {
            // Fallback para alert
            alert(message);
        }
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('pt-PT', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Inicializar o SharePostManager quando o DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => {
    window.sharePostManager = new SharePostManager();
});

// Função global para abrir o modal de partilha
function openShareModal(postId) {
    if (window.sharePostManager) {
        window.sharePostManager.openModal(postId);
    }
}

