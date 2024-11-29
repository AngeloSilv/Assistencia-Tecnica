
:- encoding(utf8).

:- dynamic(sim/1).
:- dynamic(nao/1).
:- dynamic(tipo_aparelho/1).

diagnosticar(Problema, PerguntasFaltantes) :-
    verificar('O aparelho é um notebook?', R0),
    (R0 == pergunta('O aparelho é um notebook?') ->
        PerguntasFaltantes = ['O aparelho é um notebook?']
    ;
        (
            (R0 == sim -> asserta(tipo_aparelho(notebook)) ; asserta(tipo_aparelho(desktop))),
            verificar_consistencia,  
            findall((P, PF, V), hipoteses(P, PF, V), Hipoteses),
            selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes)
        )
    ).

selecionar_hipotese(Hipoteses, Problema, PerguntasFaltantes) :-
    map_list_to_pairs(hyp_key, Hipoteses, KeyedHipoteses),
    keysort(KeyedHipoteses, SortedKeyedHipoteses),
    pairs_values(SortedKeyedHipoteses, Ordenadas),
    member((Problema, PerguntasFaltantes, Valid), Ordenadas),
    (Valid == true -> true ; (PerguntasFaltantes \= [] -> true ; fail)).

hyp_key((_, PerguntasFaltantes, Valid), Key) :-
    length(PerguntasFaltantes, N),
    (Valid == true -> V = 0 ; V = 1),
    Key = (V, N).

hipoteses(Problema, PerguntasFaltantes, Valid) :-
    verificar_condicoes(Problema, Perguntas),
    coletar_pendentes(Perguntas, PerguntasFaltantes),
    (PerguntasFaltantes == [] ->
        (hipoteses_validas(Perguntas) -> Valid = true ; Valid = false)
    ;
        Valid = false).

hipoteses_validas([]).
hipoteses_validas([(_, sim)|T]) :-
    hipoteses_validas(T).
hipoteses_validas([(_, nao)|_]) :-
    fail.

verificar_condicoes('Computador não está conectado à energia', [
    ('O computador não liga?', R1),
    ('O cabo de energia está desconectado?', R2),
    ('Ao pressionar o botão de ligar, nenhuma luz acende ou som é emitido?', R3)
]) :-
    tipo_aparelho(desktop),
    verificar('O computador não liga?', R1),
    verificar('O cabo de energia está desconectado?', R2),
    verificar('Ao pressionar o botão de ligar, nenhuma luz acende ou som é emitido?', R3).

verificar_condicoes('Bateria do notebook descarregada', [
    ('O notebook não liga?', R1),
    ('O carregador não está conectado?', R2),
    ('A bateria está descarregada?', R3)
]) :-
    tipo_aparelho(notebook),
    verificar('O notebook não liga?', R1),
    verificar('O carregador não está conectado?', R2),
    verificar('A bateria está descarregada?', R3).

% Hipóteses comuns a ambos

verificar_condicoes('Problema no sistema operacional', [
    ('O computador liga?', R0),
    ('O computador liga, mas não inicia o sistema operacional?', R1),
    ('Aparece uma tela azul ou mensagem de erro durante a inicialização?', R2)
]) :-
    verificar('O computador liga?', R0),
    verificar('O computador liga, mas não inicia o sistema operacional?', R1),
    verificar('Aparece uma tela azul ou mensagem de erro durante a inicialização?', R2).

verificar_condicoes('Disco rígido com falhas', [
    ('Os arquivos demoram para abrir ou salvar?', R1),
    ('Você ouve sons estranhos vindo do computador?', R2),
    ('O sistema está lento ou travando frequentemente?', R3)
]) :-
    verificar('Os arquivos demoram para abrir ou salvar?', R1),
    verificar('Você ouve sons estranhos vindo do computador?', R2),
    verificar('O sistema está lento ou travando frequentemente?', R3).

