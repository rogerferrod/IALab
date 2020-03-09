bfs(Solution):-
    start(S),
    bfs_aux([node(S,[])],[],Sol),
    reverse(Sol, Solution).

% bfs_aux(Coda,Visited,Solution)
% Coda = [node(S,Azioni)|...]
bfs_aux([node(S,Action)|_],_,Action):-goal(S),!.
bfs_aux([node(S,Actions)|Tail],Visited,Solution):-
    findall(Action,applicable(S,Action),ApplicableList),
    generateChildren(node(S,Actions),ApplicableList,[S|Visited],ChildrenList),
    append(Tail,ChildrenList,NewQueue),
    bfs_aux(NewQueue,[S|Visited],Solution).

generateChildren(_,[],_,[]).
generateChildren(node(S,ActionForS),[Action|OtherActions],Visited,[node(SNew,[Action|ActionForS])|ChildrenTail]):-
    transform(Action,S,SNew),
    \+member(SNew,Visited),!,
    generateChildren(node(S,ActionForS),OtherActions,Visited,ChildrenTail).
generateChildren(node(S,ActionForS),[_|OtherActions],Visited,ChildrenTail):-
    generateChildren(node(S,ActionForS),OtherActions,Visited,ChildrenTail).




