(defmodule DELIBERATE (import MAIN ?ALL) (import ENV ?ALL) (import HEAT ?ALL)  (export ?ALL))

;; ******************************
;; TEMPLATES
;; ******************************

(deftemplate intention-fire
	(slot x)
	(slot y)
)

(deftemplate intention-sink
	(slot x-stern)
	(slot y-stern)
	(slot orientation (allowed-values ver hor))
	(slot type (allowed-values air-carrier cruiser destroyer submarine))
)


;; ******************************
;; RULES
;; ******************************

(defrule fire-at-first (declare (salience 40)) ; TODO valutare se togliere salience
  	(moves (fires ?f&:(> ?f 0))) ; controlla che ci siano ancora fires disponibili
	(board (median ?h))
	(heat-map (x ?x) (y ?y) (h ?h) (computed TRUE))
	(not (k-cell (x ?x) (y ?y)))
=>
	(assert (intention-fire (x ?x) (y ?y)))
	(pop-focus)
)

; (defrule demo
; =>
; 	(assert(intention-sink(x-stern 6) (y-stern 4) (orientation ver) (type air-carrier)))
; 	(pop-focus)
; )

; (deftemplate intention-abort
; 	(slot x-stern)
; 	(slot y-stern)
; 	(slot orientation (allowed-values ver hor))
; 	(slot type (allowed-values air-carrier cruiser destroyer submarine))
; )

; (deftemplate intention-observe
; 	(slot x-stern)
; 	(slot y-stern)
; )

; ; SINK AIR-CARRIER -------------------------------------------------------------

; (defrule sink-air-carriers
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Air-Carrier" crlf)
; 	(assert (intention-sink (x-stern 6) (y-stern 4) (orientation ver) (type air-carrier)))
; 	; TODO aggionare num navi da affondare....
; 	(pop-focus)
; )

; ; SINK CRUISER -----------------------------------------------------------------

; (defrule sink-cruiser1
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Cruiser1" crlf)
; 	(assert (intention-sink (x-stern 6) (y-stern 2) (orientation ver) (type cruiser)))
; 	(pop-focus) 
; )

; (defrule sink-cruiser2
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Cruiser2" crlf)
; 	(assert (intention-sink (x-stern 6) (y-stern 6) (orientation ver) (type cruiser)))
; 	(pop-focus) 
; )

; ; SINK DESTROYER ---------------------------------------------------------------

; (defrule sink-destroyer1
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Destroyer1" crlf)
; 	(assert (intention-sink (x-stern 6) (y-stern 0) (orientation ver) (type destroyer)))
; 	(pop-focus) 
; )

; (defrule sink-destroyer2
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Destroyer2" crlf)
; 	(assert (intention-sink (x-stern 6) (y-stern 8) (orientation ver) (type destroyer)))
; 	(pop-focus) 
; )

; (defrule sink-destroyer3
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Destroyer3" crlf)
; 	(assert (intention-sink (x-stern 9) (y-stern 4) (orientation ver) (type destroyer)))
; 	(pop-focus) 
; )

; ; SINK SUBMARINE ---------------------------------------------------------------

; (defrule sink-submarine1
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Submarine1" crlf)
; 	(assert (intention-sink (x-stern 0) (y-stern 0) (orientation ver) (type submarine)))
; 	(pop-focus) 
; )

; (defrule sink-submarine2
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Submarine2" crlf)
; 	(assert (intention-sink (x-stern 9) (y-stern 9) (orientation ver) (type submarine)))
; 	(pop-focus) 
; )

; (defrule sink-submarine3
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Submarine3" crlf)
; 	(assert (intention-sink (x-stern 0) (y-stern 9) (orientation ver) (type submarine)))
; 	(pop-focus) 
; )

; (defrule sink-submarine4
; 	(status (step ?s)(currently running))
; =>
; 	(printout t "Sink Submarine4" crlf)
; 	(assert (intention-sink (x-stern 9) (y-stern 0) (orientation ver) (type submarine)))
; 	(pop-focus) 
; )