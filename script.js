function enviarPergunta() {
    const pergunta = document.getElementById('inputPergunta').value;
    
    fetch('http://localhost:5000/diagnosticar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ perguntas: [pergunta] })
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('resposta').innerText = 'Possível problema: ' + data.problema;
    })
    .catch(error => console.error('Erro:', error));
}
