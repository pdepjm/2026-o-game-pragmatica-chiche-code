import wollok.game.*
import hud.*
import dificultad.*

class GeneradorObjetos {
  var listaObjetos = []
  const crear

  method generar() {
    const libres = self.posicionesLibres()
    if (not libres.isEmpty()) {
      const objeto = crear.apply()
      objeto.posicion(libres.anyOne())
      listaObjetos.add(objeto)
      game.addVisual(objeto)
    }
  }

  method posicionesLibres() = (0 .. game.width() - 1)
    .map({ x => game.at(x, marco.fila() - 2) })
    .filter({ pos => game.getObjectsIn(pos).isEmpty() })

  method actualizar() {
    listaObjetos.forEach({ objeto => objeto.caer() })
    listaObjetos = listaObjetos.filter({ objeto => objeto.estaActiva() })
  }
}

class ObjetoQueCae {
  var posicion = game.at(0, 11)
  var activa = true

  method image()
  method efectoAlAgarrar(unPersonaje)

  method estaActiva() = activa

  method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion

  method caer() {
    if (activa) {
      if (posicion.y() == 0) {
        self.desaparecer()
      } else if (not generadorCajas.hayCajaEn(posicion.down(1))) {
        posicion = posicion.down(1)
      }
    }
  }

  method serAgarrado(unPersonaje) {
    if (activa) {
      self.desaparecer()
      self.efectoAlAgarrar(unPersonaje)
    }
  }

  method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }

  method lastimar(unPersonaje) {
    dificultad.penalizar(-50)
    unPersonaje.recibirDanio(2)
  }
}

class Comida inherits ObjetoQueCae {
  const imagen
  const puntos

  override method image() = imagen

  override method efectoAlAgarrar(unPersonaje){
    if (unPersonaje.tieneEspejo()) {
      self.lastimar(unPersonaje)
    } else {
      marcador.ganarPuntos(puntos * unPersonaje.multiplicador())
    }
    unPersonaje.comioComida()
  }
}

class Corazon inherits ObjetoQueCae {
  override method image() = "corazon.png"

  override method efectoAlAgarrar(unPersonaje) {
    unPersonaje.curar(1)
  }
}

class Bomba inherits ObjetoQueCae {
  const puntos 

  override method image() = "bomba.png"

  override method efectoAlAgarrar(unPersonaje) {
    if (unPersonaje.tieneEspejo()) {
      marcador.ganarPuntos( puntos * unPersonaje.multiplicador())
    } else {
      self.lastimar(unPersonaje)
    }
  }
}

object generadorCajas inherits GeneradorObjetos(crear = { new Caja() }) {
  method hayCajaEn(posicion) = listaObjetos.any({ caja => caja.position() == posicion })
}

class Caja inherits ObjetoQueCae {
  var ticksRestantes = 7

  override method image() = "caja.png"

  override method efectoAlAgarrar(unPersonaje) {
    unPersonaje.recibirDanio(2)
  }

  method estaEnElPiso() = posicion.y() == 0
  method puedeBajar() = not self.estaEnElPiso() and not generadorCajas.hayCajaEn(posicion.down(1))

  // la cuenta solo corre en el piso: una caja apilada espera sin descontar
  override method caer() {
    if (self.puedeBajar()) {
      posicion = posicion.down(1)
    } else if (self.estaEnElPiso()) {
      self.descontarTick()
    }
  }

  method descontarTick() {
    if (ticksRestantes != 0) {
      ticksRestantes -= 1
    } else {
      self.desaparecer()
    }
  }

  // le cayo encima al personaje: lo lastima y lo corre a un costado. Si no hay lugar, la caja se rompe
  override method serAgarrado(unPersonaje) {
    self.efectoAlAgarrar(unPersonaje)

    if (unPersonaje.tieneCostadoLibre()) {
      unPersonaje.serEmpujado()
    } else {
      self.desaparecer()
    }
  }
}
