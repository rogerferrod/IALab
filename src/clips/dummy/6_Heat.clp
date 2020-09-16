;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule HEAT 
	(import MAIN ?ALL) 
	(import ENV ?ALL) 
	(export ?ALL)
)
;; ******************************
;; TEMPLATES
;; ******************************

(deftemplate heat-map
	(slot x)
	(slot y)
	(slot h)
	(slot computed)
)

;; ******************************
;; FUNCTIONS
;; ******************************

(deffunction median-aux ($?values) ; compute the median value of a  numeric multislot
	(bind ?sorted (sort > ?values)) 
	(bind ?length (length$ ?sorted))
	(if (<> (mod ?length 2) 0) then ; check if length is odd
		(bind ?median (nth$ (div (+ ?length 1) 2) ?sorted))
	else ; length is even
		(bind ?median (integer (/ (+ (nth$ (div ?length 2) ?sorted) (nth$ (+ (div ?length 2) 1) ?sorted)) 2)))
	)
)


;; ******************************
;; RULES
;; ******************************

(defrule compute-heat-map ; Computa la Heatmap
	(k-per-row (row ?row) (num ?rvalue))
	(k-per-col (col ?col) (num ?cvalue))
=>
	(assert (heat-map (x ?row) (y ?col) (h (+ ?rvalue ?cvalue)) (computed FALSE)))
)

(defrule heat-dropout ; effettua il "drop" delle righe e colonne, impostando il valore della cella a 0 
	(or	(k-per-row (row ?row) (num 0))
		(k-per-col (col ?col) (num 0)))
	?f <- (heat-map (x ?row) (y ?col) (h ?h) (computed FALSE))
=>
	(modify ?f (h 0))
)

(defrule collect-heat ; colleziona i valori della heatmap in un insieme
	?f <- (heat-map (x ?row) (y ?col) (h ?h) (computed FALSE)) ; per evitare loop
	?heat <- (heatset (values $?list))
=>
	(if (not(subsetp (create$ ?h) ?list)) then ; controlla se il valore ?h non è già presente in ?list
		(modify ?heat (values ?list ?h)))
	(modify ?f (computed TRUE)) ; per evitare loop
)

(defrule compute-median
	(heatset (values $?list))
	?f <- (board)
=>
	(modify ?f (median (median-aux ?list)))
)

(defrule make-fires (declare (salience -10))
 	(status (step ?s) (currently running))
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
=>
	(printout t "sono qui " ?x " " ?y crlf)
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(pop-focus)
)