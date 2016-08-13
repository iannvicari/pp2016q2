(module fuel (range trest)
	
	(import chicken scheme)
	(load "constants.scm")
	(import constants)

	;funcao recebe a velocidade do aviao e retorna 
	; qual seria o alcance com o tanque cheio
	(define (range truevelocidade)
	    (* truevelocidade (/ FUEL-LOAD MF)))

	; funcao recebe combustivel disponivel e retorna o tempo 
	; estimado restante de voo
	; nivelcombustivel: dado pelo simulador o quanto resta
	(define (trest nivelcombustivel)
	    (/ nivelcombustivel MF))
)