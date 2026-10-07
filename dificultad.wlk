import wollok.game.*
import hud.*

object facil {
  method penalizar(puntos) { }            // en facil no perdes puntos
  method tiempoLanza() = 600              // lanza lenta
}

object dificil {
  method penalizar(puntos) {
    marcador.ganarPuntos(puntos)          // en dificil si perdes puntos
  }
  method tiempoLanza() = 250              // lanza rapida
}

object dificultad {
  var actual = facil
  var empezado = false

  method elegir(unaDificultad) {
    actual = unaDificultad
    empezado = true
  }

  method empezado() = empezado

  // delegadores: el resto del juego le habla a 'dificultad', no a facil/dificil
  method penalizar(puntos) { actual.penalizar(puntos) }
  method tiempoLanza() = actual.tiempoLanza()
}

object selectorDificultad {
  method position() = game.at(0, 4)
  method image() = "selector.png"
}