// ==========================================================================
// Orange Social Network - Share Post JavaScript
// ==========================================================================

class SharePostManager {
    constructor() {
        this.modal = null;
        this.selectedUsers = new Set();
        this.currentPostId = null;
        this.searchTimeout = null;
        this.isLoading = false;
        
        this.init();
    }

    init() {
        this.createModal();
        this.bindEvents();
    }

    createModal() {
        // Verificar se o modal já existe
        if (document.getElementById('shareModal')) {
            this.modal = document.getElementById('shareModal');
            return;
        }

        const modalHTML = `
            <div id="shareModal" class="share-modal-overlay">
                <div class="share-modal">
                    <div class="share-modal-header">
                        <h3 class="share-modal-title">
                            <i class="fas fa-share"></i>
                            Partilhar Publicação
                        </h3>
                        <button class="share-close-btn" type="button">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    
                    <div class="share-modal-body">
                        <div class="share-post-preview" id="sharePostPreview">
                            <!-- Preview da publicação será inserido aqui -->
                        </div>
                        
                        <div class="share-message-group">
                            <label class="share-message-label">Mensagem (opcional)</label>
                            <textarea 
                                class="share-message-input" 
                                id="shareMessage" 
                                placeholder="Adicione uma mensagem à sua partilha..."
                                rows="3"
                                maxlength="500"
                            ></textarea>
                        </div>
                        
                        <div class="share-users-section">
                            <label class="share-users-label">Selecionar utilizadores</label>
                            
                            <div class="share-search-container">
                                <input 
                                    type="text" 
                                    class="share-search-input" 
                                    id="shareUserSearch" 
                                    placeholder="Pesquisar utilizadores..."
                                    autocomplete="off"
                                >
                            </div>
                            
                            <div class="share-users-list" id="shareUsersList">
                                <div class="share-loading">
                                    <i class="fas fa-spinner"></i>
                                    Carregando utilizadores...
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="share-modal-footer">
                        <div class="share-selected-info">
                            <i class="fas fa-users"></i>
                            <span id="shareSelectedCount">0 utilizadores selecionados</span>
                        </div>
                        
                        <div class="share-modal-actions">
                            <button class="share-cancel-btn" type="button">Cancelar</button>
                            <button class="share-send-btn" type="button" disabled>
                                <i class="fas fa-paper-plane"></i>
                                Partilhar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);
        this.modal = document.getElementById('shareModal');
    }

    bindEvents() {
        // Event listeners para o modal
        document.addEventListener('click', (e) => {
            if (e.target.matches('[onclick*="openShareModal"]') || 
                e.target.closest('[onclick*="openShareModal"]')) {
                e.preventDefault();
                const button = e.target.closest('button');
                if (button) {
                    const postId = this.extractPostIdFromButton(button);
                    if (postId) {
                        this.openModal(postId);
                    }
                }
            }
        });

        // Fechar modal
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('share-close-btn') || 
                e.target.closest('.share-close-btn')) {
                this.closeModal();
            }
            
            if (e.target.classList.contains('share-cancel-btn')) {
                this.closeModal();
            }
            
            if (e.target.classList.contains('share-modal-overlay')) {
                this.closeModal();
            }
        });

        // Pesquisa de utilizadores
        document.addEventListener('input', (e) => {
            if (e.target.id === 'shareUserSearch') {
                this.handleSearch(e.target.value);
            }
        });

        // Seleção de utilizadores
        document.addEventListener('change', (e) => {
            if (e.target.classList.contains('share-user-checkbox')) {
                this.handleUserSelection(e.target);
            }
        });

        // Enviar partilha
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('share-send-btn') || 
                e.target.closest('.share-send-btn')) {
                this.handleShare();
            }
        });

        // Fechar modal com ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.modal && this.modal.classList.contains('active')) {
                this.closeModal();
            }
        });
    }

    extractPostIdFromButton(button) {
        // Tentar extrair o ID da publicação do botão
        const postElement = button.closest('.post');
        if (postElement) {
            return postElement.getAttribute('data-post-id');
        }
        
        // Fallback: tentar extrair do onclick
        const onclick = button.getAttribute('onclick');
        if (onclick) {
            const match = onclick.match(/openShareModal\((\d+)\)/);
            if (match) {
                return match[1];
            }
        }
        
        return null;
    }

    async openModal(postId) {
        if (!postId) {
            console.error('ID da publicação não fornecido');
            return;
        }

        this.currentPostId = postId;
        this.selectedUsers.clear();
        
        // Mostrar modal
        this.modal.classList.add('active');
        document.body.style.overflow = 'hidden';
        
        // Carregar preview da publicação
        await this.loadPostPreview(postId);
        
        // Carregar utilizadores iniciais
        await this.loadInitialUsers();
        
        // Limpar pesquisa e mensagem
        document.getElementById('shareUserSearch').value = '';
        document.getElementById('shareMessage').value = '';
        
        // Atualizar contador
        this.updateSelectedCount();
    }

    closeModal() {
        if (this.modal) {
            this.modal.classList.remove('active');
            document.body.style.overflow = 'auto';
            
            // Limpar dados
            this.currentPostId = null;
            this.selectedUsers.clear();
            this.updateSelectedCount();
        }
    }

    async loadPostPreview(postId) {
        try {
            const response = await fetch(`../backend/get_post.php?id=${postId}`);
            
            if (!response.ok) {
                throw new Error('Erro ao carregar publicação');
            }
            
            const post = await response.json();
            
            const previewContainer = document.getElementById('sharePostPreview');
            previewContainer.innerHTML = `
                <div class="share-post-preview-header">
                    <img src="images/perfil/${post.foto_perfil || 'default-profile.jpg'}" 
                         alt="${post.nick}" class="share-post-preview-avatar">
                    <div class="share-post-preview-info">
                        <h4>${post.nick}</h4>
                        <p>${new Date(post.data_criacao).toLocaleDateString('pt-PT')}</p>
                    </div>
                </div>
                ${post.conteudo ? `<p class="share-post-preview-content">${post.conteudo}</p>` : ''}
                ${this.generateMediaPreview(post.images)}
            `;
            
        } catch (error) {
            console.error('Erro ao carregar preview:', error);
            document.getElementById('sharePostPreview').innerHTML = `
                <div class="error-loading">
                    <i class="fas fa-exclamation-triangle"></i>
                    <p>Erro ao carregar publicação</p>
                </div>
            `;
        }
    }

    generateMediaPreview(images) {
        if (!images || images.length === 0) return '';
        
        const firstImage = images[0];
        const mediaCount = images.length;
        
        if (firstImage.tipo === 'video') {
            return `
                <div class="share-media-preview">
                    <video class="share-media-thumbnail" muted>
                        <source src="images/publicacoes/${firstImage.url}" type="video/mp4">
                    </video>
                    ${mediaCount > 1 ? `<div class="share-media-count">+${mediaCount - 1}</div>` : ''}
                </div>
            `;
        } else {
            return `
                <div class="share-media-preview">
                    <img src="images/publicacoes/${firstImage.url}" 
                         alt="Preview" class="share-media-thumbnail">
                    ${mediaCount > 1 ? `<div class="share-media-count">+${mediaCount - 1}</div>` : ''}
                </div>
            `;
        }
    }

    async loadInitialUsers() {
        try {
            this.showLoading(true);
            
            const response = await fetch('../backend/search_users.php');
            
            if (!response.ok) {
                throw new Error(`Erro HTTP: ${response.status}`);
            }
            
            const users = await response.json();
            
            if (Array.isArray(users)) {
                this.displayUsers(users);
            } else {
                throw new Error('Resposta inválida do servidor');
            }
            
        } catch (error) {
            console.error('Erro ao carregar utilizadores:', error);
            this.showError('Erro ao carregar utilizadores. Tente pesquisar por um nome específico.');
        } finally {
            this.showLoading(false);
        }
    }

    handleSearch(query) {
        // Debounce da pesquisa
        clearTimeout(this.searchTimeout);
        
        this.searchTimeout = setTimeout(async () => {
            if (this.isLoading) return;
            
            try {
                this.showLoading(true);
                
                const url = query.trim() ? 
                    `../backend/search_users.php?q=${encodeURIComponent(query.trim())}` :
                    '../backend/search_users.php';
                
                const response = await fetch(url);
                
                if (!response.ok) {
                    throw new Error(`Erro HTTP: ${response.status}`);
                }
                
                const users = await response.json();
                
                if (Array.isArray(users)) {
                    this.displayUsers(users);
                } else {
                    throw new Error('Resposta inválida do servidor');
                }
                
            } catch (error) {
                console.error('Erro na pesquisa:', error);
                this.showError('Erro ao pesquisar utilizadores');
            } finally {
                this.showLoading(false);
            }
        }, 300);
    }

    displayUsers(users) {
        const container = document.getElementById('shareUsersList');
        
        if (users.length === 0) {
            container.innerHTML = `
                <div class="share-no-users">
                    <i class="fas fa-users-slash"></i>
                    <p>Nenhum utilizador encontrado</p>
                    <small>Tente pesquisar por um nome diferente</small>
                </div>
            `;
            return;
        }
        
        container.innerHTML = users.map(user => `
            <div class="share-user-item ${this.selectedUsers.has(user.id) ? 'selected' : ''}">
                <input type="checkbox" 
                       class="share-user-checkbox" 
                       data-user-id="${user.id}"
                       ${this.selectedUsers.has(user.id) ? 'checked' : ''}>
                <img src="images/perfil/${user.foto_perfil || 'default-profile.jpg'}" 
                     alt="${user.nome_completo}" class="share-user-avatar">
                <div class="share-user-info">
                    <h4 class="share-user-name">${user.nome_completo}</h4>
                    <p class="share-user-nick">@${user.nick}</p>
                </div>
            </div>
        `).join('');
    }

    showLoading(show) {
        this.isLoading = show;
        const container = document.getElementById('shareUsersList');
        
        if (show) {
            container.innerHTML = `
                <div class="share-loading">
                    <i class="fas fa-spinner"></i>
                    Carregando utilizadores...
                </div>
            `;
        }
    }

    showError(message) {
        const container = document.getElementById('shareUsersList');
        container.innerHTML = `
            <div class="share-no-users">
                <i class="fas fa-exclamation-triangle"></i>
                <p>${message}</p>
                <small>Verifique sua conexão e tente novamente</small>
            </div>
        `;
    }

    handleUserSelection(checkbox) {
        const userId = parseInt(checkbox.dataset.userId);
        const userItem = checkbox.closest('.share-user-item');
        
        if (checkbox.checked) {
            this.selectedUsers.add(userId);
            userItem.classList.add('selected');
        } else {
            this.selectedUsers.delete(userId);
            userItem.classList.remove('selected');
        }
        
        this.updateSelectedCount();
    }

    updateSelectedCount() {
        const count = this.selectedUsers.size;
        const countElement = document.getElementById('shareSelectedCount');
        const sendButton = document.querySelector('.share-send-btn');
        
        countElement.textContent = `${count} utilizador${count !== 1 ? 'es' : ''} selecionado${count !== 1 ? 's' : ''}`;
        sendButton.disabled = count === 0;
    }

    async handleShare() {
        if (this.selectedUsers.size === 0 || !this.currentPostId) {
            return;
        }
        
        const sendButton = document.querySelector('.share-send-btn');
        const originalText = sendButton.innerHTML;
        
        try {
            // Mostrar loading
            sendButton.disabled = true;
            sendButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Partilhando...';
            
            const message = document.getElementById('shareMessage').value.trim();
            const userIds = Array.from(this.selectedUsers);
            
            // Criar link direto para a publicação
            const postLink = `${window.location.protocol}//${window.location.host}${window.location.pathname.replace(/\/[^\/]*$/, '')}/publicacao.php?id=${this.currentPostId}`;
            
            const formData = new FormData();
            formData.append('post_id', this.currentPostId);
            formData.append('user_ids', JSON.stringify(userIds));
            formData.append('message', message);
            formData.append('post_link', postLink); // Adicionar o link direto
            
            const response = await fetch('../backend/share_post.php', {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                this.showSuccessMessage(`Publicação partilhada com ${data.shared_count} utilizador${data.shared_count !== 1 ? 'es' : ''}!`);
                this.closeModal();
            } else {
                throw new Error(data.message || 'Erro ao partilhar publicação');
            }
            
        } catch (error) {
            console.error('Erro ao partilhar:', error);
            this.showErrorMessage(error.message || 'Erro ao partilhar publicação');
        } finally {
            // Restaurar botão
            sendButton.disabled = this.selectedUsers.size === 0;
            sendButton.innerHTML = originalText;
        }
    }

    showSuccessMessage(message) {
        this.showToast(message, 'success');
    }

    showErrorMessage(message) {
        this.showToast(message, 'error');
    }

    showToast(message, type = 'success') {
        // Verificar se existe uma função global de toast
        if (typeof showToast === 'function') {
            showToast(message);
            return;
        }
        
        // Criar toast simples se não existir
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: ${type === 'success' ? '#10b981' : '#ef4444'};
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            opacity: 0;
            transform: translateY(100px);
            transition: all 0.3s ease;
        `;
        toast.textContent = message;
        
        document.body.appendChild(toast);
        
        // Animar entrada
        setTimeout(() => {
            toast.style.opacity = '1';
            toast.style.transform = 'translateY(0)';
        }, 10);
        
        // Remover após 3 segundos
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(100px)';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }, 3000);
    }
}

// Função global para abrir o modal (compatibilidade com onclick)
function openShareModal(postId) {
    if (window.shareManager) {
        window.shareManager.openModal(postId);
    }
}

// Inicializar quando o DOM estiver pronto
document.addEventListener('DOMContentLoaded', function() {
    window.shareManager = new SharePostManager();
});

// Exportar para uso global
window.SharePostManager = SharePostManager;
window.openShareModal = openShareModal;