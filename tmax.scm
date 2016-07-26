(load "constants.scm")
(load "thrust.scm")

;função retorna o tempo máximo de voo de acordo com constantes do modelo

(define tmax (/ fuel-load mf))