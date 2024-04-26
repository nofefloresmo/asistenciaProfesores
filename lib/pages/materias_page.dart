import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../controllers/materiaDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({super.key});

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  List<Materia> materias = [];
  final TextEditingController _nMatController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  Future<void> loadMaterias() async {
    List<Materia> result = await MateriaDB.getMaterias();
    setState(() {
      materias = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMaterias();
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
        title: const Text('Materias'),
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
                                      "¿Desea eliminar esta materia?"),
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
                            final materiaTemp = materias.removeAt(index);
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
                              // Reinsertar si hubo error
                              materias.insert(index, materiaTemp);
                            }
                          },
                          child: ListTile(
                            title: Text(materias[index].descripcion),
                            subtitle: Text('Código: ${materias[index].nMat}'),
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
                    },
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
