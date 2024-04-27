import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/asistencia.dart';
import '../controllers/asistenciaDB.dart';
import '../controllers/horarioDB.dart';
import '../controllers/profesorDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class ConsultasPage extends StatefulWidget {
  const ConsultasPage({super.key});

  @override
  createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  List<Asistencia> asistencias = [];
  Map<DateTime, List<Asistencia>> _asistenciasPorDia = {};
  DateTime _selectedDay = DateTime.now();

  Future<void> loadData() async {
    List<Asistencia> resultAsistencia = await AsistenciaDB.getAsistencias();
    setState(() {
      asistencias = resultAsistencia;
      _asistenciasPorDia = _mapAsistenciasPorDia(asistencias);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Map<DateTime, List<Asistencia>> _mapAsistenciasPorDia(
      List<Asistencia> asistencias) {
    final Map<DateTime, List<Asistencia>> map = {};
    for (final asistencia in asistencias) {
      final date = DateTime.parse(asistencia.fecha).toLocal();
      final normalizedDate = DateTime(date.year, date.month, date.day);

      if (map.containsKey(normalizedDate)) {
        map[normalizedDate]!.add(asistencia);
      } else {
        map[normalizedDate] = [asistencia];
      }
    }
    return map;
  }

  Future<List<String>> _getProfesoresPorDia(DateTime day) async {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final asistenciasDelDia = _asistenciasPorDia[normalizedDay] ?? [];

    final nombres = await Future.wait(
      asistenciasDelDia.map((asistencia) async {
        final horario = await HorarioDB.getHorarioById(asistencia.nHorario);
        final profesor =
            await ProfesorDB.getProfesorPorNumero(horario.nProfesor);
        return profesor.nombre;
      }),
    );

    return nombres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores por Día'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Asistencias',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Selecciona un día para ver los profesores que asistieron',
                            style: TextStyle(fontSize: 18),
                          ),
                          Expanded(
                            child: TableCalendar(
                              focusedDay: _selectedDay,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              eventLoader: (day) {
                                final normalizedDay =
                                    DateTime(day.year, day.month, day.day);
                                return _asistenciasPorDia[normalizedDay] ?? [];
                              },
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              onDaySelected: (selectedDay, focusedDay) async {
                                _selectedDay = selectedDay;

                                final nombresProfesores =
                                    await _getProfesoresPorDia(selectedDay);

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Profesores que asistieron el ${DateFormat('yyyy-MM-dd').format(selectedDay)}",
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: nombresProfesores
                                            .map((nombre) =>
                                                ListTile(title: Text(nombre)))
                                            .toList(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cerrar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
