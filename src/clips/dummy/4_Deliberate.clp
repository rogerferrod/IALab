(defmodule DELIBERATE (import MAIN ?ALL) (import ENV ?ALL)  (export ?ALL))

(deftemplate intention-sink
	(slot x-stern)
	(slot y-stern)
	(slot orientation (allowed-values ver hor))
	(slot type (allowed-values air-carrier cruiser destroyer submarine))
)

(deftemplate intention-abort
	(slot x-stern)
	(slot y-stern)
	(slot orientation (allowed-values ver hor))
	(slot type (allowed-values air-carrier cruiser destroyer submarine))
)

(deftemplate intention-observe
	(slot x-stern)
	(slot y-stern)
)

; SINK AIR-CARRIER -------------------------------------------------------------

(defrule sink-air-carriers
    (printout t "Sink Air-Carrier" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 6) (y-stern 4) (orientation ver) (type air-carrier)))
	; TODO aggionare num navi da affondare....
	(pop-focus)
)

; SINK CRUISER -----------------------------------------------------------------

(defrule sink-cruiser1
    (printout t "Sink Cruiser1" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 6) (y-stern 2) (orientation ver) (type cruiser)))
	(pop-focus) 
)

(defrule sink-cruiser2
    (printout t "Sink Cruiser2" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 6) (y-stern 6) (orientation ver) (type cruiser)))
	(pop-focus) 
)

; SINK DESTROYER ---------------------------------------------------------------

(defrule sink-destroyer1
    (printout t "Sink Destroyer1" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 6) (y-stern 0) (orientation ver) (type destroyer)))
	(pop-focus) 
)

(defrule sink-destroyer2
    (printout t "Sink Destroyer2" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 6) (y-stern 8) (orientation ver) (type destroyer)))
	(pop-focus) 
)

(defrule sink-destroyer3
    (printout t "Sink Destroyer3" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 9) (y-stern 4) (orientation ver) (type destroyer)))
	(pop-focus) 
)

; SINK SUBMARINE ---------------------------------------------------------------

(defrule sink-submarine1
    (printout t "Sink Submarine1" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 0) (y-stern 0) (orientation ver) (type submarine)))
	(pop-focus) 
)

(defrule sink-submarine2
    (printout t "Sink Submarine2" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 9) (y-stern 9) (orientation ver) (type submarine)))
	(pop-focus) 
)

(defrule sink-submarine3
    (printout t "Sink Submarine3" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 0) (y-stern 9) (orientation ver) (type submarine)))
	(pop-focus) 
)

(defrule sink-submarine4
    (printout t "Sink Submarine4" crlf)
	(status (step ?s)(currently running))
=>
	(assert (intention-sink (x-stern 9) (y-stern 0) (orientation ver) (type submarine)))
	(pop-focus) 
)