% PROBLEMA ORIGINALE
% 358 ore + 2 ore di introduzione = 360 ore
% 24 settimane
%   22 settimane "normali" (da 12 ore, di cui 4 il sabato)
%   2 settimane "full" (44)
% 352 -> 6 sabati da 5 necessari
%


% Relazione d'ordine
% first(30).
% second(10).

% geq(X, Y) :- X >= Y, first(X), second(Y).

% #show geq/2.

%1 settimana piena (5 giorni da 8 ore + sabato)
%1 settimana ridotta (1 giorno da 8 ore + sabato)
%sabato può avere 4 o 5 ore

% per semplicità considero solo 3 settimane:
% la prima ridotta, la seconda piena, la terza ridotta

#const n_weeks = 2. % 2 settimane
#const n_days = 8. % numero totale di giorni, 8 in 2 settimane (2 ful)
%#const n_hours = 58. % max 58 ore in 2 settimane
#const n_hours = 57. % max 58 ore in 2 settimane

prof("prof1").
prof("prof2").
prof("prof3").
prof("prof4").

% subj, n_hour, prof
subject("subj1", 8, "prof1").
subject("subj2", 14, "prof2").
subject("subj3", 24, "prof3").
subject("subj4", 11, "prof1").
%subject("recupero", 1, _).

% subj2 viene prima di subj4
propaedeutic("subj2", "subj4").

% settimane
week(1..n_weeks).
day(1..6).
hour(1..8).

total_days(1..n_days).

fullweek(2). % la seconda settimana è piena

fullday(1..5). % giorni feriali (lun-ven) da 8 ore


temp(5..6).
temp2(1..6).

1 {calendar(W, D, H, W*100+D*10+H, lecture(S, P)) : week(W), day(D), hour(H), subject(S, _, P)} 8 :- total_days(_). % max 8 ore al giorno