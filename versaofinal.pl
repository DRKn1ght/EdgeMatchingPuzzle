:- use_module(library(plunit)).

%  Um jogo é representado por uma estrutura jogo com 3 argumentos. O primeiro é
%  o número de linhas (L), o segundo o número de colunas (C) e o terceiro uma
%  lista (Blocos - de tamanho linhas x colunas) com os blocos do jogo. Nessa
%  representação os primeiros L elementos da lista Blocos correspondem aos
%  blocos da primeira linha do jogo, os próximos L blocos correspondem aos
%  blocos da segunda linha do jogo e assim por diante.
%
%  Dessa forma, em jogo com 3 linhas e 5 colunas (total de 15 blocos), os
%  blocos são indexados da seguinte forma:
%
%   0  1  2  3  4
%   5  6  7  8  9
%  10 11 12 13 14
%
%  Cada bloco é representado por uma estrutura bloco com 4 argumentos. Os
%  argumentos representam os valores da borda superior, direita, inferior e
%  esquerda (sentido horário começando do topo). Por exemplo o bloco
%
%  |  3  |
%  |4   6|  é representado por bloco(3, 6, 7, 4).
%  |  7  |
%
%  Dizemos que um bloco está em posição adequada se os blocos adjacentes 
%  (acima, a direita, abaixo e a esquerda) tem o mesmo valor nas bordas adjacentes.
%
%  Dica: Implemente inicialmente o predicado bloco_adequado e depois
%  blocos_adequados. Crie predicados auxiliares se necessário. Depois que o
%  predicado jogo_solucao estiver funcionando, faça uma nova implementação
%  eficiente dele.

%% Resultados
%
% Permutação sem reordenar os blocos x Permutação ordenando os blocos:
% Medio:   2.341 sec   x 0.356 sec
% Grande:  105.456 sec x 40.980 sec
% Grande2: 59.579 sec  x 15.916 sec
% Grande3: 62.700 sec  x 25.444 sec
%
% Retrocesso sem reordenar os blocos x Retrocesso ordenando os blocos:
% Medio:   17.845 sec  x 2.367 sec
% Grande:  263.911 sec x 241.478 sec
% Grande2: 258.245 sec x 102.930 sec
% Grande3: 267.432 sec x 157.842 sec

%% jogo_solucao(?JogoInicial, ?JogoFinal) is semidet
%
%  Verdadeiro se JogoInicial é uma estrutura jogo(L, C, Blocos) e JogoFinal é
%  uma estrutura jogo(L, C, Solucao), onde Solucao é uma solução válida para o
%  JogoInicial, isto é, os blocos que aparecem em Solucao são os mesmos de
%  Blocos e estão em posições adequadas.

jogo_solucao(JogoInicial, JogoFinal) :-
    jogo(L, C, Blocos) = JogoInicial,
    jogo(L, C, Solucao) = JogoFinal,
    blocos_adequados(JogoFinal),
    sort_blocks(Blocos, Sorted),
    permutation(Sorted, Solucao).

:- begin_tests(pequeno).

test(j1x1, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 6, 7, 5)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(1, 1, Inicial), jogo(1, 1, Final)).


test(j2x2, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 4, 7, 9),
        bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2),
        bloco(5, 3, 1, 6)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(2, 2, Inicial), jogo(2, 2, Final)).

test(j3x3, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(6, 6, 6, 9),
        bloco(7, 8, 5, 6)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(3, 3, Inicial), jogo(3, 3, Final)).

:- end_tests(pequeno).


:- begin_tests(medio).

test(j4x4, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(7, 7, 4, 8),
        bloco(3, 0, 2, 7),
        bloco(7, 9, 1, 0),
        bloco(1, 6, 3, 9),
        bloco(4, 2, 5, 5),
        bloco(2, 4, 5, 2),
        bloco(1, 5, 7, 4),
        bloco(3, 8, 0, 5),
        bloco(5, 5, 8, 0),
        bloco(5, 5, 9, 5),
        bloco(7, 6, 7, 5),
        bloco(0, 2, 1, 6),
        bloco(8, 7, 9, 5),
        bloco(9, 2, 8, 7),
        bloco(7, 3, 3, 2),
        bloco(1, 0, 4, 3)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(4, 4, Inicial), jogo(4, 4, Final)).

