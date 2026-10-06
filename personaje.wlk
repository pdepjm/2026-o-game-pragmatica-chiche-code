import wollok.game.*
import hud.*
import efectos.*

object personaje {
  var posicion = game.at(4,0)
  var saltando = false
  // puede haber efectos repetidos: cada uno se saca con su propio timer
  const efectosActivos = []

  const vidaMaxima = 10
  var vidaActual = 10

  method position() = posicion
  method image() =
    if (efectosActivos.isEmpty()) "personaje/personaje.png"
    else efectosActivos.min({ efecto => efecto.prioridad() }).image()
  method vida() = vidaActual

  method puedeMoverse() = efectosActivos.all({ efecto => efecto.permiteMoverse() })
  method multiplicador() =
    if (efectosActivos.isEmpty()) 1
    else efectosActivos.max({ efecto => efecto.multiplicador() }).multiplicador()

  method agregarEfecto(efecto) {
    efectosActivos.add(efecto)
  }

  method quitarEfecto(efecto) {
    efectosActivos.remove(efecto)
  }

  method moverIzquierda() {
    if (posicion.x() > 0 and self.puedeMoverse()) {
      posicion = posicion.left(1)
    }
  }

  method moverDerecha() {
    if (posicion.x() < game.width()-1 and self.puedeMoverse()) {
      posicion = posicion.right(1)
    }
  }

  method saltar() {
    if (not saltando and self.puedeMoverse()) {
      saltando = true
      posicion = posicion.up(1)
      game.schedule(400, {
        posicion = posicion.down(1)
        saltando = false
      })
    }
  }

  method recibirDanio(danio) {
    vidaActual = vidaActual - danio
    if (vidaActual < 0) {
      vidaActual = 0
    }

    lastimado.aplicar(self)

    healthBar.actualizar()

    if (vidaActual == 0) {
      self.gameOver()
    }
  }

  method gameOver() {
    game.addVisual(gameOver)

    game.stop()
  }

  method curar(cantidad) {
    vidaActual = vidaActual + cantidad
    if (vidaActual > vidaMaxima) {
      vidaActual = vidaMaxima
    }

    healthBar.actualizar()
  }

}
