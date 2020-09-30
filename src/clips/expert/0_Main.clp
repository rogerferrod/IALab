(defmodule MAIN (export ?ALL))


(deftemplate exec
   (slot step)
   (slot action (allowed-values fire guess unguess solve))
   (slot x) ;;non usato nel caso del comando solve
   (slot y) ;;non usato nel caso del comando solve
)

(deftemplate status (slot step) (slot currently (allowed-values running stopped)) )

(deftemplate moves (slot fires) (slot guesses) )

(deftemplate statistics
	(slot num_fire_ok)
	(slot num_fire_ko)
	(slot num_guess_ok)
	(slot num_guess_ko)
	(slot num_safe)
	(slot num_sink)
)



(defrule go-on-env-first (declare (salience 30))
  ?f <- (first-pass-to-env)
=>

  (retract ?f)
  (focus ENV)
)


(defrule go-on-agent  (declare (salience 20))
   (maxduration ?d)
   (status (step ?s&:(< ?s ?d)) (currently running))

 =>

    ;(printout t crlf crlf)
    ;(printout t "vado ad agent  step" ?s crlf)
    (focus AGENT)
)



; SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env  (declare (salience 30))
  ?f1<-	(status (step ?s))
  (exec (step ?s)) 	;// azione da eseguire al passo s, viene simulata dall'environment

=>

  ; (printout t crlf crlf)
  ;(printout t "vado ad ENV  step" ?s crlf)
  (focus ENV)

)

(defrule game-over
	(maxduration ?d)
	(status (step ?s&:(>= ?s ?d)) (currently running))
=>
	(assert (exec (step ?s) (action solve)))
	(focus ENV)
)

(deffunction check-boundary (?x ?y)
	(if (or (< ?x 0) 
			(< ?y 0) 
			(> ?x 9) 
			(> ?y 9))
	then (bind ?return FALSE)
	else (bind ?return TRUE))
)

(deftemplate board
	(slot air-carrier)  ;tipo nave, #navi, #celle occupate
	(slot cruiser)
	(slot destroyer)
	(slot submarine)
  (slot n-air-carriers)  ;tipo nave, #navi, #celle occupate
	(slot n-cruisers)
	(slot n-destroyers)
	(slot n-submarines)
  (multislot ordered)
  (slot median)
)  

(deftemplate heatset
	(multislot values (type SYMBOL))
)

(deftemplate convolution-scores
    (multislot values (type SYMBOL))
    (slot best-id)
    (slot is-first)
)

(deftemplate plan-stack
  (multislot plans (type SYMBOL))
  (slot lastplan)
)

(deffacts initial-facts
	(maxduration 10000)
	(status (step 0) (currently running))
  (statistics (num_fire_ok 0) (num_fire_ko 0) (num_guess_ok 0) (num_guess_ko 0) (num_safe 0) (num_sink 0))
	(first-pass-to-env)
  (first-pass-to-heat)
  (first-pass-to-discover)
	(moves (fires 5) (guesses 20))
  (board
    (air-carrier 4)
    (cruiser 3)
    (destroyer 2)
    (submarine 1)
    (n-air-carriers 1)
    (n-cruisers 2)
    (n-destroyers 3)
    (n-submarines 4)
    (ordered air-carrier cruiser cruiser destroyer destroyer destroyer submarine submarine submarine submarine)
  )
  (heatset (values (create$)))
  (plan-stack (plans (create$)) (lastplan nil))
  (ship-index 1)
  (convolution-scores (values (create$)) (best-id nil) (is-first TRUE))
)

