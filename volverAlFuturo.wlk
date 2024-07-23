import personajes.*

class ExceptionSinElementos inherits Exception {}
 
object deLorean{
 	var property combustible = nafta
 	const pasajeros = [] 

 	method subirPasajero(pasajero){
 		pasajeros.add(pasajero)
 	}
 	method bajarPasajero(pasajero){
 		pasajeros.remove(pasajero)
 	}
 	method viajarA(unDestino,unaFecha){
 		pasajeros.forEach{pasajero => combustible.efecto(pasajero)}
 	}
 	method huboUnProblemaCon(unPersonaje,unaFecha){
 		pasajeros.forEach{pasajero => pasajero.problemaCon(unPersonaje,unaFecha)}
 	}
 }
 

object radiactividad {
 	method efecto(persona){
 		persona.cambiarAltura(-1)
 	}
 }
 
object nafta{
 	method efecto(persona){
 		persona.cambiarEdad( if(persona.esMayor()) -10 else 5)
 	}
 }
 
object electricidad{
 	method efecto(persona){
 		if(persona.noTieneElementos()) 
 			throw new ExceptionSinElementos()
 		persona.perderLoMasAntiguo()
 	}
 }
 
object basura{
 	method efecto(persona){
 		// no hace nada
 	}
 }

 import deLorean.*

class Personaje {
	var property edad
	var property altura
	var property apellido
	const elementos = []
	
	method esMayor() = edad > 50
	
	method tiene(elemento) = elementos.contains(elemento)
	
	method tieneElementoPropio() = elementos.any({ e => e.esDe(self) })
	
	method cambiarAltura(cant) {
		altura += cant
	}
	
	method cambiarEdad(cant) {
		edad += cant
	}
	
	method elementoMasAntiguo() = elementos.min({ e => e.fecha() })
	
	method perderLoMasAntiguo() {
		elementos.remove({ self.elementoMasAntiguo() })
	}
	
	method noTieneElementos() = elementos.isEmpty()
	
	method esAntepesadoDe(
		alguien
	) = (apellido == alguien.apellido()) && alguien.esMayor()
	
	method problemaCon(unPersonaje, unaFecha) {
		elementos.filter({ e => e.esMasReciente(unaFecha) }).forEach(
			{ e => e.problemaCon(unPersonaje) }
		)
	}
}

class Destino {
	const personajes = []
	
	method antepasadosDe(unPersonaje) = personajes.filter(
		{ personaje => personaje.esAntepesadoDe(unPersonaje) }
	)
}

class Elemento {
	var descripcion
	var property fecha
	
	method esDe(alguien) = false
	
	method esMasReciente(unaFecha) = fecha < unaFecha
	
	method problemaCon(alguien) {
		descripcion = "BTTF " + descripcion
	}
}

class Documentacion inherits Elemento {
	const personajes
	
	override method esDe(alguien) = personajes.contains(alguien)
	
	override method problemaCon(alguien) {
		super(alguien)
		if (self.esDe(alguien)) personajes.remove(alguien)
	}
}

class Especial inherits Elemento {
	const duenio
	
	override method esDe(alguien) = duenio == alguien
}
