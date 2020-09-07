;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT 
	(import MAIN ?ALL) 
	(import ENV ?ALL) 
	(import DELIBERATE ?ALL) 
	(import PLANNING ?ALL) 
	(export ?ALL)
)

(defrule go-on-deliberate (declare (salience 30)
	(status (step ?s)(currently running))
=>
	(focus DELIBERATE) 
)

(defrule go-on-planning (declare (salience 20)
	(status (step ?s)(currently running))
=>
	(focus PLANNING) 
)

(defrule execute (declare (salience 10) ; TODO serve la salience?
	(printout t "Focus on EXECUTE" crlf)
	(status (step ?s)(currently running))
	(plan (action-sequence $?p))
	(> (length$ $?p) 0)
	(action (id (first$ $?p)) (type ?t) (x ?x) (y ?y))
=>
	(assert (exec (step ?s) (action ?t) (x ?x) (y ?y)))
	(pop-focus) 
)

(defrule print-what-i-know-since-the-beginning
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

