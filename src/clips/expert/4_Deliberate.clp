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

(defrule fire-at-first (declare (salience 40))
  	(moves (fires ?f&:(> ?f 0))) ; controlla che ci siano ancora fires disponibili
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
	(not (k-cell (x ?x) (y ?y)))
=>
	(assert (intention-fire (x ?x) (y ?y)))
	(pop-focus)
)

(defrule update-k-per-col (declare (salience 30)) 
	(k-per-col (col ?col) (num ?num))
	=> 
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?b-cell b-cell)) 
						(and (eq ?b-cell:y ?col) (eq ?b-cell:content boat)) 
						(bind ?b-cell-counter (+ ?b-cell-counter 1)))
	;(printout t "col " ?col " b-cell " ?b-cell-counter crlf) 
	(do-for-all-facts ((?update updated-k-per-col)) (eq ?update:col ?col) (modify ?update (num (- ?num ?b-cell-counter))))
)

(defrule update-k-per-row (declare (salience 30)) 
	(k-per-row (row ?row) (num ?num))
	=> 
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?b-cell b-cell)) 
						(and (eq ?b-cell:x ?row) (eq ?b-cell:content boat)) 
						(bind ?b-cell-counter (+ ?b-cell-counter 1)))
	;(printout t "row " ?row " b-cell " ?b-cell-counter crlf) 
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
	?c <- (convolution-scores (is-first FALSE) (best-id ?best-area-id&:(neq ?best-area-id nil)))
	?f <- (convolution-area (id ?best-area-id) (x ?x) (y ?y) (orientation ?or) (type ?t))
=>
	(printout t "intention-sink " ?t " on " ?x " " ?y " orientation " ?or crlf)
	(assert(intention-sink(x-stern ?x) (y-stern ?y) (orientation ?or) (type ?t)))
	(retract ?i)
	(assert (ship-index (+ ?s 1))) ; select the next ship
	(delete-conv-cell ?best-area-id)
	(retract ?f) 
	(modify ?c (is-first TRUE) (best-id nil)) ; TODO cambiare nome a is-first -> ignore score
 	(pop-focus)
)

(defrule make-intention-abort ;is-first FALSE and best-id == nil
	?i <- (ship-index ?s)
	?c <- (convolution-scores (is-first FALSE) (best-id nil)) ; no cell found to place the ship
=>
	(printout t "intention-abort index" (- ?s 1) crlf)
	(retract ?i)
	(assert (ship-index (- ?s 1))) ; select the previous ship
	(assert (intention-abort))
	(modify ?c (is-first TRUE)) ; TODO cambiare nome a is-first -> ignore score
	(pop-focus)
)

(defrule go-to-convolution (declare (salience -5))
	(status (step ?s)(currently running))
	(ship-index ?i)
=>
	(assert (make-new-convolutions))
	(focus CONVOLUTION)
)
