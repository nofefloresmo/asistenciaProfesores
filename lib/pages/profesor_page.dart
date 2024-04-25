import 'package:flutter/material.dart';
import '../models/profesor.dart';
import '../controllers/profesorDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class ProfesorPage extends StatefulWidget {
  const ProfesorPage({super.key});

  @override
  State<ProfesorPage> createState() => _ProfesorState();
}

class _ProfesorState extends State<ProfesorPage> {
  List<Profesor> profesores = [];
  final TextEditingController _nProfesorController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();

  Future<void> loadProfesores() async {
    List<Profesor> result = await ProfesorDB.getProfesores();
    setState(() {
      profesores = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfesores();
  }

  Future<void> showEditProfesorDialog(Profesor profesor) async {
    _nProfesorController.text = profesor.nProfesor;
    _nombreController.text = profesor.nombre;
    _carreraController.text = profesor.carrera;

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar datos del profesor"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nProfesorController,
                  decoration: const InputDecoration(
                    labelText: "Número de Profesor",
                  ),
                  enabled: false,
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre Completo",
                  ),
                ),
                TextField(
                  controller: _carreraController,
                  decoration: const InputDecoration(
                    labelText: "Carrera",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nombreController.text.isEmpty ||
                    _carreraController.text.isEmpty) {
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

    if (result != null && result) {
      try {
        profesor.nombre = _nombreController.text;
        profesor.carrera = _carreraController.text;
        await ProfesorDB.update(profesor);
        loadProfesores();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Profesor actualizado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar el profesor"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Future<void> showAddProfesorDialog() async {
    _nProfesorController.clear();
    _nombreController.clear();
    _carreraController.clear();

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar nuevo profesor"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nProfesorController,
                  decoration: const InputDecoration(
                    labelText: "Número de Profesor",
                  ),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre Completo",
                  ),
                ),
                TextField(
                  controller: _carreraController,
                  decoration: const InputDecoration(
                    labelText: "Carrera",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nProfesorController.text.isEmpty ||
                    _nombreController.text.isEmpty ||
                    _carreraController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true);
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
        Profesor newProfesor = Profesor(
          nProfesor: _nProfesorController.text,
          nombre: _nombreController.text,
          carrera: _carreraController.text,
        );
        await ProfesorDB.insert(newProfesor);
        loadProfesores();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Profesor agregado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar el profesor"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores'),
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
                    'Profesores',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: profesores.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            profesores[index].nProfesor.toString(),
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
                            Profesor profesorTemp = profesores[index];
                            try {
                              ProfesorDB.delete(profesorTemp.nProfesor);
                              loadProfesores();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Error al eliminar el profesor"),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 54, 67),
                              ));
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "profesor eliminado correctamente",
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
                                    ProfesorDB.insert(profesorTemp);
                                    loadProfesores();
                                  });
                                },
                              ),
                            ));
                          },
                          child: ListTile(
                            title: Text(profesores[index].nombre),
                            subtitle:
                                Text('Carrera: ${profesores[index].carrera}'),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              showEditProfesorDialog(profesores[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                      title: const Text('Agregar Profesor'),
                      leading: const Icon(Icons.add),
                      onTap: () {
                        showAddProfesorDialog();
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
