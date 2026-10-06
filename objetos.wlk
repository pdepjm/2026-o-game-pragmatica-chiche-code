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
    const xRandom = (0 .. game.width() - 1).anyOne()

    return game.at(xRandom, marco.fila() - 1)
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
      if(posicion.y() == 0){
        self.desaparecer()
      }else if(not generadorCajas.hayCajaEn(posicion.down(1))){
        posicion = posicion.down(1)
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
      if (posicion.y() == 0) {
        self.desaparecer()
      } else if (not generadorCajas.hayCajaEn(posicion.down(1))) {
        posicion = posicion.down(1)
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

object generadorCajas {
  
  var listaCajas = []

  method hayCajaEn(posicion) = listaCajas.any({caja => caja.posicion() == posicion})

  method generar() {
    const caja = new Caja()
    caja.posicion(self.posicionRandom())
    listaCajas.add(caja)
    game.addVisual(caja)
  }

  method actualizar() {
    listaCajas.forEach({caja => caja.caer()})

    listaCajas = listaCajas.filter({caja => caja.estaActiva()})
  }

  method posicionRandom() {
    const xRandom = (0 .. game.width() - 1).anyOne()

    return game.at(xRandom, marco.fila() - 1)
  }
}

class Caja {
  var property posicion = game.at(7, 11)
  var activa = true
  var ticksRestantes = 7

  method estaActiva() = activa

  method position() = posicion
  method image() = "caja.png"

  method estaEnElPiso() = posicion.y() == 0
  method puedeBajar() = not self.estaEnElPiso() and not generadorCajas.hayCajaEn(posicion.down(1))

  // la cuenta solo corre en el piso: una caja apilada espera sin descontar
  method caer() {
    if (self.puedeBajar()) {
      posicion = posicion.down(1)
    } else if (self.estaEnElPiso()) {
      self.descontarTick()
    }
  }

  method descontarTick() {
    if (ticksRestantes != 0) {
      ticksRestantes -= 1
    } else {
      self.desaparecer()
    }
  }

  // le cayo encima al personaje: lo lastima y lo corre a un costado. Si no hay lugar, la caja se rompe
  method serAgarrado() {
    personaje.recibirDanio(2)

    if (personaje.tieneCostadoLibre()) {
      personaje.serEmpujado()
    } else {
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