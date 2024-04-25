import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Future<Database> openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'profesores.db'),
        version: 1, onCreate: (Database db, int version) async {
      return await script(db);
    });
  }

  /* static Future<void> script(Database db) async {
    db.execute(
        'CREATE TABLE profesor (nProfesor TEXT PRIMARY KEY, nombre TEXT, carrera TEXT)');
    db.execute(
        'CREATE TABLE materia (nMat TEXT PRIMARY KEY, descripcion TEXT)');
    db.execute(
        'CREATE TABLE horario (nHorario INTEGER PRIMARY KEY, nProfesor TEXT, nMat TEXT, hora TEXT, edificio TEXT, salon TEXT, FOREIGN KEY (nProfesor) REFERENCES profesor(nProfesor) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY (nMat) REFERENCES materia(nMat) ON DELETE CASCADE ON UPDATE CASCADE)');
    db.execute(
        'CREATE TABLE asistencia (idAsistencia INTEGER PRIMARY KEY, nHorario INTEGER, fecha TEXT, asistencia BOOLEAN, FOREIGN KEY (nHorario) REFERENCES horario(nHorario) ON DELETE CASCADE ON UPDATE CASCADE)');
  } */

  static Future<void> script(Database db) async {
    await db.execute(
      'CREATE TABLE profesor (nProfesor TEXT PRIMARY KEY, nombre TEXT, carrera TEXT)',
    );
    await db.execute(
      'CREATE TABLE materia (nMat TEXT PRIMARY KEY, descripcion TEXT)',
    );
    await db.execute(
      'CREATE TABLE horario (nHorario INTEGER PRIMARY KEY, nProfesor TEXT, nMat TEXT, hora TEXT, edificio TEXT, salon TEXT, FOREIGN KEY (nProfesor) REFERENCES profesor(nProfesor) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY (nMat) REFERENCES materia(nMat) ON DELETE CASCADE ON UPDATE CASCADE)',
    );
    await db.execute(
      'CREATE TABLE asistencia (idAsistencia INTEGER PRIMARY KEY, nHorario INTEGER, fecha TEXT, asistencia BOOLEAN, FOREIGN KEY (nHorario) REFERENCES horario(nHorario) ON DELETE CASCADE ON UPDATE CASCADE)',
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
