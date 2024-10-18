function adicionarMensagem(remetente, mensagem) {
    const chat = document.getElementById('chat');
    const novaMensagem = document.createElement('div');
    novaMensagem.classList.add(remetente);
    novaMensagem.innerText = mensagem;
    chat.appendChild(novaMensagem);
    chat.scrollTop = chat.scrollHeight; // Rolagem automática
}

function enviarMensagem() {
    const input = document.getElementById('inputMensagem');
    const mensagem = input.value;
    if (mensagem.trim() === '') return;

    adicionarMensagem('usuario', mensagem);
    input.value = '';

    fetch('/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: mensagem })
    })
    .then(response => response.json())
    .then(data => {
        if (data.type === 'question') {
            adicionarMensagem('bot', data.message + '? (sim/nao)');
        } else if (data.type === 'diagnosis') {
            adicionarMensagem('bot', data.message);
        }
    })
    .catch(error => console.error('Erro:', error));
}

document.getElementById('inputMensagem').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        enviarMensagem();
    }
});

document.getElementById('botaoEnviar').addEventListener('click', enviarMensagem);