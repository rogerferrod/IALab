(defmodule PLANNING (import DELIBERATE ?ALL) (export ?ALL))

(deftemplate action
    (slot id (default-dynamic (gensym*))) ; genX
    (slot x)
    (slot y)
    (slot type (allowed-values guess unguess fire))
)

(deftemplate plan
	(multislot action-sequence (type SYMBOL))
)
