	(load "constants.scm")
	;função irá rodar a cada 1 segundo
	;retorna o grau e direção
	;old_latitude, latitide da ultima medida
	;latitude, latitude atual
	;old_longitude da ultima medida
	;longitude atual
	;max-latitude, latitude máxima(90.000)
	;min-latitude, latitude mínima(-90.000)        
	;max-longitude, longitude máxima(180.000)		
	;min-longitude, longitude mínima(-180.000)

	
		(define guidance
			(lambda (latitude, longitude)
			(let guidance_i ((latitude latitude)(longitude longitude))
			(if (and (< latitude  max-latitude) (> latitude min-latitude ))
			(if (and (< longitude  max-longitude) (> longitude min-longitude))
			
			(if (and (> longitude 0)(> latitude 0))
			(cons  ('NE'  (arctg (/ longitude latitude)) ))
			(if (and (> longitude 0)(< latitude 0))
			(cons  ('SE'  (+(arctg (/ longitude latitude))90.0))   )
			(if (and (< longitude 0)(> latitude 0))
			(cons  ('NO'  (arctg (/ longitude latitude))   )  )
			(if (and (< longitude 0)(< latitude 0))
			(cons  ('SO'  (+(arctg (/ longitude latitude))90.0)   )  )
			(if (and (> longitude 0)(= latitude 0))
			(cons  ('E'  90 ) )
			(if (and (= longitude 0)(> latitude 0))
			(cons  ('N'  0 ) )
			(if (and (< longitude 0)(= latitude 0))
			(cons  ('O' -90.0 )  )
			(if (and (= longitude 0)(< latitude 0))
			(cons  ('S' 180.0 )   ))))))))))))))
