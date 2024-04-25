// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../controllers/materiaDB.dart';
import '../models/profesor.dart';
import '../controllers/profesorDB.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  final TextEditingController _nMatController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nProfesorController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();

  Future<void> loadProfesores() async {
    List<Profesor> result = await ProfesorDB.getProfesores();
    setState(() {
      profesores = result;
    });
  }

  Future<void> loadMaterias() async {
    List<Materia> result = await MateriaDB.getMaterias();
    setState(() {
      materias = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfesores();
    loadMaterias();
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

  Future<void> showEditMateriaDialog(Materia materia) async {
    _nMatController.text = materia.nMat;
    _descripcionController.text = materia.descripcion;

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar datos de la materia"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nMatController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de Materia",
                  ),
                  enabled: false,
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_descripcionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("El campo de descripción es obligatorio"),
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
        materia.descripcion = _descripcionController.text;
        await MateriaDB.update(materia);
        loadMaterias();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Materia actualizada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar la materia"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Future<void> showAddMateriaDialog() async {
    _nMatController.clear();
    _descripcionController.clear();

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar nueva materia"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nMatController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de Materia",
                  ),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nMatController.text.isEmpty ||
                    _descripcionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true); //
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
        Materia newMateria = Materia(
          nMat: _nMatController.text,
          descripcion: _descripcionController.text,
        );
        await MateriaDB.insert(newMateria);
        loadMaterias();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Materia agregada correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar la materia"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio - Asistencia de Profesores'),
      ),
      drawer: Drawer(
        // backgroundColor: Color.fromRGBO(30, 142, 212, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nombre del Usuario'),
              accountEmail: Text('usuario@ejemplo.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/logo/tec.png'),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo/header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Profesores'),
              onTap: () {
                Navigator.pushNamed(context, '/profesores');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Materias'),
              onTap: () {
                Navigator.pushNamed(context, '/materias');
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Horarios'),
              onTap: () {
                Navigator.pushNamed(context, '/horarios');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Asistencias'),
              onTap: () {
                Navigator.pushNamed(context, '/asistencias');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuraciones'),
              onTap: () {
                Navigator.pushNamed(context, '/configuraciones');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // Icono de logout
              title: Text('Logout'), // Texto del botón
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Materias',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: materias.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            materias[index].nMat.toString(),
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
                            Materia materiaTemp = materias[index];
                            try {
                              MateriaDB.delete(materiaTemp.nMat);
                              loadMaterias();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Error al eliminar la materia"),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 54, 67),
                              ));
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  "materia eliminada correctamente",
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
                                    MateriaDB.insert(materiaTemp);
                                    loadMaterias();
                                  });
                                },
                              ),
                            ));
                          },
                          child: ListTile(
                            title: Text(materias[index].descripcion),
                            subtitle: Text('Nombre: ${materias[index].nMat}'),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              showEditMateriaDialog(materias[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                      title: const Text('Agregar Materia'),
                      leading: const Icon(Icons.add),
                      onTap: () {
                        showAddMateriaDialog();
                      }),
                ],
              ),
            ),
          ),
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
