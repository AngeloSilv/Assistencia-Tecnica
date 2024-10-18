document.addEventListener('DOMContentLoaded', function() {
    enviarMensagem('Iniciar diagnóstico');
});

function adicionarMensagem(remetente, mensagem) {
    const chat = document.getElementById('chat');
    const novaMensagem = document.createElement('div');
    novaMensagem.classList.add(remetente);
    novaMensagem.innerText = mensagem;
    chat.appendChild(novaMensagem);
    chat.scrollTop = chat.scrollHeight;
}

function enviarMensagem(mensagem = null) {
    const input = document.getElementById('inputMensagem');
    if (!mensagem) {
        mensagem = input.value;
    }
    if (mensagem.trim() === '') return;

    adicionarMensagem('usuario', mensagem);
    input.value = '';

    console.log('Enviando mensagem para o servidor:', mensagem); // Log de depuração

    fetch('/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: mensagem })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Resposta do servidor:', data); // Log de depuração
        processarResposta(data);
    })
    .catch(error => {
        console.error('Erro:', error);
        adicionarMensagem('bot', 'Ocorreu um erro ao se comunicar com o servidor.');
    });
}

function processarResposta(data) {
    if (data.type === 'question') {
        adicionarMensagem('bot', data.message + '? (sim/nao)');
    } else if (data.type === 'diagnosis') {
        adicionarMensagem('bot', data.message);
    } else if (data.type === 'error') {
        adicionarMensagem('bot', data.message);
    }
}

// Iniciar o diagnóstico ao carregar a página
window.addEventListener('DOMContentLoaded', function() {
    fetch('/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: '' }) // Mensagem vazia para iniciar
    })
    .then(response => response.json())
    .then(data => {
        console.log('Resposta inicial do servidor:', data); // Log de depuração
        processarResposta(data);
    })
    .catch(error => {
        console.error('Erro:', error);
        adicionarMensagem('bot', 'Ocorreu um erro ao iniciar o diagnóstico.');
    });
});

document.getElementById('inputMensagem').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        enviarMensagem();
    }
});

document.getElementById('botaoEnviar').addEventListener('click', enviarMensagem);
