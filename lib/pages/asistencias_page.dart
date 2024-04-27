import 'package:flutter/material.dart';
import '../models/asistencia.dart';
import '../controllers/asistenciaDB.dart';
import '../models/horario.dart';
import '../controllers/horarioDB.dart';
import 'package:intl/intl.dart'; // * Para formatear fechas
import 'package:table_calendar/table_calendar.dart'; // * Para vista en calendario
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class AsistenciasPage extends StatefulWidget {
  const AsistenciasPage({super.key});

  @override
  State<AsistenciasPage> createState() => _AsistenciasPageState();
}

class _AsistenciasPageState extends State<AsistenciasPage> {
  List<Asistencia> asistencias = [];
  List<Horario> horarios = []; // * VISTA POR HORARIOS
  DateTime _selectedDay = DateTime.now(); // * VISTA EN CALENDARIO
  Map<DateTime, List<Asistencia>> _asistenciasPorDia =
      {}; // * VISTA EN CALENDARIO
  String? _horarioSeleccionado;
  int _selectedIndex = 0; // * INDICE PARA EL NAV BAR
  final TextEditingController _nHorarioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _asistenciaController = TextEditingController();

  Future<void> loadData() async {
    List<Asistencia> resultAsistencia = await AsistenciaDB.getAsistencias();
    List<Horario> resultHorario = await HorarioDB.getHorarios();
    setState(() {
      asistencias = resultAsistencia;
      horarios = resultHorario;
      _asistenciasPorDia = _mapAsistenciasPorDia(asistencias);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> showEditAsistenciaDialog(Asistencia asistencia) async {
    _nHorarioController.text = asistencia.nHorario.toString();
    _fechaController.text = asistencia.fecha;
    _asistenciaController.text = asistencia.asistencia ? 'Sí' : 'No';

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar datos de la asistencia"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nHorarioController,
                  decoration: const InputDecoration(
                    labelText: "Número de Horario",
                  ),
                  enabled: false,
                ),
                TextField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: "Fecha",
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _asistenciaController.text,
                  decoration: const InputDecoration(labelText: "Asistencia"),
                  items: const [
                    DropdownMenuItem(value: 'Sí', child: Text("Sí")),
                    DropdownMenuItem(value: 'No', child: Text("No")),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _asistenciaController.text = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_fechaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("El campo de fecha es obligatorio"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Guardar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        asistencia.fecha = _fechaController.text;
        asistencia.asistencia = _asistenciaController.text == 'Sí';
        await AsistenciaDB.update(asistencia);
        loadData(); // Recargar asistencias
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Asistencia actualizada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar la asistencia"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Future<void> showAddAsistenciaDialog() async {
    _nHorarioController.clear();
    _fechaController.clear();
    _asistenciaController.text = '';

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar nueva asistencia"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<List<Horario>>(
                  future: HorarioDB.getHorarios(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Horario>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text("Error al cargar horarios");
                    }
                    List<DropdownMenuItem<String>> horarioItems =
                        snapshot.data!.map((horario) {
                      return DropdownMenuItem<String>(
                        value: horario.nHorario.toString(),
                        child: Text(horario.nHorario.toString()),
                      );
                    }).toList();

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: "Seleccionar Horario"),
                      value: _horarioSeleccionado,
                      items: horarioItems,
                      onChanged: (newValue) {
                        setState(() {
                          _horarioSeleccionado = newValue;
                        });
                      },
                    );
                  },
                ),
                TextField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: "Fecha",
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Asistencia"),
                  items: const [
                    DropdownMenuItem(value: 'Sí', child: Text("Sí")),
                    DropdownMenuItem(value: 'No', child: Text("No")),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _asistenciaController.text = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_horarioSeleccionado == null ||
                    _fechaController.text.isEmpty ||
                    _asistenciaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Guardar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result != null && result == true) {
      try {
        Asistencia newAsistencia = Asistencia(
          nHorario: int.parse(_horarioSeleccionado!),
          fecha: _fechaController.text,
          asistencia: _asistenciaController.text == 'Sí',
        );
        await AsistenciaDB.insert(newAsistencia);
        loadData();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Asistencia agregada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar la asistencia"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  void showAsistenciasPorHorario(int nHorario) {
    final asistenciasPorHorario = asistencias
        .where((asistencia) => asistencia.nHorario == nHorario)
        .toList();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Asistencias para Horario $nHorario"),
          content: SingleChildScrollView(
            child: Column(
              children: asistenciasPorHorario.map((asistencia) {
                return ListTile(
                  title: Text("Fecha: ${asistencia.fecha}"),
                  subtitle: Text(
                    "Asistencia: ${asistencia.asistencia ? 'Sí' : 'No'}",
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // * Cambiar el índice seleccionado
    });
  }

  Widget _buildMainView() {
    return Column(
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
                  child: ListView.builder(
                    itemCount: asistencias.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(asistencias[index].idAsistencia.toString()),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          color: const Color.fromARGB(255, 252, 71, 58),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          color: const Color.fromARGB(255, 252, 71, 58),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirmar Eliminación"),
                                content: const Text(
                                    "¿Desea eliminar esta asistencia?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text("Eliminar"),
                                  ),
                                ],
                              );
                            },
                          );
                          return result ?? false;
                        },
                        onDismissed: (direction) {
                          final asistenciaTemp = asistencias.removeAt(index);
                          try {
                            AsistenciaDB.delete(asistenciaTemp.idAsistencia!);
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Error al eliminar la asistencia"),
                              backgroundColor: Color.fromARGB(255, 58, 54, 67),
                            ));
                            asistencias.insert(index, asistenciaTemp);
                          }
                        },
                        child: ListTile(
                          title:
                              Text("Horario: ${asistencias[index].nHorario}"),
                          subtitle: Text("Fecha: ${asistencias[index].fecha}"),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            showEditAsistenciaDialog(asistencias[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Agregar Asistencia'),
                  leading: const Icon(Icons.add),
                  onTap: () {
                    showAddAsistenciaDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorarioView() {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Asistencias por Horario',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: horarios.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Horario: ${horarios[index].nHorario}"),
                        subtitle: Text(
                            "Profesor: ${horarios[index].nProfesor}\nMateria: ${horarios[index].nMat}"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          showAsistenciasPorHorario(horarios[index].nHorario!);
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
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'Asistencias por Día',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TableCalendar(
                    focusedDay: _selectedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    onDaySelected: _onDaySelected,
                    eventLoader: (day) {
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);
                      return _asistenciasPorDia[normalizedDay] ?? [];
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      _buildMainView(), // Vista principal
      _buildHorarioView(), // Vista por horario
      _buildCalendarView(), // Vista de calendario
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            label: 'Asistencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Por Horario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}
