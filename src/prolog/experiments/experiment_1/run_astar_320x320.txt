:- include('../../mazes/labirinto320x320.pl').

:- include('../../azioni.pl').
:- include('../../utils.pl').
:- include('../../astar.pl').

:- assert(distance(l2)). 
:- astar(X), write(X).

:-halt(1).

