(defmodule PLANNING 
    (import MAIN ?ALL)	
    (import ENV ?ALL) 
    (import DELIBERATE ?ALL) 
    (export ?ALL)
)



;; *******************************
;; TEMPLATES
;; *******************************

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

(deffunction generate-ship-guess (?x-start ?y-start ?orientation ?size)
    (bind ?id-sequence (create$)) 

    (loop-for-count (?i 0 (- ?size 1)) 
        (bind ?id (gensym*)) ; sequence id
        
        (if (eq ?orientation ver) then ; vertical orientation
            (bind ?moving (- ?x-start ?i)) ; move along row 
            (assert (action (id ?id) (x ?moving) (y ?y-start) (type guess))) 
        else ; horizontal orientation
            (bind ?moving (- ?y-start ?i)) ; move along columns
            (assert (action (id ?id) (x ?x-start) (y ?moving) (type guess)))
        )
        
        (bind ?id-sequence (create$ ?id-sequence ?id)) ; add id to list
    )
    (return ?id-sequence)
)  

(deffunction generate-ship-hor-water (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
    ; loop for water on ship sides 
    (loop-for-count (?i -1 ?size) ; ?i == -1 is for the col before the stern, ?i == size is for the col after the bow
        (bind ?y (- ?y-start ?i))
        
        ; horizontal right side -|o|->
        (bind ?id (gensym*))
        (assert (action (id ?id) (x (- ?x-start 1)) (y ?y) (type water)))
        (bind ?id-sequence (create$ ?id-sequence ?id))
        
        ; horizontal left side <-|o|-
        (bind ?id (gensym*))
        (assert (action (id ?id) (x (+ ?x-start 1)) (y ?y) (type water)))        
        (bind ?id-sequence (create$ ?id-sequence ?id))
    )
    ; add water on the left of the bow
    (bind ?id (gensym*))
    (assert (action (id ?id) (x ?x-start) (y (- ?y-start ?size)) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    ; add water on the right of the stern
    (bind ?id (gensym*))
    (assert (action (id ?id) (x ?x-start) (y (+ ?y-start 1)) (type water)))
    (bind ?id-sequence (create$ ?id-sequence ?id))

    (return ?id-sequence)
) 

(deffunction generate-ship-vert-water (?x-start ?y-start ?size)
    (bind ?id-sequence (create$)) 
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

(defrule plan-backtracking
    (status (step ?s)(currently running))
    ?i <- (intention-abort)
    ?ps <- (plan-stack (lastplan ?plan) (plans $?plans))
	?p <- (plan (id ?plan))
=>
    (printout t "Catch intention abort" crlf)
    (retract ?i)
    (modify ?ps (lastplan (nth$ 2 ?plans))) ; set lastplan to the previous plan in the stack
	(modify ?ps (plans (rest$ ?plans))) ; pop plan from the stack
    (assert (backtracking ?plan))
)

(defrule plan-ship
	(status (step ?s)(currently running))
    ?i <- (intention-sink (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?hor) (type ?type))
    ?b <- (board)
=>
    (printout t "Catch intention sink" crlf)
    (assert (intention-to-plan (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?hor) (type ?type) (size (fact-slot-value ?b ?type))))
    (retract ?i)
)

(defrule generate-plan
    (status (step ?s)(currently running))
	?f <- (intention-to-plan (x-stern ?x-stern) (y-stern ?y-stern) (orientation ?orient) (type ?type) (size ?size))
    ?ps <- (plan-stack (plans $?list))
=>
    (printout t "Plan WarShip" crlf)
    (bind ?plan_id (gensym*))
    
    (bind ?guess_id_seq (generate-ship-guess ?x-stern ?y-stern ?orient ?size)) ;assert guess actions
    
    (if (eq ?orient ver)
        then
            (bind ?water_id_seq (generate-ship-vert-water ?x-stern ?y-stern ?size)) ;assert water actions
        else    
            (bind ?water_id_seq (generate-ship-hor-water ?x-stern ?y-stern ?size)) ;assert water actions
    )
    
    (assert (plan (id ?plan_id ) (ship ?type) (counter 1) (action-sequence (create$ ?guess_id_seq ?water_id_seq)) (x ?x-stern) (y ?y-stern) (orientation ?orient))) ; create a new plan
    (modify ?ps (lastplan ?plan_id) (plans ?plan_id ?list)) ; push new plan on the stack
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