:- include('../../mazes/labirinto40x40.pl').

:- include('../../azioni.pl').
:- include('../../ida.pl').

:- assert(distance(l2)). 
:- ida(X), write(X).

:- halt(1).