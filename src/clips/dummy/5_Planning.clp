(defmodule PLANNING (import MAIN ?ALL)	(import ENV ?ALL) (import DELIBERATE ?ALL) (export ?ALL))


;; *******************************
;; TEMPLATES
;; *******************************

(deftemplate action
    (slot id (default-dynamic (gensym*))) ; genX
    (slot x)
    (slot y)
    (slot type (allowed-values guess unguess fire))
)

(deftemplate plan
    (slot id (default-dynamic (gensym*))) ; genX
	(multislot action-sequence (type SYMBOL))
)


;; *******************************
;; RULES
;; *******************************

; si potrebbe rendere più generica
; (defrule plan-air-carriers-ver
; 	(status (step ?s)(currently running))
;     (intention-sink (x-stern ?x) (y-stern ?y) (orientation ver) (type air-carrier))
;     ;(air-carriers-info ?n ?size)
;     ?ps <- (plan-stack (plans $?list))
; =>
;     (printout t "Plan Air-CarrierVer" crlf)
;     (bind ?plan_id (gensym*))
;     (bind ?id1 (gensym*))
;     (bind ?id2 (gensym*))
;     (bind ?id3 (gensym*))
;     (bind ?id4 (gensym*))
; 	(assert (action (id ?id1) (x ?x) (y ?y) (type guess)))
;     (assert (action (id ?id2) (x (- ?x 1)) (y ?y) (type guess)))
;     (assert (action (id ?id3) (x (- ?x 2)) (y ?y) (type guess)))
;     (assert (action (id ?id4) (x (- ?x 3)) (y ?y) (type guess)))

;     (assert plan (id ?plan_id )(action-sequence (create$ ?id1 ?id2 ?id3 ?id4)))
;     (modify ?ps (plans ?plan_id ?list))
; 	(pop-focus)
; )


; ; (foreach <list-variable> <multifield-expression> <expression>*)

; ; CLIPS> (foreach ?field (create$ abc def ghi) 
; ;             (printout t "--> " ?field " " ?field-index " <--" crlf))
; ; --> abc 1 <-- 
; ; --> def 2 <-- 
; ; --> ghi 3 <-- 
; ; CLIPS>