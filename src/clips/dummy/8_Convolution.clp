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

(defrule count-visited
    (conv-cell (id ?id) (x ?x) (y ?y) (area-id ?conv))
    ?c <- (convolution-area (size ?size) (visited ?v&:(< ?v ?size)))
=>
    (modify ?c (visited (+ ?v 1)))
)

(defrule check-conv-cell-ver
    (conv-cell (id ?id) (x ?x) (y ?y) (area-id ?conv))
    ?c <- (convolution-area (id ?conv) (area $?area) (orientation ver) (size ?size) (visited ?v&:(> ?v 0)))
    (or 
        (test (not (check-in-boundary ?x ?y))) ; deletes the cells that exceed the boundary
        (k-cell (x ?x) (y ?y) (content water))
        (b-cell (x ?x) (y ?y))
        (k-per-col (col ?y) (num ?num&:(> ?v ?num)))  ; not(v <= col) -> (v > col) --------> TODO: usare update-k-per-col
        (k-per-row (row ?x) (num ?num&:(< ?num 1))) ; not(row >= 1) -> (row < 1) ----------> TODO: usare update-k-per-col
        ; TODO: controllare sovrapposizioni compatibili di k-cell (bottom, top, middle...)
    )
=>
    (printout t "elimino convolution_area " ?conv crlf)
    (do-for-all-facts ; loop and retract conv-cell associated with the area that match with LHS
        ((?conva convolution-area) (?cell conv-cell)) 
        (and 
            (eq ?conva:id ?conv)
            (eq ?conva:id ?cell:area-id) 
        )
        (retract ?cell)
    )
    (retract ?c)
)

(defrule convolution
    ?c <- (convolution-area (id ?conv-id) (type ?ship) (size ?size) (x ?x) (y ?y) (orientation ?orientation) (score ?score) (area $?area) (computed FALSE))
=>
    (bind ?id-list (create$))  
    (loop-for-count (?i 0 (- ?size 1)) 
        (bind ?id (gensym*)) ; area cell id
        
        (if (eq ?orientation ver) then ; vertical orientation
            (bind ?nx (- ?x ?i)) ; move along row 
            (assert (conv-cell (id ?id) (area-id ?conv-id) (x ?nx) (y ?y))) ; TODO: aggiungere il content (bot, middle, top), vedi TODO check-conv-cell
            (printout t "Assert conv-cell in " ?nx " " ?y crlf)
        else ; horizontal orientation
            (bind ?ny (- ?y ?i)) ; move along columns
            (assert (conv-cell (id ?id) (area-id ?conv-id) (x ?x) (y ?ny)))
            (printout t "Assert conv-cell in " ?x " " ?ny crlf)
        )

        (bind ?id-list (create$ ?id-list ?id))
    )

    (modify ?c (area ?id-list) (computed TRUE))
)