% PARA INICIAR O PROGRAMA, DIGITE A FUN��O "main."
% SEM "", COM O PONTO FINAL

% Base de dados din�mica para a lista de compras
:- dynamic item/1.

% Adiciona um item � lista de compras
adicionar_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> write('O item j� est� na lista.'), nl;
                                                  assertz(item(ItemAtom)), write('Item adicionado � lista.'), nl);
     write('O nome do item est� em branco. Por favor, insira um nome v�lido.'), nl).

% Remove um item da lista de compras
remover_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> retract(item(ItemAtom)), write('Item removido da lista.'), nl;
                                                  write('O item n�o est� na lista.'), nl);
     write('O nome do item est� em branco. Por favor, insira um nome v�lido.'), nl).

% Verifica se um item est� na lista de compras
verificar_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> write('O item est� na lista.'), nl;
                                                  write('O item n�o est� na lista.'), nl);
     write('O nome do item est� em branco. Por favor, insira um nome v�lido.'), nl).

% Imprime todos os itens na lista de compras
imprimir_lista :-
    write('Sua lista de compras �: '), nl,
    forall(item(Item), (write(Item), nl)).

% Interagindo com o usu�rio
main :-
    write('Bem-vindo ao gerenciador de lista de compras!'), nl,
    menu.

menu :-
    write('Digite 1 para adicionar um item.'), nl,
    write('Digite 2 para remover um item.'), nl,
    write('Digite 3 para verificar se um item est� na lista.'), nl,
    write('Digite 4 para imprimir a lista de compras.'), nl,
    write('Digite 0 para sair.'), nl,
    read_line_to_string(user_input, Opcao),
    atom_number(Opcao, Numero),
    (Numero == 0 -> write('Programa interrompido.'), nl;
     Numero == 1 -> write('Digite o nome do item que voc� deseja adicionar: '), read_line_to_string(user_input, Item), adicionar_item(Item), nl, menu;
     Numero == 2 -> write('Digite o nome do item que voc� deseja remover: '), read_line_to_string(user_input, Item), remover_item(Item), nl, menu;
     Numero == 3 -> write('Digite o nome do item que voc� deseja verificar: '), read_line_to_string(user_input, Item), verificar_item(Item), nl, menu;
     Numero == 4 -> imprimir_lista, nl, menu;
     write('Op��o inv�lida.'), nl, menu).
