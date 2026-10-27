import wollok.game.*
import personaje.*
import objetos.*
import lanza.*
import buffs.*
import debuffs.*
import hud.*
import dificultad.*

object configuracion {
  // antes de elegir dificultad no cae nada ni corre el cronometro
  var estado = enMenu

  const generadorNormal = new GeneradorObjetos(crear = { new Comida(imagen = ["manzana.png", "banana.png"].anyOne(), puntos = 10) })
  const generadorRara = new GeneradorObjetos(crear = { new Comida(imagen = ["frutilla.png", "naranja.png"].anyOne(), puntos = 25) })
  const generadorEpica = new GeneradorObjetos(crear = { new Comida(imagen = ["sandia.png", "cereza.png"].anyOne(), puntos = 50) })
  const generadorBomba = new GeneradorObjetos(crear = { new Bomba(puntos = 25) })
  const generadorInspiracion = new GeneradorObjetos(crear = { new Inspiracion() })
  const generadorEspejo = new GeneradorObjetos(crear = { new EspejoMetabolico() })
  const generadorDebuffHielo = new GeneradorObjetos(crear = { new DebuffHielo() })
  const generadorCorazon = new GeneradorObjetos(crear = { new Corazon() })
  const generadorDebuffParasito = new GeneradorObjetos(crear = { new DebuffParasito() })

  method estado(nuevoEstado) {
    estado = nuevoEstado
  }
  
  method generadoresDeObjetos() = [
    generadorNormal, generadorRara, generadorEpica, generadorCorazon,
    generadorBomba, generadorInspiracion, generadorEspejo, generadorDebuffHielo, generadorDebuffParasito
  ]

  method generadores() = self.generadoresDeObjetos() + [generadorCajas]

  method configurarTablero() {
    game.title("Lluvia de objetos")
    game.height(14)
    game.width(10)
    game.cellSize(60)
    game.ground("celda.png")
  }

  method configurarVisuales() {
    marco.dibujar()
    game.addVisual(fondoPuntuacion)
    game.addVisual(marcador)
    game.addVisual(personaje)
    game.addVisual(healthBar)
    game.addVisual(selectorDificultad)
    game.addVisual(temporizador)
  }

  method configurarTeclado() {
    keyboard.left().onPressDo({ personaje.moverIzquierda() })
    keyboard.a().onPressDo({ personaje.moverIzquierda() })

    keyboard.right().onPressDo({ personaje.moverDerecha() })
    keyboard.d().onPressDo({ personaje.moverDerecha() })

    keyboard.space().onPressDo({ personaje.saltar() })
    keyboard.w().onPressDo({ personaje.saltar() })

    keyboard.f().onPressDo({ self.empezar(facil) })
    keyboard.j().onPressDo({ self.empezar(dificil) })
  }

  method configurarColisiones() {
    game.onCollideDo(personaje, { objeto => objeto.serAgarrado(personaje) })
  }

  method programarLanza() {
    game.schedule(dificultad.tiempoEntreLanzas(), {
      generadorLanzas.lanzarRandom()
      self.programarLanza()
    })
  }

  method empezar(unaDificultad) {
    estado.empezar(unaDificultad)
  }

  method configurarTicks() {
    game.onTick(1500, "Generar fruta normal", { estado.generar(generadorNormal) })
    game.onTick(3000, "Generar fruta rara", { estado.generar(generadorRara) })
    game.onTick(6000, "Generar fruta epica", { estado.generar(generadorEpica) })
    game.onTick(3000, "Generar bomba", { estado.generar(generadorBomba) })
    game.onTick(4000, "Generar inspiracion", { estado.generar(generadorInspiracion) })
    game.onTick(4500, "Generar espejo metabolico", { estado.generar(generadorEspejo) })
    game.onTick(4000, "Generar debuff hielo", { estado.generar(generadorDebuffHielo) })
    game.onTick(7000, "Generar Caja", { estado.generar(generadorCajas) })
    game.onTick(20000, "Generar corazon", { estado.generar(generadorCorazon) })
    game.onTick(25000, "Generar debuff parasito", { estado.generar(generadorDebuffParasito) })

    game.onTick(600, "caida", {
      self.generadores().forEach({ generador => generador.actualizar() })
      // por si desaparecio la caja en la que estaba parado
      personaje.caer()
    })

    game.onTick(1000, "cronometro", { estado.avanzarCronometro() })
  }
}

object enMenu {
  method empezar(unaDificultad) {
    dificultad.elegir(unaDificultad)
    game.removeVisual(selectorDificultad)
    configuracion.programarLanza()
    game.onTick(30000, "acelerar lanzas", { dificultad.acelerar() })
    configuracion.estado(jugando)
  }

  method generar(generador) { }
  method avanzarCronometro() { }
}

object jugando {
  // ya se eligio dificultad: apretar f o j no hace nada
  method empezar(unaDificultad) { }

  method generar(generador) {
    generador.generar()
  }

  method avanzarCronometro() {
    temporizador.avanzar()
  }
}
