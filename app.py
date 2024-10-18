from flask import Flask, request, jsonify, render_template, session
from pyswip import Prolog

app = Flask(__name__, template_folder='templates')
app.secret_key = 'sua_chave_secreta_aqui'

prolog = Prolog()
prolog.consult('diagnostico.pl')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/diagnosticar', methods=['POST'])
def diagnosticar():
    data = request.get_json()
    user_message = data.get('message')

    # Inicializar a lista de respostas na sessão
    if 'respostas' not in session:
        session['respostas'] = {}

    # Processar a mensagem do usuário
    if 'pergunta_atual' in session:
        # O usuário está respondendo a uma pergunta
        pergunta = session['pergunta_atual']
        resposta = user_message.lower()
        if resposta in ['sim', 's', 'yes', 'y']:
            session['respostas'][pergunta] = 'sim'
        else:
            session['respostas'][pergunta] = 'nao'
        del session['pergunta_atual']
    else:
        # O usuário está iniciando a conversa ou descrevendo o problema
        # Podemos armazenar a descrição inicial se necessário
        pass

    # Limpar fatos anteriores no Prolog
    prolog.retractall('sim(_)')  # Remover todos os fatos 'sim'
    prolog.retractall('nao(_)')  # Remover todos os fatos 'nao'

    # Assertar as respostas atuais no Prolog
    for pergunta, resposta in session['respostas'].items():
        prolog.assertz(f"{resposta}('{pergunta}')")

    # Tentar diagnosticar
    consulta = list(prolog.query('diagnosticar(Problema, PerguntasFaltantes)'))

    if consulta:
        resultado = consulta[0]
        if resultado['PerguntasFaltantes']:
            # Há perguntas pendentes
            proxima_pergunta = resultado['PerguntasFaltantes'][0]
            session['pergunta_atual'] = proxima_pergunta
            return jsonify({'type': 'question', 'message': proxima_pergunta})
        else:
            # Diagnóstico concluído
            session.clear()
            problema = resultado['Problema']
            return jsonify({'type': 'diagnosis', 'message': f'Possível problema identificado: {problema}'})
    else:
        # Nenhuma hipótese correspondeu; diagnóstico não encontrado
        session.clear()
        return jsonify({'type': 'diagnosis', 'message': 'Desculpe, não foi possível identificar o problema.'})

if __name__ == '__main__':
    app.run(debug=True)