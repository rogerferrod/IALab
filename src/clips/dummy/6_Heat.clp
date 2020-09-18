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

(deffunction median-aux ($?values) ; compute the median value of a numeric multislot
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

(defrule compute-heat-map-known-boat ; Computa la Heatmap per le celle conosciute già dall'inizio del gioco
	(k-cell (x ?x) (y ?y) (content ?c&~water))
=>
	(assert (heat-map (x ?x) (y ?y) (h 100) (computed TRUE))) ; importante che sia TRUE per non alterare la mediana (collect-heat)
)

(defrule compute-heat-map-known-water
	(k-cell (x ?x) (y ?y) (content water))
=>
	(assert (heat-map (x ?x) (y ?y) (h 0) (computed TRUE))) ; importante che sia TRUE per non alterare la mediana (collect-heat)
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

(defrule compute-median ; ultima regola prima di eseguire pop-focus (implicito)
	(heatset (values $?list))
	?f <- (board)
=>
	(modify ?f (median (median-aux ?list)))
)

