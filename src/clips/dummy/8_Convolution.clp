(deftemplate convolution-scores
    (multislot values)
)

; (defrule delete-area
;     (delete-all-area-modify ?conv)
;     ?c <- (convolution-area (id ?conv) (area $?area))
; =>
;     (bind ?f (nth$ 1 ?area))
;     ()
; )

(defrule check-conv-cell
    ?f <- (conv-cell (id ?id) (x ?x) (y ?y) (id-conv ?conv))
    ?c <- (convolution-area (id ?conv) (area $?area))
    (test (not (check-in-boundary ?x ?y)))
=>
    (retract ?f)
    (retract ?c)
)


(defrule convolution
    ?c <- (convolution-area (id ?id1) (type ?ship) (size ?size) (x ?x) (y ?y) (orientation ?orientation) (score ?score) (area $?area) (computed FALSE))
=>
    (bind ?id-list (create$))  
    (loop-for-count (?i 0 (- ?size 1)) 
        (bind ?id (gensym*)) ; area cell id
        
        (if (eq ?orientation ver) then ; vertical orientation
            (bind ?nx (- ?x ?i)) ; move along row 
            (assert (conv-cell (id ?id) (x ?nx) (y ?y)))
            (printout t "Assert conv-cell in " ?nx " " ?y crlf)
        else ; horizontal orientation
            (bind ?ny (- ?y ?i)) ; move along columns
            (assert (conv-cell (id ?id) (x ?x) (y ?ny)))
            (printout t "Assert conv-cell in " ?x " " ?ny crlf)
        )

        (bind ?id-list (create$ ?id-list ?id))
    )

    (modify ?c (area ?id-list) (computed TRUE))
)