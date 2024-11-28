:- dynamic(sim/1).
:- dynamic(nao/1).
:- dynamic(tipo_aparelho/1).

% Regra principal para iniciar o diagnostico
diagnosticar(Problema, PerguntasFaltantes) :-
    verificar('O aparelho e um notebook', R0),
    (R0 == pergunta('O aparelho e um notebook') ->
        PerguntasFaltantes = ['O aparelho e um notebook'];  % Adiciona a pergunta as perguntas faltantes
        (
            (R0 == sim -> asserta(tipo_aparelho(notebook)) ; asserta(tipo_aparelho(desktop))),
            findall((P, PF), hipoteses(P, PF), Hipoteses),
            selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes)
        )
    ).

% Seleciona a hipotese com o menor numero de perguntas pendentes
selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes) :-
    sort(2, @=<, Hipoteses, Ordenadas),
    Ordenadas = [(Problema, PerguntasFaltantes) | _].

% Hipoteses de problemas e suas condicoes
hipoteses(Problema, PerguntasFaltantes) :-
    verificar_condicoes(Problema, Perguntas),
    coletar_pendentes(Perguntas, PerguntasFaltantes),
    (PerguntasFaltantes \= [] ; hipoteses_validas(Perguntas)).

% Verifica se todas as condicoes para uma hipotese sao validas
hipoteses_validas([]).
hipoteses_validas([(_, sim) | T]) :-
    hipoteses_validas(T).

% Definicao das hipoteses e suas perguntas associadas

% Hipoteses especificas para notebook ou desktop

% Hipotese para desktop: Computador nao esta conectado a energia
verificar_condicoes('Computador nao esta conectado a energia', [
    ('O aparelho e um notebook', R0),
    ('O computador nao liga', R1),
    ('Nenhuma luz ou som eh emitido ao pressionar o botao de ligar', R2),
    ('O cabo de energia esta desconectado', R3)
]) :-
    verificar('O aparelho e um notebook', R0),
    R0 == nao,
    verificar('O computador nao liga', R1),
    verificar('Nenhuma luz ou som eh emitido ao pressionar o botao de ligar', R2),
    verificar('O cabo de energia esta desconectado', R3).

% Hipotese para notebook: Bateria do notebook descarregada
verificar_condicoes('Bateria do notebook descarregada', [
    ('O aparelho e um notebook', R0),
    ('O notebook nao liga', R1),
    ('O carregador nao esta conectado', R2),
    ('A bateria esta descarregada', R3)
]) :-
    verificar('O aparelho e um notebook', R0),
    R0 == sim,
    verificar('O notebook nao liga', R1),
    verificar('O carregador nao esta conectado', R2),
    verificar('A bateria esta descarregada', R3).

% Hipoteses comuns a ambos

verificar_condicoes('Problema no sistema operacional', [
    ('O computador liga mas nao inicializa o sistema operacional', R1),
    ('Aparece uma tela azul ou mensagem de erro durante a inicializacao', R2)
]) :-
    verificar('O computador liga mas nao inicializa o sistema operacional', R1),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicializacao', R2).

verificar_condicoes('Disco rigido com falhas', [
    ('Arquivos demoram para abrir ou salvar', R1),
    ('Sons estranhos vem do computador', R2),
    ('O sistema esta lento ou travando', R3)
]) :-
    verificar('Arquivos demoram para abrir ou salvar', R1),
    verificar('Sons estranhos vem do computador', R2),
    verificar('O sistema esta lento ou travando', R3).

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
    verificar('Pop-ups ou anuncios aparecem inesperadamente', R1),
    verificar('O navegador redireciona para sites desconhecidos', R2),
    verificar('Arquivos ou programas desapareceram ou foram modificados', R3).

verificar_condicoes('Problemas de driver de dispositivo', [
    ('Dispositivos conectados nao funcionam corretamente', R1),
    ('Atualizacoes recentes foram instaladas', R2),
    ('Mensagens de erro sobre drivers ausentes ou corrompidos', R3)
]) :-
    verificar('Dispositivos conectados nao funcionam corretamente', R1),
    verificar('Atualizacoes recentes foram instaladas', R2),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos', R3).

