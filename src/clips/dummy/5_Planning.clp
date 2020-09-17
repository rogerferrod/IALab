(defmodule PLANNING (import MAIN ?ALL)	(import ENV ?ALL) (import DELIBERATE ?ALL) (export ?ALL))

;; *******************************
;; FUNCTIONS
;; *******************************


(deffunction check-in-boundary (?x ?y)
	(if (or (< ?x 0) 
			(< ?y 0) 
			(> ?x 9) 
			(> ?y 9))
	then (bind ?return FALSE)
	else (bind ?return TRUE))
)

;; *******************************
;; TEMPLATES
;; *******************************

(deftemplate action
    (slot id (default-dynamic (gensym*))) ; genX
    (slot x)
    (slot y)
    (slot type (allowed-values guess unguess water fire))
)

(deftemplate plan
    (slot id (default-dynamic (gensym*))) ; genX
    (slot counter)
    (slot ship)
	(multislot action-sequence (type SYMBOL))
)


;; *******************************
;; RULES
;; *******************************

; si potrebbe rendere più generica
(defrule plan-air-carriers-ver
	(status (step ?s)(currently running))
    ?f <- (intention-sink (x-stern ?x) (y-stern ?y) (orientation ver) (type air-carrier))
    ;(air-carriers-info ?n ?size)
    ?ps <- (plan-stack (plans $?list))
=>
    (printout t "Plan Air-CarrierVer" crlf)
    (bind ?plan_id (gensym*))
    (bind ?id1 (gensym*))
    (bind ?id2 (gensym*))
    (bind ?id3 (gensym*))
    (bind ?id4 (gensym*))
    (bind ?id5 (gensym*))
    (bind ?id6 (gensym*))
    (bind ?id7 (gensym*))
    (bind ?id8 (gensym*))
    (bind ?id9 (gensym*))
    (bind ?id10 (gensym*))
    (bind ?id11 (gensym*))
    (bind ?id12 (gensym*))
    (bind ?id13 (gensym*))
    (bind ?id14 (gensym*))
    (bind ?id15 (gensym*))
    (bind ?id16 (gensym*))
    (bind ?id17 (gensym*))
    (bind ?id18 (gensym*))

	(assert (action (id ?id1) (x ?x) (y ?y) (type guess)))
    (assert (action (id ?id2) (x (- ?x 1)) (y ?y) (type guess)))
    (assert (action (id ?id3) (x (- ?x 2)) (y ?y) (type guess)))
    (assert (action (id ?id4) (x (- ?x 3)) (y ?y) (type guess)))

    (bind ?nx ?x)
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 2))
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 3))
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 4))
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 4))
	(bind ?ny ?y)
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 4))
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 3))
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 2))
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx ?x)
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (+ ?x 1))
	(bind ?ny ?y)
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    (bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
    (assert (action (id ?id5) (x ?nx) (y ?ny) (type water)))
    
    (assert (plan (id ?plan_id ) (ship air-carrier) (action-sequence (create$ ?id1 ?id2 ?id3 ?id4 ?id5 ?id6 ?id7 ?id8 ?id9 ?id10 ?id11 ?id12 ?id13 ?id14 ?id15 ?id16 ?id17 ?id18))))
    (modify ?ps (plans ?plan_id ?list))
    (retract ?f)
	(assert (to-check-ship-neighborhood))
)

(defrule check-ship-neighborhood
    (to-check-ship-neighborhood)  
    ?a <- (action (id ?id) (x ?x) (y ?y) (type water))
    ?p <- (plan (id ?plan_id) (action-sequence ?actions))
    (or
        (not (check-in-boundary ?x ?y))
        (not (k-cell (x ?x) (y ?y) (content water)))
    )
=>
    (retract ?a)
    (modify ?p (action-sequence (delete-member$ ?actions ?id)))
)


(defrule back-to-agent (declare (salience -10)) ; ultima regole da eseguire prima di tornare all'agent
    ?f <- (to-check-ship-neighborhood)  
=>
    (retract ?f)
    (pop-focus) ;si potrebbe anche togliere
)

; ; (foreach <list-variable> <multifield-expression> <expression>*)

; ; CLIPS> (foreach ?field (create$ abc def ghi) 
; ;             (printout t "--> " ?field " " ?field-index " <--" crlf))
; ; --> abc 1 <-- 
; ; --> def 2 <-- 
; ; --> ghi 3 <-- 
; ; CLIPS>