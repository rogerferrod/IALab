:- include('../../mazes/labirinto320x320.pl').

:- include('../../azioni.pl').
:- include('../../ida.pl').

:- assert(distance(l2)). 
:- ida(X), write(X).

:- halt(1).