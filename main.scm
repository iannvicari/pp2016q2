; Inicializar testes com os modulos
; EX: csi -s main.scm

(load "simulators.scm")
(import simulators)

(load "fuel.scm")
(import fuel)

(load "coordinations.scm")
(import coordinations)

(load "physics.scm")
(import physics)

(load "aerodynamics.scm")
(import aerodynamics)

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
	(define panel_truevelocity 0)
	(define panel_direction 'LOADING)
	(define mx (make-mutex))
	; Monitor de movimento
	(define movement-monitor (make-movement-monitor 0 0 0))
	
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
	; atualizar valor do monitor de velocidade (metodo interno)
	(define (update-velocity-var)
		(mutex-lock! mx)
		(set! panel_direction
			((movement-monitor 'direction) panel_latitude panel_longitude))
		(set! panel_truevelocity 
			((movement-monitor 'true-velocity) panel_latitude panel_longitude panel_altitude))
		(mutex-unlock! mx))
	; atualizar o console com os novos valores
	(define (update)
		(update-velocity-var) ; update do monitor
		(run clear) ; limpar o console
		(print "*** Atmosphere Condition ***")
		(print (format "Pressure: ~@T~1,3f ~@TAir Density: ~@T~1,8f" 
			(atmospheric-pressure panel_altitude panel_latitude) ; pressure
			(air-density panel_altitude panel_latitude))) ; air density
		(print "\n*** Fuel ***")
		(print (format "Fuel: ~@T~1,3f ~@TRange: ~@T~1,3f" 
			panel_fuel 
			(range panel_truevelocity)))
		(print (format "Flight Time Left: ~@T~1,3f hours" 
			(trest panel_fuel)))
		(print "\n*** Flight Info ***")
		(print (format "Velocity: ~@T~1,3f ~@TLift: ~@T~1,3f" 
			panel_truevelocity
			(lift panel_altitude panel_latitude panel_truevelocity))) ; lift
		(print (format "Acceleration: ~@T~1,3f ~@TThrust: ~@T~1,3f" 
			(acceleration panel_altitude panel_latitude panel_truevelocity) ; acceleration
			(thrust panel_altitude panel_latitude))) ; thrust
		(print (format "Collision Risk: ~@T~1,8f ~@TDrag: ~@T~1,3f" 
			(collision-risk panel_altitude panel_horizon panel_truevelocity)
			(drag panel_truevelocity panel_altitude panel_latitude)))
		(print "\n*** Navigation ***")
		(print (format "Latitude: ~@T~1,5f ~@TLongitude: ~@T~1,5f"
			panel_latitude 
			panel_longitude))
		(print (format "Altitude: ~@T~1,3f ~@TArtificial Horizon: ~@T~1,5f" 
			panel_altitude
			panel_horizon))
		(print (format "Position: ~@T~1,3f ~A ~@TDirection: ~@T~A" 
			(cdr (position panel_latitude panel_longitude)) ; Degrees
			(car (position panel_latitude panel_longitude)) ; Global position
			panel_direction)) ; direction
		(print "\n\nPress Ctrl+C to exit"))
	(lambda (m)
			(cond ((eq? m 'update) update)
				  ((eq? m 'update-fuel-var) update-fuel-var)
				  ((eq? m 'update-gps-var) update-gps-var)
				  ((eq? m 'update-altitude-var) update-altitude-var))))

; Criar sensores
(define gps-sensor (make-gps-sensor))
(define fuel-sensor (make-fuel-sensor))
(define altitude-sensor (make-altitude-sensor))

; Criar painel da interface
(define panel (make-interface))

; Lista de simuladores de sensor (funcionam independentes da interface)
(define simulators-threads
	(list
		; Latitude
		(make-thread
			(lambda () ; thunk
				(let loop() ; loop infinito para update de sensor
					((gps-sensor 'update-latitude))
					((panel 'update-gps-var) gps-sensor)
					(thread-sleep! 1) ; "atualiza" sensor de n em n segundos
					(loop))) 'latitude-simulator)
 		; Longitude
		(make-thread
			(lambda () ; thunk
				(let loop() ; loop infinito para update de sensor
					((gps-sensor 'update-longitude))
					((panel 'update-gps-var) gps-sensor)
					(thread-sleep! 1) ; "atualiza" sensor de n em n segundos
					(loop))) 'longitude-simulator)
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
; e monitor de movimento
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