test(j5x5, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(1, 6, 7, 5),
        bloco(4, 0, 0, 6),
        bloco(9, 2, 0, 0),
        bloco(8, 3, 5, 2),
        bloco(0, 4, 5, 3),
        bloco(7, 1, 2, 6),
        bloco(0, 4, 5, 1),
        bloco(0, 0, 3, 4),
        bloco(5, 1, 1, 0),
        bloco(5, 3, 2, 1),
        bloco(2, 9, 1, 0),
        bloco(5, 5, 5, 9),
        bloco(3, 2, 2, 5),
        bloco(1, 0, 6, 2),
        bloco(2, 9, 0, 0),
        bloco(1, 0, 7, 0),
        bloco(5, 0, 7, 0),
        bloco(2, 4, 8, 0),
        bloco(6, 9, 4, 4),
        bloco(0, 0, 6, 9),
        bloco(7, 0, 2, 5),
        bloco(7, 2, 0, 0),
        bloco(8, 6, 1, 2),
        bloco(4, 4, 6, 6),
        bloco(6, 5, 8, 4)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(5, 5, Inicial), jogo(5, 5, Final)).

test(j6x6, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 0, 2, 4),
        bloco(9, 5, 5, 0),
        bloco(1, 1, 8, 5),
        bloco(4, 2, 0, 1),
        bloco(4, 3, 2, 2),
        bloco(8, 0, 0, 3),
        bloco(2, 2, 3, 9),
        bloco(5, 9, 1, 2),
        bloco(8, 2, 3, 9),
        bloco(0, 2, 3, 2),
        bloco(2, 9, 8, 2),
        bloco(0, 6, 9, 9),
        bloco(3, 1, 6, 9),
        bloco(1, 2, 2, 1),
        bloco(3, 0, 8, 2),
        bloco(3, 5, 8, 0),
        bloco(8, 7, 8, 5),
        bloco(9, 4, 8, 7),
        bloco(6, 0, 6, 9),
        bloco(2, 4, 5, 0),
        bloco(8, 7, 6, 4),
        bloco(8, 3, 7, 7),
        bloco(8, 7, 2, 3),
        bloco(8, 7, 1, 7),
        bloco(6, 3, 9, 0),
        bloco(5, 1, 9, 3),
        bloco(6, 9, 8, 1),
        bloco(7, 7, 0, 9),
        bloco(2, 0, 6, 7),
        bloco(1, 3, 7, 0),
        bloco(9, 9, 8, 7),
        bloco(9, 0, 6, 9),
        bloco(8, 1, 6, 0),
        bloco(0, 9, 7, 1),
        bloco(6, 1, 7, 9),
        bloco(7, 8, 1, 1)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(6, 6, Inicial), jogo(6, 6, Final)).

:- end_tests(medio).


:- begin_tests(grande).

test(j7x7, [nondet, Blocos = Final]) :-
    Blocos = [
        bloco(4, 1, 0, 8),
        bloco(7, 8, 1, 1),
        bloco(0, 3, 5, 8),
        bloco(4, 0, 9, 3),
        bloco(9, 7, 1, 0),
        bloco(6, 8, 3, 7),
        bloco(3, 5, 2, 8),
        bloco(0, 9, 5, 8),
        bloco(1, 4, 9, 9),
        bloco(5, 1, 6, 4),
        bloco(9, 3, 1, 1),
        bloco(1, 5, 6, 3),
        bloco(3, 3, 2, 5),
        bloco(2, 0, 4, 3),
        bloco(5, 1, 8, 8),
        bloco(9, 6, 8, 1),
        bloco(6, 5, 2, 6),
        bloco(1, 8, 6, 5),
        bloco(6, 4, 9, 8),
        bloco(2, 8, 2, 4),
        bloco(4, 1, 8, 8),
        bloco(8, 1, 5, 4),
        bloco(8, 2, 0, 1),
        bloco(2, 0, 2, 2),
        bloco(6, 4, 8, 0),
        bloco(9, 7, 7, 4),
        bloco(2, 8, 5, 7),
        bloco(8, 0, 7, 8),
        bloco(5, 6, 0, 8),
        bloco(0, 9, 4, 6),
        bloco(2, 2, 2, 9),
        bloco(8, 9, 5, 2),
        bloco(7, 1, 5, 9),
        bloco(5, 2, 0, 1),
        bloco(7, 9, 6, 2),
        bloco(0, 7, 5, 8),
        bloco(4, 7, 5, 7),
        bloco(2, 9, 1, 7),
        bloco(5, 7, 5, 9),
        bloco(5, 5, 4, 7),
        bloco(0, 8, 5, 5),
        bloco(6, 8, 7, 8),
        bloco(5, 7, 9, 6),
        bloco(5, 0, 2, 7),
        bloco(1, 4, 6, 0),
        bloco(5, 3, 2, 4),
        bloco(4, 9, 6, 3),
        bloco(5, 8, 1, 9),
        bloco(7, 8, 0, 8)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(7, 7, Inicial), jogo(7, 7, Final)).

