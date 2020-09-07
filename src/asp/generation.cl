#const n_weeks = 24. % 24 settimane
#const n_days = 6. % max giorni in una settimana

week(1..n_weeks).
day(1..n_days).
hour(1..8).
isFullWeek(7;16). % settimane full
isFullDay(1..5). % giorni feriali (lun-ven) da 8 ore

%% Prodotto cartesiano con possibilità nullable (#32256)
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), day(D), hour(H), subject(S, P, _).

%% Tutte le settimane hanno 2 giorni, eccetto quelle "full"
:- 2 != #count{D : calendar(W, D, _, _, _, _)}, week(W), not isFullWeek(W).
%test1(W, X) :- X = #count{D : calendar(W, D, _, _, _, _)}, week(W), not isFullWeek(W).
%#show test1/2.

%% Le settimane full hanno 6 giorni
:- 6 != #count{D : calendar(W, D, _, _, _, _)}, isFullWeek(W).
%test2(W, X) :- X = #count{D : calendar(W, D, _, _, _, _)}, isFullWeek(W).
%#show test2/2.

%% Il sabato ha 4 o 5 ore
:- #count{I : calendar(W, D, _, I, _, _)} > 5, week(W), day(D), not isFullDay(D).
:- #count{I : calendar(W, D, _, I, _, _)} < 4, week(W), day(D), not isFullDay(D).
%test3(W, X) :- X = #count{I : calendar(W, D, _, I, _, _)}, week(W), day(D), not isFullDay(D).
%#show test3/2.

%% I giorni feriali (lun-ven) delle settimane full hanno 8 ore
:- 8 != #count{I : calendar(W, D, _, I, _, _)}, isFullWeek(W), isFullDay(D).

%% I venerdì delle settimane "normali" hanno 8 ore
:- 8 != #count{I : calendar(W, 5, _, I, _, _)}, week(W), not isFullWeek(W).
%test4(W, D, X) :- X = #count{I : calendar(W, D, _, I, _, _)}, week(W), day(D).
%#show test4/3.