verificar_condicoes('Superaquecimento', [
    ('O computador desliga sozinho após algum tempo de uso?', R1),
    ('A parte inferior ou traseira do computador está muito quente?', R2),
    ('Os ventiladores estão fazendo muito barulho?', R3)
]) :-
    verificar('O computador desliga sozinho após algum tempo de uso?', R1),
    verificar('A parte inferior ou traseira do computador está muito quente?', R2),
    verificar('Os ventiladores estão fazendo muito barulho?', R3).

verificar_condicoes('Infecção por malware ou vírus', [
    ('Pop-ups ou anúncios aparecem inesperadamente?', R1),
    ('O navegador redireciona para sites desconhecidos?', R2),
    ('Arquivos ou programas sumiram ou mudaram sem você ter feito isso?', R3)
]) :-
    verificar('Pop-ups ou anúncios aparecem inesperadamente?', R1),
    verificar('O navegador redireciona para sites desconhecidos?', R2),
    verificar('Arquivos ou programas sumiram ou mudaram sem você ter feito isso?', R3).

verificar_condicoes('Problemas de driver de dispositivo', [
    ('Dispositivos conectados não funcionam corretamente?', R1),
    ('Você instalou atualizações recentes?', R2),
    ('Mensagens de erro sobre drivers ausentes ou corrompidos aparecem?', R3)
]) :-
    verificar('Dispositivos conectados não funcionam corretamente?', R1),
    verificar('Você instalou atualizações recentes?', R2),
    verificar('Mensagens de erro sobre drivers ausentes ou corrompidos aparecem?', R3).

verificar_condicoes('Conflito de software', [
    ('Programas fecham inesperadamente?', R1),
    ('Mensagens de erro aparecem ao abrir aplicativos?', R2),
    ('O sistema ficou lento após a instalação de um novo software?', R3)
]) :-
    verificar('Programas fecham inesperadamente?', R1),
    verificar('Mensagens de erro aparecem ao abrir aplicativos?', R2),
    verificar('O sistema ficou lento após a instalação de um novo software?', R3).

verificar_condicoes('Problemas de conexão de rede', [
    ('Não é possível acessar a internet?', R1),
    ('A conexão Wi-Fi está instável?', R2),
    ('Outros dispositivos na mesma rede funcionam corretamente?', R3)
]) :-
    verificar('Não é possível acessar a internet?', R1),
    verificar('A conexão Wi-Fi está instável?', R2),
    verificar('Outros dispositivos na mesma rede funcionam corretamente?', R3).

verificar_condicoes('Memória RAM insuficiente ou defeituosa', [
    ('O computador está muito lento?', R1),
    ('Mensagens de erro sobre falta de memória aparecem?', R2),
    ('O sistema reinicia ou trava aleatoriamente?', R3)
]) :-
    verificar('O computador está muito lento?', R1),
    verificar('Mensagens de erro sobre falta de memória aparecem?', R2),
    verificar('O sistema reinicia ou trava aleatoriamente?', R3).

verificar_condicoes('Placa-mãe com defeito', [
    ('O computador não liga?', R1),
    ('Nenhum componente interno recebe energia?', R2),
    ('Ao ligar, nenhum sinal visual ou sonoro é emitido?', R3)
]) :-
    verificar('O computador não liga?', R1),
    verificar('Nenhum componente interno recebe energia?', R2),
    verificar('Ao ligar, nenhum sinal visual ou sonoro é emitido?', R3).

verificar_condicoes('Problema com a placa de vídeo', [
    ('O computador liga?', R0),
    ('O computador liga, mas não exibe imagem na tela?', R1),
    ('A tela fica preta ou com distorções visuais?', R2),
    ('O computador reinicia ao executar aplicativos gráficos?', R3)
]) :-
    verificar('O computador liga?', R0),
    verificar('O computador liga, mas não exibe imagem na tela?', R1),
    verificar('A tela fica preta ou com distorções visuais?', R2),
    verificar('O computador reinicia ao executar aplicativos gráficos?', R3).

verificar_condicoes('Falta de espaço em disco', [
    ('Não é possível instalar novos programas?', R1),
    ('Mensagens de erro sobre espaço insuficiente aparecem?', R2),
    ('O computador está lento ou travando?', R3)
]) :-
    verificar('Não é possível instalar novos programas?', R1),
    verificar('Mensagens de erro sobre espaço insuficiente aparecem?', R2),
    verificar('O computador está lento ou travando?', R3).

