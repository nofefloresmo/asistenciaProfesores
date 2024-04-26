import '../models/asistencia.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class AsistenciaDB {
  static Future<int> insert(Asistencia a) async {
    final Database db = await Conexion.openDB();
    return await db.insert('asistencia', a.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Asistencia>> getAsistencias() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('asistencia');
    return List.generate(maps.length, (i) {
      return Asistencia(
          idAsistencia: maps[i]['idAsistencia'],
          nHorario: maps[i]['nHorario'],
          fecha: maps[i]['fecha'],
          asistencia: maps[i]['asistencia'] == 1);
    });
  }

  static Future<int> update(Asistencia a) async {
    final Database db = await Conexion.openDB();
    return await db.update('asistencia', a.toJson(),
        where: 'idAsistencia = ?', whereArgs: [a.idAsistencia]);
  }

  static Future<int> delete(int idAsistencia) async {
    final Database db = await Conexion.openDB();
    return await db.delete('asistencia',
        where: 'idAsistencia = ?', whereArgs: [idAsistencia]);
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    db.delete('asistencia');
  }
}
