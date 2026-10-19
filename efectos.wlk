import wollok.game.*

class Efecto {
  method prioridad()
  method image()

  // lo normal es que un efecto no frene al personaje ni cambie los puntos
  method permiteMoverse() = true
  method multiplicador() = 1

  method aplicar(unPersonaje) {
    unPersonaje.agregarEfecto(self)
  }
}

// los que se sacan solos despues de un tiempo
class EfectoTemporal inherits Efecto {
  method duracion()

  override method aplicar(unPersonaje) {
    super(unPersonaje)
    game.schedule(self.duracion(), { unPersonaje.quitarEfecto(self) })
  }
}

object lastimado inherits EfectoTemporal {
  // 1 es la prioridad mas alta
  override method prioridad() = 1
  override method image() = "personaje/personaje_lastimado.png"
  override method duracion() = 1000
}

object congelado inherits EfectoTemporal {
  override method prioridad() = 2
  override method image() = "personaje/personaje_congelado.png"
  override method duracion() = 3000
  override method permiteMoverse() = false
}

object dorado inherits EfectoTemporal {
  override method prioridad() = 4
  override method image() = "personaje/personaje_dorado.png"
  override method duracion() = 5000
  override method multiplicador() = 2
}

object espejoMetabolico inherits EfectoTemporal {
  override method prioridad() = 3
  override method image() = "personaje/personaje_espejo.png"
  override method duracion() = 5000
}

// no se va con un timer: lo saca una lanza o explota despues de 5 comidas
object infectado inherits Efecto {
  var comidas = 0

  override method prioridad() = 5
  override method image() = "personaje/personaje_infectado.png"

  override method aplicar(unPersonaje) {
    // si ya estaba infectado no pasa nada: la cuenta sigue
    if (not unPersonaje.tieneParasito()) {
      comidas = 0
      super(unPersonaje)
    }
  }

  method sumarComida(unPersonaje) {
    comidas += 1
    if (comidas >= 5) {
      unPersonaje.sacarParasito()
      unPersonaje.recibirDanio(5)
    }
  }
}
