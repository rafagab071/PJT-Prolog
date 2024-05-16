% PARA INICIAR: DIGITE 'jogar.' SEM '', COM O PONTO FINAL!
% TODAS AS JOGADAS DEVEM OBRIGATORIAMENTE TERMINAR COM O PONTO FINAL!

% Este é o Jogo da Velha
% Uma matriz 3 x 3 é impressa, podendo selecionar entre os modos de jogo:
% Humano x Humano (opção 1),
% Humano x Computador (opção 2).
% Após selecionar o modo de jogo, a matriz será apresentada dessa forma:
% |1|2|3|
% |4|5|6|
% |7|8|9|
% Para realizar sua jogada, basta selecionar uma posição livre e digitá-la
% Exemplo: 2. (Lembre-se de sempre colocar o ponto final em toda jogada!)

:-op(300, xfx, :).

% Imprimir a Matriz
printGrid([]):- !.
printGrid([E1,E2,E3|Grid]) :- 
		printRow([E1, E2, E3]),printGrid(Grid).

% Print as Linhas	
printRow([_:X, _:Y, _:Z]) :- write('|'),
		printChar(X), write('|'),
		printChar(Y), write('|'),
		printChar(Z), write('|'), nl.
		
% Print um Caracter
printChar(X) :- atom(X), write(X),!.
printChar(Y) :- write(Y), !.

% Iniciar o Jogo
jogar :- write('Bem-vindo ao Jogo da Velha!'),nl,
		write('Selecione o modo que voce deseja jogar:'), nl,
		write('Digite 1. - para jogar o modo Humano x Humano'),nl,
		write('Digite 2. - para jogar o modo Humano x Computador'),nl,
		readOption(Type), makeChoice(Type).

readOption(Type) :- write('Selecione seu modo: '), nl,
		read(Type).
		
makeChoice(1) :- human_vs_human.
makeChoice(2) :- human_vs_computer.

% ------------------------------------		
% Jogando o modo Humano x Humano
% ------------------------------------
human_vs_human :- 
		Grid = [1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9],
		write('Este e o seu tabuleiro.'), nl,
		printGrid(Grid), 
		write('Selecione uma opcao de 1 a 9 para seu proximo movimento.'),
		nl, move(Grid, x).

% Realizando uma jogada
move(Grid, x) :- notFull(Grid), nl, write('E a vez de X. '), 
		turn(Grid, NewGrid, x),
		printGrid(NewGrid),
		(win(NewGrid, x) -> write('X Venceu!'); move(NewGrid, 'O')).
		
move(Grid, 'O') :- notFull(Grid), nl, write('E a vez de O. '),
		turn(Grid, NewGrid, 'O'),
		printGrid(NewGrid),
		(win(NewGrid, 'O') -> write('O Venceu!'); move(NewGrid, x)).
		
% Checando se a matriz não está cheia
notFull([]) :- false.
notFull([_:H|_]) :- not(atom(H)), !.
notFull([_:H|T]) :- atom(H), notFull(T),!.

% Definindo o turno - 'A' pode ser 'X' ou 'O'
turn(Grid, NewGrid, A) :- readInput(Pos), 
		(empty(Pos, Grid) -> add(Grid, Pos, A, NewGrid);
		turn(Grid, NewGrid, A)).

% Checando se a posição está vazia
empty(Pos, [Pos:A|_]) :- not(atom(A)), !.
empty(Pos, [Pos:_|_]) :- 
		write('Essa posicao ja esta ocupada. Tente novamente.'), nl, !, fail.
empty(Pos, [_:_|T]) :- empty(Pos, T), !.
		
% Opções Horizontais para vencer o jogo
win([1:A, 2:A, 3:A, 4:_, 5:_, 6:_, 7:_, 8:_, 9:_], A).
win([1:_, 2:_, 3:_, 4:A, 5:A, 6:A, 7:_, 8:_, 9:_], A).
win([1:_, 2:_, 3:_, 4:_, 5:_, 6:_, 7:A, 8:A, 9:A], A).

% Opções verticais para vencer o jogo
win([1:A, 2:_, 3:_, 4:A, 5:_, 6:_, 7:A, 8:_, 9:_], A).
win([1:_, 2:A, 3:_, 4:_, 5:A, 6:_, 7:_, 8:A, 9:_], A).
win([1:_, 2:_, 3:A, 4:_, 5:_, 6:A, 7:_, 8:_, 9:A], A).

% Opções diagonais para vencer o jogo
win([1:A, 2:_, 3:_, 4:_, 5:A, 6:_, 7:_, 8:_, 9:A], A).
win([1:_, 2:_, 3:A, 4:_, 5:A, 6:_, 7:A, 8:_, 9:_], A).
	
% Adicionar um movimento na matriz - 'X' ou 'O' - especificado por A
add(Grid, Pos, A, NewGrid) :- split(Grid, Pos, L1, L2),
		append(L1, [Pos:A|L2], NewGrid), !.

