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

(defrule solve
	(status (step ?s)(currently running))
	?f <- (intention-solve)
=>
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)

(defrule go-on-planning
	(status (step ?s)(currently running))
	(or
		(intention-sink)
		(intention-abort)
	)
=>
    ;(printout t "vado a planning  step" ?s crlf)
	(focus PLANNING)
)


(defrule select-action
	(status (step ?s) (currently running))
	(plan-stack (lastplan ?plan))
	?p <- (plan (id ?plan) (counter ?i) (action-sequence $?actions))
	(test (<= ?i (length$ ?actions)))
=>
	(assert (action-to-exec(nth$ ?i $?actions))) ; TODO togliere ildollaro?
	(if (< ?i (length$ ?actions))
		then
			(modify ?p (counter (+ ?i 1))) ; go forward to the index of the next action		
	)
)

(defrule select-action-to-delete
	(status (step ?s) (currently running))
	?b <- (backtracking ?plan)
	?p <- (plan (id ?plan) (counter ?i) (action-sequence $?actions))
	(test (>= ?i 1)) ; exectute backward until the first action of the plan-
=>
	(if (eq 1 ?i)
		then
			(retract ?b)
			(assert (action-to-delete(nth$ ?i $?actions))) 
		else
			(assert (action-to-delete(nth$ ?i $?actions))) 
			(modify ?p (counter (- ?i 1))) ; go backward
	)
	;(printout t "backtrack " ?plan " con i=" ?i crlf)
)

(defrule execute-action
	(status (step ?s) (currently running))
	?f <- (action-to-exec ?id)
	(action (id ?id) (type ?t) (x ?x) (y ?y))
=>
	(retract ?f)
	(if (eq ?t water)
		then 
			(assert (b-cell (x ?x) (y ?y) (content water)))
		else 
			(assert (exec (step ?s) (action ?t) (x ?x) (y ?y)))
			(assert (b-cell (x ?x) (y ?y) (content boat)))
			(pop-focus)
	)
)

(defrule delete-action-guess
	(status (step ?s) (currently running))
	?f <- (action-to-delete ?id)
	(action (id ?id) (type guess) (x ?x) (y ?y))
	?b <- (b-cell (x ?x) (y ?y) (content boat))
=>	
	(assert (exec (step ?s) (action unguess) (x ?x) (y ?y)))
	(retract ?f)
	(retract ?b) 
	(pop-focus)
)

(defrule delete-action-water
	(status (step ?s) (currently running))
	?f <- (action-to-delete ?id)
	(action (id ?id) (type water) (x ?x) (y ?y))
	?b <- (b-cell (x ?x) (y ?y) (content water))
=>
	(retract ?f)
	(retract ?b)
)

(defrule go-on-deliberate (declare (salience -5))
	(status (step ?s)(currently running))
=>
    (printout t "vado a deliberate  step" ?s crlf)
	(focus DELIBERATE) 
)
