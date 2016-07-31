(load "constants.scm")

;força gravitacional, considerando-se altitude e latitude
;equação obtida em:https://pt.wikipedia.org/wiki/Acelera%C3%A7%C3%A3o_da_gravidade 

(define gravity
  (lambda ()
    (- (* (+ (- (* (* (sin latitude) (sin latitude)) 0.0053024) 
    (* (* (* (sin latitude) (sin latitude)) 0.0000058) 2)) 1) 9.780327) 
    (* altura 0.000003086))))

;à definir variáveis: latitude (latitude atual em graus) e altura 
;(altura atual da aeronave em relação ao nível do mar em metros) 


