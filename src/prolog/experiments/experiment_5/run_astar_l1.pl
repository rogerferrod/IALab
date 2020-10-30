:- include('../../mazes/labirinto40x40.pl').

:- include('../../azioni.pl').
:- include('../../utils.pl').
:- include('../../astar.pl').

:- assert(distance(l1)). 
:- astar(X), write(X).

:-halt(1).

