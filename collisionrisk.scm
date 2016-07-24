; Altitude - Altitude Absoluta
; Grau - Horizonte artificial
; Velocidade - true-velocity(velocidade horizontal velocidade-vertical)
(define collision-risk
	(lambda (altitude velocidade grau)
		(if (>= grau 0)
			-1
			(/ altitude (* (sin grau) velocidade)))))