(load constants.scm)
(load airdensity.scm)

(define drag
	(lambda (velocidade)
		(* 0.5 (* drag_coeff (* (air-density altitude) (* wing-area (expt velocidade 2)))))))