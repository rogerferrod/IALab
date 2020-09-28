(defmodule CONVOLUTION (import MAIN ?ALL) (import ENV ?ALL) (import HEAT ?ALL) (export ?ALL))

(deftemplate convolution-area
	(slot id)
	(slot type)
	(slot size)
	(slot x)
	(slot y)
	(slot orientation (allowed-values ver hor))
	(slot score (default 0))
	(multislot area) ; id dei fatti corrispondenti alle celle dell'area
	(slot computed (default FALSE))
	(slot visited (default 0)) ; counter of cells already visited during convolution
    (slot collected (default FALSE))
)

(deftemplate conv-cell
	(slot id)
	(slot area-id)
	(slot x)
	(slot y)
    (slot computed (default FALSE))
)

(defrule make-convolutions (declare (salience 30))
    ?f <- (make-new-convolutions)
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
    (retract ?f)
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
            ;(printout t "Assert conv-cell in " ?nx " " ?y crlf)
        else ; horizontal orientation
            (bind ?ny (- ?y ?i)) ; move along columns
            (assert (conv-cell (id ?id) (area-id ?conv-id) (x ?x) (y ?ny)))
            ;(printout t "Assert conv-cell in " ?x " " ?ny crlf)
        )

        (bind ?id-list (create$ ?id-list ?id))
    )

    (modify ?c (area ?id-list) (computed TRUE))
)

(defrule count-visited ; TODO cambiare nome
    ?k <- (conv-cell (id ?id) (x ?x) (y ?y) (area-id ?conv) (computed FALSE))
    ?c <- (convolution-area (size ?size) (score ?score) (visited ?v&:(< ?v ?size)))
    (heat-map (x ?x) (y ?y) (h ?h))
=>
    (modify ?c (visited (+ ?v 1)) (score (+ ?score ?h)))
    (modify ?k (computed TRUE))
    ;(printout t "sono in " ?x " " ?y " con " ?h crlf)
)

(defrule check-conv-cell-ver 
;; check invalid condition to carry out convolution operation, 
;; if one condition is invalid stop convolution in that area and remove the conv-cell associated
    (conv-cell (id ?id) (x ?x) (y ?y) (area-id ?conv))
    ?c <- (convolution-area (id ?conv) (area $?area) (orientation ver) (size ?size) (visited ?v&:(> ?v 0)))
    (or ; 
        (test (not (check-boundary ?x ?y))) ; deletes the cells that exceed the boundary
        (k-cell (x ?x) (y ?y) (content water)) ; no ship could be placed in water
        (b-cell (x ?x) (y ?y)) ; check if there is an already placed guess 
        (updated-k-per-col (col ?y) (num ?num&:(> ?v ?num)))  ; not(v <= col) -> (v > col)
        (updated-k-per-row (row ?x) (num ?num&:(< ?num 1))) ; not(row >= 1) -> (row < 1)
        ; TODO: controllare sovrapposizioni compatibili di k-cell (bottom, top, middle...)
    )
=>
    ;(printout t "elimino convolution_area " ?conv crlf)
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

(defrule check-conv-cell-hor
    (conv-cell (id ?id) (x ?x) (y ?y) (area-id ?conv))
    ?c <- (convolution-area (id ?conv) (area $?area) (orientation hor) (size ?size) (visited ?v&:(> ?v 0)))
    (or 
        (test (not (check-boundary ?x ?y))) ; deletes the cells that exceed the boundary
        (k-cell (x ?x) (y ?y) (content water))
        (b-cell (x ?x) (y ?y))
        (updated-k-per-row (row ?y) (num ?num&:(> ?v ?num)))  ; not(v <= row) -> (v > row)
        (updated-k-per-col (col ?x) (num ?num&:(< ?num 1))) ; not(col >= 1) -> (col < 1)
        ; TODO: controllare sovrapposizioni compatibili di k-cell (bottom, top, middle...)
    )
=>
    ;(printout t "elimino convolution_area " ?conv crlf)
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

(defrule collect-conv (declare (salience -5)) ; se non ci sono possibilità, non scatta nemmeno
    ?c <- (convolution-area (id ?conv-id) (score ?s) (computed TRUE) (collected FALSE))
    ?scores <- (convolution-scores (values $?list) (best-id ?b))
=>
    (if (eq ?b nil)
        then
            (modify ?scores (best-id ?conv-id))
        else
            (if
                (> ?s (max (expand$ ?list))) ; ?s è il nuovo max
                    then
                        (modify ?scores (best-id ?conv-id))    
            )
    )
    
    (modify ?scores (values ?list ?s))
    (modify ?c (collected TRUE))
)