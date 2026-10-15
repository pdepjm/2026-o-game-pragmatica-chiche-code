import wollok.game.*

class Efecto {
  method prioridad()
  method image()
  method duracion()

  // lo normal es que un efecto no frene al personaje ni cambie los puntos
  method permiteMoverse() = true
  method multiplicador() = 1

  method aplicar(unPersonaje) {
    unPersonaje.agregarEfecto(self)
    game.schedule(self.duracion(), { unPersonaje.quitarEfecto(self) })
  }
}

object lastimado inherits Efecto {
  // 1 es la prioridad mas alta
  override method prioridad() = 1
  override method image() = "personaje/personaje_lastimado.png"
  override method duracion() = 1000
}

object congelado inherits Efecto {
  override method prioridad() = 2
  override method image() = "personaje/personaje_congelado.png"
  override method duracion() = 3000
  override method permiteMoverse() = false
}

object dorado inherits Efecto {
  override method prioridad() = 3
  override method image() = "personaje/personaje_dorado.png"
  override method duracion() = 5000
  override method multiplicador() = 2
}
