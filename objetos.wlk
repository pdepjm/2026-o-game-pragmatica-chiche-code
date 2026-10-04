import wollok.game.*
import personaje.*
import hud.*

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
