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

        return self.materiaPorCursar(materia) && (! self.tieneAprobada(materia)) && materia.estaInscripto(self) && self.puedeCursar(materia)
    }

    method materiaPorCursar(materia) = carreras.any({carrera => carrera.tieneMateria(materia)})

    method puedeCursar(materia) = materia.requisitos()

}

class Materia {
    
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