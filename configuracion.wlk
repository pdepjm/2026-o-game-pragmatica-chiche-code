import wollok.game.*
import personaje.*
import objetos.*
import lanza.*
import buffs.*
import debuffs.*
import hud.*

object configuracion {
  const generadorComida = new GeneradorObjetos(crear = { new Comida() })
  const generadorBomba = new GeneradorObjetos(crear = { new Bomba() })
  const generadorInspiracion = new GeneradorObjetos(crear = { new Inspiracion() })
  const generadorDebuffHielo = new GeneradorObjetos(crear = { new DebuffHielo() })

  method generadores() = [generadorComida, generadorBomba, generadorInspiracion, generadorDebuffHielo]

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
  }

  method configurarTeclado() {
    keyboard.left().onPressDo({ personaje.moverIzquierda() })
    keyboard.a().onPressDo({ personaje.moverIzquierda() })

    keyboard.right().onPressDo({ personaje.moverDerecha() })
    keyboard.d().onPressDo({ personaje.moverDerecha() })

    keyboard.space().onPressDo({ personaje.saltar() })
    keyboard.w().onPressDo({ personaje.saltar() })
  }

  method configurarColisiones() {
    game.onCollideDo(personaje, { objeto => objeto.serAgarrado() })
  }

  method configurarTicks() {
    game.onTick(1600, "Generar comida", { generadorComida.generar() })
    game.onTick(2500, "Generar bomba", { generadorBomba.generar() })
    game.onTick(4000, "Generar inspiracion", { generadorInspiracion.generar() })
    game.onTick(3500, "Generar debuff hielo", { generadorDebuffHielo.generar() })

    game.onTick(600, "caida", {
      self.generadores().forEach({ generador => generador.actualizar() })
    })

    game.onTick(7000, "crear lanza", { generadorLanzas.lanzarRandom() })
  }
}
