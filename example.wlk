object personaje {
  var posicion = game.at(4,0)
  var saltando = false

  method position() = posicion
  method image()= "personaje.png"

 
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

object comida {
  var posicion = game.at(2,11)
  var activa = true

  method position() = posicion
  method image()= "apple.png"

  method caer(){
    if(activa){
      if(posicion.y() > 0){
        posicion = posicion.down(1)
      }else {
        self.desaparecer()
      }
    }
  }
 method serAgarrado(){
  self.desaparecer()
 }
method desaparecer(){
  if(activa){
    activa = false
    game.removeVisual(self)
  }
}
}

object bomba {
  var posicion = game.at(7, 11)
  var activa = true

  method position() = posicion
  method image() = "bomba.png"

  method caer() {
    if (activa) {
      if (posicion.y() > 0) {
        posicion = posicion.down(1)
      } else {
        self.desaparecer()
      }
    }
  }

  method serAgarrado() {
    self.desaparecer()
  }

  method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
}

object segmentoLanza1 {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var imagen = "lanzaMango.png"

  method setearSegunLado(){
    if(lado == "izquierda"){
      posicion = game.at(0, 0)
    } else {
      posicion = game.at(9,0)
    }
  }

  method lado(_lado) {
    lado = _lado

    self.setearSegunLado()
  }

  method position() = posicion
  method image() = imagen

  method moverDerecha() {
    posicion = posicion.right(1)
  }

  method moverIzquierda() {
    posicion = posicion.left(1)
  }
}

object segmentoLanza2 {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var imagen = "lanzaMango.png"

  method setearSegunLado(){
    if(lado == "izquierda"){
      posicion = game.at(0, 0)
    } else {
      posicion = game.at(9,0)
    }
  }

  method lado(_lado) {
    lado = _lado

    self.setearSegunLado()
  }

  method position() = posicion
  method image() = imagen

  method moverDerecha() {
    posicion = posicion.right(1)
  }

  method moverIzquierda() {
    posicion = posicion.left(1)
  }
}

object segmentoLanza3 {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var imagen = "lanzaMango.png"

  method setearSegunLado(){
    if(lado == "izquierda"){
      posicion = game.at(0, 0)
    } else {
      posicion = game.at(9,0)
    }
  }

  method lado(_lado) {
    lado = _lado

    self.setearSegunLado()
  }

  method position() = posicion
  method image() = imagen

  method moverDerecha() {
    posicion = posicion.right(1)
  }

  method moverIzquierda() {
    posicion = posicion.left(1)
  }
}

object lanza {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var imagen = "lanzaIzq.png"

  method lado(_lado) {
    lado = _lado

    self.setearLanzaSegunLado()
  }

  method moverLanza() {
    if (lado == "izquierda") {
      game.schedule(400, {
        posicion = posicion.right(1)
        segmentoLanza1.lado("izquierda")
        segmentoLanza2.lado("izquierda")
        segmentoLanza3.lado("izquierda")
        game.addVisual(segmentoLanza1)
        })
      game.schedule(800, {
        posicion = posicion.right(1)
        game.addVisual(segmentoLanza2)
        segmentoLanza1.moverDerecha()
        })
      game.schedule(1200, {
        posicion = posicion.right(1)
        game.addVisual(segmentoLanza3)
        segmentoLanza1.moverDerecha()
        segmentoLanza2.moverDerecha()
        })
      game.schedule(1600, {
        posicion = posicion.left(1)
        game.removeVisual(segmentoLanza3)
        segmentoLanza1.moverIzquierda()
        segmentoLanza2.moverIzquierda()
        })
      game.schedule(2000, {
        posicion = posicion.left(1)
        game.removeVisual(segmentoLanza2)
        segmentoLanza1.moverIzquierda()
        })
      game.schedule(2400, {
        posicion = posicion.left(1)
        game.removeVisual(segmentoLanza1)
        })
      game.schedule(2800, {game.removeVisual(self)})
    } else {
      game.schedule(400, {
        posicion = posicion.left(1)
        segmentoLanza1.lado("derecha")
        segmentoLanza2.lado("derecha")
        segmentoLanza3.lado("derecha")
        game.addVisual(segmentoLanza1)
        })
      game.schedule(800, {
        posicion = posicion.left(1)
        game.addVisual(segmentoLanza2)
        segmentoLanza1.moverIzquierda()
        })
      game.schedule(1200, {
        posicion = posicion.left(1)
        game.addVisual(segmentoLanza3)
        segmentoLanza1.moverIzquierda()
        segmentoLanza2.moverIzquierda()
        })
      game.schedule(1600, {
        posicion = posicion.right(1)
        game.removeVisual(segmentoLanza3)
        segmentoLanza1.moverDerecha()
        segmentoLanza2.moverDerecha()
        })
      game.schedule(2000, {
        posicion = posicion.right(1)
        game.removeVisual(segmentoLanza2)
        segmentoLanza1.moverDerecha()
        })
      game.schedule(2400, {
        posicion = posicion.right(1)
        game.removeVisual(segmentoLanza1)
        })
      game.schedule(2800, {game.removeVisual(self)})
    }
  }

// seteamos la posicion y la imagen de la lanza segun el lado de spawn
  method setearLanzaSegunLado(){
    if(lado == "izquierda") {
      imagen = "lanzaIzq.png"
      posicion = game.at(0, 0)
    } else {
      imagen = "lanzaDer.png"
      posicion = game.at(9, 0)
    }
  }

  method position() = posicion
  method image() = imagen
  
}

object advertencia {
  var posicion = game.at(9, 0)
  var lado = "izquierda"
  var imagen = "advertencia1.png"

  method lado(_lado) {
    lado = _lado

    self.setearAdvertenciaSegunLado()
  }

  method setearAdvertenciaSegunLado(){
    if(lado == "izquierda") {
      posicion = game.at(0, 0)
    } else {
      posicion = game.at(9, 0)
    }
  }

  method position() = posicion
  method image() = imagen

  method animacion() {
    game.schedule(400, {
      imagen = "advertencia2.png"
    })

    game.schedule(800, {
      imagen = "advertencia3.png"
    })

    game.schedule(1200, {
      imagen = "advertencia2.png"
    })

    game.schedule(1600, {
      imagen = "advertencia1.png"
    })

    game.schedule(2000, {
      imagen = "advertencia2.png"
    })

    game.schedule(2400, {
      imagen = "advertencia3.png"
    })

    game.schedule(2800, {
      imagen = "advertencia2.png"
    })

    game.schedule(3200, {
      imagen = "advertencia1.png"
    })

    game.schedule(3600, {
      self.desaparecer()
    })
  }

  method desaparecer(){
    game.removeVisual(self)
    lanza.lado(lado)
    game.addVisual(lanza)
    lanza.moverLanza()
  }
}

// objeto de ejemplo
object ejemplo {
  var posicion  = game.at(4, 4)
  var imagen = "cuadradito.png"

  method position() = posicion
  method image() = imagen
}