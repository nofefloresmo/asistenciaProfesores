class Materia {
  String nMat;
  String descripcion;

  Materia({required this.nMat, required this.descripcion});

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(nMat: json['nMat'], descripcion: json['descripcion']);
  }

  Map<String, dynamic> toJson() {
    return {'nMat': nMat, 'descripcion': descripcion};
  }
}
