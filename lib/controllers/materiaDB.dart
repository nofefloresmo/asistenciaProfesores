import '../models/materia.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class MateriaDB {
  static Future<int> insert(Materia m) async {
    final Database db = await Conexion.openDB();
    return await db.insert(
      'materia',
      m.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<List<Materia>> getMaterias() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('materia');
    return List.generate(maps.length, (i) {
      return Materia(
        nMat: maps[i]['nMat'],
        descripcion: maps[i]['descripcion'],
      );
    });
  }

  static Future<int> update(Materia m) async {
    final Database db = await Conexion.openDB();
    return await db.update(
      'materia',
      m.toJson(),
      where: 'nMat = ?',
      whereArgs: [m.nMat],
    );
  }

  static Future<int> delete(String nMat) async {
    final Database db = await Conexion.openDB();
    return await db.delete(
      'materia',
      where: 'nMat = ?',
      whereArgs: [nMat],
    );
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    db.delete('materia');
  }
}
