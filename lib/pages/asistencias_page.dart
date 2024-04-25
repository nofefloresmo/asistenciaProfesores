import 'package:flutter/material.dart';
import '../models/asistencia.dart';
import '../controllers/asistenciaDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class AsistenciasPage extends StatefulWidget {
  const AsistenciasPage({super.key});

  @override
  State<AsistenciasPage> createState() => _AsistenciasPageState();
}

class _AsistenciasPageState extends State<AsistenciasPage> {
  List<Asistencia> asistencias = [];
  final TextEditingController _idAsistenciacontroller = TextEditingController();
  final TextEditingController _nHorarioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _asistenciaController = TextEditingController();

  Future<void> loadAsistencias() async {
    List<Asistencia> result = await AsistenciaDB.getAsistencias();
    setState(() {
      asistencias = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAsistencias();
  }

  Future<void> showEditAsistenciaDialog(Asistencia asistencia) async {
    _nHorarioController.text = asistencia.nHorario.toString();
    _fechaController.text = asistencia.fecha;
    _asistenciaController.text = asistencia.asistencia.toString();

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
                ),
                TextField(
                  controller: _asistenciaController,
                  decoration: const InputDecoration(
                    labelText: "Asistencia",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_fechaController.text.isEmpty ||
                    _asistenciaController.text.isEmpty ||
                    _nHorarioController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true);
                }
              },
              child: Text("Guardar",
                  style: TextStyle(color: Colors.yellowAccent.shade100)),
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
        asistencia.nHorario = int.parse(_nHorarioController.text);
        asistencia.fecha = _fechaController.text;
        asistencia.asistencia = bool.parse(_asistenciaController.text);
        await AsistenciaDB.update(asistencia);
        loadAsistencias();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Asistencia actualizada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
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
    _asistenciaController.clear();

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
                TextField(
                  controller: _nHorarioController,
                  decoration: const InputDecoration(
                    labelText: "Número de Horario",
                  ),
                ),
                TextField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: "Fecha",
                  ),
                ),
                TextField(
                  controller: _asistenciaController,
                  decoration: const InputDecoration(
                    labelText: "Asistencia",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nHorarioController.text.isEmpty ||
                    _fechaController.text.isEmpty ||
                    _asistenciaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true); //
                }
              },
              child: Text("Guardar"),
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

    if (result != null && result) {
      try {
        Asistencia newAsistencia = Asistencia(
          idAsistencia: int.parse(_idAsistenciacontroller.text),
          nHorario: int.parse(_nHorarioController.text),
          fecha: _fechaController.text,
          asistencia: _asistenciaController.text.isNotEmpty,
        );
        await AsistenciaDB.insert(newAsistencia);
        loadAsistencias();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
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
                    child: ListView.builder(
                      itemCount: asistencias.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            asistencias[index].idAsistencia.toString(),
                          ),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            color: const Color.fromARGB(255, 252, 71, 58),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: const Color.fromARGB(255, 252, 71, 58),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            Asistencia asistenciaTemp = asistencias[index];
                            try {
                              AsistenciaDB.delete(asistenciaTemp.idAsistencia);
                              loadAsistencias();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Error al eliminar la asistencia"),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 54, 67),
                              ));
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "Asistencia eliminada correctamente",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 80, 188, 150),
                                      fontWeight: FontWeight.bold)),
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromARGB(255, 58, 54, 67),
                              action: SnackBarAction(
                                label: "Deshacer",
                                onPressed: () {
                                  setState(() {
                                    AsistenciaDB.insert(asistenciaTemp);
                                    loadAsistencias();
                                  });
                                },
                              ),
                            ));
                          },
                          child: ListTile(
                            title:
                                Text('Horario: ${asistencias[index].nHorario}'),
                            subtitle: Text(
                                'Fecha: ${asistencias[index].fecha}\nAsistencia: ${asistencias[index].asistencia}'),
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
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
