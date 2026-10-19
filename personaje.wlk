import objetos.*
import wollok.game.*
import hud.*
import efectos.*

object personaje {
  var posicion = game.at(4,0)
  var saltando = false
  var cayendo = false
  var tieneParasito = false
  var comidasConParasito = 0
  // cuanto tarda en bajar cada celda cuando cae
  const tiempoCaida = 300
  // puede haber efectos repetidos: cada uno se saca con su propio timer
  const efectosActivos = []
  

  const vidaMaxima = 8
  var vidaActual = 8

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

  // una celda esta libre si queda dentro del tablero y no tiene una caja
  method estaLibre(celda) = celda.x().between(0, game.width() - 1) and not generadorCajas.hayCajaEn(celda)

  method moverIzquierda() {
    self.moverA(posicion.left(1))
  }

  method moverDerecha() {
    self.moverA(posicion.right(1))
  }

  method moverA(celda) {
    if (self.puedeMoverse() and self.estaLibre(celda)) {
      posicion = celda
      self.caer()
    }
  }

  method puedeSaltar() =
    not saltando and self.estaApoyado() and self.puedeMoverse() and posicion.y() < marco.fila() - 2 and self.estaLibre(posicion.up(1))

  method saltar() {
    if (self.puedeSaltar()) {
      saltando = true
      posicion = posicion.up(1)
      game.schedule(400, {
        saltando = false
        self.bajarUnaCelda()
      })
    }
  }

  method estaApoyado() = posicion.y() == 0 or generadorCajas.hayCajaEn(posicion.down(1))

  // si quedo en el aire empieza a caer de a una celda, hasta apoyarse en el piso o en una caja.
  // En medio de un salto no cae: de eso se encarga el timer del salto
  method caer() {
    if (not saltando and not cayendo and not self.estaApoyado()) {
      cayendo = true
      game.schedule(tiempoCaida, { self.bajarUnaCelda() })
    }
  }

  method bajarUnaCelda() {
    cayendo = false
    if (not saltando and not self.estaApoyado()) {
      posicion = posicion.down(1)
    }
    self.caer()
  }

  method costadosLibres() = [posicion.left(1), posicion.right(1)].filter({ celda => self.estaLibre(celda) })
  method tieneCostadoLibre() = not self.costadosLibres().isEmpty()

  method serEmpujado() {
    posicion = self.costadosLibres().anyOne()
    self.caer()
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

  method tieneEspejo() = efectosActivos.contains(espejoMetabolico)

  method tieneParasito() = tieneParasito

  method infectarParasito() {
    tieneParasito = true
    comidasConParasito = 0
  }

  method comioManzanaParasito() {
    if(tieneParasito) {
      comidasConParasito += 1
      if(comidasConParasito >= 5) {
        self.explotarParasito()
      }
    }
  }
  method explotarParasito() {
    tieneParasito = false
    comidasConParasito = 0
    self.recibirDanio(5)
  }

  method curarParasito() {
  tieneParasito = false
  comidasConParasito = 0
}
}
