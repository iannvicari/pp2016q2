(load "constants.scm")

(module physics (air-density atmospheric-pressure gravity)

	(import chicken scheme)
	(import constants)

	;Forca gravitacional, considerando-se altitude e latitude
	;obtida em: https://pt.wikipedia.org/wiki/Acelera%C3%A7%C3%A3o_da_gravidade 
	(define (gravity altitude latitude)
	    (- (* (+ (- (* (* (sin latitude) (sin latitude)) 0.0053024) 
	    (* (* (* (sin latitude) (sin latitude)) 0.0000058) 2)) 1) 9.780327) 
	    (* altitude 0.000003086)))

	; Pressao atmosferica
	; Calculo da pressao atmosferica exercida de acordo com a altitude e latitude
	(define (atmospheric-pressure altitude latitude)
			(/ P-SL (exp (/ (* (gravity altitude latitude) altitude) (* R-AIR TEMPERATURE)))))

	; Densidade do ar
	(define (air-density altitude latitude)
		(/ (atmospheric-pressure altitude latitude) (* R-AIR TEMPERATURE)))	)