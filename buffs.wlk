import wollok.game.*
import personaje.*
import objetos.*
import efectos.*

class Inspiracion inherits ObjetoQueCae {
  override method image() = "inspiracion.png"

  override method efectoAlAgarrar() {
    dorado.aplicar(personaje)
  }
}
