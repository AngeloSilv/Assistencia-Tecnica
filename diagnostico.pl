% Definição de fatos dinâmicos para armazenar respostas do usuário
:- dynamic(sim/1).
:- dynamic(nao/1).

% Regra principal para iniciar o diagnóstico
diagnosticar(Problema, PerguntasFaltantes) :-
    hipoteses(Problema, PerguntasFaltantes).

% Hipóteses de problemas e suas condições
hipoteses('Computador não está conectado à energia', PerguntasFaltantes) :-
    verificar('O computador não liga', R1),
    verificar('Nenhuma luz ou som é emitido ao pressionar o botão de ligar', R2),
    verificar('O cabo de energia está desconectado', R3),
    coletar_pendentes([('O computador não liga', R1),
                       ('Nenhuma luz ou som é emitido ao pressionar o botão de ligar', R2),
                       ('O cabo de energia está desconectado', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Bateria do notebook descarregada', PerguntasFaltantes) :-
    verificar('O notebook não liga', R1),
    verificar('O carregador não está conectado', R2),
    verificar('A bateria está descarregada', R3),
    coletar_pendentes([('O notebook não liga', R1),
                       ('O carregador não está conectado', R2),
                       ('A bateria está descarregada', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Problema no sistema operacional', PerguntasFaltantes) :-
    verificar('O computador liga mas não inicializa o sistema operacional', R1),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicialização', R2),
    coletar_pendentes([('O computador liga mas não inicializa o sistema operacional', R1),
                       ('Aparece uma tela azul ou mensagem de erro durante a inicialização', R2)], PerguntasFaltantes),
    R1 == sim, R2 == sim.

hipoteses('Disco rígido com falhas', PerguntasFaltantes) :-
    verificar('Arquivos demoram para abrir ou salvar', R1),
    verificar('Sons estranhos vêm do computador', R2),
    verificar('O sistema está lento ou travando', R3),
    coletar_pendentes([('Arquivos demoram para abrir ou salvar', R1),
                       ('Sons estranhos vêm do computador', R2),
                       ('O sistema está lento ou travando', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Superaquecimento', PerguntasFaltantes) :-
    verificar('O computador desliga sozinho após algum tempo de uso', R1),
    verificar('A parte inferior ou traseira do computador está muito quente', R2),
    verificar('Os ventiladores estão fazendo muito barulho', R3),
    coletar_pendentes([('O computador desliga sozinho após algum tempo de uso', R1),
                       ('A parte inferior ou traseira do computador está muito quente', R2),
                       ('Os ventiladores estão fazendo muito barulho', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Infecção por malware ou vírus', PerguntasFaltantes) :-
    verificar('Pop-ups ou anúncios aparecem inesperadamente', R1),
    verificar('O navegador redireciona para sites desconhecidos', R2),
    verificar('Arquivos ou programas desapareceram ou foram modificados', R3),
    coletar_pendentes([('Pop-ups ou anúncios aparecem inesperadamente', R1),
                       ('O navegador redireciona para sites desconhecidos', R2),
                       ('Arquivos ou programas desapareceram ou foram modificados', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Problemas de driver de dispositivo', PerguntasFaltantes) :-
    verificar('Dispositivos conectados não funcionam corretamente', R1),
    verificar('Atualizações recentes foram instaladas', R2),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos', R3),
    coletar_pendentes([('Dispositivos conectados não funcionam corretamente', R1),
                       ('Atualizações recentes foram instaladas', R2),
                       ('Mensagens de erro sobre drivers ausentes ou corrompidos', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Conflito de software', PerguntasFaltantes) :-
    verificar('Programas fecham inesperadamente', R1),
    verificar('Mensagens de erro ao abrir aplicativos', R2),
    verificar('O sistema está lento após a instalação de novo software', R3),
    coletar_pendentes([('Programas fecham inesperadamente', R1),
                       ('Mensagens de erro ao abrir aplicativos', R2),
                       ('O sistema está lento após a instalação de novo software', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Problemas de conexão de rede', PerguntasFaltantes) :-
    verificar('Não é possível acessar a internet', R1),
    verificar('A conexão Wi-Fi está instável', R2),
    verificar('Outros dispositivos na mesma rede funcionam corretamente', R3),
    coletar_pendentes([('Não é possível acessar a internet', R1),
                       ('A conexão Wi-Fi está instável', R2),
                       ('Outros dispositivos na mesma rede funcionam corretamente', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

hipoteses('Memória RAM insuficiente ou defeituosa', PerguntasFaltantes) :-
    verificar('O computador está muito lento', R1),
    verificar('Mensagens de erro sobre falta de memória', R2),
    verificar('O sistema reinicia ou trava aleatoriamente', R3),
    coletar_pendentes([('O computador está muito lento', R1),
                       ('Mensagens de erro sobre falta de memória', R2),
                       ('O sistema reinicia ou trava aleatoriamente', R3)], PerguntasFaltantes),
    R1 == sim, R2 == sim, R3 == sim.

% Procedimento para verificar e coletar respostas
verificar(Pergunta, Resposta) :-
    (sim(Pergunta) -> Resposta = sim ;
     nao(Pergunta) -> Resposta = nao ;
     Resposta = pergunta(Pergunta)).

% Função auxiliar para coletar perguntas pendentes
coletar_pendentes([], []).
coletar_pendentes([(Pergunta, pergunta(Pergunta)) | T], [Pergunta | Rest]) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(_, _) | T], Rest) :-
    coletar_pendentes(T, Rest).

% Limpa as respostas armazenadas para uma nova sessão
limpar_respostas :-
    retractall(sim(_)),
    retractall(nao(_)).
