import '../models/profesor.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class ProfesorDB {
  static Future<int> insert(Profesor p) async {
    final Database db = await Conexion.openDB();
    return await db.insert('profesor', p.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Profesor>> getProfesores() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('profesor');
    return List.generate(maps.length, (i) {
      return Profesor(
          nProfesor: maps[i]['nProfesor'],
          nombre: maps[i]['nombre'],
          carrera: maps[i]['carrera']);
    });
  }

  static Future<int> update(Profesor p) async {
    final Database db = await Conexion.openDB();
    return await db.update('profesor', p.toJson(),
        where: 'nProfesor = ?', whereArgs: [p.nProfesor]);
  }

  static Future<int> delete(String nProfesor) async {
    final Database db = await Conexion.openDB();
    return await db
        .delete('profesor', where: 'nProfesor = ?', whereArgs: [nProfesor]);
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    db.delete('profesor');
  }
}
