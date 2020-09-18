((defmodule PLANNING (import MAIN ?ALL)	(import ENV ?ALL) (import DELIBERATE ?ALL) (export ?ALL))



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

(deftemplate intention-to-plan
    (slot x-stern)
    (slot y-stern)
    (slot orientation)
    (slot type)
    (slot size)
)

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

(deffunction generate-ship-vert-guess (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
    (loop-for-count (?i 0 (- ?size 1)) 
        (bind ?x (- ?x-start ?i))
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y ?y-start) (type guess))) ; no need to assign gensym* to id slot since is default-dynamic
        (bind ?id-sequence (create$ ?id-sequence ?id))
    )
    (return ?id-sequence)
)  

(deffunction generate-ship-hor-guess (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
    (loop-for-count (?i 0 (- ?size 1)) 
        (bind ?x (- ?x-start ?i))
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y ?y-start) (type guess))) ; no need to assign gensym* to id slot since is default-dynamic
        (bind ?id-sequence (create$ ?id-sequence ?id))
    )
    (return ?id-sequence)
)  

(deffunction generate-ship-vert-water (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
    (bind ?water-start )
    ; loop for water on ship sides 
    (loop-for-count (?i -1 ?size) ; ?i == -1 is for the row under the stern, ?i == size is for the row on top of the bow
        (bind ?x (- ?x-start ?i))
        
        ; left side <-|o|-
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y (- ?y-start 1)) (type water)))
        (bind ?id-sequence (create$ ?id-sequence ?id))
        
        ; right side -|o|->
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y (+ ?y-start 1)) (type water)))        
        (bind ?id-sequence (create$ ?id-sequence ?id))
    )
    ; add water on top of the bow
    (bind ?id (gensym*))
    (assert (action (id ?id) (x (- ?x-start ?size)) (y ?y-start) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    ; add water under the stern
    (bind ?id (gensym*))
    (assert (action (id ?id) (x (+ ?x-start 1)) (y ?y-start) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    (return ?id-sequence)
) 

(deffunction generate-ship-hor-water (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
    (bind ?water-start )
    ; loop for water on ship sides 
    (loop-for-count (?i -1 ?size) ; ?i == -1 is for the row under the stern, ?i == size is for the row on top of the bow
        (bind ?x (- ?x-start ?i))
        
        ; left side <-|o|-
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y (- ?y-start 1)) (type water)))
        (bind ?id-sequence (create$ ?id-sequence ?id))
        
        ; right side -|o|->
        (bind ?id (gensym*))
        (assert (action (id ?id) (x ?x) (y (+ ?y-start 1)) (type water)))        
        (bind ?id-sequence (create$ ?id-sequence ?id))
    )
    ; add water on top of the bow
    (bind ?id (gensym*))
    (assert (action (id ?id) (x (- ?x-start ?size)) (y ?y-start) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    ; add water under the stern
    (bind ?id (gensym*))
    (assert (action (id ?id) (x (+ ?x-start 1)) (y ?y-start) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    (return ?id-sequence)
)

;; *******************************
;; RULES
;; *******************************

(defrule plan-ship
	(status (step ?s)(currently running))
    ?i <- (intention-sink (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?hor) (type ?type)) ; TODO generalizzare orientation
    ?b <- (board)
=>
    (printout t "Catch intention" crlf)
    (assert (intention-to-plan (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?hor) (type ?type) (size (fact-slot-value ?b ?type))))
    (retract ?i)
)

(defrule generate-plan
    (status (step ?s)(currently running))
	?f <- (intention-to-plan (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?hor) (type ?type) (size ?size))
    ?ps <- (plan-stack (plans $?list))
=>
    (printout t "Plan WarShip" crlf)
    (bind ?plan_id (gensym*))
    
    (if (eq ?hor ver)
        then
            (bind ?guess_id_seq (generate-ship-vert-guess ?x-stern ?y-stern ?size)) ;assert guess actions
            (bind ?water_id_seq (generate-ship-vert-water ?x-stern ?y-stern ?size)) ;assert water actions
        else    
            (bind ?guess_id_seq (generate-ship-hor-guess ?x-stern ?y-stern ?size)) ;assert guess actions
            (bind ?water_id_seq (generate-ship-hor-water ?x-stern ?y-stern ?size)) ;assert water actions
    )
    
    
    (assert (plan (id ?plan_id ) (ship ?type) (counter 1) (action-sequence (create$ ?guess_id_seq ?water_id_seq)))) ; create a new plan
    (modify ?ps (lastplan ?plan_id) (plans ?plan_id ?list)) ; push new plan on the on stack
    (retract ?f); remove the intention
	(assert (to-check-ship-neighborhood))
)

(defrule check-ship-neighborhood ;; check if generated water actions from intention-sink is invalid, if so retract
    (to-check-ship-neighborhood)  
    ?a <- (action (id ?id) (x ?x) (y ?y) (type water))
    ?p <- (plan (id ?plan_id) (action-sequence $?actions))
    (test (not (check-in-boundary ?x ?y)))
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