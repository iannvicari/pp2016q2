(load "constants.scm")
(load "airdensity.scm")
(load "truevelocity.scm")

;coeficiente de sustentação considerando a inclinação como 0 
;falta fazer uma função para o cosseno da inclinação e multiplicar pelo coeficiente
;fórmula obtida em: http://128.173.204.63/courses/cee5614/cee5614_pub/Aircraft_perf_notes2.pdf
(define lift-coefficient
  (lambda ()
    (/ (* (* weight 9.8) 2) (* (* air-density wing-area) (* true-velocity true-velocity))))) 

;sustentação e coeficiente de sustentação 
;(fórmula obtida em: https://www.grc.nasa.gov/www/k-12/airplane/lifteq.html)
(define lift
  (lambda ()
    (/ (* lift-coefficient (* (* wing-area (* true-velocity true-velocity)) air-density)) 2)))
