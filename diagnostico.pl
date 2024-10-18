% Definição de fatos dinâmicos para armazenar respostas do usuário
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
verificar_condicoes('Computador não está conectado à energia', [
    ('O computador não liga', R1),
    ('Nenhuma luz ou som é emitido ao pressionar o botão de ligar', R2),
    ('O cabo de energia está desconectado', R3)
]) :-
    verificar('O computador não liga', R1),
    verificar('Nenhuma luz ou som é emitido ao pressionar o botão de ligar', R2),
    verificar('O cabo de energia está desconectado', R3).

verificar_condicoes('Bateria do notebook descarregada', [
    ('O notebook não liga', R1),
    ('O carregador não está conectado', R2),
    ('A bateria está descarregada', R3)
]) :-
    verificar('O notebook não liga', R1),
    verificar('O carregador não está conectado', R2),
    verificar('A bateria está descarregada', R3).

verificar_condicoes('Problema no sistema operacional', [
    ('O computador liga mas não inicializa o sistema operacional', R1),
    ('Aparece uma tela azul ou mensagem de erro durante a inicialização', R2)
]) :-
    verificar('O computador liga mas não inicializa o sistema operacional', R1),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicialização', R2).

verificar_condicoes('Disco rígido com falhas', [
    ('Arquivos demoram para abrir ou salvar', R1),
    ('Sons estranhos vêm do computador', R2),
    ('O sistema está lento ou travando', R3)
]) :-
    verificar('Arquivos demoram para abrir ou salvar', R1),
    verificar('Sons estranhos vêm do computador', R2),
    verificar('O sistema está lento ou travando', R3).

verificar_condicoes('Superaquecimento', [
    ('O computador desliga sozinho após algum tempo de uso', R1),
    ('A parte inferior ou traseira do computador está muito quente', R2),
    ('Os ventiladores estão fazendo muito barulho', R3)
]) :-
    verificar('O computador desliga sozinho após algum tempo de uso', R1),
    verificar('A parte inferior ou traseira do computador está muito quente', R2),
    verificar('Os ventiladores estão fazendo muito barulho', R3).

verificar_condicoes('Infecção por malware ou vírus', [
    ('Pop-ups ou anúncios aparecem inesperadamente', R1),
    ('O navegador redireciona para sites desconhecidos', R2),
    ('Arquivos ou programas desapareceram ou foram modificados', R3)
]) :-
    verificar('Pop-ups ou anúncios aparecem inesperadamente', R1),
    verificar('O navegador redireciona para sites desconhecidos', R2),
    verificar('Arquivos ou programas desapareceram ou foram modificados', R3).

verificar_condicoes('Problemas de driver de dispositivo', [
    ('Dispositivos conectados não funcionam corretamente', R1),
    ('Atualizações recentes foram instaladas', R2),
    ('Mensagens de erro sobre drivers ausentes ou corrompidos', R3)
]) :-
    verificar('Dispositivos conectados não funcionam corretamente', R1),
    verificar('Atualizações recentes foram instaladas', R2),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos', R3).

verificar_condicoes('Conflito de software', [
    ('Programas fecham inesperadamente', R1),
    ('Mensagens de erro ao abrir aplicativos', R2),
    ('O sistema está lento após a instalação de novo software', R3)
]) :-
    verificar('Programas fecham inesperadamente', R1),
    verificar('Mensagens de erro ao abrir aplicativos', R2),
    verificar('O sistema está lento após a instalação de novo software', R3).

verificar_condicoes('Problemas de conexão de rede', [
    ('Não é possível acessar a internet', R1),
    ('A conexão Wi-Fi está instável', R2),
    ('Outros dispositivos na mesma rede funcionam corretamente', R3)
]) :-
    verificar('Não é possível acessar a internet', R1),
    verificar('A conexão Wi-Fi está instável', R2),
    verificar('Outros dispositivos na mesma rede funcionam corretamente', R3).

verificar_condicoes('Memória RAM insuficiente ou defeituosa', [
    ('O computador está muito lento', R1),
    ('Mensagens de erro sobre falta de memória', R2),
    ('O sistema reinicia ou trava aleatoriamente', R3)
]) :-
    verificar('O computador está muito lento', R1),
    verificar('Mensagens de erro sobre falta de memória', R2),
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
