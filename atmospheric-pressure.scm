(load "constants.scm")
(load "gravity.scm")


;Calculo da pressão atmosférica exercida sobre a aeronave de acordo com a altitude
(define atmospheric-pressure
  (lambda ()
    (/ p-SL (exp(/ (* gravity altitude) (* R-air Temperature))))))

