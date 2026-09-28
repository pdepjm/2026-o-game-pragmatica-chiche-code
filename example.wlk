object gameOver {
  method position() = game.at(2, 3)
  method image() = "gameOver.png"
}

object personaje {
  var posicion = game.at(4,0)
  var saltando = false
  var puedeMoverse = true
  var property multiplicador = 1
  var inspiracionesActivas = 0
  var congelamientosActivos = 0

  const vidaMaxima = 10
  var vidaActual = 10

  method position() = posicion
  method image() =
    if (congelamientosActivos > 0) "personaje_congelado.png"
    else if (inspiracionesActivas > 0) "personaje_dorado.png"
    else "personaje.png"
  method vida() = vidaActual

 
  method moverIzquierda() {
    if (posicion.x() > 0 and puedeMoverse) {
      posicion = posicion.left(1)
    }
  }

  method moverDerecha() {
    if (posicion.x() < game.width()-1 and puedeMoverse) {
      posicion = posicion.right(1)
    }
  }

  method saltar() {
    if (not saltando and puedeMoverse) {
      saltando = true
      posicion = posicion.up(1)
      game.schedule(400, {
        posicion = posicion.down(1)
        saltando = false
      })
    }
  }
  method congelar() {
    congelamientosActivos += 1
    puedeMoverse = false
    game.schedule(3000, { 
      congelamientosActivos -= 1
      if (congelamientosActivos == 0) {
        puedeMoverse = true 
      }
    })
  }
  method inspirar() {
    inspiracionesActivas += 1
    multiplicador = 2
    
    game.schedule(5000, { 
      inspiracionesActivas -= 1
      if (inspiracionesActivas == 0) {
        multiplicador = 1 
      }
    })
  }

  method recibirDanio(danio) {
    vidaActual = vidaActual - danio
    if (vidaActual < 0) {
      vidaActual = 0
    }

    healthBar.actualizar()

    if (vidaActual == 0) {
      self.gameOver()
    }
  }

  method gameOver() {
    game.addVisual(gameOver)

    game.stop()
  }

  method curar(cantidad) {
    vidaActual = vidaActual + cantidad
    if (vidaActual > vidaMaxima) {
      vidaActual = vidaMaxima
    }

    healthBar.actualizar()
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
    var posicionRandom = game.at(xRandom, marco.fila() - 1)

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
  marcador.ganarPuntos(10 * personaje.multiplicador())
  personaje.curar(1)
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
    marcador.ganarPuntos(-50)
    personaje.recibirDanio(2)
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
  var imagen = "lanzaIzq.png"
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
  var imagen = "advertencia1.png"

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

class Inspiracion {
  var posicion = game.at(3, 11)
  var activa = true

 method estaActiva() = activa

method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = "inspiracion.png"
    
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
    if (activa) {
      personaje.inspirar() 
      self.desaparecer()
    }
  }

   method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
  
}

class DebuffHielo {
  var posicion = game.at(6, 11)
  var activa = true

 method estaActiva() = activa

method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = "hielo.png"

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
    if (activa) {
      personaje.congelar() 
      self.desaparecer()
    }
  }

   method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
  

}

object fondoPuntuacion {
  method position() = game.at(8, marco.fila())
  method image() = "puntuacion.png"
}

object marcador {
  var puntos = 0
  method position() = game.at(9, marco.fila())
  method text() = puntos.toString()
  method textColor() = "FFD700"
  method ganarPuntos(cantidad) {
    puntos = (puntos + cantidad).max(0)
  }
  method reiniciar() {
    puntos = 0
  }
}

class CeldaMarco {
  const property position
  method image() = "celda2.png"
}

object marco {
  method fila() = 12

  method dibujar() {
    (0 .. 9).forEach({ x =>
      game.addVisual(new CeldaMarco(position = game.at(x, self.fila())))
    })
  }
}

object healthBar {

  var imagen = "vida/vida10.png"

  method position() = game.at(0, marco.fila())

  method image() = imagen

  method actualizar() {
    imagen = "vida/vida" + personaje.vida() + ".png"
  }
}