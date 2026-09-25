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

class GeneradorObjetos {
  
  var listaObjetos = []
  const crear

  method generar() {
    const objeto = crear.apply()
    objeto.posicion(self.posicionRandom())
    listaObjetos.add(objeto)
    game.addVisual(objeto)
  }

  method actualizar() {
    listaObjetos.forEach({objeto => objeto.caer()})

    listaObjetos = listaObjetos.filter({objeto => objeto.estaActiva()})
  }

  method posicionRandom() {
    var xRandom = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].anyOne()
    var posicionRandom = game.at(xRandom, 11)

    return posicionRandom
  }
}
class Comida {
  var posicion = game.at(2,11)
  var activa = true

  method estaActiva() = activa

  method posicion(_posicion) {
    posicion = _posicion
  }

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

class Bomba {
  var posicion = game.at(7, 11)
  var activa = true

  method estaActiva() = activa

  method posicion(_posicion) {
    posicion = _posicion
  }

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

class SegmentoLanza {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "lanzaMango.png"

  method setearSegunSpawn(){
    if (lado == "izquierda" && altura == "piso") {
      posicion = game.at(0, 0)
    }
    if (lado == "derecha" && altura == "piso") {
      posicion = game.at(9, 0)
    }
    if (lado == "izquierda" && altura == "aire") {
      posicion = game.at(0, 1)
    }
    if (lado == "derecha" && altura == "aire") {
      posicion = game.at(9, 1)
    }
  }

  method spawn(_lado, _altura) {
    lado = _lado
    altura = _altura

    self.setearSegunSpawn()
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

class Lanza {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "lanzaIzq.png"

  const segmentoLanza1 = new SegmentoLanza()
  const segmentoLanza2 = new SegmentoLanza()
  const segmentoLanza3 = new SegmentoLanza()

  method spawn(_lado, _altura) {
    lado = _lado
    altura = _altura

    self.setearLanzaSegunSpawn()
  }

  method moverLanza() {
    if (lado == "izquierda") {
      game.schedule(400, {
        posicion = posicion.right(1)
        segmentoLanza1.spawn(lado, altura)
        segmentoLanza2.spawn(lado, altura)
        segmentoLanza3.spawn(lado, altura)
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
        segmentoLanza1.spawn(lado, altura)
        segmentoLanza2.spawn(lado, altura)
        segmentoLanza3.spawn(lado, altura)
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
  method setearLanzaSegunSpawn(){
    if (lado == "izquierda" && altura == "piso") {
      imagen = "lanzaIzq.png"
      posicion = game.at(0, 0)
    }
    if (lado == "derecha" && altura == "piso") {
      imagen = "lanzaDer.png"
      posicion = game.at(9, 0)
    }
    if (lado == "izquierda" && altura == "aire") {
      imagen = "lanzaIzq.png"
      posicion = game.at(0, 1)
    }
    if (lado == "derecha" && altura == "aire") {
      imagen = "lanzaDer.png"
      posicion = game.at(9, 1)
    }
  }

  method position() = posicion
  method image() = imagen
  
}

class Advertencia {
  var posicion = game.at(9, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "advertencia1.png"

  const lanza = new Lanza()

  method spawn(_lado, _altura) {
    lado = _lado
    altura = _altura

    self.setearAdvertenciaSegunSpawn()
  }

  method setearAdvertenciaSegunSpawn(){
    if (lado == "izquierda" && altura == "piso") {
      posicion = game.at(0, 0)
    }
    if (lado == "derecha" && altura == "piso") {
      posicion = game.at(9, 0)
    }
    if (lado == "izquierda" && altura == "aire") {
      posicion = game.at(0, 1)
    }
    if (lado == "derecha" && altura == "aire") {
      posicion = game.at(9, 1)
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
    lanza.spawn(lado, altura)
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