#const n_weeks = 24. % 24 settimane
#const n_days = 6. % max giorni in una settimana

week(1..n_weeks).
day(1..n_days).
isFullWeek(7;16).
in_week_hours(1..5,1..8). %(day, hour range)
saturday_hours(6,1..5). % ore del satato


%% Settimane full, giorni lun-gio
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), isFullWeek(W), in_week_hours(D, H), D < 5, subject(S, P, _).

%% Venerdi
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), in_week_hours(D, H), D = 5, subject(S, P,_). 

%% Sabato
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W),  saturday_hours(D,H), subject(S, P,_).

%% Prodotto cartesiano con possibilità nullable (#10528)
test1(W, X) :- X = #count{D : calendar(W, D, _, _, _, _)}, week(W), not isFullWeek(W). % conta il numero di giorni nelle settimane non piene
test2(W, X) :- X = #count{D : calendar(W, D, _, _, _, _)}, isFullWeek(W). % conta il numero di giorni delle settimane piene
test3(W, X) :- X = #count{I : calendar(W, D, _, I, _, _)}, week(W), day(D), not in_week_hours(D, _). % il sabato, della settimana W, ha 4 o 5 ore
test4(W, D, X) :- X = #count{I : calendar(W, D, _, I, _, _)}, week(W), day(D). % cont il numero di ore nel giorno D della settimana W
