;;; Constantes fisicas

(define p-SL 1.225) ; Kg/m^3 => Pressao do ar no nivel do mar
(define R-air 287.05) ; J/(Kg*K) => Constante de gases para o ar
(define Temperature 288.15) ; Kelvin => Temperatura constante
(define qav 0.813) ; QAV => densidade da querosene de aviação

;;; Constantes da Aeronave
; Modelo da aeronave: Boeing 777

(define drag-coeff 0.026) ; Coeficiente de arrast0
(define wing-area 427.8) ; m^2 => Area das asas
(define Tmax-SL 830000) ; N => Empuxo Maximo possivel
(define weight 351533) ; peso máximo da aeronave em kg

;Boeing 777-300ER:
(define fuel-load (/ 171160 qav)) ;Capacidade em kg
(define mf (/ 9100 qav)) ;Consumo em kg/h
