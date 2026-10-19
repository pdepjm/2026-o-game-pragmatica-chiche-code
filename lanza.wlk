import wollok.game.*
import personaje.*
import objetos.*
import hud.*
import dificultad.*
class SegmentoLanza {
  var posicion  = game.at(0, 0)
  const lanza

  method serAgarrado() {
    lanza.serAgarrado()
  }

  method posicion(_posicion) {
    posicion = _posicion
  }

  method position() = posicion
  method image() = "lanza/lanzaMango.png"

  method avanzar() {
    posicion = lanza.adelante(posicion)
  }

  method retroceder() {
    posicion = lanza.atras(posicion)
  }
}

class Lanza {
  var posicion  = game.at(0, 0)
  var lado = "izquierda"
  var altura = "piso"
  var golpeado = false
  var activa = true
  var avanzando = true
  // cuantos segmentos tiene afuera en este momento
  var extension = 0

  const segmentos = [
    new SegmentoLanza(lanza = self),
    new SegmentoLanza(lanza = self),
    new SegmentoLanza(lanza = self)
  ]

  method tiempoPaso() = dificultad.tiempoLanza()

  method serAgarrado() {
    if (not golpeado) {
      personaje.sacarParasito()
      dificultad.penalizar(-75)
      personaje.recibirDanio(3)
      golpeado = true
    }
  }

  method spawn(_lado, _altura) {
    lado = _lado
    altura = _altura

    posicion = generadorLanzas.posicionDeSpawn(lado, altura)
    segmentos.forEach({ segmento => segmento.posicion(posicion) })
  }

  // hacia donde apunta la lanza segun el lado del que sale
  method adelante(unaPosicion) = if (lado == "izquierda") unaPosicion.right(1) else unaPosicion.left(1)
  method atras(unaPosicion) = if (lado == "izquierda") unaPosicion.left(1) else unaPosicion.right(1)

  // programa los pasos que hacen falta para ir y volver completa. Si una caja la frena se retrae antes y los pasos que sobran no hacen nada
  method moverLanza() {
    (1 .. 2 * segmentos.size() + 1).forEach({ paso =>
      game.schedule(paso * self.tiempoPaso(), { self.darPaso() })
    })
  }

  method puedeExtenderse() =
    avanzando and extension < segmentos.size() and not generadorCajas.hayCajaEn(self.adelante(posicion))

  method darPaso() {
    if (self.puedeExtenderse()) {
      self.extender()
    } else {
      // una vez que deja de avanzar no vuelve a extenderse, aunque la caja que la freno ya no este
      avanzando = false
      self.volver()
    }
  }

  method volver() {
    if (extension > 0) {
      self.retraer()
    } else {
      self.desaparecer()
    }
  }

  // la punta avanza, aparece un segmento nuevo en el borde y avanzan los que ya estaban
  method extender() {
    posicion = self.adelante(posicion)
    game.addVisual(segmentos.get(extension))
    segmentos.take(extension).forEach({ segmento => segmento.avanzar() })
    extension += 1
  }

  // la punta retrocede, se va el ultimo segmento que aparecio y retroceden los que quedan
  method retraer() {
    extension -= 1
    posicion = self.atras(posicion)
    game.removeVisual(segmentos.get(extension))
    segmentos.take(extension).forEach({ segmento => segmento.retroceder() })
  }

  method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
      generadorLanzas.liberar(lado, altura)
    }
  }

  method position() = posicion
  method image() = if (lado == "izquierda") "lanza/lanzaIzq.png" else "lanza/lanzaDer.png"

}

object generadorLanzas {
  const spawns = [
    ["izquierda", "piso"], ["derecha", "piso"],
    ["izquierda", "aire"], ["derecha", "aire"]
  ]

  // spawns que tienen una advertencia o una lanza activa
  const ocupados = []

  method lanzarRandom() {
    const libres = spawns.filter({ spawn => self.estaLibre(spawn) })
    if (not libres.isEmpty()) {
      const spawn = libres.anyOne()
      ocupados.add(spawn)

      const advertencia = new Advertencia()
      advertencia.spawn(spawn.first(), spawn.last())
      game.addVisual(advertencia)
      advertencia.animacion()
    }
  }

  // un spawn sirve si no tiene otra lanza ni una caja en su celda
  method estaLibre(spawn) =
    not ocupados.contains(spawn) and not generadorCajas.hayCajaEn(self.posicionDeSpawn(spawn.first(), spawn.last()))

  // la lanza avisa cuando termina para que su spawn se pueda volver a usar
  method liberar(lado, altura) {
    ocupados.removeAllSuchThat({ spawn => spawn.first() == lado and spawn.last() == altura })
  }

  // el lado define la columna y la altura define la fila
  method posicionDeSpawn(lado, altura) {
    const coordenadaX = if (lado == "izquierda") 0 else game.width() - 1
    const coordenadaY = if (altura == "piso") 0 else 1

    return game.at(coordenadaX, coordenadaY)
  }
}


class Advertencia {
  var posicion = game.at(0, 0)
  var lado = "izquierda"
  var altura = "piso"
  var imagen = "advertencia/advertencia1.png"

  const tiempoPaso = 400
  // numero de imagen que se muestra en cada paso de la animacion
  const cuadros = [2, 3, 2, 1, 2, 3, 2, 1]
  const lanza = new Lanza()

  method serAgarrado(){
    // vacio no hace nada
  }

  method spawn(_lado, _altura) {
    lado = _lado
    altura = _altura

    posicion = generadorLanzas.posicionDeSpawn(lado, altura)
  }

  method position() = posicion
  method image() = imagen

  method animacion() {
    (0 .. cuadros.size() - 1).forEach({ paso =>
      game.schedule((paso + 1) * tiempoPaso, {
        imagen = "advertencia/advertencia" + cuadros.get(paso) + ".png"
      })
    })

    game.schedule((cuadros.size() + 1) * tiempoPaso, { self.desaparecer() })
  }

  method desaparecer(){
    game.removeVisual(self)

    if (generadorCajas.hayCajaEn(posicion)) {
      // cayo una caja en el spawn durante la advertencia: la lanza no sale
      generadorLanzas.liberar(lado, altura)
    } else {
      lanza.spawn(lado, altura)
      game.addVisual(lanza)
      lanza.moverLanza()
    }
  }
}
