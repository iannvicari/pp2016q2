;;; Calcular o modulo dos vetores de velocidade
(define true-velocity
	(lambda (h_velocity v_velocity)
		(sqrt (+ (expt h_velocity 2) (expt v_velocity 2)))))