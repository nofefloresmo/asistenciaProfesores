class Asistencia {
  int idAsistencia;
  int nHorario;
  String fecha;
  bool asistencia;

  Asistencia(
      {required this.idAsistencia,
      required this.nHorario,
      required this.fecha,
      required this.asistencia});

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
        idAsistencia: json['idAsistencia'],
        nHorario: json['nHorario'],
        fecha: json['fecha'],
        asistencia: json['asistencia']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idAsistencia': idAsistencia,
      'nHorario': nHorario,
      'fecha': fecha,
      'asistencia': asistencia
    };
  }
}
