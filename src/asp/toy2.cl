%% Solo max e min con due predicati diversi => Si
%cal1(1..6).
%cal2(1..6).
%diff(X-Y) :- X=#max{A: cal1(A)}, Y=#min{A: cal2(A)}. 


%% Solo max e min sullo stesso predicato => Si
%cal1(1..6).
%diff(X-Y) :- X=#max{A: cal1(A)}, Y=#min{A: cal1(A)}. 


%% max e min con argomenti (se non si aggiunge subj(S1/S2) le varibili saranno unsafe) => Si
%calendar(1..6,"A").
%calendar(2..4,"B").
%calendar(3..9,"C").
%subj("A";"B";"C").
%diff(X-Y,S1,S2) :- X=#max{A: calendar(A,S1)}, Y=#min{A: calendar(A,S2)}, subj(S1), subj(S2), S1 != S2. 


%% max e min con calendar generato => Si
%subj("A";"B").
%calendar(D,S) :- D=1..6, subj(S).
%diff(X-Y,S1,S2) :- X=#max{A: calendar(A,S1)}, Y=#min{A: calendar(A,S2)}, subj(S1), subj(S2), S1 != S2. 


%% max e min con calendar aggregato => NO!
subj("A";"B").
1{calendar(D,S)}1 :- D=1..6, subj(S).

diff(X-Y,S1,S2) :- first(X, S1), last(Y, S2), subj(S1), subj(S2), X!=#inf, Y!=#sup, S1 != S2. 

first(X, S) :- X=#max{A: calendar(A,S)}, subj(S).




last(X, S) :- X = #min{B: calendar(B,S)}, subj(S).

%period(F,L,S1) :-F=#min{A: calendar(A,S2)},  subj(S2),  L=#max{A: calendar(A,S1)},  subj(S1) . 

#show diff/3.
#show first/2.
#show last/2.