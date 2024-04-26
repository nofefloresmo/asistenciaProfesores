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
                          key: Key(profesores[index]
                              .nProfesor
                              .toString()), // Asegúrate de que las claves sean únicas
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            color: const Color.fromARGB(255, 252, 71, 58),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
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
                                      "Eliminar este profesor también eliminará sus horarios. ¿Desea continuar?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, false); // Mantener el ítem
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, true); // Eliminar el ítem
                                      },
                                      child: const Text("Eliminar"),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Devuelve `true` para confirmar eliminación, `false` para cancelar
                            return result ?? false;
                          },
                          onDismissed: (direction) async {
                            final profesorTemp = profesores
                                .removeAt(index); // Eliminar del estado
                            try {
                              await ProfesorDB.delete(profesorTemp
                                  .nProfesor); // Eliminar de la base de datos
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Error al eliminar el profesor"),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 54, 67),
                              ));
                              // Reinsertar si hubo error
                              profesores.insert(index, profesorTemp);
                            }
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
