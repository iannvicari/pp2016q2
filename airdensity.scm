(load "constants.scm")
;(load "atmpressure.scm") ;;; Funcao de pressao atmosferica - Grupo 2

(define air-density
	(lambda (altitude)
		(/ (atm-pressure altitude) (* R-air Temperature))))