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

    method tieneAprobada(materia) = materiasAprobadas.any({aprobacion => aprobacion.materia() == materia})

    method materiasAprobadas() = materiasAprobadas

    method materiasInscriptas() = self.todasLasMaterias().asSet()

    method todasLasMaterias() = carreras.map({carrera => carrera.materias()}).flatten()

    // punto 5... 4 condiciones para que el alumno pueda inscribirse  en la materia. No esta terminado
    method puedeInscribirse(materia){

        return materia.correspondeACarrera(self) && (! self.tieneAprobada(materia)) && (!self.estaInscripto(materia)) && self.esAptoParaCursar(materia)
    }

    method estaInscripto(materia) = materia.estaInscripto(self)

    method tieneQueCursar(materia) = self.todasLasMaterias().contains(materia)
    
    method esAptoParaCursar(materia) = materia.coorrelativas().all({materia => self.tieneAprobada(materia)})

    method inscribirse(materia){
        self.validarInscribirse(materia)
        materia.inscribir(self)
    }

    method validarInscribirse(materia){

        if(!self.puedeInscribirse(materia)){
            self.error("No es posible Inscribirse en " + materia)
        }
    }

}

class Materia {
    const inscriptos = #{}
    const coorrelativas= #{}
    const cupoMaximo = 30
    const estudiantesEspera = #{}

    method agregarCoorrelativa(materia){
        coorrelativas.add(materia)
    }

    method inscribir(estudiante){
        if(cupoMaximo > self.cantInscriptos()){
        inscriptos.add(estudiante)
        } else {
            estudiantesEspera.add(estudiante)
        }
    }

    method cantInscriptos() = self.inscriptos().size()

    method correspondeACarrera(estudiante) = estudiante.tieneQueCursar(self)

    method estaInscripto(estudiante) = inscriptos.contains(estudiante)

    method coorrelativas() = coorrelativas

    method inscriptos() = inscriptos
    
}

class Aprobacion {

    
    const materia
    const nota

   

    method materia() = materia

    method nota() = nota



} 

class Carrera {
    const materias = #{}

    method agregarMateria(materia){

        materias.add(materia)
    }

    method tieneMateria(materia) = materias.contains(materia)

    method materias() = materias
}