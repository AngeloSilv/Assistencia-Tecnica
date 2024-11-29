// Esconde elementos inicialmente
document.getElementById('botaoEncerrar').style.display = 'none';
document.querySelector('.search-bar').style.display = 'none';

// Função para exibir o chat ao clicar no botão "Iniciar conversa"
document.getElementById('iniciarConversa').addEventListener('click', function () {
    document.getElementById('iniciarConversa').style.display = 'none'; // Esconde o botão
    document.getElementById('chatContainer').style.display = 'flex'; // Exibe o chat
    document.getElementById('botaoEncerrar').style.display = 'block'; // Mostra o botão "Encerrar conversa"
    document.querySelector('.search-bar').style.display = 'block'; // Mostra a barra de pesquisa

    // Iniciar o diagnóstico sem enviar mensagem do usuário
    iniciarDiagnostico();
});

// Evento para encerrar a conversa
document.getElementById('botaoEncerrar').addEventListener('click', function () {
    document.getElementById('chatContainer').style.display = 'none'; // Esconde o chat
    document.getElementById('iniciarConversa').style.display = 'block'; // Mostra o botão "Iniciar conversa"
    document.getElementById('inputMensagem').value = ''; // Limpa o campo de mensagem
    document.getElementById('chat').innerHTML = ''; // Limpa o conteúdo do chat
    document.getElementById('botaoEncerrar').style.display = 'none'; // Esconde o botão "Encerrar conversa"
    document.querySelector('.search-bar').style.display = 'none'; // Esconde a barra de pesquisa
    document.getElementById('inputPesquisa').value = ''; // Limpa o campo de pesquisa

    // Enviar requisição para encerrar a sessão no servidor
    fetch('/encerrar', {
        method: 'POST',
    })
    .then(response => response.json())
    .then(data => {
        console.log(data.message);
    })
    .catch(error => {
        console.error('Erro ao encerrar a sessão:', error);
    });
});

// Função para adicionar mensagens ao chat
function adicionarMensagem(remetente, mensagem) {
    const chat = document.getElementById('chat');
    const novaMensagem = document.createElement('div');
    novaMensagem.classList.add(remetente);
    novaMensagem.innerText = mensagem;
    chat.appendChild(novaMensagem);
    chat.scrollTop = chat.scrollHeight;
}

// Função para enviar mensagens
function enviarMensagem(mensagem = null) {
    const input = document.getElementById('inputMensagem');
    if (!mensagem) {
        mensagem = input.value;
    }
    if (mensagem.trim() === '') return;

    adicionarMensagem('usuario', mensagem);
    input.value = '';

    console.log('Enviando mensagem para o servidor:', mensagem);

    fetch('/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json;charset=UTF-8' },
        body: JSON.stringify({ message: mensagem })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Resposta do servidor:', data);
        processarResposta(data);
    })
    .catch(error => {
        console.error('Erro:', error);
        adicionarMensagem('bot', 'Ocorreu um erro ao se comunicar com o servidor.');
    });
}

// Função para processar a resposta do servidor
function processarResposta(data) {
    if (data.type === 'question') {
        adicionarMensagem('bot', data.message + ' (sim / não)');
    } else if (data.type === 'diagnosis') {
        adicionarMensagem('bot', data.message);
    } else if (data.type === 'error') {
        adicionarMensagem('bot', data.message);
    }
}

// Função para iniciar o diagnóstico
function iniciarDiagnostico() {
    fetch('/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json;charset=UTF-8' },
        body: JSON.stringify({ message: '' })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Resposta inicial do servidor:', data);
        processarResposta(data);
    })
    .catch(error => {
        console.error('Erro:', error);
        adicionarMensagem('bot', 'Ocorreu um erro ao iniciar o diagnóstico.');
    });
}

// Evento de envio com Enter no campo de mensagem
document.getElementById('inputMensagem').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        enviarMensagem();
    }
});

// Evento de envio com clique no botão "Enviar"
document.getElementById('botaoEnviar').addEventListener('click', function () {
    enviarMensagem();
});

// Função para pesquisar mensagens do bot
function pesquisarMensagens() {
    const termo = document.getElementById('inputPesquisa').value.toLowerCase();
    const mensagensBot = document.querySelectorAll('#chat .bot');

    mensagensBot.forEach(msg => {
        msg.classList.remove('highlight');
        if (msg.innerText.toLowerCase().includes(termo) && termo !== '') {
            msg.classList.add('highlight');
        }
    });
}

// Evento de pesquisa no campo de pesquisa
document.getElementById('inputPesquisa').addEventListener('input', function () {
    pesquisarMensagens();
});
