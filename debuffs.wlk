import wollok.game.*
import objetos.*
import efectos.*

class DebuffHielo inherits ObjetoQueCae {
  override method image() = "hielo.png"

  override method efectoAlAgarrar(unPersonaje) {
    congelado.aplicar(unPersonaje)
  }
}

class DebuffParasito inherits ObjetoQueCae {
  override method image() = "parasito.png"

  override method efectoAlAgarrar(unPersonaje) {
    infectado.aplicar(unPersonaje)
  }
}
