(load "constants.scm")
(load "physics.scm")

(module aerodynamics (collision-risk acceleration drag lift thrust)

	(import chicken scheme)
	(import constants)
	(import physics)

	; Altitude - Altitude Absoluta (simulado)
	; Grau - Horizonte artificial (simulado)
	; True-velocity (valor retirado de monitor de velocidade: coordinations.scm)
	(define (collision-risk altitude grau truevelocity)
			(if (>= grau 0)
				-1
				(/ altitude (* (sin grau) truevelocity))))

	; Drag
	(define (drag truevelocity altitude latitude)
		(* 0.5 (* DRAG-COEFF (* (air-density altitude latitude) (* WING-AREA (expt truevelocity 2))))))

	; Funcao Auxiliar
	;coeficiente de sustentacao considerando a inclinacao como 0 
	;falta fazer uma funcao para o cosseno da inclinacao e multiplicar pelo coeficiente
	;obtido em: http://128.173.204.63/courses/cee5614/cee5614_pub/Aircraft_perf_notes2.pdf
	(define lift-coefficient
	  (lambda (altitude latitude truevelocity)
	    (/ (* (* MASS (gravity altitude latitude)) 2) (* (* (air-density altitude latitude) WING-AREA) (expt truevelocity 2)))))

	; Lift
	;sustentacao e coeficiente de sustentacao 
	;obtido em: https://www.grc.nasa.gov/www/k-12/airplane/lifteq.html
	(define (lift altitude latitude truevelocity)
	    (/ (* (lift-coefficient altitude latitude truevelocity) (* (* WING-AREA (expt truevelocity 2)) (air-density altitude latitude))) 2))

	; Thrust
	(define (thrust altitude latitude)
		(* (/ (air-density altitude latitude) P-SL) TMAX-SL))

	; Aceleracao
	; extraido de: https://www.grc.nasa.gov/www/k-12/airplane/motion.html 
	(define (acceleration altitude latitude truevelocity)
	    (/ (- (thrust altitude latitude) (drag truevelocity altitude latitude)) MASS))	)