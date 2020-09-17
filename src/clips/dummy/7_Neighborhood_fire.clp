;; *******************************
;; FUNCTIONS
;; *******************************


(deffunction check-boundary (?x ?y)
	(if (or (< ?x 0) 
			(< ?y 0) 
			(> ?x 9) 
			(> ?y 9))
	then (bind ?return FALSE)
	else (bind ?return TRUE))
)

;; *******************************
;; RULES
;; *******************************

(defrule discover-neighborhood-top
	(k-cell (x ?x) (y ?y) (content top))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x-1, y -> nord neighbor
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y-1 -> ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y+1 -> est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x+1, y -> sud neighbor 
	 then 
		(assert (modify-heat ?nx ?ny 100))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)

(defrule discover-neighborhood-left
	(k-cell (x ?x) (y ?y) (content left))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x-1, y -> nord neighbor
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y-1 -> ovest neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y+1 -> est neighbor 
	 then 
		(assert (modify-heat ?nx ?ny 100))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x+1, y -> sud neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)

(defrule discover-neighborhood-right
	(k-cell (x ?x) (y ?y) (content right))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x-1, y -> nord neighbor
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y-1 -> ovest neighbor 
	 then 
		(assert (modify-heat ?nx ?ny 100))
	)
	(bind ?nx ?x)
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y+1 -> est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x+1, y -> sud neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)


(defrule discover-neighborhood-bottom
	(k-cell (x ?x) (y ?y) (content bot))
	?m <- (heat-map (x ?x) (y ?y))
=>
    ;(printout t "CURRENT MODULE: " (get-current-module))
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x-1, y -> nord neighbor
	 then 
		(assert (modify-heat ?nx ?ny 100)) ; siamo sicuri che c'è una pezzo di nave ma non sappiamo quale
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y-1 -> ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y+1 -> est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x+1, y -> sud neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)

(defrule discover-neighborhood-sub
	(k-cell (x ?x) (y ?y) (content sub))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x-1, y -> nord neighbor
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y-1 -> ovest neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx ?x)
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x, y+1 -> est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny ?y)
	(if (check-boundary ?nx ?ny) ; x+1, y -> sud neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)

(defrule discover-neighborhood-middle
	(k-cell (x ?x) (y ?y) (content middle))
	?m <- (heat-map (x ?x) (y ?y))
=>
	(bind ?nx (- ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y-1 -> nord-ovest neighbor
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (- ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x-1, y+1 -> nord-est neighbor 
	 then 
		(assert (k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (- ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y-1 -> sud-ovest neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
	(bind ?nx (+ ?x 1))
	(bind ?ny (+ ?y 1))
	(if (check-boundary ?nx ?ny) ; x+1, y+1 -> sud-est neighbor 
	 then 
		(assert(k-cell (x ?nx) (y ?ny) (content water)))
		(assert (modify-heat ?nx ?ny 0))
	)
)