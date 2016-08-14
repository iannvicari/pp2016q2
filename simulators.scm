(load "constants.scm")

(module simulators (make-fuel-sensor)

	(import chicken scheme)
	(import extras) ;random
	(import constants)
	(use srfi-18)

	; TODO Simulador de latitude e longitude (juntos)

	; TODO Simulador de altitude e variacao de grau do horizonte artificial (juntos)

	; Simulador do sensor do tanque de combustivel
	(define (make-fuel-sensor)
		(define fuel FUEL-LOAD) ; capacidade inicial
		(define mx (make-mutex))
		(define (update n)
			; verificar se ha combistivel e atualizar
			(if (> fuel 0)
				(begin 
					(mutex-lock! mx)
					; atualizar o valor do combustivel disponivel
					; consumo de n segundos somado a um valor randomico 			
					(set! fuel (- fuel (+ (* 0.0001 (random 1000));randomico [0, 0.0999]
										  (/ (* MF n) 3600)))) ;consumo medio em n segundos
					(mutex-unlock! mx))
			;else
				(begin
					(mutex-lock! mx)
					(set! fuel 0)
					(mutex-unlock! mx))))
		(define (get) fuel)
		(lambda (m)
			(cond ((eq? m 'update) update)
				  ((eq? m 'get) get))))
)
