:- include('../../mazes/labirinto160x160.pl').

:- include('../../azioni.pl').
:- include('../../ida.pl').

:- assert(distance(l2)). 
:- ida(X), write(X).

:- halt(1).