object personaje {
  var posicion = game.at(4,0)
  var saltando = false

  method position() = posicion
  method image()= "goat.png"

 
  method moverIzquierda() {
    if (posicion.x() > 0) {
      posicion = posicion.left(1)
    }
  }

  method moverDerecha() {
    if (posicion.x() < game.width()-1) {
      posicion = posicion.right(1)
    }
  }

  method saltar() {
    if (not saltando) {
      saltando = true
      posicion = posicion.up(1)
      game.schedule(400, {
        posicion = posicion.down(1)
        saltando = false
      })
    }
  }
}