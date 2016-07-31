(load "constants.scm")
(load "thrust.scm")
(load "drag.scm")


;calculo da aceleração
;equação extraída de: https://www.grc.nasa.gov/www/k-12/airplane/motion.html 
(define aceleration
  (lambda ()
    (/ (- (thrust) (drag)) weight)))