verificar_condicoes('Problema na BIOS ou UEFI', [
    ('O computador não passa da tela de inicialização?', R1),
    ('Configurações de hardware não são reconhecidas?', R2),
    ('Mensagens de erro aparecem durante o POST?', R3)
]) :-
    verificar('O computador não passa da tela de inicialização?', R1),
    verificar('Configurações de hardware não são reconhecidas?', R2),
    verificar('Mensagens de erro aparecem durante o POST?', R3).


verificar(Pergunta, Resposta) :-
    inferir_resposta(Pergunta, RespostaInferida),
    (RespostaInferida \= desconhecido ->
        (
            Resposta = RespostaInferida,
            (Resposta = sim -> asserta(sim(Pergunta)) ;
             Resposta = nao -> asserta(nao(Pergunta)))
        )
    ;
        (sim(Pergunta) -> Resposta = sim ;
         nao(Pergunta) -> Resposta = nao ;
         Resposta = pergunta(Pergunta))
    ).



coletar_pendentes([], []).

coletar_pendentes([(_, Resposta)|T], Rest) :-
    (Resposta = sim ; Resposta = nao),
    coletar_pendentes(T, Rest).


coletar_pendentes([(Pergunta, pergunta(Pergunta))|T], [Pergunta|Rest]) :-
    coletar_pendentes(T, Rest).

inferir_resposta('O computador liga?', Resposta) :-
    sim('O computador não liga?'),
    Resposta = nao.

inferir_resposta('O computador liga?', Resposta) :-
    nao('O computador não liga?'),
    Resposta = sim.

inferir_resposta('O computador não liga?', Resposta) :-
    sim('O computador liga?'),
    Resposta = nao.

inferir_resposta('O computador não liga?', Resposta) :-
    nao('O computador liga?'),
    Resposta = sim.


inferir_resposta('O computador liga?', Resposta) :-
    tipo_aparelho(notebook),
    sim('O notebook não liga?'),
    Resposta = nao.

inferir_resposta('O computador liga?', Resposta) :-
    tipo_aparelho(notebook),
    nao('O notebook não liga?'),
    Resposta = sim.

inferir_resposta('O computador não liga?', Resposta) :-
    tipo_aparelho(notebook),
    sim('O notebook não liga?'),
    Resposta = sim.

inferir_resposta('O computador não liga?', Resposta) :-
    tipo_aparelho(notebook),
    nao('O notebook não liga?'),
    Resposta = nao.


inferir_resposta('O notebook não liga?', Resposta) :-
    tipo_aparelho(notebook),
    sim('O computador não liga?'),
    Resposta = sim.

inferir_resposta('O notebook não liga?', Resposta) :-
    tipo_aparelho(notebook),
    nao('O computador não liga?'),
    Resposta = nao.

% Inferências adicionais existentes

inferir_resposta('O cabo de energia está desconectado?', Resposta) :-
    sim('O computador liga?'),
    Resposta = nao.

inferir_resposta('O cabo de energia está desconectado?', Resposta) :-
    nao('O computador não liga?'),
    Resposta = nao.

inferir_resposta('Nenhum componente interno recebe energia?', Resposta) :-
    sim('O computador liga?'),
    Resposta = nao.

inferir_resposta('Nenhum componente interno recebe energia?', Resposta) :-
    nao('O computador não liga?'),
    Resposta = desconhecido.

inferir_resposta('Nenhum componente interno recebe energia?', Resposta) :-
    sim('O cabo de energia está desconectado?'),
    Resposta = sim.

% Inferência sobre a conexão do carregador no notebook
inferir_resposta('O carregador está funcionando corretamente?', Resposta) :-
    sim('O carregador está conectado?'),
    Resposta = sim.

inferir_resposta('O carregador está funcionando corretamente?', Resposta) :-
    nao('O carregador está conectado?'),
    Resposta = desconhecido.

