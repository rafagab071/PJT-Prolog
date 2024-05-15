% O Programa se iniciar utilizando o seguinte predicado:
% "iniciar.", sem aspas
% Para as fun��es dentro do menu, n�o utilize ponto final na entrada

:- dynamic tarefa/2.

% Predicado para adicionar uma nova tarefa
adicionar_tarefa :-
    writeln('\nDigite o nome da tarefa: '),
    read_line_to_string(user_input, Tarefa),
    (Tarefa \= '', \+ tarefa(Tarefa, pendente) ->
        assertz(tarefa(Tarefa, pendente)),
        writeln('Tarefa adicionada com sucesso!');
        Tarefa = '' ->
            writeln('Erro: Nome da tarefa n�o pode estar vazio.'),
            adicionar_tarefa;
        writeln('Erro: Tarefa j� existente.'),
        adicionar_tarefa),
    !.

% Predicado para marcar uma tarefa como conclu�da
concluir_tarefa :-
    listar_tarefas_pendentes,
    findall(Tarefa, tarefa(Tarefa, pendente), Tarefas),
    length(Tarefas, N),
    (N > 0 ->
        writeln('\nDigite o n�mero da tarefa a ser conclu�da: '),
        read_line_to_string(user_input, IndexString),
        atom_number(IndexString, Index),
        (integer(Index), Index > 0, Index =< N ->
            nth1(Index, Tarefas, Tarefa),
            (retract(tarefa(Tarefa, pendente)) ->
                assertz(tarefa(Tarefa, concluida)),
                writeln('Tarefa marcada como conclu�da!');
                writeln('Erro: Tarefa j� conclu�da.'));
            writeln('Erro: �ndice inv�lido.'));
        writeln('Erro: N�o h� tarefas pendentes para concluir.')),
    !.

% Predicado para listar todas as tarefas pendentes
listar_tarefas_pendentes :-
    findall(Tarefa, tarefa(Tarefa, pendente), Tarefas),
    (Tarefas = [] ->
        writeln('\nN�o h� tarefas pendentes.');
        writeln('\nTarefas Pendentes:'),
        listar_tarefas(Tarefas, 1)
    ),
    !.

% Predicado auxiliar para listar as tarefas
listar_tarefas([], _).
listar_tarefas([Tarefa|Tarefas], Index) :-
    format('~d. ~w~n', [Index, Tarefa]),
    NextIndex is Index + 1,
    listar_tarefas(Tarefas, NextIndex).

% Predicado principal que inicia o sistema
iniciar :-
    writeln('Bem-vindo ao Sistema de Gerenciamento de Tarefas!'),
    menu.

% Predicado que exibe o menu principal e processa as op��es do usu�rio
menu :-
    writeln('\nEscolha uma op��o:'),
    writeln('1. Adicionar uma nova tarefa'),
    writeln('2. Concluir uma tarefa'),
    writeln('3. Listar tarefas pendentes'),
    writeln('4. Sair'),
    read_line_to_string(user_input, OpcaoString),
    atom_number(OpcaoString, Opcao),
    processar_opcao(Opcao),
    !.

% Predicado que processa a op��o escolhida pelo usu�rio
processar_opcao(1) :- adicionar_tarefa, !, menu.
processar_opcao(2) :- concluir_tarefa, !, menu.
processar_opcao(3) :- listar_tarefas_pendentes, !, menu.
processar_opcao(4) :- writeln('\nSaindo do sistema. At� mais!'), !.
processar_opcao(_) :- writeln('\nOp��o inv�lida. Tente novamente.'), menu.

