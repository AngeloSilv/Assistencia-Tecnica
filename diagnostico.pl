:- dynamic(sim/1).
:- dynamic(nao/1).
:- dynamic(tipo_aparelho/1).

% Regra principal para iniciar o diagnóstico
diagnosticar(Problema, PerguntasFaltantes) :-
    verificar('O aparelho é um notebook', R0),
    (R0 == pergunta('O aparelho é um notebook') ->
        PerguntasFaltantes = ['O aparelho é um notebook'];  % Adiciona a pergunta às perguntas faltantes
        (
            (R0 == sim -> asserta(tipo_aparelho(notebook)) ; asserta(tipo_aparelho(desktop))),
            findall((P, PF), hipoteses(P, PF), Hipoteses),
            selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes)
        )
    ).

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

% Hipóteses específicas para notebook ou desktop

% Hipótese para desktop: Computador não está conectado à energia
verificar_condicoes('Computador não está conectado à energia', [
    ('O aparelho é um notebook', R0),
    ('O computador não liga', R1),
    ('Nenhuma luz ou som eh emitido ao pressionar o botão de ligar', R2),
    ('O cabo de energia está desconectado', R3)
]) :-
    verificar('O aparelho é um notebook', R0),
    R0 == nao,
    verificar('O computador não liga', R1),
    verificar('Nenhuma luz ou som é emitido ao pressionar o botão de ligar', R2),
    verificar('O cabo de energia está desconectado', R3).

% Hipótese para notebook: Bateria do notebook descarregada
verificar_condicoes('Bateria do notebook descarregada', [
    ('O aparelho é um notebook', R0),
    ('O notebook não liga', R1),
    ('O carregador não está conectado', R2),
    ('A bateria está descarregada', R3)
]) :-
    verificar('O aparelho é um notebook', R0),
    R0 == sim,
    verificar('O notebook não liga', R1),
    verificar('O carregador não está conectado', R2),
    verificar('A bateria está descarregada', R3).

% Hipóteses comuns a ambos

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

% Novas hipóteses adicionadas

verificar_condicoes('Placa-mãe com defeito', [
    ('O computador não liga mesmo com energia conectada', R1),
    ('Nenhum componente interno recebe energia', R2),
    ('Nenhum sinal visual ou sonoro é emitido ao ligar', R3)
]) :-
    verificar('O computador não liga mesmo com energia conectada', R1),
    verificar('Nenhum componente interno recebe energia', R2),
    verificar('Nenhum sinal visual ou sonoro é emitido ao ligar', R3).

verificar_condicoes('Problema com a placa de vídeo', [
    ('O computador liga mas não exibe imagem na tela', R1),
    ('A tela fica preta ou com artefatos visuais', R2),
    ('O computador reinicia ao executar aplicativos gráficos', R3)
]) :-
    verificar('O computador liga mas não exibe imagem na tela', R1),
    verificar('A tela fica preta ou com artefatos visuais', R2),
    verificar('O computador reinicia ao executar aplicativos gráficos', R3).

verificar_condicoes('Falta de espaço em disco', [
    ('Não é possível instalar novos programas', R1),
    ('Mensagens de erro sobre espaço insuficiente', R2),
    ('O computador está lento ou travando', R3)
]) :-
    verificar('Não é possível instalar novos programas', R1),
    verificar('Mensagens de erro sobre espaço insuficiente', R2),
    verificar('O computador está lento ou travando', R3).

verificar_condicoes('Problema na BIOS ou UEFI', [
    ('O computador não passa da tela de inicialização', R1),
    ('Configurações de hardware não são reconhecidas', R2),
    ('Mensagens de erro durante o POST', R3)
]) :-
    verificar('O computador não passa da tela de inicialização', R1),
    verificar('Configurações de hardware não são reconhecidas', R2),
    verificar('Mensagens de erro durante o POST', R3).

% Procedimento para verificar e coletar respostas
verificar(Pergunta, Resposta) :-
    (sim(Pergunta) -> Resposta = sim ;
     nao(Pergunta) -> Resposta = nao ;
     Resposta = pergunta(Pergunta)).

% Função auxiliar para coletar perguntas pendentes
coletar_pendentes([], []).
coletar_pendentes([(_, sim)|T], Rest) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(_, nao)|T], Rest) :-
    coletar_pendentes(T, Rest).
coletar_pendentes([(Pergunta, pergunta(Pergunta)) | T], [Pergunta | Rest]) :-
    coletar_pendentes(T, Rest).

% Limpa as respostas armazenadas para uma nova sessão
limpar_respostas :-
    retractall(sim(_)),
    retractall(nao(_)),
    retractall(tipo_aparelho(_)).
