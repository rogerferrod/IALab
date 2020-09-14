/*
* F(s)=g(s)+h(s)
* OPEN = coda di priorità frontiera (nodi da espandere)
* CLOSED = insieme nodi già visitati (possono essere espansi)
* coda di priorità: [pq(k,v)] dove v=node(S,[Actions])
*
*/

astar(Solution):-
    astar_start(Sol),
    reverse(Sol, Solution).

astar_start(Soluzione):-
    start(S),
    heuristic(S,H),
    astar_aux([pq(H,node(S,[]))],[],Soluzione),!.

% astar_aux(+Open, +Closed, -Solution)
astar_aux([], _, _):-
    write('no solutions\n').
astar_aux(Open, _, Actions):-
    writeln(Open),
    topPQ(Open, Pq),
    unzip(Pq, S, Actions),
    goal(S).
astar_aux(Open, Closed, Solution):-
    popPQ(Open,NewOpen,Pq),  
    unzip(Pq, S, Actions),
    getKeyPQ(Open, S, OldF),
    insertPQ(Closed,OldF,node(S,Actions),NewClosed),
    findall(Action,applicable(S,Action),ApplicableList),
    expands(node(S,Actions),ApplicableList,ChildrenList),
    computeCost(ChildrenList,NewOpen,NewClosed,FinalOpen,FinalClosed),
    astar_aux(FinalOpen,FinalClosed,Solution).

% expands(+NodeParent, +ApplicableList, -Children)
expands(_, [], []). 
expands(node(S,ActionForS), [Action|OtherActions], [node(SNew,[Action|ActionForS])|ChildrenTail]):-
    transform(Action,S,SNew),
    expands(node(S,ActionForS),OtherActions,ChildrenTail).
expands(node(S,ActionForS), [_|OtherActions], ChildrenTail):-
    expands(node(S,ActionForS),OtherActions,ChildrenTail).

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

% computeCost(+Children, +Open, +Closed, -NewOpen, -NewClosed)
computeCost([], Open, Closed, Open, Closed).  % Children = [node(S,Actions)]
computeCost([node(S,Actions)|Tail], Open, Closed, FinalOpen, FinalClosed):-
    %child not in OPEN and not in CLOSED
    \+getKeyPQ(Open, S, _), % se non c'è fallisce
    \+getKeyPQ(Closed, S, _), % se non c'è fallisce
    %write('caso 1'),
    length(Actions,G),
    heuristic(S,H),
    Fprov is G + 1 + H, % ipotesi costo unitario
    insertPQ(Open,Fprov,node(S,Actions),NewOpen),
    computeCost(Tail, NewOpen, Closed, FinalOpen, FinalClosed).
computeCost([node(S,Actions)|Tail], Open, Closed, FinalOpen, FinalClosed):-
    %child in OPEN and Fprov < OldF
    getKeyPQ(Open, S, OldF), % se non c'è fallisce
    length(Actions,G),
    heuristic(S,H),
    Fprov is G + 1 + H, % ipotesi costo unitario
    Fprov < OldF,
    %write('caso 2'),
    updatePQ(Open, Fprov, node(S,Actions), NewOpen),
    computeCost(Tail, NewOpen, Closed, FinalOpen, FinalClosed).
computeCost([node(S,Actions)|Tail], Open, Closed, FinalOpen, FinalClosed):-
    %child in CLOSED and Fprov < OldF
    getKeyPQ(Closed, S, OldF), % se non c'è fallisce
    length(Actions,G),
    heuristic(S,H),
    Fprov is G + 1 + H, % ipotesi costo unitario
    Fprov < OldF,
    %write('caso 3'),
    delPQ(Closed,S,NewClosed),
    insertPQ(Open,Fprov,node(S,Actions),NewOpen),
    computeCost(Tail, NewOpen, NewClosed, FinalOpen, FinalClosed).
computeCost([_|Tail], Open, Closed, FinalOpen, FinalClosed):-
    %altrimenti
    %write('caso 4'),
    computeCost(Tail, Open, Closed, FinalOpen, FinalClosed).

% unzip(+PQElem, -State, -Actions)
unzip(pq(_,node(S,Actions)), S, Actions).