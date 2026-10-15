import wollok.game.*
import personaje.*
import objetos.*
import efectos.*

class DebuffHielo inherits ObjetoQueCae {
  override method image() = "hielo.png"

  override method efectoAlAgarrar() {
    congelado.aplicar(personaje)
  }
}
