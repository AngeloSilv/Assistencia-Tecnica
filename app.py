from flask import Flask, request, jsonify, render_template, session
from flask_cors import CORS
from pyswip import Prolog
import secrets
import traceback
import unicodedata

app = Flask(__name__, template_folder='templates', static_folder='static')
app.secret_key = secrets.token_hex(16)

CORS(app)

prolog = Prolog()
prolog.consult('diagnostico.pl')

def normalize_str(s):
    # Função para normalizar a string removendo diferenças de codificação
    return unicodedata.normalize('NFC', s)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/diagnosticar', methods=['POST'])
def diagnosticar_route():
    try:
        data = request.get_json()
        user_message = data.get('message', '').strip()
        print("Mensagem do usuário:", user_message)

        # Inicializar a lista de respostas na sessão
        if 'respostas' not in session:
            session['respostas'] = {}
            print("Iniciando nova sessão.")

        print("Sessão antes do processamento:", dict(session))

        if 'pergunta_atual' in session and user_message != '':
            # O usuário está respondendo a uma pergunta
            pergunta = session['pergunta_atual']
            resposta = user_message.lower()
            print(f"Resposta à pergunta '{pergunta}': {resposta}")
            if resposta in ['sim', 's', 'yes', 'y']:
                session['respostas'][pergunta] = 'sim'
            elif resposta in ['não', 'nao', 'n', 'no']:
                session['respostas'][pergunta] = 'nao'
            else:
                # Resposta inválida, pedir novamente
                return jsonify({'type': 'question', 'message': f"Por favor, responda 'sim' ou 'não' à pergunta: {pergunta}"})
            session.modified = True
            del session['pergunta_atual']
        else:
            print("Iniciando o diagnóstico ou aguardando resposta.")

        # Limpar fatos anteriores no Prolog
        prolog.retractall('sim(_)')  # Remover todos os fatos 'sim'
        prolog.retractall('nao(_)')  # Remover todos os fatos 'nao'
        prolog.retractall('tipo_aparelho(_)')  # Remover o fato 'tipo_aparelho' se existir

        # Assertar as respostas atuais no Prolog
        for pergunta, resposta in session['respostas'].items():
            pergunta_norm = normalize_str(pergunta)
            # Escapar caracteres especiais na pergunta
            pergunta_escapada = pergunta_norm.replace("'", "\\'")
            # Asserta as respostas no Prolog, garantindo que strings sejam corretamente formatadas
            prolog.assertz(f"{resposta}('{pergunta_escapada}')")
            print(f"Assert no Prolog: {resposta}('{pergunta_escapada}')")

        # Tentar diagnosticar
        consulta = list(prolog.query('diagnosticar(Problema, PerguntasFaltantes)'))
        print("Resultado da consulta ao Prolog:", consulta)

        if consulta:
            resultado = consulta[0]
            PerguntasFaltantes = resultado['PerguntasFaltantes']
            if PerguntasFaltantes:
                # Converter PerguntasFaltantes para lista de strings, se necessário
                if not isinstance(PerguntasFaltantes, list):
                    PerguntasFaltantes = [PerguntasFaltantes.value]

                # Verificar se a próxima pergunta já foi respondida (possibilidade devido à inferência)
                for pergunta in PerguntasFaltantes:
                    pergunta_str = str(pergunta)
                    if pergunta_str not in session['respostas']:
                        session['pergunta_atual'] = pergunta_str
                        session.modified = True
                        print("Próxima pergunta:", pergunta_str)
                        return jsonify({'type': 'question', 'message': pergunta_str})
                # Se todas as perguntas pendentes já foram respondidas, tentar diagnosticar novamente
                return diagnosticar_route()
            else:
                # Diagnóstico concluído
                problema = resultado['Problema']
                print("Diagnóstico concluído:", problema)
                session.clear()
                return jsonify({'type': 'diagnosis', 'message': f'Possível problema identificado: {problema}'})
        else:
            # Nenhuma hipótese correspondeu; diagnóstico não encontrado
            print("Nenhuma hipótese correspondeu.")
            session.clear()
            return jsonify({'type': 'diagnosis', 'message': 'Desculpe, não foi possível identificar o problema.'})
    except Exception as e:
        print("Erro na rota /diagnosticar:", e)
        traceback.print_exc()
        session.clear()
        return jsonify({'type': 'error', 'message': 'Ocorreu um erro no servidor.'}), 500

@app.route('/encerrar', methods=['POST'])
def encerrar():
    session.clear()
    print("Conversa encerrada e sessão limpa.")
    return jsonify({'message': 'Sessão encerrada.'})

if __name__ == '__main__':
    app.run(debug=True)
