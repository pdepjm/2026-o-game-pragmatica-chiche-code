object personaje {
  var posicion = game.at(4,0)
  var saltando = false
  var puedeMoverse = true
  var property multiplicador = 1

  method position() = posicion
  method image()= "personaje.png"

 
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
    puedeMoverse = false
    game.schedule(3000, { puedeMoverse = true })
  }
  method inspirar() {
    multiplicador = 2
    game.schedule(5000, { multiplicador = 1 })
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
  marcador.ganarPuntos(10 * personaje.multiplicador())
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
  }

  method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
}

object inspiracion {
  var posicion = game.at(3, 11)
  var activa = true

  method position() = posicion

  method serAgarrado() {
    if (activa) {
      activa = false
      personaje.inspirar() 
      game.removeVisual(self)
    }
  }
  
}

object debuffHielo {
  var posicion = game.at(6, 11)
  var activa = true

  method position() = posicion
  method image() = "hielo.png"

  method serAgarrado() {
    if (activa) {
      activa = false
      personaje.congelar()
      game.removeVisual(self)
    }
  }

}

object fondoPuntuacion {
  const property position = game.at(1, 9) 
  method image() = "puntuacion.png"
}

object marcador {
  var puntos = 0
  const property position = game.at(3, 9)
  method text() = puntos.toString()
  method ganarPuntos(cantidad) {
    puntos = (puntos + cantidad).max(0)
  }
  method reiniciar() {
    puntos = 0
  }

  
}