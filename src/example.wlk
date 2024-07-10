class Persona{
	var property edad
	method potencia()= 20
	method inteligencia()= if(edad.between(20,40)) 12 else 8
	method esDestacado()= edad == 25 or edad == 35
	method darTributoAPlaneta(planeta){}
	method valor()= self.potencia() + self.inteligencia()
}

class Atleta inherits Persona{
	var masaMuscular = 4
	var tecnicasConocidas = 2
	override method potencia()= super() + masaMuscular * tecnicasConocidas
	override method esDestacado()= super() or tecnicasConocidas > 5
	method entrenar(dias){
		masaMuscular += dias / 5
	}
	method aprenderUnaTecnica(){
		tecnicasConocidas += 1
	}
	override method darTributoAPlaneta(planeta){
		planeta.construirMurallas(2)
	}
}

class Docente inherits Persona{
	var cursosDados = 0
	method darCurso(){
		cursosDados += 1
	}
	override method inteligencia()= super() + (2 * cursosDados)
	override method esDestacado()= cursosDados > 3
	override method darTributoAPlaneta(planeta){
		planeta.fundarMuseo()
	}
	override method valor()= super() + 5
}

class Soldado inherits Persona{
	const armas = #{}
	override method potencia()= super() + armas.map({arma => arma.potenciaQueOtorga(self)}).sum()
	override method darTributoAPlaneta(planeta){
		planeta.construirMurallas(5)
	}
}

class Planeta{
	const habitantes = #{}
	var museos
	var logMurallas
	method agregarHabitante(habitante){
		habitantes.add(habitante)
	}
	method expulsarHabitante(habitante){
		habitantes.remove(habitante)
	}
	method construirMurallas(cant){
		logMurallas += cant
	}
	method fundarMuseo(){
		museos += 1
	}
	method delegacionDiplomatica()= habitantes.filter({hab => hab.esDestacado()})
	method esCulto()= museos >= 2 and self.todosConAlmenos10DeInteligencia()
	method todosConAlmenos10DeInteligencia()= habitantes.all({hab => hab.inteligencia() >= 10})
	method potenciaReal()= habitantes.map({hab => hab.potencia()}).sum() 
	method potenciaAparente()= self.habitanteMasPotente().potencia() * self.cantidadDeHabitantes()
	method cantidadDeHabitantes()= habitantes.size()
	method habitanteMasPotente()= habitantes.max({hab => hab.potencia()})
	method necesitaReforzarse()= self.potenciaAparente() >= (self.potenciaReal() * 2)
	method recibirTributos(){
		habitantes.forEach({hab => hab.darTributoAPlaneta(self)})
	}
	method habitantesValiosos()= habitantes.filter({hab => hab.valor() >= 40})
	method apaciguar(planeta){
		self.habitantesValiosos().forEach({hab => hab.darTributoAPlaneta(planeta)})
	}
}

class Pistolete{
	const largo = 7
	method potenciaQueOtorga(soldado)= if(soldado.edad() > 30)largo * 3 else largo * 2
}

class Espadon{
	const peso
	method potenciaQueOtorga(soldado)= if(soldado.edad() < 40)peso / 2 else 6
}