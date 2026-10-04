import wollok.game.*
import hud.*

object personaje {
  var posicion = game.at(4,0)
  var saltando = false
  var puedeMoverse = true
  var property multiplicador = 1
  var inspiracionesActivas = 0
  var congelamientosActivos = 0
  var lastimadurasActivas = 0

  const vidaMaxima = 10
  var vidaActual = 10

  method position() = posicion
  method image() =
    if (lastimadurasActivas > 0 ) "personaje/personaje_lastimado.png"
    else if (congelamientosActivos > 0) "personaje/personaje_congelado.png"
    else if (inspiracionesActivas > 0) "personaje/personaje_dorado.png"
    else "personaje/personaje.png"
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

    lastimadurasActivas += 1
    game.schedule(1000, { lastimadurasActivas -= 1 })

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
