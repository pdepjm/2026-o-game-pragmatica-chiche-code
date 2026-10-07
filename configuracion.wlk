import wollok.game.*
import personaje.*
import objetos.*
import lanza.*
import buffs.*
import debuffs.*
import hud.*
import dificultad.*

object configuracion {
  const generadorManzana = new GeneradorObjetos(crear = { new Comida(imagen = "manzana.png", puntos = 10) })
  const generadorBanana = new GeneradorObjetos(crear = { new Comida(imagen = "banana.png", puntos = 10) })
  const generadorCereza = new GeneradorObjetos(crear = { new Comida(imagen = "cereza.png", puntos = 25) })
  const generadorFrutilla = new GeneradorObjetos(crear = { new Comida(imagen = "frutilla.png", puntos = 25) })
  const generadorNaranja = new GeneradorObjetos(crear = { new Comida(imagen = "naranja.png", puntos = 25) })
  const generadorSandia = new GeneradorObjetos(crear = { new Comida(imagen = "sandia.png", puntos = 50) })
  const generadorBomba = new GeneradorObjetos(crear = { new Bomba() })
  const generadorInspiracion = new GeneradorObjetos(crear = { new Inspiracion() })
  const generadorDebuffHielo = new GeneradorObjetos(crear = { new DebuffHielo() })

  method generadoresDeObjetos() = [
    generadorManzana, generadorBanana, generadorCereza,
    generadorFrutilla, generadorNaranja, generadorSandia,
    generadorBomba, generadorInspiracion, generadorDebuffHielo
  ]
  
  method generadores() =  self.generadoresDeObjetos() + [generadorCajas]


  method configurarTablero() {
    game.title("Lluvia de objetos")
    game.height(13)
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
    game.onCollideDo(personaje, { objeto => objeto.serAgarrado() })
  }

  method empezar(unaDificultad) {
    if (not dificultad.empezado()) {
      dificultad.elegir(unaDificultad)
      game.removeVisual(selectorDificultad)
    }
  }

  method spawnear(generador) {
    if (dificultad.empezado()) {
      generador.generar()
    }
  }

  method configurarTicks() {
    game.onTick(2500, "Generar manzana", { self.spawnear(generadorManzana) })
    game.onTick(2800, "Generar banana", { self.spawnear(generadorBanana) })
    game.onTick(4500, "Generar cereza", { self.spawnear(generadorCereza) })
    game.onTick(4800, "Generar frutilla", { self.spawnear(generadorFrutilla) })
    game.onTick(5200, "Generar naranja", { self.spawnear(generadorNaranja) })
    game.onTick(9000, "Generar sandia", { self.spawnear(generadorSandia) })
    game.onTick(2500, "Generar bomba", { self.spawnear(generadorBomba) })
    game.onTick(4000, "Generar inspiracion", { self.spawnear(generadorInspiracion) })
    game.onTick(3500, "Generar debuff hielo", { self.spawnear(generadorDebuffHielo) })
    game.onTick(7000, "Generar Caja", { self.spawnear(generadorCajas) })

    game.onTick(600, "caida", {
      self.generadores().forEach({ generador => generador.actualizar() })
      // por si desaparecio la caja en la que estaba parado
      personaje.caer()
    })

    game.onTick(7000, "crear lanza", { if (dificultad.empezado()) generadorLanzas.lanzarRandom() })
  }
}
