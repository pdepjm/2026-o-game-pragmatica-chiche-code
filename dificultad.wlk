import wollok.game.*
import hud.*

object facil {
  method penalizar(puntos) { }
  method tiempoLanza() = 600          // velocidad de movimiento (fija)
  method tiempoEntreLanzas() = 7000   // cada cuanto sale una (fija)
  method acelerar() { }               // en facil no se acelera
}

object dificil {
  var tiempoLanza = 250
  var tiempoEntreLanzas = 5000

  method penalizar(puntos) {
    marcador.ganarPuntos(puntos)
  }

  method tiempoLanza() = tiempoLanza
  method tiempoEntreLanzas() = tiempoEntreLanzas

  method acelerar() {
    tiempoLanza = (tiempoLanza - 30).max(100)              // mas rapido, piso 100
    tiempoEntreLanzas = (tiempoEntreLanzas - 500).max(2000) // mas seguido, piso 2000
  }
}

object dificultad {
  var actual = facil

  method elegir(unaDificultad) {
    actual = unaDificultad
  }

  method penalizar(puntos) { actual.penalizar(puntos) }
  method tiempoLanza() = actual.tiempoLanza()
  method tiempoEntreLanzas() = actual.tiempoEntreLanzas()
  method acelerar() { actual.acelerar() }
}

object selectorDificultad {
  method position() = game.at(0, 4)
  method image() = "selector.png"
}