:- end_tests(grande).

:- begin_tests(grande2).

test(j7x7, [nondet, Blocos = Final]) :-
    Blocos = [
        bloco(8, 3, 4, 4), 
        bloco(6, 5, 5, 3), 
        bloco(0, 1, 3, 5), 
        bloco(6, 5, 8, 1), 
        bloco(4, 1, 5, 5), 
        bloco(6, 8, 5, 1), 
        bloco(5, 5, 3, 8), 
        bloco(4, 7, 2, 0), 
        bloco(5, 1, 5, 7), 
        bloco(3, 3, 1, 1), 
        bloco(8, 4, 8, 3), 
        bloco(5, 3, 3, 4), 
        bloco(5, 4, 5, 3), 
        bloco(3, 7, 4, 4), 
        bloco(2, 6, 7, 2), 
        bloco(5, 0, 4, 6), 
        bloco(1, 0, 7, 0), 
        bloco(8, 8, 2, 0), 
        bloco(3, 7, 4, 8), 
        bloco(5, 2, 5, 7), 
        bloco(4, 9, 3, 2), 
        bloco(7, 2, 3, 1), 
        bloco(4, 4, 1, 2), 
        bloco(7, 0, 5, 4), 
        bloco(2, 8, 0, 0), 
        bloco(4, 5, 1, 8), 
        bloco(5, 7, 5, 5), 
        bloco(3, 7, 9, 7), 
        bloco(3, 0, 9, 7), 
        bloco(1, 9, 3, 0), 
        bloco(5, 9, 0, 9), 
        bloco(0, 3, 4, 9), 
        bloco(1, 6, 9, 3), 
        bloco(5, 4, 1, 6), 
        bloco(9, 7, 3, 4), 
        bloco(9, 8, 4, 1), 
        bloco(3, 2, 7, 8), 
        bloco(0, 9, 5, 2), 
        bloco(4, 0, 5, 9), 
        bloco(9, 4, 4, 0), 
        bloco(1, 0, 0, 4), 
        bloco(3, 5, 0, 0), 
        bloco(4, 4, 6, 0), 
        bloco(7, 6, 4, 4), 
        bloco(5, 3, 3, 6), 
        bloco(5, 9, 7, 3), 
        bloco(4, 6, 6, 9), 
        bloco(0, 8, 1, 6), 
        bloco(0, 3, 1, 8) ] ,
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(7, 7, Inicial), jogo(7, 7, Final)).

:- end_tests(grande2).

:- begin_tests(grande3).

