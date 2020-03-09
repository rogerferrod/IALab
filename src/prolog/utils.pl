% nth(+List, +Position, -Value)
nth([Head|_], 0, Head):-!.
nth([_|Tail], Pos, X):-
    nonvar(Pos),!,
    Pos1 is Pos-1,
    nth(Tail,Pos1,X).
nth([_|Tail], Pos, X):-
    nth(Tail,Pos1,X),
    Pos is Pos1+1.

% swap(+List, +Pos1, +Pos2, -NewList)
swap(Lista, Pos1, Pos2, NuovaLista):-
  nth(Lista,Pos1,X1),
  nth(Lista,Pos2,X2),
  setElement(Lista,Pos2,X1,Temp),
  setElement(Temp,Pos1,X2,NuovaLista).

% setElement(+List, +Position, +Value, -NewList)
setElement([_|Tail], 0, X, [X|Tail]):-!.
setElement([Head|Tail], Pos, X, [Head|NuovaTail]):-
  Pos1 is Pos-1,
  setElement(Tail,Pos1,X,NuovaTail).

% reverse(+List, -NewList)
reverse([], _):-!,fail.
reverse(Lista, Reversed):-reverseAux(Lista,[],Reversed).
reverseAux([], Temp, Temp).
reverseAux([Head|Tail], Temp, Res):-reverseAux(Tail,[Head|Temp],Res).

/*
* Priority Queue (key=priority)
* specifica per A*
* [pq(k, node(S,Actions))]
*
* non ci sono duplicati, unico State
*/

% insertPQ(+OldPQ, +Key, +Value, -NewPQ)
insertPQ(OldPQ, Key, node(S,Actions), NewPQ):-
  \+getKeyPQ(OldPQ, S, _),!, % se non c'è lo aggiunge
  insertPQAux(OldPQ, Key, node(S,Actions), NewPQ).
insertPQ(OldPQ, Key, node(S,Actions), NewPQ):-
  getKeyPQ(OldPQ, S, OldKey), 
  Key < OldKey,!, % se il nuovo valore è minore di quello vecchio, aggiorna
  updatePQ(OldPQ, Key, node(S,Actions), NewPQ).
insertPQ(OldPQ, _, _, OldPQ). % altrimenti rimane invariato

% insertPQAux(+OldPQ, +Key, +Value, -NewPQ)
insertPQAux([], Key, Value, [pq(Key,Value)]).
insertPQAux([pq(K,V)|Tail], Key, Value, [pq(Key,Value)|[pq(K,V)|Tail]]):- %inserimento in testa
  K > Key,!.
insertPQAux([Head|Tail], Key, Value, [Head|Queue]):-
  insertPQ(Tail,Key,Value,Queue).

% updatePQ(OldPQ, Key, +Value, -NewPQ)
updatePQ(OldPQ, Key, node(S,Actions), NewPQ):-
  delPQ(OldPQ,S,Temp),
  insertPQ(Temp,Key,node(S,Actions),NewPQ).

% popPQ(+OldPQ, -NewPQ, -Head)
popPQ([Head|Tail],Tail,Head). % rimozione testa

% topPQ(+PQ, -Head)
topPQ([Head|_],Head). % senza rimozione

% getElemPQ(+PQ, +State, -Key)
getKeyPQ([], _, _):-fail.
getKeyPQ([pq(K,node(V,_))|_], V, K):-!.
getKeyPQ([pq(_,_)|Tail], Value, K):-
  getKeyPQ(Tail, Value, K).

% delPQ(+PQ, +State, -NewPQ)
delPQ([], _, []).
delPQ([pq(_,node(V,_))|Tail], V, Tail):-!.
delPQ([Head|Tail], Value, [Head|NewTail]):-
  delPQ(Tail,Value,NewTail).