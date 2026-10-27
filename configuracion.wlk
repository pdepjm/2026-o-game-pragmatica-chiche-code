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

  const generadores = [
    new GeneradorObjetos(frecuencia = 1500, crear = { new Comida(imagen = ["manzana.png", "banana.png"].anyOne(), puntos = 10) }),
    new GeneradorObjetos(frecuencia = 3000, crear = { new Comida(imagen = ["frutilla.png", "naranja.png"].anyOne(), puntos = 25) }),
    new GeneradorObjetos(frecuencia = 6000, crear = { new Comida(imagen = ["sandia.png", "cereza.png"].anyOne(), puntos = 50) }),
    new GeneradorObjetos(frecuencia = 3000, crear = { new Bomba(puntos = 25) }),
    new GeneradorObjetos(frecuencia = 4000, crear = { new Inspiracion() }),
    new GeneradorObjetos(frecuencia = 4500, crear = { new EspejoMetabolico() }),
    new GeneradorObjetos(frecuencia = 4000, crear = { new DebuffHielo() }),
    new GeneradorObjetos(frecuencia = 20000, crear = { new Corazon() }),
    new GeneradorObjetos(frecuencia = 25000, crear = { new DebuffParasito() }),
    generadorCajas
  ]

  method estado(nuevoEstado) {
    estado = nuevoEstado
  }

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
    generadores.forEach({ generador =>
      game.onTick(generador.frecuencia(), "generar objetos", { estado.generar(generador) })
    })

    game.onTick(600, "caida", {
      generadores.forEach({ generador => generador.actualizar() })
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
