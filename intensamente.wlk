class Emocion{
	var property intensidad
	const property color
	method puedeLiberarse()= intensidad >= valorComun.valor()
	method expresar(){
		if(self.puedeLiberarse()){
			intensidad -= self.cantAdicional()
		}
	}
	method cantAdicional()= 0 
	method efecto(evento)
}

object valorComun{
	var property valor = 75	
}

class Furia inherits Emocion{
	const palabrotas = #{}
	method agregarPalabrota(palabra){
		palabrotas.add(palabra)
	}
	method quitarPalabrota(palabra){
		palabrotas.remove(palabra)
	}
	override method puedeLiberarse()= super() and palabrotas.any({p => p.size() > 7})
	override method cantAdicional()= self.mayorPalabrota().length()
	method mayorPalabrota()= palabrotas.max({p => p.length()})
	override method efecto(evento){
		intensidad += (evento.nivelImpacto() * 2)
	}
}

class Alegria inherits Emocion{
	var acontPositivos = 0
	method aumentarAcontPos(cant){
		acontPositivos += cant.min(100)
	}
	override method puedeLiberarse()= super() or acontPositivos.even()
	override method cantAdicional()= intensidad * (acontPositivos / 100)
	override method efecto(evento){
		intensidad += evento.nivelImpacto()
		self.aumentarAcontPos(1)
	}
}

class Tristeza inherits Emocion{
	var property esLlorona
	var property melancolica
	override method puedeLiberarse()= melancolica or esLlorona
	override method cantAdicional()= if(color == "azul") 10 else 5
	override method efecto(evento){
		intensidad += (evento.nivelImpacto() / 2)
		esLlorona = true
		melancolica = true
	}
}

class Individuo{
	const edad
	const emociones = #{}
	const property eventos = #{}
	method esAdolescente()= edad.between(12,19)
	method explotaEmocionalmente()= emociones.all({emo => emo.puedeLiberarse()})
	method deltaEmocional()= self.emoMaxIntensidad().intensidad() - self.emoMinIntensidad().intensidad()
	method emoMaxIntensidad()= emociones.max({emo => emo.intensidad()})
	method emoMinIntensidad()= emociones.min({emo => emo.intensidad()})
	method mapaCromatico()= emociones.map({emo => emo.color()}).asSet() 
	method energiaEmocional()= self.emoPromedio().map({emo => emo.intensidad()}).sum()
	method emoPromedio()= emociones.filter({emo => emo.intensidad().between(50,75)})
	method expresarEmociones(){
		emociones.forEach({emo => emo.expresar()})
	}
	method registrarEvento(evento){
		eventos.add(evento)
	}
	method procesarEvento(evento){
		evento.colorEmocional().asSet().intersection(emociones).forEach({emo => emo.efecto(evento)})
		eventos.clear()
	}
}

class Eventos{
	const property  nombre
	const property colorEmocional
	const property nivelImpacto
	const property individuos = #{}
	method transferirA(individuo){
		if(individuos.contains(individuo)){
			self.error("el evento ya fue transferido")
		}else{
			individuos.add(individuo)
			individuo.registrarEvento(self)
	    }
	}
}

/*De cada Evento nos interesa registrar el nombre, el color emocional asociado al evento y el nivel de impacto que produce.

Los eventos deben contar con la posibilidad de transeferirse a un individuo transferirA(unIndividuo), y a su vez el individuo deberá registrar que evento le fue transferido. Pero atención, antes de realizar cualquier acción se debe controlar si ya fue transferido o no. Y si ya fue transferido previamente deberá informarse el error "El evento ya fue transferido al individuo".

Además, los individuos deberán contar con la posibilidad de procesar todos los eventos que tiene registrados y quedar sin eventos al final del proceso.

La acción de procesar un evento por un individuo es tomar solo aquellas emociones cuyo color coincida con el color emocional el evento y producirles un efecto efecto(unEvento)que varia por cada emoción.

Furia aumenta su intensidad en un 50% más del valor del impacto del evento.
Alegría aumenta su intensidad en el mismo valor que el nivel del impacto del evento, y también aumenta en uno el registro de acontecimientos positivos.
Tristeza aumenta su intensidad en solo la mitad del nivel del impacto del evento, y pasa a ser melancólica y llorona.*/