test(j7x7, [nondet, Blocos = Final]) :-
    Blocos = [ 
        bloco(5, 6, 9, 5), 
        bloco(2, 0, 6, 6), 
        bloco(4, 3, 0, 0), 
        bloco(3, 0, 2, 3), 
        bloco(3, 1, 9, 0), 
        bloco(7, 8, 9, 1), 
        bloco(0, 5, 0, 8), 
        bloco(9, 1, 2, 6), 
        bloco(6, 4, 4, 1), 
        bloco(0, 0, 2, 4), 
        bloco(2, 2, 5, 0), 
        bloco(9, 9, 2, 2), 
        bloco(9, 5, 1, 9), 
        bloco(0, 8, 6, 5), 
        bloco(2, 5, 8, 5), 
        bloco(4, 6, 4, 5), 
        bloco(2, 0, 5, 6), 
        bloco(5, 2, 3, 0), 
        bloco(2, 3, 7, 2), 
        bloco(1, 6, 2, 3), 
        bloco(6, 6, 4, 6), 
        bloco(8, 6, 7, 7), 
        bloco(4, 4, 2, 6), 
        bloco(5, 6, 7, 4), 
        bloco(3, 4, 0, 6), 
        bloco(7, 7, 2, 4), 
        bloco(2, 7, 2, 7), 
        bloco(4, 3, 9, 7), 
        bloco(7, 8, 5, 9), 
        bloco(2, 3, 7, 8), 
        bloco(7, 4, 7, 3), 
        bloco(0, 4, 0, 4), 
        bloco(2, 4, 9, 4), 
        bloco(2, 8, 3, 4), 
        bloco(9, 9, 5, 8), 
        bloco(5, 3, 8, 1), 
        bloco(7, 7, 7, 3), 
        bloco(7, 3, 6, 7), 
        bloco(0, 8, 7, 3), 
        bloco(9, 4, 1, 8), 
        bloco(3, 2, 0, 4), 
        bloco(5, 3, 9, 2), 
        bloco(8, 2, 2, 7), 
        bloco(7, 7, 7, 2), 
        bloco(6, 4, 4, 7), 
        bloco(7, 1, 6, 4), 
        bloco(1, 9, 7, 1), 
        bloco(0, 5, 1, 9), 
        bloco(9, 1, 5, 5)],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(7, 7, Inicial), jogo(7, 7, Final)).

:- end_tests(grande3).

%% jogo_solucao_retrocesso(?JogoInicial, ?JogoFinal) is semidet
%
%  Verdadeiro se JogoInicial é uma estrutura jogo(L, C, Blocos) e JogoFinal é
%  uma estrutura jogo(L, C, Solucao), onde Solucao é uma solução válida para o
%  JogoInicial, isto é, os blocos que aparecem em Solucao são os mesmos de
%  Blocos e estão em posições adequadas. Utiliza a estratégia de retrocesso
%  para resolver.

jogo_solucao_retrocesso(JogoInicial, JogoFinal) :-
    jogo(L, C, Blocos) = JogoInicial,
    init_puzzle(Blocos, BlankBlocks),
    sort_blocks(Blocos, Sorted),
    retrocesso(jogo(L, C, BlankBlocks), Sorted, 0, JogoFinal).

init_puzzle(Blocos, BlankBlocks) :-
    maplist(init_bloco, Blocos, BlankBlocks).

init_bloco(bloco(_, _, _, _), bloco(_, _, _, _)).

retrocesso(Jogo, [], _, _):- 
    blocos_adequados(Jogo),
    !.
    
retrocesso(Jogo, BlocosDisp, Pos, Solucao):-
    Jogo = jogo(L, C, Blocks),
    length(BlocosDisp, Len),
    Len1 is Len - 1,
    between(0, Len1, Index),
    nth0(Index, BlocosDisp, Bloco),
    nth0(Pos, Blocks, Bloco),
    bloco_adequado(jogo(L, C, Blocks), Pos),
    select(Bloco, BlocosDisp, RemainingBlocks),
    Solucao = jogo(L, C, Blocks),
    NextPos is Pos + 1,
    retrocesso(jogo(L, C, Blocks), RemainingBlocks, NextPos, Solucao),
    !.

:- begin_tests(medio_retrocesso).

