(defmodule DELIBERATE (export ?ALL))

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

; TEST -------------------------------------------------------------------------

;(defrule sink-air-carriers
;    (printout t "Focus on DELIBERATE" crlf)
;	(status (step ?s)(currently running))
;=>
;	(assert (intention-sink (x-stern 5) (y-ster 5) (orientation ver) (type air-carrier)))
;	(focus PLANNING) 
;)