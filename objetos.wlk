import wollok.game.*
import personaje.*
import hud.*
import dificultad.*

class GeneradorObjetos {
  var listaObjetos = []
  const crear

  method generar() {
    const libres = self.posicionesLibres()
    if (not libres.isEmpty()) {
      const objeto = crear.apply()
      objeto.posicion(libres.anyOne())
      listaObjetos.add(objeto)
      game.addVisual(objeto)
    }
  }

  method posicionesLibres() = (0 .. game.width() - 1)
    .map({ x => game.at(x, marco.fila() - 2) })
    .filter({ pos => game.getObjectsIn(pos).isEmpty() })

  method actualizar() {
    listaObjetos.forEach({ objeto => objeto.caer() })
    listaObjetos = listaObjetos.filter({ objeto => objeto.estaActiva() })
  }
}

class Comida {
  var posicion = game.at(2,11)
  var activa = true
  const imagen
  const puntos

  method estaActiva() = activa

  method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = imagen

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
    marcador.ganarPuntos(puntos * personaje.multiplicador())
  }

  method desaparecer(){
    if(activa){
      activa = false
      game.removeVisual(self)
    }
  }
}

class Corazon {
  var posicion = game.at(2,11)
  var activa = true

  method estaActiva() = activa
  method posicion(_posicion) { posicion = _posicion }
  method position() = posicion
  method image() = "corazon.png"

  method caer(){
    if(activa){
      if(posicion.y() == 0){
        self.desaparecer()
      } else if(not generadorCajas.hayCajaEn(posicion.down(1))){
        posicion = posicion.down(1)
      }
    }
  }

  method serAgarrado(){
    self.desaparecer()
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
    dificultad.penalizar(-50)
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
    const libres = self.posicionesLibres()
    if (not libres.isEmpty()) {
      const caja = new Caja()
      caja.posicion(libres.anyOne())
      listaCajas.add(caja)
      game.addVisual(caja)
    }
  }

  method actualizar() {
    listaCajas.forEach({caja => caja.caer()})

    listaCajas = listaCajas.filter({caja => caja.estaActiva()})
  }

  method posicionesLibres() = (0 .. game.width() - 1)
    .map({ x => game.at(x, marco.fila() - 2) })
    .filter({ pos => game.getObjectsIn(pos).isEmpty() })
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