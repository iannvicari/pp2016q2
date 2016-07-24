;;; Constantes fisicas

(define p-SL 1.225) ; Kg/m^3 => Pressao do ar no nivel do mar
(define R-air 287.05) ; J/(Kg*K) => Constante de gases para o ar
(define Temperature 288.15) ; Kelvin => Temperatura constante

;;; Constantes da Aeronave
; Modelo da aeronave: Boeing 777

(define drag-coeff 0.026) ; Coeficiente de arrast0
(define wing-area 427.8) ; m^2 => Area das asas
(define Tmax-SL 830000) ; N => Empuxo Maximo possivel
