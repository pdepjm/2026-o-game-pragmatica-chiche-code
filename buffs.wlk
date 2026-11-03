import wollok.game.*
import objetos.*
import efectos.*

class Inspiracion inherits ObjetoQueCae {
  override method image() = "inspiracion.png"

  override method efectoAlAgarrar(unPersonaje) {
    dorado.aplicar(unPersonaje)
  }
}

class EspejoMetabolico inherits ObjetoQueCae {
  override method image() = "espejoMetabolico.png"

  override method efectoAlAgarrar(unPersonaje) {
    espejoMetabolico.aplicar(unPersonaje)
  }
}
