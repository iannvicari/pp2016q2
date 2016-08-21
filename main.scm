; Inicializar testes com os modulos
; EX: csi -s main.scm

(load "simulators.scm")
(import simulators)

(load "fuel.scm")
(import fuel)

; *** Importante, instalar egg do "shell" para usar:
; *** sudo chicken-install shell
(use shell)

; *** Importante, instalar egg do "format" para usar:
; *** sudo chicken-install format
(use format)

(use srfi-18)

; Criar interface que sera exibida no console
(define (make-interface)
	; variaveis dos simuladores
	(define panel_fuel 'LOADING)
	(define panel_latitude 'LOADING)
	(define panel_longitude 'LOADING)
	(define panel_altitude 'LOADING)
	(define panel_horizon 'LOADING)
	(define mx (make-mutex))
	; atualizar valores dos simuladores
	(define (update-fuel-var fuel-sensor)
		(mutex-lock! mx)
		(set! panel_fuel ((fuel-sensor 'get)))
		(mutex-unlock! mx))
	(define (update-gps-var gps-sensor)
		(mutex-lock! mx)
		(set! panel_latitude ((gps-sensor 'get-latitude)))
		(set! panel_longitude ((gps-sensor 'get-longitude)))
		(mutex-unlock! mx))
	(define (update-altitude-var altitude-sensor)
		(mutex-lock! mx)
		(set! panel_altitude ((altitude-sensor 'get-altitude)))
		(set! panel_horizon ((altitude-sensor 'get-horizon)))
		(mutex-unlock! mx))

	; atualizar o console com os novos valores
	(define (update)
		(run clear) ; limpar o console
		(print "*** Atmosphere Condition ***")
		(print (format "Pressure: ~@T~1,3f ~@TAir Density: ~@T~1,3f" "-" "-")) ; TODO
		(print "\n*** Fuel ***")
		(print (format "Fuel: ~@T~1,3f ~@TRange: ~@T~1,3f" panel_fuel "-")) ; TODO
		(print (format "Flight Time Left: ~@T~1,3f hours" (trest panel_fuel)))
		(print "\n*** Flight Info ***")
		(print (format "Velocity: ~@T~1,3f ~@TLift: ~@T~1,3f" "-" "-")) ; TODO
		(print (format "Accelration: ~@T~1,3f ~@TThrust: ~@T~1,3f" "-" "-")) ; TODO
		(print (format "Collision Risk: ~@T~1,3f ~@TDrag: ~@T~1,3f" "-" "-")) ; TODO
		(print "\n*** Navigation ***")
		(print (format "Latitude: ~@T~1,3f ~@TLongitude: ~@T~1,3f" "-" "-")) ; TODO
		(print (format "Altitude: ~@T~1,3f ~@TArtificial Horizon: ~@T~1,5f" panel_altitude panel_horizon))
		(print (format "Position: ~@T~1,3f ~@TDirection: ~@T~1,3f" "-" "-")) ; TODO
		(print "\n\nPress Ctrl+C to exit"))

	(lambda (m)
			(cond ((eq? m 'update) update)
				  ((eq? m 'update-fuel-var) update-fuel-var)
				  ((eq? m 'update-gps-var) update-gps-var)
				  ((eq? m 'update-altitude-var) update-altitude-var))))

(define panel (make-interface))

; Criar sensores
(define fuel-sensor (make-fuel-sensor))
(define altitude-sensor (make-altitude-sensor))

; Lista de simuladores de sensor (funcionam independentes da interface)
(define simulators-threads
	(list
		; Latitude e longitude
		; TODO
		
		; Altitude
		(make-thread
			(lambda () ; thunk
				(let loop() ; loop infinito para update de sensor
					((altitude-sensor 'update-altitude))
					((panel 'update-altitude-var) altitude-sensor)
					(thread-sleep! 1) ; "atualiza" sensor de n em n segundos
					(loop))) 'altitude-simulator)

		; Horizonte artificial
		(make-thread
			(lambda () ; thunk
				(let loop() ; loop infinito para update de sensor
					((altitude-sensor 'update-horizon))
					((panel 'update-altitude-var) altitude-sensor)
					(thread-sleep! 3) ; "atualiza" sensor de n em n segundos
					(loop))) 'horizon-simulator)

		; Fuel
		(make-thread
			(lambda () ; thunk
				(let loop() ; loop infinito para update de sensor
					(define intervalo 3) ; define o intervalo n de atualizacao
					((fuel-sensor 'update) intervalo)
					((panel 'update-fuel-var) fuel-sensor)
					(thread-sleep! intervalo) ; "atualiza" sensor de n em n segundos
					(loop))) 'fuel-simulator)))

; Interface no console mostrando resultados do processamentos para o usuario
(define panel-thread
	(list
		(make-thread 
			(lambda () ;thunk
				(let loop() ; loop infinito para atualizar painel
					((panel 'update))
			   		(thread-sleep! 1)
			   		(loop))) 'panel-interface)))

; Executar simuladores e interface
(map thread-join! (map thread-start! (append simulators-threads panel-thread)))
