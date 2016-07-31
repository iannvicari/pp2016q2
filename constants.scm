;;; Constantes fisicas

(define p-SL 1.225) ; Kg/m^3 => Pressao do ar no nivel do mar
(define R-air 287.05) ; J/(Kg*K) => Constante de gases para o ar
(define Temperature 288.15) ; Kelvin => Temperatura constante
(define qav 0.813) ; QAV => densidade da querosene de aviação


;;; Constantes geográficas
(define max-latitude 90.0);
(define min-latitude -90.0);
(define max-longitude 180.0);
(define min-longitude -180.0);


;;; Constantes da Aeronave
; Modelo da aeronave: Boeing 777

(define drag-coeff 0.026) ; Coeficiente de arrasto
(define wing-area 427.8) ; m^2 => Area das asas
(define Tmax-SL 830000) ; N => Empuxo Maximo possivel
(define mass 351533) ; massa máxima da aeronave em kg
(define max-altitude 13.14); Km

;Boeing 777-300ER:
(define fuel-load (/ 171160 qav)) ;Capacidade em kg
(define mf (/ 9100 qav)) ;Consumo em kg/h
