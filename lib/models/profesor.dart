class Profesor {
  String nProfesor;
  String nombre;
  String carrera;

  Profesor(
      {required this.nProfesor, required this.nombre, required this.carrera});

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
        nProfesor: json['nProfesor'],
        nombre: json['nombre'],
        carrera: json['carrera']);
  }

  Map<String, dynamic> toJson() {
    return {'nProfesor': nProfesor, 'nombre': nombre, 'carrera': carrera};
  }
}
