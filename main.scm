; Inicializar testes com os modulos
; EX: csi -s main.scm

(load "simulators.scm")
(import simulators)

(load "fuel.scm")
(import fuel)

(use srfi-18)

; Criar sensores
(define fuel-sensor (make-fuel-sensor))

; Lista de simuladores
(define start-simulators
	(list
		(make-thread
			(lambda () ;thunk
				(let loop() ; loop infinito para update de sensor
					(define intervalo 1) ; define o intervalo n de atualizacao
					((fuel-sensor 'update) intervalo)
					(print (current-thread) ((fuel-sensor 'get)))
					(thread-sleep! intervalo) ; "atualiza" sensor de n em n segundos
					(loop))) 'fuel-simulator)
		
	))

; Lista de processamentos
(define thread-list
	(list
		(make-thread 
			(lambda () ;thunk
				(let loop() ; loop infinito executando
					(print (current-thread) (trest ((fuel-sensor 'get))))
			   		(thread-sleep! 5) ;executa funcao a cada 5 segundos
			   		(loop))) 'trest)))

; Executar simuladores e processamentos
(map thread-join! (map thread-start! (append start-simulators thread-list)))
