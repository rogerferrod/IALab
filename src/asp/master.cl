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
day(1..n_days).
hour(1..8).

%total_days(1..n_days).

fullweek(2). % la seconda settimana è piena

%fullday(1..5). % giorni feriali (lun-ven) da 8 ore

1 {calendar(W, D, H, W*100+D*10+H, lecture(S, P)) : week(W), hour(H), subject(S, _, P)} 8 :- day(D). % max 8 ore al giorno

% tutte le settimane hanno 2 giorni, eccotto quelle "full"
:- not 2 = #count{D : calendar(W, D, _, _, lecture(_, _))}, week(W), not fullweek(W).

% tutti i giorni hanno 8 ore, eccotto quelli non "fullday"
%:- not 8 = #count{D : calendar(_, D, _, _, lecture(_, _))}, day(D), not fullday(D).

% settimane full hanno 6 giorni
:- not 6 = #count{D : calendar(W, D, _, _, lecture(_, _))}, fullweek(W).

% vincoli ore corso
:- not X = #count{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, X, _).

% vincolo no due corsi nello stesso slot
:- calendar(_, _, _, I, lecture(S1, _)), calendar(_, _, _, I, lecture(S2, _)), S1 != S2.

% vincolo propedeutica
:- calendar(_, _, _, I1, lecture(S1, _)), calendar(_, _, _, I2, lecture(S2, _)), propaedeutic(S1, S2), I1 > I2.

% Vincoli Hard -----------------------------------------------------------------

% 1. lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
:- #count{I : calendar(_, D, _, I, lecture(_, P))} > 4, day(D), prof(P).

% 2. a ciascun insegnamento vengono assegnate minimo 2 ore e massimo 4 ore al giorno
:- 1 = #count{I : calendar(W, D, _, I, lecture(S, _))} > 4, day(D), week(W), subject(S, _, _).

test(W, D, X) :- X = #count{I : calendar(W, D, _, I, lecture("subj2", _))}, day(D), week(W).

% testw11(X):- X = #count{I : calendar(1, 1, _, I, lecture(_, "prof1"))}.
% testw12(X):- X = #count{I : calendar(1, 2, _, I, lecture(_, "prof1"))}.
% testw13(X):- X = #count{I : calendar(1, 3, _, I, lecture(_, "prof1"))}.
% testw14(X):- X = #count{I : calendar(1, 4, _, I, lecture(_, "prof1"))}.
% testw15(X):- X = #count{I : calendar(1, 5, _, I, lecture(_, "prof1"))}.
% testw1Tot(X):- X = #count{I : calendar(1, _, _, I, lecture(_, "prof1"))}.

% testw21(X):- X = #count{I : calendar(2, 1, _, I, lecture(_, "prof1"))}.
% testw22(X):- X = #count{I : calendar(2, 2, _, I, lecture(_, "prof1"))}.
% testw23(X):- X = #count{I : calendar(2, 3, _, I, lecture(_, "prof1"))}.
% testw24(X):- X = #count{I : calendar(2, 4, _, I, lecture(_, "prof1"))}.
% testw25(X):- X = #count{I : calendar(2, 5, _, I, lecture(_, "prof1"))}.
% testw2Tot(X):- X = #count{I : calendar(2, _, _, I, lecture(_, "prof1"))}.

#show calendar/5.
%#show test/3.
%#show testw1Tot/1.
%#show testw2Tot/1.

% #show testw11/1.
% #show testw12/1.
% #show testw13/1.
% #show testw14/1.
% #show testw15/1.

% #show testw21/1.
% #show testw22/1.
% #show testw23/1.
% #show testw24/1.
% #show testw25/1.
