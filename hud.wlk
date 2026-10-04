import wollok.game.*
import personaje.*

object gameOver {
  method position() = game.at(2, 3)
  method image() = "gameOver.png"
}

object fondoPuntuacion {
  method position() = game.at(8, marco.fila())
  method image() = "puntuacion.png"
}

object marcador {
  var puntos = 0
  method position() = game.at(9, marco.fila())
  method text() = puntos.toString()
  method textColor() = "FFD700"
  method ganarPuntos(cantidad) {
    puntos = (puntos + cantidad).max(0)
  }
  method reiniciar() {
    puntos = 0
  }
}

class CeldaMarco {
  const property position
  method image() = "celda2.png"
}

object marco {
  method fila() = 12

  method dibujar() {
    (0 .. 9).forEach({ x =>
      game.addVisual(new CeldaMarco(position = game.at(x, self.fila())))
    })
  }
}

object healthBar {

  var imagen = "vida/vida10.png"

  method position() = game.at(0, marco.fila())

  method image() = imagen

  method actualizar() {
    imagen = "vida/vida" + personaje.vida() + ".png"
  }
}
