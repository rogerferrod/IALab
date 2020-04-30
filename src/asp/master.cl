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

% vincoli ore corso
:- X != #count{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, _, X).
%test6(S, X) :- X = #count{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, _, _).
%#show test6/2.

% vincolo no due corsi nello stesso slot
:- calendar(_, _, _, I, lecture(S1, _)), calendar(_, _, _, I, lecture(S2, _)), S1 != S2.


% Vincoli rigidi -------------------------------------------------------------------------------------------------------

% 1. lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
:- #count{I : calendar(W, D, _, I, lecture(_, P))} > 4, week(W), day(D), prof(P).

% 2. a ciascun insegnamento vengono assegnate minimo 2 ore e massimo 4 ore al giorno
% serve lo 0 perchè non possiamo obbligare ogni subj a essere presente tutt i giorni
:- 1 = #count{I : calendar(W, D, _, I, lecture(S, _))} > 4, week(W), day(D), subject(S, _, _).

% TODO: Da sistemare
% 3. il primo giorno di lezione prevede che, nelle prime due ore, vi sia la presentazione del master
:- calendar(_, _, _, I1, lecture("Intro", _)), calendar(_, _, _, I2, lecture(S, _)), subject(S, _, _), I1 > I2, S != "Intro".

% il corso 1 deve iniziare prima che il corso 2 termini, non serve >= (che negato diventa < stretto) xke c'è già il vincolo sulla non sovrapposizione
:- calendar(_, _, _, I1, lecture("Accessibilità e usabilità nella progettazione multimediale", _)), calendar(_, _, _, I2, lecture("Linguaggi di markup", _)), first(I1, "Accessibilità e usabilità nella progettazione multimediale") > last(I2, "Linguaggi di markup").
last(X, S) :- X = #max{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, _, _).
first(X, S) :- X = #min{I : calendar(_, _, _, I, lecture(S, _))}, subject(S, _, _).
%test2(X) :- X = #max{I : calendar(_, _, _, I, lecture("subj2", _))}.
%test1(X) :- X = #min{I : calendar(_, _, _, I, lecture("subj1", _))}.
%#show test2/1.
%#show test1/1.

% 5. l’insegnamento “Project Management” deve concludersi non oltre la prima settimana full-time, W <= 7
:- calendar(W, _, _, _, lecture("Project Management", _)), W > 7.

% 6. Le lezioni dei vari insegnamenti devono rispettare la propedeuticità sul testo del progetto
:- calendar(_, _, _, I1, lecture(S1, _)), calendar(_, _, _, I2, lecture(S2, _)), propaedeutic(S1, S2), I1 > I2.

% Vincoli auspicabili --------------------------------------------------------------------------------------------------

% 1. La lunghezza corsi non deve superare le 6 settimane
%:- first_week(X1, S), last_week(X2, S), subject(S, _, _), (X2 + X1) > 6.
last_week(X, S) :- X = #max{W : calendar(W, _, _, _, lecture(S, _))}, subject(S, _, _).
first_week(X, S) :- X = #min{W : calendar(W, _, _, _, lecture(S, _))}, subject(S, _, _).
test1b(S, X) :- first_week(X1, S), last_week(X2, S), subject(S, _, _), X = minus(X2, X1).

% 2. la prima lezione degli insegnamenti “Crossmedia: articolazione delle scritture multimediali” e “Introduzione al social media management” 
% devono essere collocate nella seconda settimana full-time
:- calendar(W, _, _, _, lecture("Crossmedia: articolazione delle scritture multimediali", _)), W != 16.
:- calendar(W, _, _, _, lecture("Introduzione al social media management", _)), W != 16.

%#show calendar/5.
#show test1b/2.