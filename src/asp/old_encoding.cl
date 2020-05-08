
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
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), day(D), hour(H), subject(S,P,_).



% vincolo no due corsi nello stesso slot
%:- calendar(_, _, _, I, lecture(S1, _)), calendar(_, _, _, I, lecture(S2, _)), S1 != S2.