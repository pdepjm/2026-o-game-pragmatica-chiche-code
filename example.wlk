object personaje {
  
  const vidaMaxima = 10
  var vidaActual = 10

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

  method vida() = vidaActual
  
  method recibirDanio(danio) {
    vidaActual = vidaActual - danio
    if (vidaActual < 0) {
      vidaActual = 0
    }

    healthBar.actualizar()
  }

  method curar(cantidad) {
    vidaActual = vidaActual + cantidad
    if (vidaActual > vidaMaxima) {
      vidaActual = vidaMaxima
    }

    healthBar.actualizar()
  }
}

object comida {
  var posicion = game.at(2,11)
  var activa = true

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
    personaje.curar(1)
  }
  method desaparecer(){
    if(activa){
      activa = false
      game.removeVisual(self)
    }
  }
}

object bomba {
  var posicion = game.at(7, 11)
  var activa = true

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
    personaje.recibirDanio(2)
  }

  method desaparecer() {
    if (activa) {
      activa = false
      game.removeVisual(self)
    }
  }
}

object healthBar {

  var imagen = "vida/vida10.png"

  method position() = game.at(0, 11)

  method image() = imagen

  method actualizar() {
    imagen = "vida/vida" + personaje.vida() + ".png"
  }
}