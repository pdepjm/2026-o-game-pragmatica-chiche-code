import wollok.game.*

object lastimado {
  // 1 es la prioridad mas alta
  method prioridad() = 1
  method image() = "personaje/personaje_lastimado.png"
  method permiteMoverse() = true
  method multiplicador() = 1

  method aplicar(unPersonaje) {
    unPersonaje.agregarEfecto(self)
    game.schedule(1000, { unPersonaje.quitarEfecto(self) })
  }
}

object congelado {
  method prioridad() = 2
  method image() = "personaje/personaje_congelado.png"
  method permiteMoverse() = false
  method multiplicador() = 1

  method aplicar(unPersonaje) {
    unPersonaje.agregarEfecto(self)
    game.schedule(3000, { unPersonaje.quitarEfecto(self) })
  }
}

object dorado {
  method prioridad() = 3
  method image() = "personaje/personaje_dorado.png"
  method permiteMoverse() = true
  method multiplicador() = 2

  method aplicar(unPersonaje) {
    unPersonaje.agregarEfecto(self)
    game.schedule(5000, { unPersonaje.quitarEfecto(self) })
  }
}
