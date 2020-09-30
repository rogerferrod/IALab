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
	(status (step ?s)(currently running))
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
	(status (step ?s)(currently running))
	(k-per-row (row ?row) (num ?num))
	=> 
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?b-cell b-cell)) 
						(and (eq ?b-cell:x ?row) (eq ?b-cell:content boat)) 
						(bind ?b-cell-counter (+ ?b-cell-counter 1)))
	;(printout t "row " ?row " b-cell " ?b-cell-counter crlf) 
	(do-for-all-facts ((?update updated-k-per-row)) (eq ?update:row ?row) (modify ?update (num (- ?num ?b-cell-counter))))
)