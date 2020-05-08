
#const n_weeks = 24. % 24 settimane
#const n_days = 6. % max giorni in una settimana

week(1..n_weeks).
isFullWeek(7;16).

in_week_hours(1..5,1..8). %% available hours from monday to friday (Day number, Hours range)
saturday_hours(6,1..5). %% available hours in saturday only

% generare nella prima settimana alle prime due ore la lezione intro
%calendar(1, 1, 1, 111, "Intro", "").
%calendar(1, 1, 2, 112, "Intro", "").
% bisogna comunqe eliminare la possibilità alle restanti materie di occupare gli slot 111 e 112


%% full weeks from monday to thursday
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), isFullWeek(W), in_week_hours(D, H), D < 5, subject(S, P, _).

%% every week only friday
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W), in_week_hours(D, H), D = 5, subject(S, P,_). 

%% every week only saturday
0 {calendar(W, D, H, W*100+D*10+H, S, P)} 1 :- week(W),  saturday_hours(D,H), subject(S, P,_).
