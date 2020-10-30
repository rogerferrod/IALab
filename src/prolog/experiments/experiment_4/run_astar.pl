:- include('../../mazes/labirintotwosolutions.pl').

:- include('../../azioni.pl').
:- include('../../utils.pl').
:- include('../../astar.pl').

:- assert(distance(l2)). 
:- astar(X), write(X).

:-halt(1).

