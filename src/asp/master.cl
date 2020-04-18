%1 settimana piena (5 giorni da 8 ore + sabato)
%1 settimana ridotta (1 giorno da 8 ore + sabato)
%sabato può avere 4 o 5 ore

% per semplicità considero solo 3 settimane:
% la prima ridotta, la seconda piena, la terza ridotta

#const n_weeks = 3. % 3 settimane
#const n_days = 10. % 10 giorni in 3 settimane
#const n_hours = 80. % max 80 ore in 3 settimane

% subj, n_hour
subject("subj1", 20).
subject("subj2", 20).
subject("subj3", 20).
subject("subj4", 20).

prof("prof1").
prof("prof2").
prof("prof3").

% settimane
week(1..n_weeks).
day(1..n_days).
hour(1..n_hours).

full(2). % la seconda settimana è piena



1 {calendar(W, D, H, lecture(S, P)) : week(W), hour(H), subject(S, _), prof(P)} 8 :- day(D). % max 8 ore al giorno

% tutte le settimane hanno 2 giorni, eccotto quelle "full"
:- not 2 = #count{D : calendar(W, D, _, lecture(_, _))}, week(W), not full(W).

% settimane full hanno 6 giorni
:- not 6 = #count{D : calendar(W, D, _, lecture(_, _))}, full(W).

% vincoli ore corso
:- not X = #count{H : calendar(_, _, H, lecture(S, _))}, subject(S, X).

#show calendar/4.

