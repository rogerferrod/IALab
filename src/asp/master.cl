%% Vincoli ore corso (gestisce anche le ore di recupero)
:- X != #count{I : calendar(_, _, _, I, S, _)}, subject(S, _, X).
%test5(S, X) :- X = #count{I : calendar(_, _, _, I, S, _)}, subject(S, _, _).

%% Vincolo no due corsi nello stesso slot
:- calendar(_, _, _, I, S1, _), calendar(_, _, _, I, S2, _), S1 != S2.

% Vincoli Rigidi ---------------------------------------------------------------------------------------------------------

%% 1. lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
:- #count{I : calendar(W, D, _, I, _, P)} > 4, week(W), day(D), prof(P).

%% 2. A ciascun insegnamento vengono assegnate minimo 2 ore e massimo 4 ore al giorno
% bisogna considerare anche la possibilità di non avere una lezione, pertanto escludiamo solamente il valore 1 (unico valore discreto tra 0 e 2)
:- 1 = #count{I : calendar(W, D, _, I, S, _)} > 4, week(W), day(D), subject(S, _, _).

%% 3. Il primo giorno di lezione prevede che, nelle prime due ore, vi sia la presentazione del master
:- calendar(_, _, _, I1, "Introduzione al Master", _), calendar(_, _, _, I2, S, _), subject(S, _, _), I1 > I2, S != "Introduzione al Master".

%% 4. Il calendario deve prevedere almeno 2 blocchi liberi di 2 ore ciascuno per eventuali recuperi di lezioni annullate o rinviate
% questo vincolo è modellato implicitamente in facts.cl

%% 5. L’insegnamento “Project Management” deve concludersi non oltre la prima settimana full-time (W <= 7)
:- calendar(W, _, _, _, "Project Management", _), W > 7.

%% 6. Il corso 1 deve iniziare prima che il corso 2 termini
% non serve >= (che negato diventa < stretto) perchè c'è già il vincolo sulla non sovrapposizione
:- calendar(_, _, _, I1, "Accessibilità e usabilità nella progettazione multimediale", _), 
   calendar(_, _, _, I2, "Linguaggi di markup", _), 
   period(I1,_,"Accessibilità e usabilità nella progettazione multimediale"), period(_,I2, "Linguaggi di markup"), I1 > I2.


%% 7. Le lezioni dei vari insegnamenti devono rispettare la propedeuticità
:- calendar(_, _, _, I1, S1, _), calendar(_, _, _, I2, S2, _), propaedeutic(S1, S2), I1 > I2.
%:- period(_, L, S1), period(F, _, S2), propaedeutic(S1, S2), L > F.

% Vincoli Auspicabili --------------------------------------------------------------------------------------------------

%% 1. La lunghezza dei corsi non deve superare le 6 settimane

% Intepretazione 1: Il corso non deve coprire più di 6 settimane (diverse)
%:- X = #count{W : calendar(W, _, _, _, S, _)}, subject(S, _, _), X > 6.
% Interpretazione 2: La durata di un corso non deve superare le 6 settimane (da inizio alla fine)
:- week_length(X, S), subject(S, _, _), X > 6.

%% 2. La prima lezione degli insegnamenti “Crossmedia: articolazione delle scritture multimediali” e “Introduzione al social media management” 
%% devono essere collocate nella seconda settimana full-time
:- calendar(W, _, _, _, "Crossmedia: articolazione delle scritture multimediali", _), W != 16.
:- calendar(W, _, _, _, "Introduzione al social media management", _), W != 16.

%% 3. Le lezioni dei vari insegnamenti devono rispettare le seguenti propedeuticità, in particolare la prima lezione 
%% dell’insegnamento della colonna di destra deve essere successiva alle prime 4 ore di lezione del corrispondente 
%% insegnamento della colonna di sinistra
:- fourth_hour(X, S1), first_right(Y, S2), propaedeuticSoft(S1, S2), Y < X.

first_left(X, S) :- X = #min{I : calendar(_, _, _, I, S, _)}, propaedeuticSoft(S,_).
first_right(X, S) :- X = #min{I : calendar(_, _, _, I, S, _)}, propaedeuticSoft(_,S).
all_greater_than_1(X, S) :- gt(X, Y, S), first_left(Y, S), propaedeuticSoft(S, _).
second_hour(X, S) :- X = #min{Y : all_greater_than_1(Y, S)}, propaedeuticSoft(S, _).
all_greater_than_2(X, S) :- gt(X, Y, S), second_hour(Y, S), propaedeuticSoft(S, _).
third_hour(X, S) :- X = #min{Y : all_greater_than_2(Y, S)}, propaedeuticSoft(S, _).
all_greater_than_3(X, S) :- gt(X, Y, S), third_hour(Y, S), propaedeuticSoft(S, _).
fourth_hour(X, S) :- X = #min{Y : all_greater_than_3(Y, S)}, propaedeuticSoft(S, _).

%% 4. la distanza fra l’ultima lezione di “Progettazione e sviluppo di applicazioni web su dispositivi mobile I” e la 
% prima di “Progettazione e sviluppo di applicazioni web su dispositivi mobile II” non deve superare le due settimane.
:- week_distance_4(X, S1, S2), subject(S1, _ ,_), subject(S2, _ ,_), X > 2, 
   S1="Progettazione e sviluppo di applicazioni web su dispositivi mobile I", 
   S2="Progettazione e sviluppo di applicazioni web su dispositivi mobile II".

week_distance_4(L/100-F/100, S1, S2) :- period(_, L, S1), period(F, _, S2), subject(S1, _ ,_), subject(S2, _ ,_), L!=#inf, F!=#sup,
   S1="Progettazione e sviluppo di applicazioni web su dispositivi mobile I", 
   S2="Progettazione e sviluppo di applicazioni web su dispositivi mobile II".

% Predicati ausiliari --------------------------------------------------------------------------------------------------
%% Ritorna tutti gli slot (X) del subject S successivi allo slot I
gt(X, I, S) :- calendar(_, _, _, X, S, _), calendar(_, _, _, I, S, _), X > I, propaedeuticSoft(S, _).

%% Calcola la durata (in settimane) di ogni subject
week_length(L/100-F/100, S) :- period(F, L, S), subject(S, _ ,_), L!=#inf, F!=#sup.

%% Ritorna slot iniziale e finale di ogni subject
period(F, L, S) :-F = #min{I: calendar(_, _, _, I, S, _)}, L = #max{I: calendar(_, _, _, I, S, _)},  subject(S, _, _). 

#show calendar/6.
%#show test1/2.
%#show test2/2.
%#show test3/2.
%#show test4/3.
%#show test5/2.
%#show first_right/2.
%#show fourth_hour/2.
%#show week_distance_4/3.
%#show gt/3.
%#show week_length/2.
%#show period/3.