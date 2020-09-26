;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT 
	(import MAIN ?ALL)
	(import ENV ?ALL)
	(import HEAT ?ALL)
	(import DISCOVER ?ALL)
	(import DELIBERATE ?ALL) 
	(import PLANNING ?ALL) 
	(export ?ALL)
)

;;
;;
;;


;; --------------------------------------
;; RULES
;; --------------------------------------

(defrule go-on-heat-first (declare (salience 40)) ; force to compute heatmap as first game step
  ?f <- (first-pass-to-heat)
=>
  (retract ?f)
  (focus HEAT)
)

(defrule go-on-discover-first (declare (salience 30)) ; force to discover k-cell known from game beginning
	?f <- (first-pass-to-discover)
=>
	(retract ?f)
	(focus DISCOVER)
)

(defrule execute-fire (declare (salience 30))
	(status (step ?s) (currently running))
	?f <- (intention-fire (x ?x) (y ?y))
=>
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(assert (check-fire ?x ?y)) ; MEMO: controllare il risultato della fire richiesta
	(retract ?f)
	(pop-focus)
)

(defrule go-on-discover (declare (salience 30))
	(check-fire ?x ?y)
=>
	(focus DISCOVER)
)


;
; AGENT - DELIB - AGENT - PLANNING
;

(defrule solve (declare (salience 20))
	(status (step ?s)(currently running))
	?f <- (intention-solve)
=>
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)

(defrule go-on-planning (declare (salience 20))
	(status (step ?s)(currently running))
	(or
		(intention-sink)
		; ...
	)
=>
	;(printout t crlf crlf)
    (printout t "vado a planning  step" ?s crlf)
	(focus PLANNING)
)


(defrule explode-actions (declare (salience 10)) ; TODO: valutare se togliere salience
	(status (step ?s) (currently running))
	(plan-stack (lastplan ?plan))
	?p <- (plan (id ?plan) (counter ?i) (action-sequence $?actions))
	(test (<= ?i (length$ ?actions)))
=>
	(assert (action-to-exec(nth$ ?i $?actions)))
	(modify ?p (counter (+ ?i 1)))
)

(defrule execute-action (declare (salience 10))
	(status (step ?s) (currently running))
	?f <- (action-to-exec ?id)
	(action (id ?id) (type ?t) (x ?x) (y ?y))
=>
	(retract ?f)
	(if (eq ?t water)
		then 
			(assert (b-cell (x ?x) (y ?y) (content water)))
			(printout t "Assert water " ?x " " ?y crlf)
		else 
			(assert (exec (step ?s) (action ?t) (x ?x) (y ?y)))
			(assert (b-cell (x ?x) (y ?y) (content boat)))
			(printout t "Exec " ?t " on " ?x " " ?y crlf)
			(pop-focus)
	)
)

(defrule go-on-deliberate
	(status (step ?s)(currently running))
=>
    (printout t "vado a deliberate  step" ?s crlf)
	(focus DELIBERATE) 
)

; (defrule print-what-i-know-since-the-beginning
; 	(k-cell (x ?x) (y ?y) (content ?t))
; =>
; 	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
; )