% Inferência sobre a condição do ventilador
inferir_resposta('Os ventiladores estão funcionando corretamente?', Resposta) :-
    sim('Os ventiladores estão fazendo muito barulho?'),
    Resposta = nao.

inferir_resposta('Os ventiladores estão funcionando corretamente?', Resposta) :-
    nao('Os ventiladores estão fazendo muito barulho?'),
    Resposta = sim.

% Inferência sobre a presença de LED de energia
inferir_resposta('Os LEDs de energia estão acendendo?', Resposta) :-
    sim('O computador liga?'),
    Resposta = sim.

inferir_resposta('Os LEDs de energia estão acendendo?', Resposta) :-
    nao('O computador liga?'),
    Resposta = nao.

% Inferência sobre o estado do HD/SSD
inferir_resposta('O HD/SSD está funcionando corretamente?', Resposta) :-
    sim('Os arquivos demoram para abrir ou salvar?'),
    Resposta = nao.

inferir_resposta('O HD/SSD está funcionando corretamente?', Resposta) :-
    nao('Os arquivos demoram para abrir ou salvar?'),
    Resposta = sim.

% Inferência sobre o adaptador de energia
inferir_resposta('O adaptador de energia está funcionando?', Resposta) :-
    sim('O adaptador de energia está conectado?'),
    Resposta = sim.

inferir_resposta('O adaptador de energia está funcionando?', Resposta) :-
    nao('O adaptador de energia está conectado?'),
    Resposta = desconhecido.

% Inferência sobre a condição física do notebook
inferir_resposta('Há danos físicos visíveis no notebook?', Resposta) :-
    sim('Há rachaduras ou partes soltas no notebook?'),
    Resposta = sim.

inferir_resposta('Há danos físicos visíveis no notebook?', Resposta) :-
    nao('Há rachaduras ou partes soltas no notebook?'),
    Resposta = nao.

% Inferência sobre a placa de vídeo
inferir_resposta('A placa de vídeo está funcionando corretamente?', Resposta) :-
    sim('O computador liga, mas não exibe imagem na tela?'),
    Resposta = nao.

inferir_resposta('A placa de vídeo está funcionando corretamente?', Resposta) :-
    nao('O computador liga, mas não exibe imagem na tela?'),
    Resposta = sim.

% Inferência sobre a memória RAM
inferir_resposta('A memória RAM está instalada corretamente?', Resposta) :-
    sim('O sistema está travando frequentemente durante a inicialização?'),
    Resposta = nao.

inferir_resposta('A memória RAM está instalada corretamente?', Resposta) :-
    nao('O sistema está travando frequentemente durante a inicialização?'),
    Resposta = sim.

% Inferência sobre a BIOS/UEFI
inferir_resposta('A BIOS/UEFI está configurada corretamente?', Resposta) :-
    sim('O computador não passa da tela de inicialização?'),
    Resposta = nao.

inferir_resposta('A BIOS/UEFI está configurada corretamente?', Resposta) :-
    nao('O computador não passa da tela de inicialização?'),
    Resposta = sim.

% Caso contrário, não é possível inferir
inferir_resposta(_, desconhecido).

% Predicado para verificar consistência das respostas
verificar_consistencia :-

    sim('O cabo de energia está desconectado?'),
    sim('O computador liga?'),
    inconsistente('O cabo de energia está desconectado, mas o computador liga.'),
    !.

verificar_consistencia :-

    sim('Nenhum componente interno recebe energia?'),
    sim('O computador liga?'),
    inconsistente('Nenhum componente interno recebe energia, mas o computador liga.'),
    !.

verificar_consistencia :-

    nao('O cabo de energia está desconectado?'),
    nao('O computador liga?'),
    inconsistente('O cabo de energia está conectado, mas o computador não liga.'),
    !.

verificar_consistencia :-

    nao('O computador liga?'),
    nao('Nenhum componente interno recebe energia?'),
    inconsistente('O computador não liga, mas algum componente interno recebe energia.'),
    !.

verificar_consistencia :-

    sim('O cabo de energia está desconectado?'),
    nao('Ao pressionar o botão de ligar, nenhuma luz acende ou som é emitido?'),
    inconsistente('O cabo de energia está desconectado, mas alguma luz ou som é emitido ao pressionar o botão de ligar.'),
    !.

