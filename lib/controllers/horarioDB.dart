import '../models/horario.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class HorarioDB {
  static Future<int> insert(Horario h) async {
    final Database db = await Conexion.openDB();
    return await db.insert('horario', h.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Horario>> getHorarios() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('horario');
    return List.generate(maps.length, (i) {
      return Horario(
          nHorario: maps[i]['nHorario'],
          nProfesor: maps[i]['nProfesor'],
          nMat: maps[i]['nMat'],
          hora: maps[i]['hora'],
          edificio: maps[i]['edificio'],
          salon: maps[i]['salon']);
    });
  }

  static Future<int> update(Horario h) async {
    final Database db = await Conexion.openDB();
    return await db.update('horario', h.toJson(),
        where: 'nHorario = ?', whereArgs: [h.nHorario]);
  }

  static Future<int> delete(int nHorario) async {
    final Database db = await Conexion.openDB();
    return await db
        .delete('horario', where: 'nHorario = ?', whereArgs: [nHorario]);
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    db.delete('horario');
  }
}
