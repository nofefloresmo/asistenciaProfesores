import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Future<Database> openDB() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), 'profesores.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('PRAGMA foreign_keys = ON;');
      return await script(db);
    });
    await db.execute('PRAGMA foreign_keys = ON;');
    return db;
  }

  static Future<void> script(Database db) async {
    await db.execute(
      'CREATE TABLE profesor (nProfesor TEXT PRIMARY KEY, nombre TEXT, carrera TEXT)',
    );
    await db.execute(
      'CREATE TABLE materia (nMat TEXT PRIMARY KEY, descripcion TEXT)',
    );
    await db.execute(
      'CREATE TABLE horario (nHorario INTEGER PRIMARY KEY AUTOINCREMENT, nProfesor TEXT, nMat TEXT, hora TEXT, edificio TEXT, salon TEXT, FOREIGN KEY (nProfesor) REFERENCES profesor(nProfesor) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY (nMat) REFERENCES materia(nMat) ON DELETE CASCADE ON UPDATE CASCADE)',
    );
    await db.execute(
      'CREATE TABLE asistencia (idAsistencia INTEGER PRIMARY KEY AUTOINCREMENT, nHorario INTEGER, fecha TEXT, asistencia BOOLEAN, FOREIGN KEY (nHorario) REFERENCES horario(nHorario) ON DELETE CASCADE ON UPDATE CASCADE)',
    );
  }

  static Future<void> closeDB() async {
    final Database db = await openDB();
    db.close();
  }

  static Future<void> deleteDB() async {
    await deleteDatabase(join(await getDatabasesPath(), 'profesores.db'));
  }
}
