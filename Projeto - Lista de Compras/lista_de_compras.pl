% PARA INICIAR O PROGRAMA, DIGITE A FUNÇÃO "main."
% SEM "", COM O PONTO FINAL

% Base de dados dinâmica para a lista de compras
:- dynamic item/1.

% Adiciona um item à lista de compras
adicionar_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> write('O item já está na lista.'), nl;
                                                  assertz(item(ItemAtom)), write('Item adicionado à lista.'), nl);
     write('O nome do item está em branco. Por favor, insira um nome válido.'), nl).

% Remove um item da lista de compras
remover_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> retract(item(ItemAtom)), write('Item removido da lista.'), nl;
                                                  write('O item não está na lista.'), nl);
     write('O nome do item está em branco. Por favor, insira um nome válido.'), nl).

% Verifica se um item está na lista de compras
verificar_item(Item) :-
    atom_string(ItemAtom, Item),
    (ItemAtom \= '' -> (item(ItemAtom) -> write('O item está na lista.'), nl;
                                                  write('O item não está na lista.'), nl);
     write('O nome do item está em branco. Por favor, insira um nome válido.'), nl).

% Imprime todos os itens na lista de compras
imprimir_lista :-
    write('Sua lista de compras é: '), nl,
    forall(item(Item), (write(Item), nl)).

% Interagindo com o usuário
main :-
    write('Bem-vindo ao gerenciador de lista de compras!'), nl,
    menu.

menu :-
    write('Digite 1 para adicionar um item.'), nl,
    write('Digite 2 para remover um item.'), nl,
    write('Digite 3 para verificar se um item está na lista.'), nl,
    write('Digite 4 para imprimir a lista de compras.'), nl,
    write('Digite 0 para sair.'), nl,
    read_line_to_string(user_input, Opcao),
    atom_number(Opcao, Numero),
    (Numero == 0 -> write('Programa interrompido.'), nl;
     Numero == 1 -> write('Digite o nome do item que você deseja adicionar: '), read_line_to_string(user_input, Item), adicionar_item(Item), nl, menu;
     Numero == 2 -> write('Digite o nome do item que você deseja remover: '), read_line_to_string(user_input, Item), remover_item(Item), nl, menu;
     Numero == 3 -> write('Digite o nome do item que você deseja verificar: '), read_line_to_string(user_input, Item), verificar_item(Item), nl, menu;
     Numero == 4 -> imprimir_lista, nl, menu;
     write('Opção inválida.'), nl, menu).
