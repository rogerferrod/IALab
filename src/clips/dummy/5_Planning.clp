(defmodule PLANNING (import MAIN ?ALL)	(import ENV ?ALL) (import DELIBERATE ?ALL) (export ?ALL))

(deftemplate action
    (slot id (default-dynamic (gensym*))) ; genX
    (slot x)
    (slot y)
    (slot type (allowed-values guess unguess fire))
)

(deftemplate plan
	(multislot action-sequence (type SYMBOL))
)

; AIR-CARRIER RULES ------------------------------------------------------------
; si potrebbe rendere più generica
(defrule plan-air-carriers-ver
    (printout t "Plan Air-Carrier" crlf)
	(status (step ?s)(currently running))
    (intention-sink (x-stern ?x) (y-ster ?y) (orientation ver) (type air-carrier)
    (air-carriers-info ?n ?size)
    ?p <- (plan)
=>
	?f1 <- (assert (action (?x) (?y) (type guess)))
    ?f2 <- (assert (action (?x+1) (?y) (type guess)))
    ?f3 <- (assert (action (?x+2) (?y) (type guess)))
    ?f4 <- (assert (action (?x+3) (?y) (type guess)))
    ?id1 <- (fact-slot-value ?f1 id)
    ?id2 <- (fact-slot-value ?f2 id)
    ?id3 <- (fact-slot-value ?f3 id)
    ?id4 <- (fact-slot-value ?f4 id)

    (modify ?p (action-sequence (create$ ?id1 ?id2 ?id3 ?id4)))
	(pop-focus)
)

; (defrule plan-air-carriers-hor
;     (printout t "Plan Air-Carrier" crlf)
; 	(status (step ?s)(currently running))
;     (intention-sink (x-stern ?x) (y-ster ?y) (orientation hor) (type air-carrier)
;     (air-carriers-info ?n ?size)
;     ?p <- (plan)
; =>
; 	?f1 <- (assert (action (?x) (?y) (type guess)))
;     ?f2 <- (assert (action (?x) (?y+1) (type guess)))
;     ?f3 <- (assert (action (?x) (?y+2) (type guess)))
;     ?f4 <- (assert (action (?x) (?y+3) (type guess)))
;     ?id1 <- (fact-slot-value ?f1 id)
;     ?id2 <- (fact-slot-value ?f2 id)
;     ?id3 <- (fact-slot-value ?f3 id)
;     ?id4 <- (fact-slot-value ?f4 id)

;     (modify ?p (action-sequence (create$ ?id1 ?id2 ?id3 ?id4)))
; 	(pop-focus)
; )

; (foreach <list-variable> <multifield-expression> <expression>*)

; CLIPS> (foreach ?field (create$ abc def ghi) 
;             (printout t "--> " ?field " " ?field-index " <--" crlf))
; --> abc 1 <-- 
; --> def 2 <-- 
; --> ghi 3 <-- 
; CLIPS>