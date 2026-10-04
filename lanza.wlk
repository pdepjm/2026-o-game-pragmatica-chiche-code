import wollok.game.*
import personaje.*
import hud.*

class SegmentoLanza {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "lanza/lanzaMango.png"
  const lanza

  method serAgarrado() {
    lanza.serAgarrado()
  }

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
  var imagen = "lanza/lanzaIzq.png"
  var golpeado = false

  const segmentoLanza1 = new SegmentoLanza(lanza = self)
  const segmentoLanza2 = new SegmentoLanza(lanza = self)
  const segmentoLanza3 = new SegmentoLanza(lanza = self)

  method serAgarrado() {
    if (not golpeado) {
      marcador.ganarPuntos(-75)
      personaje.recibirDanio(3)
      golpeado = true
    }
  }

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
      game.schedule(2800, {
        game.removeVisual(self)
        generadorLanzas.liberar(lado, altura)
        })
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
      game.schedule(2800, {
        game.removeVisual(self)
        generadorLanzas.liberar(lado, altura)
        })
    }
  }

// seteamos la posicion y la imagen de la lanza segun el lado de spawn
  method setearLanzaSegunSpawn(){
    if (lado == "izquierda" && altura == "piso") {
      imagen = "lanza/lanzaIzq.png"
      posicion = game.at(0, 0)
    }
    if (lado == "derecha" && altura == "piso") {
      imagen = "lanza/lanzaDer.png"
      posicion = game.at(9, 0)
    }
    if (lado == "izquierda" && altura == "aire") {
      imagen = "lanza/lanzaIzq.png"
      posicion = game.at(0, 1)
    }
    if (lado == "derecha" && altura == "aire") {
      imagen = "lanza/lanzaDer.png"
      posicion = game.at(9, 1)
    }
  }

  method position() = posicion
  method image() = imagen
  
}

object generadorLanzas {
  const spawns = [
    ["izquierda", "piso"], ["derecha", "piso"],
    ["izquierda", "aire"], ["derecha", "aire"]
  ]
  
  // spawns que tienen una advertencia o una lanza activa
  const ocupados = []

  method lanzarRandom() {
    const libres = spawns.filter({ spawn => not ocupados.contains(spawn) })
    if (not libres.isEmpty()) {
      const spawn = libres.anyOne()
      ocupados.add(spawn)

      const advertencia = new Advertencia()
      advertencia.spawn(spawn.first(), spawn.last())
      game.addVisual(advertencia)
      advertencia.animacion()
    }
  }

  // la lanza avisa cuando termina para que su spawn se pueda volver a usar
  method liberar(lado, altura) {
    ocupados.removeAllSuchThat({ spawn => spawn.first() == lado and spawn.last() == altura })
  }
}


class Advertencia {
  var posicion = game.at(9, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "advertencia/advertencia1.png"

  const lanza = new Lanza()

  method serAgarrado(){
    // vacio no hace nada
  }

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
      imagen = "advertencia/advertencia2.png"
    })

    game.schedule(800, {
      imagen = "advertencia/advertencia3.png"
    })

    game.schedule(1200, {
      imagen = "advertencia/advertencia2.png"
    })

    game.schedule(1600, {
      imagen = "advertencia/advertencia1.png"
    })

    game.schedule(2000, {
      imagen = "advertencia/advertencia2.png"
    })

    game.schedule(2400, {
      imagen = "advertencia/advertencia3.png"
    })

    game.schedule(2800, {
      imagen = "advertencia/advertencia2.png"
    })

    game.schedule(3200, {
      imagen = "advertencia/advertencia1.png"
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
