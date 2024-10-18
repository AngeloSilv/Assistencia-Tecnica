:- dynamic(sim/1).
:- dynamic(nao/1).

% Regra principal para iniciar o diagnóstico
diagnosticar(Problema, PerguntasFaltantes) :-
    findall((P, PF), hipoteses(P, PF), Hipoteses),
    selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes).

% Seleciona a hipótese com o menor número de perguntas pendentes
selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes) :-
    sort(2, @=<, Hipoteses, Ordenadas),
    Ordenadas = [(Problema, PerguntasFaltantes) | _].

% Hipóteses de problemas e suas condições
hipoteses(Problema, PerguntasFaltantes) :-
    verificar_condicoes(Problema, Perguntas),
    coletar_pendentes(Perguntas, PerguntasFaltantes),
    (PerguntasFaltantes \= [] ; hipoteses_validas(Perguntas)).

% Verifica se todas as condições para uma hipótese são válidas
hipoteses_validas([]).
hipoteses_validas([(_, sim) | T]) :-
    hipoteses_validas(T).

% Definição das hipóteses e suas perguntas associadas
verificar_condicoes('Computador nao esta conectado a energia', [
    ('O computador nao liga', R1),
    ('Nenhuma luz ou som e emitido ao pressionar o botao de ligar', R2),
    ('O cabo de energia esta desconectado', R3)
]) :-
    verificar('O computador nao liga', R1),
    verificar('Nenhuma luz ou som e emitido ao pressionar o botao de ligar', R2),
    verificar('O cabo de energia esta desconectado', R3).

verificar_condicoes('Bateria do notebook descarregada', [
    ('O notebook nao liga', R1),
    ('O carregador nao esta conectado', R2),
    ('A bateria esta descarregada', R3)
]) :-
    verificar('O notebook nao liga', R1),
    verificar('O carregador nao esta conectado', R2),
    verificar('A bateria esta descarregada', R3).

verificar_condicoes('Problema no sistema operacional', [
    ('O computador liga mas nao inicializa o sistema operacional', R1),
    ('Aparece uma tela azul ou mensagem de erro durante a inicializacao', R2)
]) :-
    verificar('O computador liga mas nao inicializa o sistema operacional', R1),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicializacao', R2).

verificar_condicoes('Disco rigido com falhas', [
    ('Arquivos demoram para abrir ou salvar', R1),
    ('Sons estranhos vem do computador', R2),
    ('O sistema está lento ou travando', R3)
]) :-
    verificar('Arquivos demoram para abrir ou salvar', R1),
    verificar('Sons estranhos vem do computador', R2),
    verificar('O sistema está lento ou travando', R3).

verificar_condicoes('Superaquecimento', [
    ('O computador desliga sozinho apos algum tempo de uso', R1),
    ('A parte inferior ou traseira do computador esta muito quente', R2),
    ('Os ventiladores estao fazendo muito barulho', R3)
]) :-
    verificar('O computador desliga sozinho apos algum tempo de uso', R1),
    verificar('A parte inferior ou traseira do computador esta muito quente', R2),
    verificar('Os ventiladores estao fazendo muito barulho', R3).

verificar_condicoes('Infeccao por malware ou virus', [
    ('Pop-ups ou anuncios aparecem inesperadamente', R1),
    ('O navegador redireciona para sites desconhecidos', R2),
    ('Arquivos ou programas desapareceram ou foram modificados', R3)
]) :-
    verificar('Pop-ups ou anúncios aparecem inesperadamente', R1),
    verificar('O navegador redireciona para sites desconhecidos', R2),
    verificar('Arquivos ou programas desapareceram ou foram modificados', R3).

verificar_condicoes('Problemas de driver de dispositivo', [
    ('Dispositivos conectados nao funcionam corretamente', R1),
    ('Atualizaçoes recentes foram instaladas', R2),
    ('Mensagens de erro sobre drivers ausentes ou corrompidos', R3)
]) :-
    verificar('Dispositivos conectados nao funcionam corretamente', R1),
    verificar('Atualizaçoes recentes foram instaladas', R2),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos', R3).

verificar_condicoes('Conflito de software', [
    ('Programas fecham inesperadamente', R1),
    ('Mensagens de erro ao abrir aplicativos', R2),
    ('O sistema esta lento após a instalacao de novo software', R3)
]) :-
    verificar('Programas fecham inesperadamente', R1),
    verificar('Mensagens de erro ao abrir aplicativos', R2),
    verificar('O sistema está lento após a instalação de novo software', R3).

verificar_condicoes('Problemas de conexao de rede', [
    ('Nao e possível acessar a internet', R1),
    ('A conexão Wi-Fi está instavel', R2),
    ('Outros dispositivos na mesma rede funcionam corretamente', R3)
]) :-
    verificar('Nao e possível acessar a internet', R1),
    verificar('A conexao Wi-Fi está instavel', R2),
    verificar('Outros dispositivos na mesma rede funcionam corretamente', R3).

verificar_condicoes('Memoria RAM insuficiente ou defeituosa', [
    ('O computador esta muito lento', R1),
    ('Mensagens de erro sobre falta de memoria', R2),
    ('O sistema reinicia ou trava aleatoriamente', R3)
]) :-
    verificar('O computador esta muito lento', R1),
    verificar('Mensagens de erro sobre falta de memoria', R2),
    verificar('O sistema reinicia ou trava aleatoriamente', R3).

% Procedimento para verificar e coletar respostas
verificar(Pergunta, Resposta) :-
    (sim(Pergunta) -> Resposta = sim ;
     nao(Pergunta) -> Resposta = nao ;
     Resposta = pergunta(Pergunta)).

% Função auxiliar para coletar perguntas pendentes
coletar_pendentes([], []).
coletar_pendentes([(Pergunta, pergunta(Pergunta)) | T], [Pergunta | Rest]) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(_, Resposta) | T], Rest) :-
    Resposta \= pergunta(_),
    coletar_pendentes(T, Rest).

% Limpa as respostas armazenadas para uma nova sessão
limpar_respostas :-
    retractall(sim(_)),
    retractall(nao(_)).
