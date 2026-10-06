import wollok.game.*
import personaje.*
import hud.*

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

  const tiempoPaso = 400
  const segmentos = [
    new SegmentoLanza(lanza = self),
    new SegmentoLanza(lanza = self),
    new SegmentoLanza(lanza = self)
  ]

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

    posicion = generadorLanzas.posicionDeSpawn(lado, altura)
    segmentos.forEach({ segmento => segmento.posicion(posicion) })
  }

  // hacia donde apunta la lanza segun el lado del que sale
  method adelante(unaPosicion) = if (lado == "izquierda") unaPosicion.right(1) else unaPosicion.left(1)
  method atras(unaPosicion) = if (lado == "izquierda") unaPosicion.left(1) else unaPosicion.right(1)

  // en cada paso de ida aparece un segmento y en cada paso de vuelta se va el ultimo que aparecio
  method moverLanza() {
    const cantidad = segmentos.size()

    (0 .. cantidad - 1).forEach({ paso =>
      game.schedule((paso + 1) * tiempoPaso, { self.extender(paso) })
      game.schedule((2 * cantidad - paso) * tiempoPaso, { self.retraer(paso) })
    })

    game.schedule((2 * cantidad + 1) * tiempoPaso, { self.desaparecer() })
  }

  method extender(paso) {
    posicion = self.adelante(posicion)
    game.addVisual(segmentos.get(paso))
    segmentos.take(paso).forEach({ segmento => segmento.avanzar() })
  }

  method retraer(paso) {
    posicion = self.atras(posicion)
    game.removeVisual(segmentos.get(paso))
    segmentos.take(paso).forEach({ segmento => segmento.retroceder() })
  }

  method desaparecer() {
    game.removeVisual(self)
    generadorLanzas.liberar(lado, altura)
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
    lanza.spawn(lado, altura)
    game.addVisual(lanza)
    lanza.moverLanza()
  }
}
