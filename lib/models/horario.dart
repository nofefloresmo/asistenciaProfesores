class Horario {
  int nHorario;
  String nProfesor;
  String nMat;
  String hora;
  String edificio;
  String salon;

  Horario(
      {required this.nHorario,
      required this.nProfesor,
      required this.nMat,
      required this.hora,
      required this.edificio,
      required this.salon});

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
        nHorario: json['nHorario'],
        nProfesor: json['nProfesor'],
        nMat: json['nMat'],
        hora: json['hora'],
        edificio: json['edificio'],
        salon: json['salon']);
  }

  Map<String, dynamic> toJson() {
    return {
      'nHorario': nHorario,
      'nProfesor': nProfesor,
      'nMat': nMat,
      'hora': hora,
      'edificio': edificio,
      'salon': salon
    };
  }
}
