:- include('../../mazes/labirinto80x80.pl').

:- include('../../azioni.pl').
:- include('../../utils.pl').
:- include('../../astar.pl').

:- assert(distance(l1)). 
:- astar(X), write(X).

:-halt(1).

