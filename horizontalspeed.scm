	(load "constants.scm")
	;função irá rodar a cada 1 segundo
	;old_latitude, latitide da ultima medida
	;latitude, latitude atual
	;old_longitude da ultima medida
	;longitude atual
	;max-latitudes, latitude máxima(90.0000000)
	;min-latitudes, latitude mínima(-90.0000000)
	;max-longitude, longitude máxima(180.000000)
	;min-longitude, longitude mínima(-180.000000)
	;1° latitude = 111,12 Km
	;1° longitude = é de 111,12 km vezes o cosseno da latitude
	
		(define horizontal-speed
			(lambda (latitude, longitude)
			(if (and (< latitude  max-latitude) (> latitude min-latitude ))
			(if (and (< longitude  max-longitude) (> longitude min-longitude))
			(sqrt (+(exp (* 111,12 (- old_latitude latitude))2)(exp(*(- old_longitude longitude)(* 111.12 (cos latitude)))2)))
			))))
