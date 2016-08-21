(load "constants.scm")

(module simulators (make-fuel-sensor make-altitude-sensor)

	(import chicken scheme)
	(import extras) ;random
	(import constants)
	(use srfi-18)

	; TODO Simulador de latitude e longitude (juntos)

	; Simulador de altitude e variacao de grau do horizonte artificial
	(define (make-altitude-sensor)
		(define altitude (/ MAX-ALTITUDE 2)) ; valores iniciais
		(define old-altitude altitude)
		(define horizon 0)
		(define mx (make-mutex))
		; Variacao de 0.01 m por update
		; Chance de 40% manter, 30% de subir e 30% de descer
		; Respeitar altitudes maximas e minimas
		(define (update-alitude)
			(mutex-lock! mx)
			(cond ((>= altitude MAX-ALTITUDE) ; forcar diminuir
					(set! altitude (- altitude (- 0.03 (* 0.001 (random 10))))))
				  ((<= altitude MIN-ALTITUDE) ; forcar aumentar
				  	(set! altitude (+ altitude (+ 0.03 (* 0.001 (random 10))))))
				  (else
				  	(begin
				  		(define signal (random 101))
				  		(cond ((< signal 30) ; aumenta altitude
				  				(set! altitude (+ altitude (+ 0.01 (* 0.001 (random 10))))))
				  			  ((> signal 70) ; diminui altitude
				  			  	(set! altitude (- altitude (- 0.01 (* 0.001 (random 10))))))
				  			  (else ; manter altitude (com variacao minima) 
				  			  	(set! altitude (+ altitude (* 0.001 (random 6)))))))))
			(mutex-unlock! mx))
		; Compara altitude atual com antiga e gera valor de angulo
		; somado a uma variacao randomica para o simulador
		(define (update-horizon)
			(mutex-lock! mx)
			(cond 
				((<= (abs (- altitude old-altitude)) 0.01) ; variacao quase nula
					(set! horizon 0))
				((< (- altitude old-altitude) 0) ; descendo
					(set! horizon (* -1 (+ (random 30) (* 0.1 (abs (- altitude old-altitude)))))))
				((> (- altitude old-altitude) 0) ; subindo
					(set! horizon (+ (random 30) (* 0.1 (abs (- altitude old-altitude)))))))
			; Resetar caso gere algum valor fora do intervalo aceitavel
			(if (or (>= horizon 90) (<= horizon -90)) (set! horizon 0))
			; Atualizar valor de old-altitude
			(set! old-altitude altitude)
			(mutex-unlock! mx))
		(define (get-altitude) altitude)
		(define (get-horizon) horizon)
		(lambda (m)
			(cond ((eq? m 'update-altitude) update-alitude)
				  ((eq? m 'update-horizon) update-horizon)
				  ((eq? m 'get-altitude) get-altitude)
				  ((eq? m 'get-horizon) get-horizon))))

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
