% vincoli ore corso (gestisce anche le ore di recupero)
:- X != #count{I : calendar(_, _, _, I, S, _)}, subject(S, _, X).
%test6(S, X) :- X = #count{I : calendar(_, _, _, I, S, _)}, subject(S, _, _).
%#show test6/2.

% vincolo no due corsi nello stesso slot
:- calendar(_, _, _, I, S1, _), calendar(_, _, _, I, S2, _), S1 != S2.

% Vincoli rigidi -------------------------------------------------------------------------------------------------------

% 1. lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
:- #count{I : calendar(W, D, _, I, _, P)} > 4, week(W), day(D), prof(P).

% 2. a ciascun insegnamento vengono assegnate minimo 2 ore e massimo 4 ore al giorno
% serve lo 0 perchè non possiamo obbligare ogni subj a essere presente tutt i giorni
:- 1 = #count{I : calendar(W, D, _, I, S, _)} > 4, week(W), day(D), subject(S, _, _).

% 3. il primo giorno di lezione prevede che, nelle prime due ore, vi sia la presentazione del master
:- calendar(_, _, _, I1, "Intro", _), calendar(_, _, _, I2, S, _), subject(S, _, _), I1 > I2, S != "Intro".

% 4. il calendario deve prevedere almeno 2 blocchi liberi di 2 ore ciascuno per eventuali recuperi di lezioni annullate o rinviate
% Questo vincolo è modellato alla riga 31 di facts.cl

% 5. l’insegnamento “Project Management” deve concludersi non oltre la prima settimana full-time, W <= 7
:- calendar(W, _, _, _, "Project Management", _), W > 7.

% 6. il corso 1 deve iniziare prima che il corso 2 termini, non serve >= (che negato diventa < stretto) perchè c'è già il vincolo sulla non sovrapposizione
:- calendar(_, _, _, I1, "Accessibilità e usabilità nella progettazione multimediale", _), 
calendar(_, _, _, I2, "Linguaggi di markup", _), 
first(I1, "Accessibilità e usabilità nella progettazione multimediale"), last(I2, "Linguaggi di markup"), I1 > I2.
last(X, S) :- X = #max{I : calendar(_, _, _, I, S, _)}, subject(S, _, _).
first(X, S) :- X = #min{I : calendar(_, _, _, I, S, _)}, subject(S, _, _).
%test2(X) :- X = #max{I : calendar(_, _, _, I, "subj2", _)}.
%test1(X) :- X = #min{I : calendar(_, _, _, I, "subj1", _)}.
%#show test2/1.
%#show test1/1.

% 7. Le lezioni dei vari insegnamenti devono rispettare la propedeuticità sul testo del progetto
:- calendar(_, _, _, I1, S1, _), calendar(_, _, _, I2, S2, _), propaedeutic(S1, S2), I1 > I2.

% Vincoli auspicabili --------------------------------------------------------------------------------------------------

% 1. La lunghezza corsi non deve superare le 6 settimane
%:- X = #count{W : calendar(W, _, _, _, S, _)}, subject(S, _, _), subject(S, _, _), X > 6.
:- X = #count{W : calendar(W, _, _, _, S, _)}, subject(S, _, _), X > 6.
%length(X, S) :- X = #count{W : calendar(W, _, _, _, S, _)}, subject(S, _, _).
%#show length/2.

% 2. la prima lezione degli insegnamenti “Crossmedia: articolazione delle scritture multimediali” e “Introduzione al social media management” 
% devono essere collocate nella seconda settimana full-time
:- calendar(W, _, _, _, "Crossmedia: articolazione delle scritture multimediali", _), W != 16.
:- calendar(W, _, _, _, "Introduzione al social media management", _), W != 16.

% 3. le lezioni dei vari insegnamenti devono rispettare le seguenti propedeuticità, in particolare la prima lezione 
% dell’insegnamento della colonna di destra deve essere successiva alle prime 4 ore di lezione del corrispondente 
% insegnamento della colonna di sinistra
:- fourth_hour(X, S1), first_right(Y, S2), propaedeuticSoft(S1, S2), Y < X.

% Ritorna tutti gli slot (X) del subject S maggiori di I
gt(X, I, S) :- calendar(_, _, _, X, S, _), calendar(_, _, _, I, S, _), X > I, propaedeuticSoft(S, _).

first_left(X, S) :- X = #min{I : calendar(_, _, _, I, S, _)}, propaedeuticSoft(S,_).
first_right(X, S) :- X = #min{I : calendar(_, _, _, I, S, _)}, propaedeuticSoft(_,S).
all_greater_than_1(X, S) :- gt(X, Y, S), first_left(Y, S), propaedeuticSoft(S, _).
second_hour(X, S) :- X = #min{Y : all_greater_than_1(Y, S)}, propaedeuticSoft(S, _).
all_greater_than_2(X, S) :- gt(X, Y, S), second_hour(Y, S), propaedeuticSoft(S, _).
third_hour(X, S) :- X = #min{Y : all_greater_than_2(Y, S)}, propaedeuticSoft(S, _).
all_greater_than_3(X, S) :- gt(X, Y, S), third_hour(Y, S), propaedeuticSoft(S, _).
fourth_hour(X, S) :- X = #min{Y : all_greater_than_3(Y, S)}, propaedeuticSoft(S, _).
%#show first_right/2.
%#show fourth_hour/2.

% 4. la distanza fra l’ultima lezione di “Progettazione e sviluppo di applicazioni web su dispositivi mobile I” e la 
% prima di “Progettazione e sviluppo di applicazioni web su dispositivi mobile II” non deve superare le due settimane.

% TEMP 1
%pred("Progettazione e sviluppo di applicazioni web su dispositivi mobile I").
%pred("Progettazione e sviluppo di applicazioni web su dispositivi mobile II").
%:- calendar(W1, _, _, _, "Progettazione e sviluppo di applicazioni web su dispositivi mobile I", _), 
%calendar(W2, _, _, _, "Progettazione e sviluppo di applicazioni web su dispositivi mobile II", _), 
%first_week(W1, "Progettazione e sviluppo di applicazioni web su dispositivi mobile I"), 
%last_week(W2,"Progettazione e sviluppo di applicazioni web su dispositivi mobile II"),
% W1 > W2.

%last_week(X, S) :- X = #max{W : calendar(W, _, _, _, S, _)}, subject(S, _, _).
%first_week(X, S) :- X = #min{W : calendar(W, _, _, _, S, _)}, subject(S, _, _).

% TEMP 2
% :- X = #count{W : calendar(W, _, _, I, _, _)}, 
% last(I1, "Progettazione e sviluppo di applicazioni web su dispositivi mobile I"), 
% first(I2, "Progettazione e sviluppo di applicazioni web su dispositivi mobile II"), 
% X > 2.


%distance_week(X2 - X1) :- X2 = #max{W : calendar(W, _, _, _, S1, _)}, subject(S1, _, _), 
%                              X1 = #min{W : calendar(W, _, _, _, S2, _)}, subject(S2, _, _).

%minus(L-R, X1, X2) :- L = X1, R = X2.
%minus(L-R) :- left(L), right(R)
%totals(P, S) :- S = #sum[ curr(P,I) = I ], pick(P).

#show calendar/6.
%#show test1/2.
%#show test2/2.
%#show test3/2.
%#show test4/3.
%#show distance_week/3.
