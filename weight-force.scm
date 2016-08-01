(load "constants.scm")
(load "gravity.scm")

(define weight-force
  (lambda (mass)
    (* mass gravity)))

