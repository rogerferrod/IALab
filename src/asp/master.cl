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
#const n_days = 8. % 8 giorni in 2 settimane
#const n_hours = 58. % max 58 ore in 2 settimane

% subj, n_hour
subject("subj1", 14).
subject("subj2", 14).
subject("subj3", 14).
subject("subj4", 16).

% subj1 viene prima di subj4
propaedeutic("subj1", "subj2").
propaedeutic("subj2", "subj3").

prof("prof1").
prof("prof2").
prof("prof3").

% settimane
week(1..n_weeks).
day(1..n_days).
hour(1..8).

full(2). % la seconda settimana è piena

1 {calendar(W, D, H, W*100+D*10+H, lecture(S, P)) : week(W), hour(H), subject(S, _), prof(P)} 8 :- day(D). % max 8 ore al giorno

% tutte le settimane hanno 2 giorni, eccotto quelle "full"
:- not 2 = #count{D : calendar(W, D, _, _, lecture(_, _))}, week(W), not full(W).

% settimane full hanno 6 giorni
:- not 6 = #count{D : calendar(W, D, _, _, lecture(_, _))}, full(W).

% vincoli ore corso
:- not X = #count{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, X).

% vincolo no due corsi nello stesso slot
:- calendar(_, _, _, I, lecture(S1, _)), calendar(_, _, _, I, lecture(S2, _)), S1 != S2.

% vincolo propedeutica
%:- calendar(_, _, _, I1, lecture("subj1", _)), calendar(_, _, _, I2, lecture("subj4", _)), I1 < I2.
:- calendar(_, _, _, I1, lecture(S1, _)), calendar(_, _, _, I2, lecture(S2, _)), propaedeutic(S1, S2), I1 > I2.

#show calendar/5.