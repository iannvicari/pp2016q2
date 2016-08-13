(module constants

	(import chicken scheme)

	;;; Constantes fisicas
	(define P-SL 1.225) ; Kg/m^3 => Pressao do ar no nivel do mar
	(define R-AIR 287.05) ; J/(Kg*K) => Constante de gases para o ar
	(define TEMPERATURE 288.15) ; Kelvin => Temperatura constante
	(define QAV 0.813) ; QAV => densidade da querosene de aviação


	;;; Constantes geográficas (em graus)
	(define MAX-LATITUDE 90.0);
	(define MIN-LATITUDE -90.0);
	(define MAX-LONGITUDE 180.0);
	(define MIN-LONGITUDE -180.0);


	;;; Constantes da Aeronave
	;;; Modelo: Boeing 777-300ER
	(define DRAG-COEFF 0.026) ; sem unidade => Coeficiente de arrasto
	(define WING-AREA 427.8) ; m^2 => Area das asas
	(define TMAX-SL 830000) ; N => Empuxo Maximo possivel
	(define MASS 351533) ; Kg => Massa máxima da aeronave
	(define MAX-ALTITUDE 13.14); Km => Altitude maxima suportada
	(define FUEL-LOAD (/ 171160 QAV)) ; Kg => Capacidade maxima de combustivel
	(define MF (/ 9100 QAV)) ; Kg/hora => Consumo de combustivel por hora
)
