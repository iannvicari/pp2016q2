(load "constants.scm")
(load "tmax.scm")

;função recebe combustível gasto e retorna tempo estimado restante
;mf -> kg/h, fuel-load -> kg e tmax -> h
;PROBLEMA -> entrar com a quantidade de combustível gasto

(define trest
  (lambda (gasto)
    (/ (- fuel-load gasto) mf)))