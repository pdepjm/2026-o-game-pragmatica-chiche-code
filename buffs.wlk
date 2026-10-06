import wollok.game.*
import personaje.*
import objetos.*
import efectos.*

class Inspiracion {
  var posicion = game.at(3, 11)
  var activa = true

 method estaActiva() = activa

method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = "inspiracion.png"
    
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
      dorado.aplicar(personaje)
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
