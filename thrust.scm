(load "constants.scm")
(load "airdensity.scm")

(define thrust
	(lambda (altitude)
		(* (/ (air-density altitude) p-SL) Tmax-SL)))