test(j4x4, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(7, 7, 4, 8),
        bloco(3, 0, 2, 7),
        bloco(7, 9, 1, 0),
        bloco(1, 6, 3, 9),
        bloco(4, 2, 5, 5),
        bloco(2, 4, 5, 2),
        bloco(1, 5, 7, 4),
        bloco(3, 8, 0, 5),
        bloco(5, 5, 8, 0),
        bloco(5, 5, 9, 5),
        bloco(7, 6, 7, 5),
        bloco(0, 2, 1, 6),
        bloco(8, 7, 9, 5),
        bloco(9, 2, 8, 7),
        bloco(7, 3, 3, 2),
        bloco(1, 0, 4, 3)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao_retrocesso(jogo(4, 4, Inicial), jogo(4, 4, Final)).

test(j5x5, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(1, 6, 7, 5),
        bloco(4, 0, 0, 6),
        bloco(9, 2, 0, 0),
        bloco(8, 3, 5, 2),
        bloco(0, 4, 5, 3),
        bloco(7, 1, 2, 6),
        bloco(0, 4, 5, 1),
        bloco(0, 0, 3, 4),
        bloco(5, 1, 1, 0),
        bloco(5, 3, 2, 1),
        bloco(2, 9, 1, 0),
        bloco(5, 5, 5, 9),
        bloco(3, 2, 2, 5),
        bloco(1, 0, 6, 2),
        bloco(2, 9, 0, 0),
        bloco(1, 0, 7, 0),
        bloco(5, 0, 7, 0),
        bloco(2, 4, 8, 0),
        bloco(6, 9, 4, 4),
        bloco(0, 0, 6, 9),
        bloco(7, 0, 2, 5),
        bloco(7, 2, 0, 0),
        bloco(8, 6, 1, 2),
        bloco(4, 4, 6, 6),
        bloco(6, 5, 8, 4)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao_retrocesso(jogo(5, 5, Inicial), jogo(5, 5, Final)).

test(j6x6, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 0, 2, 4),
        bloco(9, 5, 5, 0),
        bloco(1, 1, 8, 5),
        bloco(4, 2, 0, 1),
        bloco(4, 3, 2, 2),
        bloco(8, 0, 0, 3),
        bloco(2, 2, 3, 9),
        bloco(5, 9, 1, 2),
        bloco(8, 2, 3, 9),
        bloco(0, 2, 3, 2),
        bloco(2, 9, 8, 2),
        bloco(0, 6, 9, 9),
        bloco(3, 1, 6, 9),
        bloco(1, 2, 2, 1),
        bloco(3, 0, 8, 2),
        bloco(3, 5, 8, 0),
        bloco(8, 7, 8, 5),
        bloco(9, 4, 8, 7),
        bloco(6, 0, 6, 9),
        bloco(2, 4, 5, 0),
        bloco(8, 7, 6, 4),
        bloco(8, 3, 7, 7),
        bloco(8, 7, 2, 3),
        bloco(8, 7, 1, 7),
        bloco(6, 3, 9, 0),
        bloco(5, 1, 9, 3),
        bloco(6, 9, 8, 1),
        bloco(7, 7, 0, 9),
        bloco(2, 0, 6, 7),
        bloco(1, 3, 7, 0),
        bloco(9, 9, 8, 7),
        bloco(9, 0, 6, 9),
        bloco(8, 1, 6, 0),
        bloco(0, 9, 7, 1),
        bloco(6, 1, 7, 9),
        bloco(7, 8, 1, 1)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao_retrocesso(jogo(6, 6, Inicial), jogo(6, 6, Final)).

:- end_tests(medio_retrocesso).


:- begin_tests(grande_retrocesso).

test(j7x7, [nondet, Blocos = Final]) :-
    Blocos = [
        bloco(4, 1, 0, 8),
        bloco(7, 8, 1, 1),
        bloco(0, 3, 5, 8),
        bloco(4, 0, 9, 3),
        bloco(9, 7, 1, 0),
        bloco(6, 8, 3, 7),
        bloco(3, 5, 2, 8),
        bloco(0, 9, 5, 8),
        bloco(1, 4, 9, 9),
        bloco(5, 1, 6, 4),
        bloco(9, 3, 1, 1),
        bloco(1, 5, 6, 3),
        bloco(3, 3, 2, 5),
        bloco(2, 0, 4, 3),
        bloco(5, 1, 8, 8),
        bloco(9, 6, 8, 1),
        bloco(6, 5, 2, 6),
        bloco(1, 8, 6, 5),
        bloco(6, 4, 9, 8),
        bloco(2, 8, 2, 4),
        bloco(4, 1, 8, 8),
        bloco(8, 1, 5, 4),
        bloco(8, 2, 0, 1),
        bloco(2, 0, 2, 2),
        bloco(6, 4, 8, 0),
        bloco(9, 7, 7, 4),
        bloco(2, 8, 5, 7),
        bloco(8, 0, 7, 8),
        bloco(5, 6, 0, 8),
        bloco(0, 9, 4, 6),
        bloco(2, 2, 2, 9),
        bloco(8, 9, 5, 2),
        bloco(7, 1, 5, 9),
        bloco(5, 2, 0, 1),
        bloco(7, 9, 6, 2),
        bloco(0, 7, 5, 8),
        bloco(4, 7, 5, 7),
        bloco(2, 9, 1, 7),
        bloco(5, 7, 5, 9),
        bloco(5, 5, 4, 7),
        bloco(0, 8, 5, 5),
        bloco(6, 8, 7, 8),
        bloco(5, 7, 9, 6),
        bloco(5, 0, 2, 7),
        bloco(1, 4, 6, 0),
        bloco(5, 3, 2, 4),
        bloco(4, 9, 6, 3),
        bloco(5, 8, 1, 9),
        bloco(7, 8, 0, 8)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao_retrocesso(jogo(7, 7, Inicial), jogo(7, 7, Final)).

:- end_tests(grande_retrocesso).

%% sort_blocks(+Blocos, ?Sorted) is semidet
%
% Verdadeiro se Sorted é uma lista com os blocos da lista Blocos
% ordenado de forma ascendente baseado no número possível de vizinhos.

sort_blocks(Blocos, Sorted) :-
    possible_neighbors(Blocos, PossiblesN),
    pairs_keys_values(Pairs, PossiblesN, Blocos),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, Sorted),
    !.

:- begin_tests(sort_blocks).

test(j1x3, X == [bloco(7, 7, 3, 2), bloco(0, 6, 6, 0), bloco(8, 0, 1, 7)]) :-
    sort_blocks([
                bloco(7, 7, 3, 2),
                bloco(8, 0, 1, 7), 
                bloco(0, 6, 6, 0)], X).

test(j1x3, X == [bloco(4, 9, 3, 4), bloco(1, 7, 0, 4), bloco(0, 4, 2, 9)]) :-
    sort_blocks([
                bloco(4, 9, 3, 4), 
                bloco(0, 4, 2, 9), 
                bloco(1, 7, 0, 4)], X).

:- end_tests(sort_blocks).

%% possible_neighbors(?Blocos, ?NeighborCounts) is semidet
%
% Verdadeiro se NeighborCounts for uma lista com o número de possíveis
% vizinhos de cada bloco da lista Blocos

possible_neighbors(Blocos, NeighborCounts) :-
    possible_neighbors(Blocos, Blocos, NeighborCounts).

possible_neighbors(_, [], []).
possible_neighbors(Blocos, [Bloco|RestBlocos], [Count|RestCounts]) :-
    count_possible_neighbors(Bloco, Blocos, 0, Count),
    possible_neighbors(Blocos, RestBlocos, RestCounts),
    !.

count_possible_neighbors(_, [], Count, Count).
count_possible_neighbors(Bloco, [ProxBloco|RestBlocos], Acc, Count) :-
    Bloco == ProxBloco ->
        count_possible_neighbors(Bloco, RestBlocos, Acc, Count);
    Bloco = bloco(TopB, RightB, BottomB, LeftB),
    ProxBloco = bloco(TopP, RightP, BottomP, LeftP),
    (LeftB = RightP ->
        NewAcc1 is Acc + 1
    ; NewAcc1 = Acc),
    (TopB = BottomP ->
        NewAcc2 is NewAcc1 + 1
    ; NewAcc2 = NewAcc1),
    (RightB = LeftP ->
        NewAcc3 is NewAcc2 + 1
        ;
        NewAcc3 = NewAcc2),
    (BottomB = TopP ->
        NewAcc4 is NewAcc3 + 1
        ;
        NewAcc4 is NewAcc3),
    count_possible_neighbors(Bloco, RestBlocos, NewAcc4, Count).

:- begin_tests(possible_neighbors).

test(j1x3, X == [1, 2, 1]) :-
    possible_neighbors([
                bloco(7, 7, 3, 2),
                bloco(8, 0, 1, 7), 
                bloco(0, 6, 6, 0)], X).

test(j1x3, X == [2, 4, 2]) :-
    possible_neighbors([
                bloco(4, 9, 3, 4), 
                bloco(0, 4, 2, 9), 
                bloco(1, 7, 0, 4)], X).

:- end_tests(possible_neighbors).

%% blocos_adequados(?Jogo) is semidet
%
%  Verdadeiro se Jogo é uma estrutura jogo(L, C, Blocos), e todos os blocos de
%  Blocos estão em posições adequadas.

blocos_adequados(jogo(L, C, Blocos)) :-
    length(Blocos, NumBlocos),
    blocos_adequados_aux(jogo(L, C, Blocos), 0, NumBlocos).

blocos_adequados_aux(Jogo, P, NumBlocos) :-
    (P < NumBlocos ->
        bloco_adequado(Jogo, P),
        NextP is P + 1,
        blocos_adequados_aux(Jogo, NextP, NumBlocos)
    ; true).

:- begin_tests(blocos_adequados_test).

test(test_true) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(16, 21, 22, 19)]),
    blocos_adequados(Jogo).

