:- include('../../mazes/labirinto80x80.pl').

:- include('../../azioni.pl').
:- include('../../utils.pl').
:- include('../../astar.pl').

:- assert(distance(linf)). 
:- astar(X), write(X).

:-halt(1).

