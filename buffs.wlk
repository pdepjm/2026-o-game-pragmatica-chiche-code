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

class EspejoMetabolico inherits ObjetoQueCae {
  override method image() = "espejoMetabolico.png"

  override method efectoAlAgarrar() {
    espejoMetabolico.aplicar(personaje)
  }
}
