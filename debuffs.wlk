import wollok.game.*
import personaje.*
import objetos.*
import efectos.*

class DebuffHielo {
  var posicion = game.at(6, 11)
  var activa = true

 method estaActiva() = activa

method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = "hielo.png"

  method caer() {
    if (activa) {
      if (posicion.y() == 0) {
        self.desaparecer()
      } else if (not generadorCajas.hayCajaEn(posicion.down(1))) {
        posicion = posicion.down(1)
      }
    }
  }

  method serAgarrado() {
    if (activa) {
      congelado.aplicar(personaje)
      self.desaparecer()
    }
  }

   method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
  

}
