import wollok.game.*
import personaje.*
import objetos.*
import lanza.*
import buffs.*
import debuffs.*
import hud.*
import dificultad.*

object configuracion {
  const generadorNormal = new GeneradorObjetos(crear = { new Comida(imagen = ["manzana.png", "banana.png"].anyOne(), puntos = 10) })
  const generadorRara = new GeneradorObjetos(crear = { new Comida(imagen = ["frutilla.png", "naranja.png"].anyOne(), puntos = 25) })
  const generadorEpica = new GeneradorObjetos(crear = { new Comida(imagen = ["sandia.png", "cereza.png"].anyOne(), puntos = 50) })
  const generadorBomba = new GeneradorObjetos(crear = { new Bomba() })
  const generadorInspiracion = new GeneradorObjetos(crear = { new Inspiracion() })
  const generadorDebuffHielo = new GeneradorObjetos(crear = { new DebuffHielo() })
  const generadorCorazon = new GeneradorObjetos(crear = { new Corazon() })
   
   method generadoresDeObjetos() = [
    generadorNormal, generadorRara, generadorEpica, generadorCorazon,
    generadorBomba, generadorInspiracion, generadorDebuffHielo
  ]
  method generadores() =  self.generadoresDeObjetos() + [generadorCajas]


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
    game.onCollideDo(personaje, { objeto => objeto.serAgarrado() })
  }
method programarLanza() {
    game.schedule(dificultad.tiempoEntreLanzas(), {
      generadorLanzas.lanzarRandom()
      self.programarLanza()
    })
  }
 method empezar(unaDificultad) {
    if (not dificultad.empezado()) {
      dificultad.elegir(unaDificultad)
      game.removeVisual(selectorDificultad)
      self.programarLanza()
    }
  }

  method spawnear(generador) {
    if (dificultad.empezado()) {
      generador.generar()
    }
  }

  method configurarTicks() {
    game.onTick(2500, "Generar fruta normal", { self.spawnear(generadorNormal) })
    game.onTick(5000, "Generar fruta rara", { self.spawnear(generadorRara) })
    game.onTick(9000, "Generar fruta epica", { self.spawnear(generadorEpica) })
    game.onTick(2500, "Generar bomba", { self.spawnear(generadorBomba) })
    game.onTick(4000, "Generar inspiracion", { self.spawnear(generadorInspiracion) })
    game.onTick(3500, "Generar debuff hielo", { self.spawnear(generadorDebuffHielo) })
    game.onTick(7000, "Generar Caja", { self.spawnear(generadorCajas) })
    game.onTick(20000, "Generar corazon", { self.spawnear(generadorCorazon) })
    game.onTick(600, "caida", {
      self.generadores().forEach({ generador => generador.actualizar() })
      // por si desaparecio la caja en la que estaba parado
      personaje.caer()
    })
    game.onTick(1000, "cronometro", { if (dificultad.empezado()) temporizador.avanzar() })
    game.onTick(30000, "acelerar lanzas", { if (dificultad.empezado()) dificultad.acelerar() })  }
}
