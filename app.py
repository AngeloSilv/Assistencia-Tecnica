from flask import Flask, request, jsonify, render_template
from pyswip import Prolog


app = Flask(__name__, template_folder='templates')

prolog = Prolog()
prolog.consult('diagnostico.pl')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/diagnosticar', methods=['POST'])
def diagnosticar():
    dados = request.get_json()
    perguntas = dados.get('perguntas', [])
    problema = 'Desconhecido'

    for pergunta in perguntas:
        prolog.assertz(f"sim('{pergunta}')")

    solucoes = list(prolog.query('diagnosticar(Problema)'))
    if solucoes:
        problema = solucoes[0]['Problema']

    return jsonify({'problema': problema})

if __name__ == '__main__':
    app.run(debug=True)