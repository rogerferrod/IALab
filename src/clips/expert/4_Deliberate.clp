(defmodule DELIBERATE 
	(import MAIN ?ALL) 
	(import ENV ?ALL) 
	(import HEAT ?ALL) 
	(import CONVOLUTION ?ALL) 
	(export ?ALL)
)

;; ******************************
;; TEMPLATES
;; ******************************

(deftemplate intention-fire
	(slot x)
	(slot y)
)

(deftemplate intention-sink
	(slot x-stern)
	(slot y-stern)
	(slot orientation (allowed-values ver hor))
	(slot type (allowed-values air-carrier cruiser destroyer submarine))
)

;; ******************************
;; RULES
;; ******************************

(defrule make-intention-fire (declare (salience 40))
  	(moves (fires ?f&:(> ?f 0))) ; controlla che ci siano ancora fires disponibili
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
	(not (k-cell (x ?x) (y ?y)))
=>
	(assert (intention-fire (x ?x) (y ?y)))
	(pop-focus)
)

(defrule update-k-per-col (declare (salience 30)) 
	(status (step ?s)(currently running))
	(k-per-col (col ?col) (num ?num))
	=> 
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?b-cell b-cell)) 
						(and (eq ?b-cell:y ?col) (eq ?b-cell:content boat)) 
						(bind ?b-cell-counter (+ ?b-cell-counter 1)))
	
	(do-for-all-facts ((?update updated-k-per-col)) (eq ?update:col ?col) (modify ?update (num (- ?num ?b-cell-counter))))
)

(defrule update-k-per-row (declare (salience 30)) 
	(status (step ?s)(currently running))
	(k-per-row (row ?row) (num ?num))
	=> 
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?b-cell b-cell)) 
						(and (eq ?b-cell:x ?row) (eq ?b-cell:content boat)) 
						(bind ?b-cell-counter (+ ?b-cell-counter 1)))
	
	(do-for-all-facts ((?update updated-k-per-row)) (eq ?update:row ?row) (modify ?update (num (- ?num ?b-cell-counter))))
)

(defrule make-intention-solve
	?i <- (ship-index ?s&:(> ?s 10))
=>
	(assert (intention-solve))
	(pop-focus)
)

(defrule make-intention-sink
	?i <- (ship-index ?s)
	?c <- (convolution-scores (ignore FALSE) (best-id ?best-area-id&:(neq ?best-area-id nil)))
	?f <- (convolution-area (id ?best-area-id) (x ?x) (y ?y) (orientation ?or) (type ?t) (score ?score))
=>
	(printout t "    best-score " ?score crlf)
	(printout t "    intention-sink " ?t " on " ?x " " ?y " orientation " ?or crlf)
	(assert(intention-sink(x-stern ?x) (y-stern ?y) (orientation ?or) (type ?t)))
	(retract ?i)
	(assert (ship-index (+ ?s 1))) ; select the next ship
	(delete-conv-cell ?best-area-id)
	(modify ?c (ignore TRUE) (best-id nil))
	(retract ?f) 
 	(pop-focus)
)

(defrule make-intention-abort
	?i <- (ship-index ?s)
	?c <- (convolution-scores (ignore FALSE) (best-id nil)) ; no cell found to place the ship
=>
	(printout t "    intention-abort on ship index" (- ?s 1) crlf)
	(retract ?i)
	(assert (ship-index (- ?s 1))) ; select the previous ship
	(assert (intention-abort))
	(modify ?c (ignore TRUE))
	(pop-focus)
)

(defrule go-to-convolution (declare (salience -5))
	(status (step ?s)(currently running))
	(ship-index ?i)
=>
	(assert (make-new-convolutions))
	(focus CONVOLUTION)
)
