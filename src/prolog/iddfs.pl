iterative_deepening_search(Solution):-
    Limit is 1,
    iddfs_aux(Limit, Solution).

% iddfs_aux(+Limit, -Solution)
iddfs_aux(Limit, Solution):-
    start(S),
    dfs_aux(S,Limit,[S],Solution),!.
iddfs_aux(Limit, Solution):-
    NewLimit is Limit + 1,
    iddfs_aux(NewLimit, Solution).

% dfs_aux(+State, +Limit, +Visited, -Actions)
dfs_aux(S, _, _, []):-goal(S).
dfs_aux(S, Limit, Visited, [Action|ActionTail]):-
    Limit > 0,
    applicable(S,Action),
    transform(Action,S,NewS),
    \+member(NewS,Visited),
    NewLimit is Limit-1,
    dfs_aux(NewS,NewLimit,[NewS|Visited],ActionTail).
