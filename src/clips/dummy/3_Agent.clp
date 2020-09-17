;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT 
	(import MAIN ?ALL)
	(import ENV ?ALL)
	(import HEAT ?ALL)
	(import DELIBERATE ?ALL) 
	(import PLANNING ?ALL) 
	(export ?ALL)
)

;; --------------------------------------
;; RULES
;; --------------------------------------

(defrule go-on-heat-first (declare (salience 40))
  ?f <- (first-pass-to-heat)
=>
  (retract ?f)
  (focus HEAT)
)

(defrule execute-fire (declare (salience 30))
	(status (step ?s) (currently running))
	?f <- (intention-fire (x ?x) (y ?y))
=>
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(assert (check-fire ?x ?y))
	(retract ?f)
	(pop-focus)
)

(defrule check-fire-water (declare (salience 30)) ; workaround rule, controlla se la fire è ko, allora la cella contiene acqua
	?f <- (check-fire ?x ?y)
	(not (k-cell (x ?x) (y ?y)))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(retract ?f)
	(assert (k-cell (x ?x) (y ?y) (content water)))
	(modify ?m (h 0))
)

(defrule check-fire-ship (declare (salience 30))
	?f <- (check-fire ?x ?y)
	(k-cell (x ?x) (y ?y) (content ?c&~water))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(retract ?f)
	(modify ?m (h 100))
)

(defrule apply-modify-heat (declare (salience 30))
	?f <- (modify-heat ?x ?y ?h)
	?m <- (heat-map (x ?x) (y ?y))
=>
	(modify ?m (h ?h))
	(retract ?f)
)

;
; AGENT - DELIB - AGENT - PLANNING
;

(defrule go-on-planning (declare (salience 20))
	(status (step ?s)(currently running))
	(or
		(intention-sink)
		; ...
	)
=>
	(printout t crlf crlf)
    (printout t "vado a planning  step" ?s crlf)
	(focus PLANNING)
)


(defrule go-on-deliberate (declare (salience 10))
	(status (step ?s)(currently running))
=>
	(printout t crlf crlf)
    (printout t "vado a deliberate  step" ?s crlf)
	(focus DELIBERATE) 
)


; ; TODO serve la salience?
; (defrule execute (declare (salience 10))
; 	(status (step ?s) (currently running))
; 	?p <- (plan (action-sequence $?as&:(> (length$ ?as) 0)))
; 	?first <- (first$ $?as)
; 	?tail <- (rest$ $?as)
; 	(action (id ?first) (type ?t) (x ?x) (y ?y))
; =>
; 	(modify ?p (action-sequence ?tail ))
; 	(assert (exec (step ?s) (action ?t) (x ?x) (y ?y)))
; 	(printout t "Exec " ?t " on " ?x " " ?y crlf)
; 	(pop-focus)
; )

; (defrule print-what-i-know-since-the-beginning
; 	(k-cell (x ?x) (y ?y) (content ?t))
; =>
; 	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
; )

