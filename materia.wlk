class Estudiante {
    const materiasAprobadas = #{}
    const carreras = #{}
    

    method aprobar(materia,nota){
        self.validacionAprobar(materia)
        const materiaAprobada = new Aprobacion (estudiante = self,materia=materia,nota=nota)
        materiasAprobadas.add(materiaAprobada)
    }

    method aprobadas(){

        return materiasAprobadas.map({materia=> materia.nombre()}).asSet()
    }

    method validacionAprobar(materia){
        if( self. estaAprobada(materia)){
            self.error("Ya Aaprobaste esta materia")
        }
    }

    method  materiasDeLasCarreras(){
        return self.materiasDeCarrera().flatten()
    }

    method materiasDeCarrera(){

        return carreras.map({carrera=>carrera.materias()})
    }

    method cursar(carrera){

        carreras.add(carrera)
    }


    method promedio() = self.notasDeMaterias().sum() / self.cantidadAprobadas()

    method notasDeMaterias() = materiasAprobadas.map({materia => materia.nota(self)})

    method cantidadAprobadas() = materiasAprobadas.size()

    method estaAprobada(materia) = materiasAprobadas.contains(materia)

    method materiasAprobadas() = materiasAprobadas

}

class Materia {
    
    const estudiantesCursando = #{}

    method agregarEstudiante(estudiante){
        estudiantesCursando.add(estudiante)
    }

 
}

class Aprobacion {

    var estudiante
    var materia
    var nota



} 

class Carrera {
    const materias = #{}

    method agregarMateria(materia){

        materias.add(materia)
    }
}