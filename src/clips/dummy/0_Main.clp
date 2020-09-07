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
    ;(printout t "vado ad agent  step" ?s)
    (focus AGENT)
)



; SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env  (declare (salience 30))
  ?f1<-	(status (step ?s))
  (exec (step ?s)) 	;// azione da eseguire al passo s, viene simulata dall'environment

=>

  ; (printout t crlf crlf)
  ; (printout t "vado ad ENV  step" ?s)
  (focus ENV)

)

(defrule game-over
	(maxduration ?d)
	(status (step ?s&:(>= ?s ?d)) (currently running))
=>
	(assert (exec (step ?s) (action solve)))
	(focus ENV)
)

(deffacts initial-facts
	(maxduration 100)
	(status (step 0) (currently running))
        (statistics (num_fire_ok 0) (num_fire_ko 0) (num_guess_ok 0) (num_guess_ko 0) (num_safe 0) (num_sink 0))
	(first-pass-to-env)
	(moves (fires 5) (guesses 20))
  (air-carriers-info 1 4) ; TODO magari da spostare
  (cruisers-info 2 3)
  (destroyers-info 3 2)
  (submarines-info 4 1)
)