% Dividir a matriz em duas partes
split(Grid, N, L1, L2) :- split(Grid, N, 1, [], L1, L2), !.
split([_|T], N, N, Acc, Acc, T).
split([H|T], N, K, Acc, L1, L2) :- K1 is K + 1,
		append(Acc, [H], AccNew),
		split(T, N, K1, AccNew, L1, L2).

% Método que reage com a escolha do usuário
readInput(X) :- write('Digite a posicao do seu proximo movimento: '), nl,
		read(X).

% ------------------------------------		
% Jogando o modo Humano x Computador
% ------------------------------------
human_vs_computer :- 
		Grid = [1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9],
		write('Este e o seu tabuleiro.'), nl,
		printGrid(Grid),
		write('Selecione uma opcao de 1 a 9 para seu proximo movimento.'),
		nl, human(Grid). % O Humano SEMPRE inicia

% Realizando uma jogada - Humano ou Computador
human(Grid) :- notFull(Grid), nl, write('Sua vez. '), 
		human_turn(Grid, NewGrid, x),
		printGrid(NewGrid),
		(win(NewGrid, x) -> write('Voce Venceu!'); computer(NewGrid)),!.
		
computer(Grid) :- notFull(Grid), nl, write('E a vez do Computador. '),
		nl, computer_turn(Grid, NewGrid, 'O'),
		printGrid(NewGrid),
		(win(NewGrid, 'O') -> write('Computador Venceu!'); human(NewGrid)),!.

computer(Grid) :- not(notFull(Grid)), write('E um Empate!'), nl, !.

% Definindo o turno do Humano - 'A' só pode ser 'X'
human_turn(Grid, NewGrid, A) :- readInput(Pos), 
		(empty(Pos, Grid) -> add(Grid, Pos, A, NewGrid);
		human_turn(Grid, NewGrid, A)).
		
% Define o turno do Computador
computer_turn(Grid, NewGrid, A) :- obtain_position(Grid, Pos),
		add(Grid, Pos, A, NewGrid).
		
obtain_position(Grid, Pos) :- try_to_win(Grid, 1, Pos).
obtain_position(Grid, Pos) :- defend(Grid, 1, Pos).
obtain_position(Grid, Pos) :- twoZeros(Grid, 1, Pos).
obtain_position(Grid, Pos) :- random_pos(Grid, Pos).

% Tentativa de vitória do Computador	
try_to_win(Grid, Pos, Pos) :- empty_place(Pos, Grid), 
		add(Grid, Pos, 'O', NewGrid), win(NewGrid, 'O').
try_to_win(Grid, Current, Pos) :- Next is Current + 1,
		(Next =< 9 -> try_to_win(Grid, Next, Pos) ; fail). 
		
% Em caso do humano estar vencendo uma posição, computador se defende
defend(Grid, Pos, Pos) :- empty_place(Pos, Grid), 
		add(Grid, Pos, x, NewGrid), win(NewGrid, x).
defend(Grid, Current, Pos) :- Next is Current + 1,
		(Next =< 9 -> defend(Grid, Next, Pos) ; fail). 
		
% Tentado ter dois 'O' consecutivos

% Tentar a posição na mesma linha, próxima coluna
twoZeros(Grid, Current, Pos) :- Pos is Current + 1, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na mesma linha, coluna anterior
twoZeros(Grid, Current, Pos) :- Pos is Current - 1, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na linha e na coluna anterior
twoZeros(Grid, Current, Pos) :- Pos is Current - 4, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na linha anterior, mesma coluna
twoZeros(Grid, Current, Pos) :- Pos is Current - 3, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na linha e na coluna anterior
twoZeros(Grid, Current, Pos) :- Pos is Current - 2, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na próxima linha, coluna anterior
twoZeros(Grid, Current, Pos) :- Pos is Current + 2, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na próxima linha, mesma coluna
twoZeros(Grid, Current, Pos) :- Pos is Current + 3, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Tentando a posição na próxima linha e coluna
twoZeros(Grid, Current, Pos) :- Pos is Current + 4, 
		Pos >= 1, Pos =< 9, empty_place(Pos, Grid).

% Se nenhum funcionar, vá para a próxima jogada
twoZeros(Grid, Current, Pos) :- Next is Current + 1,
		(Next =< 9 -> twoZeros(Grid, Next, Pos) ; fail).

% Se não houve posição ocupada, tente uma posição aleatória
random_pos(Grid, Pos) :- random(1, 10, Pos), empty_place(Pos, Grid).
random_pos(Grid, Pos) :- random_pos(Grid, Pos), !.

% Checando se a posição está vazia
empty_place(Pos, [Pos:A|_]) :- not(atom(A)), !.
empty_place(Pos, [Pos:_|_]) :- !, fail.
empty_place(Pos, [_:_|T]) :- empty_place(Pos, T), !.