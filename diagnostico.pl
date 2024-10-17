% Definição de fatos dinâmicos para armazenar respostas do usuário
:- dynamic(sim/1).
:- dynamic(nao/1).

% Regra principal para iniciar o diagnóstico
diagnosticar :- 
    hipoteses(Problema),
    nl, write('Possível problema identificado: '), write(Problema), nl,
    limpar_respostas.
diagnosticar :- 
    nl, write('Desculpe, não foi possível identificar o problema.'), nl,
    limpar_respostas.

% Hipóteses de problemas e suas condições
hipoteses('Computador não está conectado à energia') :-
    verificar('O computador não liga'),
    verificar('Nenhuma luz ou som é emitido ao pressionar o botão de ligar'),
    verificar('O cabo de energia está desconectado').

hipoteses('Bateria do notebook descarregada') :-
    verificar('O notebook não liga'),
    verificar('O carregador não está conectado'),
    verificar('A bateria está descarregada').

hipoteses('Problema no sistema operacional') :-
    verificar('O computador liga mas não inicializa o sistema operacional'),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicialização').

hipoteses('Disco rígido com falhas') :-
    verificar('Arquivos demoram para abrir ou salvar'),
    verificar('Sons estranhos vêm do computador'),
    verificar('O sistema está lento ou travando').

hipoteses('Superaquecimento') :-
    verificar('O computador desliga sozinho após algum tempo de uso'),
    verificar('A parte inferior ou traseira do computador está muito quente'),
    verificar('Os ventiladores estão fazendo muito barulho').

hipoteses('Infecção por malware ou vírus') :-
    verificar('Pop-ups ou anúncios aparecem inesperadamente'),
    verificar('O navegador redireciona para sites desconhecidos'),
    verificar('Arquivos ou programas desapareceram ou foram modificados').

hipoteses('Problemas de driver de dispositivo') :-
    verificar('Dispositivos conectados não funcionam corretamente'),
    verificar('Atualizações recentes foram instaladas'),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos').

hipoteses('Conflito de software') :-
    verificar('Programas fecham inesperadamente'),
    verificar('Mensagens de erro ao abrir aplicativos'),
    verificar('O sistema está lento após a instalação de novo software').

hipoteses('Problemas de conexão de rede') :-
    verificar('Não é possível acessar a internet'),
    verificar('A conexão Wi-Fi está instável'),
    verificar('Outros dispositivos na mesma rede funcionam corretamente').

hipoteses('Memória RAM insuficiente ou defeituosa') :-
    verificar('O computador está muito lento'),
    verificar('Mensagens de erro sobre falta de memória'),
    verificar('O sistema reinicia ou trava aleatoriamente').

% Procedimento para perguntar ao usuário e armazenar respostas
perguntar(Pergunta) :- 
    format('~w? (sim/nao): ', [Pergunta]),
    read(Resposta),
    nl,
    ( (Resposta == sim ; Resposta == s)
    -> 
    assert(sim(Pergunta));
    assert(nao(Pergunta)), fail).

% Verifica se já existe uma resposta para a pergunta
verificar(S) :- 
    (sim(S) -> true ;
    (nao(S) -> fail ;
    perguntar(S))).

% Limpa as respostas armazenadas para uma nova sessão
limpar_respostas :- 
    retract(sim(_)), fail.
limpar_respostas :- 
    retract(nao(_)), fail.
limpar_respostas.