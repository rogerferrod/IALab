(defmodule DELIBERATE (import MAIN ?ALL) (import ENV ?ALL) (import HEAT ?ALL) (import CONVOLUTION ?ALL) (export ?ALL))

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

(defrule fire-at-first (declare (salience 40)) ; TODO: valutare se togliere salience
  	(moves (fires ?f&:(> ?f 0))) ; controlla che ci siano ancora fires disponibili
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
	(not (k-cell (x ?x) (y ?y)))
=>
	(assert (intention-fire (x ?x) (y ?y)))
	(pop-focus)
)

; (defrule solve (declare (salience 30))
; 	(moves (guesses ?f&:(= ?f 0))) ; TODO eq?
; =>
; 	(assert (intention-solve))
; 	(pop-focus)
; )

(defrule update-k-per-col (declare (salience 5)) 
	(k-per-col (col ?col) (num ?num))
	=> 
	(bind ?k-cell-counter 0)
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?k-cell k-cell)) (and (eq ?k-cell:y ?col) (neq ?k-cell:content water)) (bind ?k-cell-counter (+ ?k-cell-counter 1)))
	;(printout t "col " ?col " k-cell " ?k-cell-counter crlf)
	(do-for-all-facts ((?b-cell b-cell)) (and (eq ?b-cell:y ?col) (neq ?b-cell:content water)) (bind ?b-cell-counter (+ ?b-cell-counter 1)))
	;(printout t "col " ?col " b-cell " ?b-cell-counter crlf) 
	(do-for-all-facts ((?update updated-k-per-col)) (eq ?update:col ?col) (modify ?update (num (- ?num (+ ?k-cell-counter ?b-cell-counter)))))
)

(defrule update-k-per-row (declare (salience 5)) 
	(k-per-row (row ?row) (num ?num))
	=> 
	(bind ?k-cell-counter 0)
	(bind ?b-cell-counter 0)
	
	(do-for-all-facts ((?k-cell k-cell)) (and (eq ?k-cell:x ?row) (neq ?k-cell:content water)) (bind ?k-cell-counter (+ ?k-cell-counter 1)))
	;(printout t "row " ?row " k-cell " ?k-cell-counter crlf)
	(do-for-all-facts ((?b-cell b-cell)) (and (eq ?b-cell:x ?row) (neq ?b-cell:content water)) (bind ?b-cell-counter (+ ?b-cell-counter 1)))
	;(printout t "row " ?row " b-cell " ?b-cell-counter crlf) 
	(do-for-all-facts ((?update updated-k-per-row)) (eq ?update:row ?row) (modify ?update (num (- ?num (+ ?k-cell-counter ?b-cell-counter)))))
)

; (defrule demo
; 	?f <- (only-one-demo)
; 	(status (step ?s) (currently running))
; =>
; 	;(assert(intention-sink(x-stern 6) (y-stern 4) (orientation ver) (type air-carrier)))
; 	;(assert(intention-sink(x-stern 6) (y-stern 2) (orientation ver) (type cruiser)))
; 	;(assert(intention-sink(x-stern 6) (y-stern 0) (orientation ver) (type destroyer)))
; 	;(assert(intention-sink(x-stern 9) (y-stern 0) (orientation ver) (type submarine)))
; 	(assert(intention-sink(x-stern 9) (y-stern 4) (orientation ver) (type destroyer)))
; 	(retract ?f)
; 	(pop-focus)
; )

(defrule make-intention-solve (declare (salience 1))
	?i <- (ship-index ?s&:(= ?s 10))
=>
	(assert (intention-solve))
	(pop-focus)
)

(defrule make-intention-sink
	?d <- (only-one-demo)
	(convolution-scores (is-first FALSE))
	(convolution-scores (best-id ?b&:(neq ?b nil)))
	?i <- (ship-index ?s)
	?f <- (convolution-area (id ?b) (x ?x) (y ?y) (orientation ?or) (type ?t))
=>
	(printout t "intention-sink " ?t crlf)
	(assert(intention-sink(x-stern ?x) (y-stern ?y) (orientation ?or) (type ?t)))
	(modify ?i (ship-index (+ ?s 1)))
	(retract ?f) ;TODO eliminare le conv-cell associate alla conv-area
 	(pop-focus)
	(retract ?d)
)

;(defrule make-intention-abort) best-id == nil

(defrule make-convolutions (declare (salience -5))
	?i <- (ship-index ?s)
	?b <- (board (ordered $?list))
	?c <- (convolution-scores)
=>
	(bind ?ship-type (nth$ ?s ?list))
	(bind ?ship-size (fact-slot-value ?b ?ship-type)) ; retrieve ship size from ship type
	(bind ?limit 9)  ; limite per le x e le y, (0,9) e (9,9)

	(loop-for-count (?i 0 ?limit)
		(loop-for-count (?j 0 ?limit)
			(bind ?id1 (gensym*))
			(bind ?id2 (gensym*))
			(assert (convolution-area (id ?id1) (type ?ship-type) (size ?ship-size) (x ?i) (y ?j) (orientation ver)))
			(assert (convolution-area (id ?id2) (type ?ship-type) (size ?ship-size) (x ?i) (y ?j) (orientation hor)))
		)
	) 
	
	(printout t "convolution on " ?ship-type crlf)
	(modify ?c (values (create$)) (best-id nil) (is-first FALSE)) ; reset convolution scores
	(focus CONVOLUTION)
)