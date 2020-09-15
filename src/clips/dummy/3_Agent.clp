;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT 
	(import MAIN ?ALL) 
	(import ENV ?ALL) 
	;(import DELIBERATE ?ALL) 
	;(import PLANNING ?ALL) 
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

(deffunction median ($?values)
	(bind ?sorted (sort > ?values)) 
	(bind ?length (length$ ?sorted))
	(if (<> (mod ?length 2) 0) then ; check if length is odd
		(bind ?median (nth$ (div (+ ?length 1) 2) ?sorted))
	else ; length is even
		(bind ?median (/ (+ (nth$ (div ?length 2) ?sorted) (nth$ (+ (div ?length 2) 1) ?sorted)) 2))
	)
)

(deffunction median-no-zero ($?values)
	(bind ?sorted (sort > (delete-member$ ?values 0))) 
	(bind ?length (length$ ?sorted))
	(if (<> (mod ?length 2) 0) then ; check if length is odd
		(bind ?median (nth$ (div (+ ?length 1) 2) ?sorted))
	else ; length is even
		(bind ?median (/ (+ (nth$ (div ?length 2) ?sorted) (nth$ (+ (div ?length 2) 1) ?sorted)) 2))
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

(defrule heat-dropout ; Computa la Heatmap e fa il drop degli 0 per le righe
	(or 
		(k-per-row (row ?row) (num 0))
		(k-per-col (col ?col) (num 0))
	)
	?f <- (heat-map (x ?row) (y ?col) (h ?h) (computed FALSE))
=>
	(modify ?f (h 0))
)

(defrule collect-heat
	?f <- (heat-map (x ?row) (y ?col) (h ?h) (computed FALSE)) ; per evitare loop
	?heat <- (sorted-heat (values $?list))
=>
	(modify ?heat (values ?list ?h))
	(modify ?f (computed TRUE)) ; per evitare loop
)


(defrule medianX
	(sorted-heat (values $?list))
=>
	
	(printout t "Values: " (sort > ?list) crlf)
	(printout t "Median computed: " (median-no-zero ?list) crlf)
	
)








; (defrule go-on-deliberate (declare (salience 30))
; 	(status (step ?s)(currently running))
; =>
; 	(printout t crlf crlf)
;     (printout t "vado a deliberate  step" ?s crlf)
; 	(focus DELIBERATE) 
; )

; (defrule go-on-planning (declare (salience 20))
; 	(status (step ?s)(currently running))
; =>
; 	(printout t crlf crlf)
;     (printout t "vado a planning  step" ?s crlf)
; 	(focus PLANNING)
; )


; ; TODO serve la salience?
; (defrule execute (declare (salience 10))
; 	(status (step ?s) (currently running))
; 	?p <- (plan (action-sequence $?as&:(> (length$ ?as) 0)))
; 	?first <- (first$ $?as)
; 	?tail <- (rest$ $?as)
; 	(action (id ?first) (type ?t) (x ?x) (y ?y))
; =>
; 	(modify ?p (action-sequence ?tail ))
; 	(assert (exec (step ?s) (action ?t) (x ?x) (y ?y)))
; 	(printout t "Exec " ?t " on " ?x " " ?y crlf)
; 	(pop-focus)
; )

; (defrule print-what-i-know-since-the-beginning
; 	(k-cell (x ?x) (y ?y) (content ?t))
; =>
; 	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
; )