verificar_consistencia :-

    sim('O computador liga?'),
    sim('O computador não liga?'),
    inconsistente('O computador liga e não liga simultaneamente.'),
    !.

verificar_consistencia :-

    nao('O computador liga?'),
    nao('O computador não liga?'),
    inconsistente('O computador não liga e não não liga simultaneamente.'),
    !.

verificar_consistencia :-

    tipo_aparelho(notebook),
    sim('O carregador está conectado?'),
    sim('O notebook não liga?'),
    inconsistente('O carregador está conectado, mas o notebook não liga.'),
    !.

verificar_consistencia :-

    sim('Os ventiladores estão fazendo muito barulho?'),
    nao('A parte inferior ou traseira do computador está muito quente?'),
    inconsistente('Os ventiladores estão fazendo muito barulho, mas não há sinais de superaquecimento.'),
    !.

verificar_consistencia :-

    nao('Os LEDs de energia estão acendendo?'),
    sim('O computador liga?'),
    inconsistente('Os LEDs de energia não estão acendendo, mas o computador está ligando.'),
    !.

verificar_consistencia :-

    nao('O adaptador de energia está funcionando?'),
    sim('O carregador está conectado?'),
    inconsistente('O adaptador de energia não está funcionando, mas o carregador está conectado.'),
    !.

verificar_consistencia :-
    % Inconsistência 12:
    % Se há danos físicos visíveis no notebook, mas alguns componentes internos estão recebendo energia
    tipo_aparelho(notebook),
    sim('Há danos físicos visíveis no notebook?'),
    nao('Nenhum componente interno recebe energia?'),
    inconsistente('Há danos físicos no notebook, mas alguns componentes internos estão recebendo energia.'),
    !.

verificar_consistencia :-
    % Inconsistência 13:
    % Se a placa de vídeo está funcionando corretamente, mas nenhum sinal visual é emitido
    sim('A placa de vídeo está funcionando corretamente?'),
    sim('Ao ligar, nenhum sinal visual ou sonoro é emitido?'),
    inconsistente('A placa de vídeo está funcionando corretamente, mas nenhum sinal visual ou sonoro é emitido.'),
    !.

verificar_consistencia :-
    % Inconsistência 14:
    % Se a memória RAM está instalada corretamente, mas o sistema está travando
    sim('A memória RAM está instalada corretamente?'),
    sim('O sistema está travando frequentemente durante a inicialização?'),
    inconsistente('A memória RAM está instalada corretamente, mas o sistema está travando durante a inicialização.'),
    !.

verificar_consistencia :-
    % Inconsistência 15:
    % Se o sistema operacional está apresentando erros, mas a memória RAM está instalada corretamente
    sim('Problema no sistema operacional'),
    sim('A memória RAM está instalada corretamente?'),
    inconsistente('Problemas no sistema operacional detectados, mas a memória RAM está instalada corretamente. Verifique outras causas.'),
    !.

verificar_consistencia :-
    % Inconsistência adicional para notebooks
    % Se o notebook não liga, mas o computador liga
    tipo_aparelho(notebook),
    sim('O notebook não liga?'),
    sim('O computador liga?'),
    inconsistente('O notebook não liga, mas o computador está ligando.'),
    !.

verificar_consistencia :-
    % Se o notebook liga, mas o computador não liga
    tipo_aparelho(notebook),
    nao('O notebook não liga?'),
    nao('O computador liga?'),
    inconsistente('O notebook liga, mas o computador não está ligando.'),
    !.

verificar_consistencia :-
    % Outras regras de consistência podem ser adicionadas aqui
    true.

% Predicado para indicar inconsistência e falhar
inconsistente(Mensagem) :-
    format('Inconsistência detectada: ~w~n', [Mensagem]),
    fail.

% Limpa as respostas armazenadas para uma nova sessão
limpar_respostas :-
    retractall(sim(_)),
    retractall(nao(_)),
    retractall(tipo_aparelho(_)).