verificar_condicoes('Conflito de software', [
    ('Programas fecham inesperadamente', R1),
    ('Mensagens de erro ao abrir aplicativos', R2),
    ('O sistema esta lento apos a instalacao de novo software', R3)
]) :-
    verificar('Programas fecham inesperadamente', R1),
    verificar('Mensagens de erro ao abrir aplicativos', R2),
    verificar('O sistema esta lento apos a instalacao de novo software', R3).

verificar_condicoes('Problemas de conexao de rede', [
    ('Nao e possivel acessar a internet', R1),
    ('A conexao Wi-Fi esta instavel', R2),
    ('Outros dispositivos na mesma rede funcionam corretamente', R3)
]) :-
    verificar('Nao e possivel acessar a internet', R1),
    verificar('A conexao Wi-Fi esta instavel', R2),
    verificar('Outros dispositivos na mesma rede funcionam corretamente', R3).

verificar_condicoes('Memoria RAM insuficiente ou defeituosa', [
    ('O computador esta muito lento', R1),
    ('Mensagens de erro sobre falta de memoria', R2),
    ('O sistema reinicia ou trava aleatoriamente', R3)
]) :-
    verificar('O computador esta muito lento', R1),
    verificar('Mensagens de erro sobre falta de memoria', R2),
    verificar('O sistema reinicia ou trava aleatoriamente', R3).

% Novas hipoteses adicionadas

verificar_condicoes('Placa-mae com defeito', [
    ('O computador nao liga mesmo com energia conectada', R1),
    ('Nenhum componente interno recebe energia', R2),
    ('Nenhum sinal visual ou sonoro e emitido ao ligar', R3)
]) :-
    verificar('O computador nao liga mesmo com energia conectada', R1),
    verificar('Nenhum componente interno recebe energia', R2),
    verificar('Nenhum sinal visual ou sonoro e emitido ao ligar', R3).

verificar_condicoes('Problema com a placa de video', [
    ('O computador liga mas nao exibe imagem na tela', R1),
    ('A tela fica preta ou com artefatos visuais', R2),
    ('O computador reinicia ao executar aplicativos graficos', R3)
]) :-
    verificar('O computador liga mas nao exibe imagem na tela', R1),
    verificar('A tela fica preta ou com artefatos visuais', R2),
    verificar('O computador reinicia ao executar aplicativos graficos', R3).

verificar_condicoes('Falta de espaco em disco', [
    ('Nao e possivel instalar novos programas', R1),
    ('Mensagens de erro sobre espaco insuficiente', R2),
    ('O computador esta lento ou travando', R3)
]) :-
    verificar('Nao e possivel instalar novos programas', R1),
    verificar('Mensagens de erro sobre espaco insuficiente', R2),
    verificar('O computador esta lento ou travando', R3).

verificar_condicoes('Problema na BIOS ou UEFI', [
    ('O computador nao passa da tela de inicializacao', R1),
    ('Configuracoes de hardware nao sao reconhecidas', R2),
    ('Mensagens de erro durante o POST', R3)
]) :-
    verificar('O computador nao passa da tela de inicializacao', R1),
    verificar('Configuracoes de hardware nao sao reconhecidas', R2),
    verificar('Mensagens de erro durante o POST', R3).

% Procedimento para verificar e coletar respostas
verificar(Pergunta, Resposta) :-
    (sim(Pergunta) -> Resposta = sim ;
     nao(Pergunta) -> Resposta = nao ;
     Resposta = pergunta(Pergunta)).

% Funcao auxiliar para coletar perguntas pendentes
coletar_pendentes([], []).
coletar_pendentes([(_, sim)|T], Rest) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(_, nao)|T], Rest) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(Pergunta, pergunta(Pergunta)) | T], [Pergunta | Rest]) :-
    coletar_pendentes(T, Rest).

% Limpa as respostas armazenadas para uma nova sessao
limpar_respostas :-
    retractall(sim(_)),
    retractall(nao(_)),
    retractall(tipo_aparelho(_)).