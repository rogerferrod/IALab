:- include('./mazes/labirinto.pl').

:- include('azioni.pl').
:- include('ida.pl').

:- assert(distance(l1)). 
:- ida(X), write(X).

:-halt(1).

