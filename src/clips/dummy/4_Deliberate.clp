(defmodule DELIBERATE (import MAIN ?ALL) (import ENV ?ALL) (import HEAT ?ALL)  (export ?ALL))

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

(deftemplate convolution-area
	(slot id)
	(slot type)
	(slot size)
	(slot x)
	(slot y)
	(slot orientation (allowed-values ver hor))
	(slot score)
	(multislot area) ; id dei fatti corrispondenti alle celle dell'area
	(slot computed)
)

(deftemplate conv-cell
	(slot id)
	(slot conv-id)
	(slot x)
	(slot y)
)


;; ******************************
;; RULES
;; ******************************

(defrule fire-at-first (declare (salience 40)) ; TODO valutare se togliere salience
  	(moves (fires ?f&:(> ?f 0))) ; controlla che ci siano ancora fires disponibili
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
	(not (k-cell (x ?x) (y ?y)))
=>
	(assert (intention-fire (x ?x) (y ?y)))
	(pop-focus)
)

(defrule solve (declare (salience 30))
	(moves (guesses ?f&:(= ?f 0))) ; TODO eq?
=>
	(assert (intention-solve))
	(pop-focus)
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

(defrule sink
 	?f <- (only-one-demo) ; TODO temporaneo
	?i <- (ship-index ?s)
	?b <- (board (ordered $?list))
=>
	(bind ?ship-type (nth$ ?s ?list))
	(bind ?ship-size (fact-slot-value ?b ?ship-type)) ; retrieve ship size from ship type
	(bind ?id1 (gensym*))
	;(bind ?id2 (gensym*))
	; TODO fare un loop su ogni possibile cella....
	(assert (convolution-area (id ?id1) (type ?ship-type) (size ?ship-size) (x 0) (y 0) (orientation ver) (computed FALSE)))
	(printout t "Assert convolution-area in 0 0" crlf)
	;(assert (convolution-area (id ?id2) (type ?ship-type) (size ?ship-size) (x 0) (y 0) (orientation hor) (computed FALSE)))
	;(modify ?i (ship-index (+ ?s 1))) ; TODO da mettere quando si asserisce intention-sink
	(retract ?f) ; TODO temporaneo
)