% applicable(+State, -Action)
applicable(pos(Row,Column), est):-
    num_columns(NC),
    Column<NC,
    NearColumn is Column+1,
    \+occupied(pos(Row,NearColumn)).

applicable(pos(Row,Column), west):-
    Column>1,
    NearColumn is Column-1,
    \+occupied(pos(Row,NearColumn)).

applicable(pos(Row,Column), nord):-
    Row>1,
    AboveRow is Row-1,
    \+occupied(pos(AboveRow,Column)).

applicable(pos(Row,Column), south):-
    num_rows(NR),
    Row<NR,
    BelowRow is Row+1,
    \+occupied(pos(BelowRow,Column)).

% transform(+Action, +State, -NewState)
transform(est,pos(Row,Column),pos(Row,NearColumn)):-
    NearColumn is Column+1.
transform(west,pos(Row,Column),pos(Row,NearColumn)):-
    NearColumn is Column-1.
transform(nord,pos(Row,Column),pos(AboveRow,Column)):-
    AboveRow is Row-1.
transform(south,pos(Row,Column),pos(BelowRow,Column)):-
    BelowRow is Row+1.