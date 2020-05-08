% PROBLEMA ORIGINALE
%
% 358 ore + 2 ore di introduzione = 360 ore
% 24 settimane
%   22 settimane "normali" (da 12 ore, di cui 4 il sabato)
%   2 settimane "full" (44)
% 352 -> 6 sabati da 5 necessari

#const n_weeks = 24. % 24 settimane
#const n_days = 6. % max giorni in una settimana

% settimane
week(1..n_weeks).
day(1..n_days).
hour(1..8).

fullweek(7). % la settima settimana è piena
fullweek(16). % la sedicesima settimana è piena
fullday(1..5). % giorni feriali (lun-ven) da 8 ore (ci serve per il sabato)

% Prodotto cartesiano con possibilità nullable
0 {calendar(W, D, H, W*100+D*10+H, lecture(S, P))} 1 :- week(W), day(D), hour(H), subject(S, P, _).

% Tutte le settimane hanno 2 giorni, eccotto quelle "full"
:- 2 != #count{D : calendar(W, D, _, _, lecture(_, _))}, week(W), not fullweek(W).
%test1(W, X) :- X = #count{D : calendar(W, D, _, _, lecture(_, _))}, week(W), not fullweek(W).
%#show test1/2.

% settimane full hanno 6 giorni
:- 6 != #count{D : calendar(W, D, _, _, lecture(_, _))}, fullweek(W).
%test2(W, X) :- X = #count{D : calendar(W, D, _, _, lecture(_, _))}, fullweek(W).
%#show test2/2.

% il sabato ha 4 o 5 ore
% TODO: da controllare la sitassi
:- #count{I : calendar(W, D, _, I, lecture(_, _))} > 5, week(W), day(D), not fullday(D).
:- #count{I : calendar(W, D, _, I, lecture(_, _))} < 4, week(W), day(D), not fullday(D).
%test3(W, X) :- X = #count{I : calendar(W, D, _, I, lecture(_, _))}, week(W), day(D), not fullday(D).
%#show test3/2.

% I giorni delle settimane fullweek (lun-ven) hanno 8 ore
:- 8 != #count{I : calendar(W, D, _, I, lecture(_, _))}, fullweek(W), fullday(D).
%test4(W, D, X) :- X = #count{I : calendar(W, D, _, I, lecture(_, _))}, week(W), day(D).
%#show test4/3.

% I venerdì delle settimane "normali" (non fullweek) hanno 8 ore
:- 8 != #count{I : calendar(W, 5, _, I, lecture(_, _))}, week(W), not fullweek(W).
%test5(W, D, X) :- X = #count{I : calendar(W, D, _, I, lecture(_, _))}, week(W), day(D).
%#show test5/3.
