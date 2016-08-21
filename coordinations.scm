(load "constants.scm")

(module coordinations (position make-movement-monitor)

	(import chicken scheme)
	(import constants)
	(use srfi-18)

	; Funcoes deverao ser executadas periodicamente para atualizar valores
	
	; Retorna o posicionamento no Globo da aeronave
	;latitude: latitude atual
	;longitude: medida atual
	;Constantes:
	;MAX-LATITUDE, latitude maxima(90.000)
	;MIN-LATITUDE, latitude minima(-90.000)        
	;MAX-LONGITUDE, longitude maxima(180.000)		
	;MIN-LONGITUDE, longitude minima(-180.000)
	(define (position latitude longitude)
		(if (and (< latitude MAX-LATITUDE) (> latitude MIN-LATITUDE))
			(if (and (< longitude MAX-LONGITUDE) (> longitude MIN-LONGITUDE))
				(if (and (> longitude 0) (> latitude 0))
					(cons 'NE  (atan (/ longitude latitude)))
					(if (and (> longitude 0) (< latitude 0))
						(cons 'SE (+ (atan (/ longitude latitude)) 90.0))
						(if (and (< longitude 0) (> latitude 0))
							(cons 'NW (atan (/ longitude latitude)))
							(if (and (< longitude 0) (< latitude 0))
								(cons 'SW (+ (atan (/ longitude latitude)) 90.0))
								(if (and (> longitude 0) (= latitude 0))
									(cons 'E  90)
									(if (and (= longitude 0) (> latitude 0))
										(cons 'N  0)
										(if (and (< longitude 0) (= latitude 0))
											(cons 'W -90.0)
											(if (and (= longitude 0) (< latitude 0))
												(cons 'S 180.0))))))))))))

	; Criar monitor de movimento para extrair informacoes
	; como velocidade horizontal, vertical e a real velocidade frontal

	; EX: (define monitor (make-movement-monitor))
	;	  (monitor vertical-speed) -> retorna velocidade vertical (na segunda execucao, primeira seta o old_value)
	;	  (monitor horizontal-speed) -> mesma coisa porem velocidade horizontal
	;	  (monitor true-velocity)
	(define (make-movement-monitor first_lat first_lon first_alt)
		(define old_altitude first_alt)
		(define old_latitude first_lat)
		(define old_longitude first_lon)
		(define mx (make-mutex))
		; Retorna Direcao em que aeronave se moveu
		; (N, S, E, W, NW, NE, SW, SE)
		(define (direction latitude longitude)
			(cond
				((and (= latitude old_latitude) (< longitude old_longitude)) 'W)
				((and (= latitude old_latitude) (> longitude old_longitude)) 'E)
				((and (> latitude old_latitude) (= longitude old_longitude)) 'N)
				((and (< latitude old_latitude) (= longitude old_longitude)) 'S)
				((and (< latitude old_latitude) (< longitude old_longitude)) 'SW)
				((and (< latitude old_latitude) (> longitude old_longitude)) 'SE)
				((and (> latitude old_latitude) (< longitude old_longitude)) 'NW)
				((and (> latitude old_latitude) (> longitude old_longitude)) 'NE)
				(else 'STOPPED)))
		
		;Velocidade vertical em Km/h (supondo que atualizacao e a cada segundo)
		;old_altitude: altitude da ultima medida
		;altitude: altitude atual
		(define (vertical-speed altitude)
			(begin
				(define speed (/ (* (abs (- altitude old_altitude)) 3600) 1000))
				(mutex-lock! mx)
				(set! old_altitude altitude) ; guarda altitude
				(mutex-unlock! mx)
				speed)) ; retorna velocidade

		; Velocidade horizontal Km/h (sendo atualizacao a cada segundo)
		;old_latitude: latitide da ultima medida
		;latitude: latitude atual
		;old_longitude: ultima medida
		;longitude: medida atual
		(define (horizontal-speed latitude longitude)
			(begin
				; Ponto 1
				(define rho1 (* EARTH-RADIUS (cos old_latitude)))
				(define z1 (* EARTH-RADIUS (sin old_latitude)))
				(define x1 (* rho1 (cos old_longitude)))
				(define y1 (* rho1 (sin old_longitude)))
				
				; Ponto 2
				(define rho2 (* EARTH-RADIUS (cos latitude)))
				(define z2 (* EARTH-RADIUS (sin latitude)))
				(define x2 (* rho2 (cos longitude)))
				(define y2 (* rho2 (sin longitude)))				

				; Guardar valores antigos para proxima execucao
				(mutex-lock! mx)
				(set! old_latitude latitude)
				(set! old_longitude longitude)
				(mutex-unlock! mx)

				(define distance
					(* EARTH-RADIUS 
					   (acos (/ (+ (* x1 x2) (+ (* y1 y2) (* z1 z2))) 
								(expt EARTH-RADIUS 2)))))
				; Retornar velocidade
				(/ (* distance 3600) 1000)))

		; Calcular o modulo do vetor de velocidade resultante dos
		; vetores de velocidade horizontal e vertical
		(define (true-velocity latitude longitude altitude)
				(sqrt (+ (expt (horizontal-speed latitude longitude) 2) 
						 (expt (vertical-speed altitude) 2))))
		(lambda (m)
			(cond ((eq? m 'direction) direction)
				  ((eq? m 'vertical-speed) vertical-speed)
		      	  ((eq? m 'horizontal-speed) horizontal-speed)
		      	  ((eq? m 'true-velocity) true-velocity))))
)