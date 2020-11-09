:- include('../../mazes/labirinto320x320.pl').

:- include('../../azioni.pl').

:- include('../../iddfs.pl').


:- iterative_deepening_search(X), write(X).

:-halt(1).

