#const slots_per_day = 6.
#const days_week = 5.
#const teachers = 11. % è ragionevole pensare che si conosca questa informazione a priori
#const classes = 6.

% aule + laboratori subject(materia, num_ore, num_insegnanti)
% 1 lettere, 2 matematica, 3 scienze, 4 musica, 5 inglese, 6 spagnolo, 7 religione, 8 arte, 9 tecnologia, 10 palestra
subject("itaA", 5, 1). 
subject("itaB", 5, 1). 
subject("mat", 4, 2).
subject("sci", 2, 2).
subject("mus", 2, 1).
subject("ing", 3, 1).
subject("spa", 2, 1).
subject("rel", 1, 1).
subject("art", 2, 1).
subject("tec", 2, 1).
subject("gym", 2, 1).

% corsi con insegnante in comune
shared_course("mat").
shared_course("sci").

% classi
% 1 IA, 2 IIA, 3 IIIA, 4 IB, 5 IIB, 6 IIIB
class("IA").
class("IIA").
class("IIIA").
class("IB").
class("IIB").
class("IIIB").

% insegnanti
teacher(1..teachers).

% giorni
day(1..days_week).

% slot orari settimanali
slot(1..slots_per_day*days_week).


% calendario  calendar(slot_orario, lecture(classe, insegnante, aula)
1 {calendar(H, lecture(C, I, S)) : class(C), teacher(I), subject(S, _, _)} classes :- slot(H). % al massimo #classes corsi per slot


% vincolo no classi diverse nella stessa aula (e nello stesso slot)
:- calendar(H, lecture(C1, _, S)), calendar(H, lecture(C2, _, S)), C1 != C2.

% la classe non può seguire più corsi nello stesso slot
:- calendar(H, lecture(C, _, S1)), calendar(H, lecture(C, _, S2)), S1 != S2.

% vincolo monte ore per ogni corso
%:- not 4 = #count{H : calendar(H, lecture(C, "subj"))}, class(C). for each "subj"
:- not X = #count{H : calendar(H, lecture(C, _, S))}, class(C), subject(S, X, _).
testH(C, S, X):- X = #count{H : calendar(H, lecture(C, _, S))}, class(C), subject(S, _, _).
testHI(I, X) :- X = #count{H : calendar(H, lecture(_, I, _))}, teacher(I).
testIS(S, I) :- calendar(_, lecture(_, I, S)).

% vincolo insegnante non può occupare più aule nello stesso slot
:- calendar(H, lecture(_, I, S1)), calendar(H, lecture(_, I, S2)), S1 != S2.

% vincolo un insegnante può insegnare solo 1 corso, eccetto matematica e scienze
shared_courses(X, Y) :- shared_course(X), shared_course(Y), X != Y.
:- calendar(_, lecture(_, I, S1)), calendar(_, lecture(_, I, S2)), S1 != S2, not shared_courses(S1, S2).

% vincolo insegnante di matematica insegna anche scienze
:- not calendar(_, lecture(_, I, "mat")), calendar(_, lecture(_, I, "sci")).

% vincolo num_insegnanti per ogni corso
:- not X = #count{I : calendar(_, lecture(_, I, S))}, subject(S, _, X).
testI(S, X) :- X = #count{I : calendar(_, lecture(_, I, S))}, subject(S, _, _).

%excount(T) :- T = #count{H : day(H)}.
#show calendar/2.
%#show testH/3.
%#show testHI/2.
%#show testIS/2.
%#show testI/2.
