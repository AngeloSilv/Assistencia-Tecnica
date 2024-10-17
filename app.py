from flask import Flask, request, jsonify
from pyswip import Prolog

app = Flask(__name__)
prolog = Prolog()
prolog.consult('diagnostico.pl')  # Carrega o arquivo Prolog

@app.route('/diagnosticar', methods=['POST'])
def diagnosticar():
    dados = request.get_json()  # Obtém os dados do frontend
    perguntas = dados.get('perguntas', [])
    problema = 'Desconhecido'
    
    # Para cada pergunta, adiciona ao Prolog como fato
    for pergunta in perguntas:
        prolog.assertz(f"sim('{pergunta}')")
    
    # Consulta o Prolog para obter o problema diagnosticado
    solucoes = list(prolog.query('diagnosticar(Problema)'))
    if solucoes:
        problema = solucoes[0]['Problema']
    
    return jsonify({'problema': problema})  # Retorna o diagnóstico

if __name__ == '__main__':
    app.run(debug=True)
