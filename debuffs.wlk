import wollok.game.*
import personaje.*

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
      if (posicion.y() > 0) {
        posicion = posicion.down(1)
      } else {
        self.desaparecer()
      }
    }
  }

  method serAgarrado() {
    if (activa) {
      personaje.congelar() 
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
