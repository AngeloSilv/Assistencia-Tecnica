// Esconde elementos
document.getElementById('botaoEncerrar').style.display = 'none';
document.querySelector('.search-bar').style.display = 'none';

//Iniciar conversa
document.getElementById('iniciarConversa').addEventListener('click', function () {
    document.getElementById('iniciarConversa').style.display = 'none'; 
    document.getElementById('chatContainer').style.display = 'flex'; 
    document.getElementById('botaoEncerrar').style.display = 'block'; 
    document.querySelector('.search-bar').style.display = 'block'; 

    iniciarDiagnostico();
});

// Evento para encerrar a conversa
document.getElementById('botaoEncerrar').addEventListener('click', function () {
    document.getElementById('chatContainer').style.display = 'none'; 
    document.getElementById('iniciarConversa').style.display = 'block'; 
    document.getElementById('inputMensagem').value = ''; 
    document.getElementById('chat').innerHTML = ''; 
    document.getElementById('botaoEncerrar').style.display = 'none'; 
    document.querySelector('.search-bar').style.display = 'none'; 
    document.getElementById('inputPesquisa').value = ''; 

    // Encerrar a sessão no servidor
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

// Função para adicionar mensagens
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

// Evento de envio com Enter
document.getElementById('inputMensagem').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        enviarMensagem();
    }
});

// Evento de envio "Enviar"
document.getElementById('botaoEnviar').addEventListener('click', function () {
    enviarMensagem();
});

// Função para pesquisar
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
