class Estudiante {
    const materiasAprobadas = #{}
    const carreras = #{}
    
    // el objeto aprobacion para crear  las materias aprobadas y guardarlas  en la coleccion materias aprobadas
    method aprobar(materia,nota){  
        self.validacionAprobar(materia)
        const materiaAprobada = new Aprobacion (materia=materia,nota=nota)
        materiasAprobadas.add(materiaAprobada)
    }

    method validacionAprobar(materia){
        if( self.tieneAprobada(materia)){
            self.error("Ya tiene  aprobada " + materia)
        }
    }

    method cursar(carrera){

        carreras.add(carrera)
    }


    method promedio() = self.notasDeMaterias().sum() / self.cantidadAprobadas()

    method notasDeMaterias() = materiasAprobadas.map({materia => materia.nota()})

    method cantidadAprobadas() = materiasAprobadas.size()

    method tieneAprobada(materia) = self.esMateriaAprobada(materia)
    //materiasAprobadas.any({aprobacion => aprobacion.materia() == materia})

    method esMateriaAprobada(materia) = self.materiasAprobadas().contains(materia)

    method materiasAprobadas() = materiasAprobadas.map{aprobada => aprobada.materia()}.asSet()

    method materiasQueDebeCursar() = self.todasLasMaterias().asSet()

    method todasLasMaterias() = carreras.map({carrera => carrera.materias()}).flatten()

    // punto 5... 4 condiciones para que el alumno pueda inscribirse  en la materia. No esta terminado
    method puedeInscribirse(materia){

        return materia.correspondeACarrera(self) && (! self.tieneAprobada(materia)) && (!self.estaInscripto(materia)) && self.aptoParaInscribirse(materia)
    }

    method estaInscripto(materia) = materia.estaInscripto(self)

    method tieneQueCursar(materia) = self.todasLasMaterias().contains(materia)
    

    method inscribirse(materia){
        self.validarInscribirse(materia)
        materia.inscribir(self)
    }

    method validarInscribirse(materia){

        if(!self.puedeInscribirse(materia)){
            self.error("No es posible Inscribirse en " + materia)
        }
    }

    method materiasInscriptas(){
        return self.todasLasMaterias().filter({materia=> materia.estaInscripto(self)}).asSet()
    }

    method materiasEnEspera(){
        return self.todasLasMaterias().filter({materia=> materia.estaEnEspera(self)})
    }

    method materiasEnlasQuePuedeInscribirse(carrera) = if(self.estaEnCarrera(carrera)) carrera.materiasQuePuedeIncribirse(self)

    method estaEnCarrera(carrera) {
        return carreras.contains(carrera)
    }

    method darDeBajaEn(materia){
        materia.darDeBaja(self)
    }

    method creditosTotal(){
        return self.creditosDeAprobadas().sum()
    }

    method creditosDeAprobadas(){
        return materiasAprobadas.map({aprobada=> aprobada.creditosDeMateria()})
    }

    method aptoParaInscribirse(materia){
        return materia.requerimientoParaInscribirse(self)
        
    }
}

class Materia {
    const inscriptos = #{}
    var cupoMaximo = 30
    const estrategiaInscripcion 
    var property creditos
    var property año
    const requerimiento
     
     
    method inscribir(estudiante){
        if(cupoMaximo > self.cantInscriptos()){
        inscriptos.add(estudiante)
        } else {
            self.agregarEspera(estudiante)
        }
    }

    method cantInscriptos() = self.inscriptos().size()

    method correspondeACarrera(estudiante) = estudiante.tieneQueCursar(self)

    method estaInscripto(estudiante) = inscriptos.contains(estudiante)

    method inscriptos() = inscriptos

    method darDeBaja(estudiante){
        inscriptos.remove(estudiante)
        self.darDeAltaEnEspera()
    }

    method darDeAltaEnEspera(){
        if(! self.estudiantesEnEspera().isEmpty()){
            estrategiaInscripcion.inscribirEstudiante(self)
        }
    }

    method agregarEspera(estudiante){
        estrategiaInscripcion.estudiantesEnEspera().add(estudiante)
    }

    method estudiantesEnEspera() = estrategiaInscripcion.estudiantesEnEspera()

    method estaEnEspera(estudiante){
        return estrategiaInscripcion.estudiantesEnEspera().contains(estudiante)
    }

    method puedeInscribirse(estudiante){
        return estudiante.puedeInscribirse(self)
    }

    method cupoMaximo(_cupoMaximo){
        cupoMaximo = _cupoMaximo
    }

    method requerimiento() = requerimiento

    method requerimientoParaInscribirse(estudiante){
        return requerimiento.cumpleRequerimiento(estudiante)
    }

    
    
}

class Aprobacion {

    
    const materia
    const nota

   

    method materia() = materia

    method nota() = nota

    method creditosDeMateria(){
        return materia.creditos()
    }



} 

class Carrera {
    const materias = #{}

    method agregarMateria(materia){

        materias.add(materia)
    }

    method tieneMateria(materia) = materias.contains(materia)

    method materias() = materias

    method materiasQuePuedeIncribirse(estudiante){
        return materias.filter({materia=> materia.puedeInscribirse(estudiante)})
    }
}

class Requerimiento{

    method cumpleRequerimiento(estudiante)
    
}

class Nada inherits Requerimiento{

    override method  cumpleRequerimiento(estudiante) = true
}

class Credito inherits Requerimiento{
    var creditosNecesarios 

    override method cumpleRequerimiento(estudiante){
        return estudiante.creditosTotal() >= creditosNecesarios
    }

    method creditosNecesarios () = creditosNecesarios

    method creditosNecesarios(_creditosNecesarios){
        creditosNecesarios = _creditosNecesarios
    }
}

class PorAño inherits Requerimiento{
    var property año
    override method cumpleRequerimiento(estudiante){

        return estudiante.materiasAprobadas().all({materia => materia.año() < año})
    }
}

class Correlativa inherits Requerimiento{
    const correlativas 
    override method cumpleRequerimiento(estudiante){
      return   correlativas.all({materia => estudiante.tieneAprobada(materia)})
    }
}

class ListaEspera {
    const estudiantesEspera =[]

    method inscribirEstudiante(materia)

   

    method estudiantesEnEspera() = estudiantesEspera

}

class OrdenDeLlegada inherits ListaEspera{

    
     override  method inscribirEstudiante(materia) {
        materia.inscribir(estudiantesEspera.first())
        estudiantesEspera.remove(estudiantesEspera.first())
      } 

    

}

class Elitista inherits ListaEspera{

    override method inscribirEstudiante(materia){
        materia.inscribir(self.estudianteConMasPromedio())
        estudiantesEspera.remove(self.estudianteConMasPromedio())
    }

    method estudianteConMasPromedio() = estudiantesEspera.max({estudiante=> estudiante.promedio()})
}

class GradoDeAvance inherits ListaEspera{

    override method inscribirEstudiante(materia){

        materia.inscribir(self.estudianteConMasMateriasAprobadas())
        estudiantesEspera.remove(self.estudianteConMasMateriasAprobadas())
    }

    method estudianteConMasMateriasAprobadas() = estudiantesEspera.max({estudiante => estudiante.cantidadAprobadas()})
}