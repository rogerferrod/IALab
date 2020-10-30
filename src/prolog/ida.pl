/*
*   Ad ogni iterazione aumenta F
*   F(s)=g(s)+h(s)
*   ad ogni iterazione si tagliano i rami che eccedono il valore di F
*   ad ogni iterazione, la soglia usata per l'iterazione successiva è il min costo dei valori che attualmente eccedono la soglia
*   all'inizio F=h(s)
*
*/

ida(Solution):-
    start(S),
    heuristic(S,Threshold),
    % format("Threshold iniziale = ~d ~n", [Threshold]),
    assertz(actual_min(0)),
    retractall(actual_min(_)), %serve per far si che il predicato esista
    iddfs_aux(Threshold, Solution).

% iddfs_aux(+Threshold, -Solution)
iddfs_aux(Threshold, Solution):-
    start(S),
    dfs_aux(S,Threshold,0,[S],Solution),!.
iddfs_aux(_, Solution):-
    retract(actual_min(NewT)),
    % format("Nuovo threshold = ~d ~n", [NewT]),
    iddfs_aux(NewT, Solution).

% dfs_aux(+State, +F, +G, +Visited, -Actions)
dfs_aux(S,_,_,_,[]):-
    goal(S),
    retractall(actual_min(_)). % sempre true
dfs_aux(S,Threshold,G,Visited,[Action|ActionTail]):-
    applicable(S,Action),
    transform(Action,S,NewS),
    \+member(NewS,Visited),
    heuristic(NewS, NewH),
    NewG is G+1, % ipotesi costo unitario
    F is NewH+NewG,
    \+update_min(F, Threshold),  % true se non eccede il limite
    dfs_aux(NewS,Threshold,NewG,[NewS|Visited],ActionTail).

% heuristic(+State, -Heuristic)
heuristic(pos(Xs,Ys), H):-
    distance(l1),
    goal(pos(X,Y)),
    H is abs(Xs-X)+abs(Ys-Y).
heuristic(pos(Xs,Ys), H):-
    distance(l2),
    goal(pos(X,Y)),
    H is sqrt((Xs-X)^2+abs(Ys-Y)^2).
heuristic(pos(Xs,Ys), H):-
    distance(linf),
    goal(pos(X,Y)),
    H is max((Xs-X),(Ys-Y)).

% update_min(+F, +Threshold)
update_min(F, Threshold) :-
    /* 
    se eccede il limite 
    ed è il costo minimo
    allora aggiorna Min
    output: true
    */
    F > Threshold,
    get_min(F, Min), % sempre true (se c'è lo restituisce, se no lo crea e lo restituisce)
    F < Min, !,
    % format("Nuovo minimo eccedente ~d = ~d ~n", [Threshold, Min]),
    retractall(actual_min(_)), % elimina minimo attuale
    assertz(actual_min(F)).
update_min(F, Threshold) :-
    /*
    se eccede il limite
    ma non è il minimo
    allora lo lascia invariato
    output: true
    */
    F > Threshold.

% get_min(+F, -Min)
get_min(_, Min) :-
    /*
    se esiste il minimo
    allora lo ricava (senza cancellarlo)
    */
    actual_min(Min), !.
get_min(F, F) :-
    /*
    se non esiste ancora il minimo
    allora lo imposta a F
    */
    assertz(actual_min(F)).
    % format("Nuovo minimo = ~d ~n", [F]).