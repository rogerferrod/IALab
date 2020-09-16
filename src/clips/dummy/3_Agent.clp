;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT 
	(import MAIN ?ALL)
	(import ENV ?ALL)
	(import HEAT ?ALL)
	;(import DELIBERATE ?ALL) 
	;(import PLANNING ?ALL) 
	(export ?ALL)
)

(defrule go-on-heat-first (declare (salience 30))
  ?f <- (first-pass-to-heat)
=>
  (retract ?f)
  (focus HEAT)
)

; (defrule go-on-deliberate (declare (salience 30))
; 	(status (step ?s)(currently running))
; =>
; 	(printout t crlf crlf)
;     (printout t "vado a deliberate  step" ?s crlf)
; 	(focus DELIBERATE) 
; )

; (defrule go-on-planning (declare (salience 20))
; 	(status (step ?s)(currently running))
; =>
; 	(printout t crlf crlf)
;     (printout t "vado a planning  step" ?s crlf)
; 	(focus PLANNING)
; )


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

