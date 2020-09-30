(defmodule AGENT 
	(import MAIN ?ALL)
	(import ENV ?ALL)
	(import HEAT ?ALL)
	(import DISCOVER ?ALL)
	(import DELIBERATE ?ALL) 
	(import PLANNING ?ALL) 
	(export ?ALL)
)

;; --------------------------------------
;; RULES
;; --------------------------------------

(defrule go-on-heat-first (declare (salience 40)) ; force to compute heatmap as first game step
  ?f <- (first-pass-to-heat)
=>
  (retract ?f)
  (focus HEAT)
)