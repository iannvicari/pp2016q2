(load "constants.scm")
(load "tmax.scm")

;função recebe a velocidade do avião (suponho que a de cruzeiro) e retorna o alcance

(define range
  (lambda (velocidade)
    (* velocidade tmax)))