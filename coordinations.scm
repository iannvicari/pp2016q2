(module coordinations (guidance make-movement-monitor)

	(import chicken scheme)
	(load "constants.scm")
	(import constants)

	; Funcoes deverao ser executadas a cada um segundo para atualizar valores
	
	; Retorna o posicionamento no Globo da aeronave
	;latitude: latitude atual
	;longitude: medida atual
	;Constantes:
	;MAX-LATITUDE, latitude maxima(90.000)
	;MIN-LATITUDE, latitude minima(-90.000)        
	;MAX-LONGITUDE, longitude maxima(180.000)		
	;MIN-LONGITUDE, longitude minima(-180.000)
	(define (guidance latitude longitude)
		(if (and (< latitude MAX-LATITUDE) (> latitude MIN-LATITUDE))
			(if (and (< longitude MAX-LONGITUDE) (> longitude MIN-LONGITUDE))
				(if (and (> longitude 0) (> latitude 0))
					(cons ('NE (atan (/ longitude latitude))))
					(if (and (> longitude 0) (< latitude 0))
						(cons ('SE (+ (atan (/ longitude latitude)) 90.0)))
						(if (and (< longitude 0) (> latitude 0))
							(cons ('NW (atan (/ longitude latitude))))
							(if (and (< longitude 0) (< latitude 0))
								(cons ('SW (+ (atan (/ longitude latitude)) 90.0)))
								(if (and (> longitude 0) (= latitude 0))
									(cons ('E 90))
									(if (and (= longitude 0) (> latitude 0))
										(cons ('N  0))
										(if (and (< longitude 0) (= latitude 0))
											(cons ('W -90.0))
											(if (and (= longitude 0) (< latitude 0))
												(cons ('S 180.0)))))))))))))

	; Criar monitor de movimento para extrair informacoes
	; como velocidade horizontal, vertical e real velocidade

	; EX: (define monitor (make-movement-monitor))
	;	  (monitor vertical-speed) -> retorna velocidade vertical (na segunda execucao, primeira seta o old_value)
	;	  (monitor horizontal-speed) -> mesma coisa porem velocidade horizontal
	;	  (monitor true-velocity)
	(define (make-movement-monitor)
		(define old_altitude 'NOTSET)
		(define old_latitude 'NOTSET)
		(define old_longitude 'NOTSET)

		; Funcao auxiliar para calcular modulo de valor
		(define modulo (lambda (valor) (if (< valor 0) (* valor -1) valor)))

		; Retorna Direcao em que aeronave se moveu
		; (N, S, E, W, NW, NE, SW, SE)
		(define (direction latitude longitude)
			(if (or (equal? old_latitude 'NOTSET) (equal? old_longitude 'NOTSET))
				(begin
					(if (equal? old_latitude 'NOTSET)
						(set! old_latitude latitude))
					(if (equal? old_longitude 'NOTSET)
						(set! old_longitude longitude)))
			; else
				(cond
					((and (= latitude old_latitude) (< longitude old_longitude)) 'W)
					((and (= latitude old_latitude) (> longitude old_longitude)) 'E)
					((and (> latitude old_latitude) (= longitude old_longitude)) 'N)
					((and (< latitude old_latitude) (= longitude old_longitude)) 'S)
					((and (< latitude old_latitude) (< longitude old_longitude)) 'SW)
					((and (< latitude old_latitude) (> longitude old_longitude)) 'SE)
					((and (> latitude old_latitude) (< longitude old_longitude)) 'NW)
					((and (> latitude old_latitude) (> longitude old_longitude)) 'NE)
					(else 'STOPPED))))

		;Velocidade vertical em Km/h
		;old_altitude: altitude da ultima medida
		;altitude: altitude atual
		;MAX-ALTITUDE, altitude maxima segura 13.14 Km
		;MIN-ALTITUDE, altitude mínima segura
		(define (vertical-speed altitude)
			(if (equal? old_altitude 'NOTSET)
				(set! old_altitude altitude)
			; else
				(if (and (< altitude MAX-ALTITUDE) (> altitude MIN-ALTITUDE))
					(begin
						(set! old_altitude altitude) ; guarda altitude antiga
						(* (modulo (- old_altitude altitude)) 3600)) ; retorna a nova
					'DANGER))) ; retorna DANGER se estiver com valor invalido?
	
		;old_latitude: latitide da ultima medida
		;latitude: latitude atual
		;old_longitude: ultima medida
		;longitude: medida atual
		;MAX-LATITUDEs, latitude maxima(90.0000000)
		;MIN-LATITUDEs, latitude minima(-90.0000000)
		;MAX-LONGITUDE, longitude maxima(180.000000)
		;MIN-LONGITUDE, longitude minima(-180.000000)
		;primeira latitude = 111.12 Km
		;primeira longitude = e de 111.12 km vezes o cosseno da latitude
		(define (horizontal-speed latitude longitude)
			(if (or (equal? old_latitude 'NOTSET) (equal? old_longitude 'NOTSET))
				(begin
					(if (equal? old_latitude 'NOTSET)
						(set! old_latitude latitude))
					(if (equal? old_longitude 'NOTSET)
						(set! old_longitude longitude)))
			; else
				(if (and (and (< latitude MAX-LATITUDE) (> latitude MIN-LATITUDE))
						 (and (< longitude MAX-LONGITUDE) (> longitude MIN-LONGITUDE)))
					(begin
						(set! old_latitude latitude)
						(set! old_longitude longitude)
						(sqrt (+ (exp (* 111.12 (- old_latitude latitude)) 2) 
						  	     (exp (* (- old_longitude longitude) (* 111.12 (cos latitude))) 2))))
					'OUT_OF_MAP))) ; latitude ou longitude invalida

		; Calcular o modulo do vetor de velocidade resultante dos
		; vetores de velocidade horizontal e vertical
		(define (true-velocity h_velocity v_velocity)
				(sqrt (+ (expt h_velocity 2) (expt v_velocity 2))))

		; TODO: chamar aqui os metodos que pegam os valores dos simuladores
		; 		de altitude, longitude e altitude
		(lambda (m)
			(cond ((eq? m 'direction) (direction <VALOR_DO_SIMULADOR_LATITUDE> <VALOR_DO_SIMULADOR_LONGITUDE>))
				  ((eq? m 'vertical-speed) (vertical-speed <VALOR_DO_SIMULADOR_ALTITUDE>))
		      	  ((eq? m 'horizontal-speed) (horizontal-speed <VALOR_DO_SIMULADOR_LATITUDE> <VALOR_DO_SIMULADOR_LONGITUDE>))
		      	  ((eq? m 'true-velocity) (true-velocity 
			      							(vertical-speed <VALOR_DO_SIMULADOR_ALTITUDE>) 
			      							(horizontal-speed <VALOR_DO_SIMULADOR_LATITUDE> <VALOR_DO_SIMULADOR_LONGITUDE>))))))	)