test(test_false) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(2, 5, 6, 1), bloco(3, 5, 9, 5),
                     bloco(4, 10, 11, 3), bloco(10, 13, 14, 6), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(17, 19, 20, 14), bloco(18, 21, 22, 19)]),
    \+ blocos_adequados(Jogo).

:- end_tests(blocos_adequados_test).

%% bloco_adequado(?Jogo, +P) is semidet
%
%  Verdadeiro se Jogo é uma estrutura jogo(L, C, Blocos), e o bloco na posição
%  P de Blocos está em uma posição adequada.

bloco_adequado(jogo(L, C, Blocos), P) :-
    nth0(P, Blocos, BlocoAtual),
    TopIndex is P - C,
    BottomIndex is P + C,
    LeftIndex is P - 1,
    RightIndex is P + 1,
    
    % Checa bloco de cima
    (P > C ->
        nth0(TopIndex, Blocos, TopBlock),
        TopBlock = bloco(_, _, TopValue, _),
        BlocoAtual = bloco(TopValue, _, _, _)
    ; true),
    
    % Checa bloco de baixo
    (P < L * C - C ->
        nth0(BottomIndex, Blocos, BottomBlock),
        BottomBlock = bloco(BottomValue, _, _, _),
        BlocoAtual = bloco(_, _, BottomValue, _)
    ; true),

    % Checa bloco da esquerda
    (P mod C > 0 ->
        nth0(LeftIndex, Blocos, LeftBlock),
        LeftBlock = bloco(_, LeftValue, _, _),
        BlocoAtual = bloco(_, _, _, LeftValue)
    ; true),

    % Checa bloco da direita
    (P mod C < C - 1 ->
        nth0(RightIndex, Blocos, RightBlock),
        RightBlock = bloco(_, _, _, RightValue),
        BlocoAtual = bloco(_, RightValue, _, _)
    ; true).

:- begin_tests(bloco_adequado_test).

test(top_left_corner) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 0).

test(top_center) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 1).

test(top_right_corner) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 2).

test(bottom_left_corner) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 6).

test(bottom_center) :-
    Jogo = jogo(3, 3, [bloco(1, 2, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 7).

test(bottom_center, fail) :-
    Jogo = jogo(3, 3, [bloco(1, 3, 3, 4), bloco(1, 5, 6, 2), bloco(1, 8, 9, 5),
                     bloco(3, 10, 11, 4), bloco(6, 13, 14, 10), bloco(9, 15, 16, 13),
                     bloco(11, 17, 18, 4), bloco(14, 19, 20, 17), bloco(18, 21, 22, 19)]),
    bloco_adequado(Jogo, 0).

:- end_tests(bloco_adequado_test).