(load "constants.scm")
(load "tmax.scm")
(load "truevelocity.scm")

;função recebe a velocidade do avião (suponho que a de cruzeiro) e retorna o alcance

(define range
  (lambda (velocidade)
    (* velocidade tmax)))
  
;versão usando a função que calcula a velocidade real (AINDA NÃO TESTEI ESSA VERSÃO DA FUNÇÃO)

;(define range
; (lambda (true-velocity)
;   (* true-velocity tmax)))
