// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';
import '../models/horario.dart';
import '../controllers/horarioDB.dart';
import '../models/profesor.dart';
import '../controllers/profesorDB.dart';
import '../models/materia.dart';
import '../controllers/materiaDB.dart';
// import '../controllers/conexion.dart'; // * @miguel69645 Importo esto para poder usar deleteDB() en el init

class HorariosPage extends StatefulWidget {
  const HorariosPage({super.key});

  @override
  createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  List<Horario> horarios = [];
  final TextEditingController _nHorarioController = TextEditingController();
  final TextEditingController _nProfesorController = TextEditingController();
  final TextEditingController _nMatController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _edificioController = TextEditingController();
  final TextEditingController _salonController = TextEditingController();
  String? _profesorSeleccionado;
  String? _materiaSeleccionada;

  Future<void> loadHorarios() async {
    List<Horario> result = await HorarioDB.getHorarios();
    setState(() {
      horarios = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHorarios();
    // Conexion.deleteDB(); // * USADO PARA REINICIAR LA BD AL DEPURAR
  }

  Future<void> showAddHorarioDialog() async {
    _nHorarioController.clear();
    _nProfesorController.clear();
    _nMatController.clear();
    _horaController.clear();
    _edificioController.clear();
    _salonController.clear();

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar nuevo horario"),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // * LA LLAVE PRIMARIA DE HORARIO AHORA ES AUTOINCREMENTABLE
                  /* TextField(
                    controller: _nHorarioController,
                    decoration: const InputDecoration(
                      labelText: "Número de Horario",
                    ),
                  ), */
                  FutureBuilder<List<Profesor>>(
                    future: ProfesorDB.getProfesores(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Profesor>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text("Error al cargar profesores");
                      }
                      List<DropdownMenuItem<String>> profesorItems =
                          snapshot.data!.map((profesor) {
                        return DropdownMenuItem<String>(
                          value: profesor.nProfesor,
                          child: Text(profesor.nombre),
                        );
                      }).toList();

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: "Seleccionar Profesor"),
                        value: _profesorSeleccionado,
                        items: profesorItems,
                        onChanged: (newValue) {
                          setState(() {
                            _profesorSeleccionado = newValue;
                          });
                        },
                      );
                    },
                  ),
                  FutureBuilder<List<Materia>>(
                    future: MateriaDB.getMaterias(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Materia>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text("Error al cargar materias");
                      }
                      List<DropdownMenuItem<String>> materiaItems =
                          snapshot.data!.map((materia) {
                        return DropdownMenuItem<String>(
                          value: materia.nMat,
                          child: Text(materia.nMat),
                        );
                      }).toList();

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            labelText: "Seleccionar Materia"),
                        value: _materiaSeleccionada,
                        items: materiaItems,
                        onChanged: (newValue) {
                          setState(() {
                            _materiaSeleccionada = newValue;
                          });
                        },
                      );
                    },
                  ),
                  TextField(
                    controller: _horaController,
                    decoration: const InputDecoration(
                      labelText: "Hora",
                    ),
                  ),
                  TextField(
                    controller: _edificioController,
                    decoration: const InputDecoration(
                      labelText: "Edificio",
                    ),
                  ),
                  TextField(
                    controller: _salonController,
                    decoration: const InputDecoration(
                      labelText: "Salón",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_profesorSeleccionado == null ||
                    _materiaSeleccionada == null ||
                    _horaController.text.isEmpty ||
                    _edificioController.text.isEmpty ||
                    _salonController.text.isEmpty) {
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

    if (result != null && result == true) {
      try {
        Horario nuevoHorario = Horario(
          // * AHORA LA LLAVE ES AUTOINCREMENTABLE
          //nHorario: int.parse(_nHorarioController.text),
          nProfesor: _profesorSeleccionado!,
          nMat: _materiaSeleccionada!,
          hora: _horaController.text,
          edificio: _edificioController.text,
          salon: _salonController.text,
        );
        await HorarioDB.insert(nuevoHorario);
        loadHorarios();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Horario agregado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar el horario"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
        print(e);
      }
    }
  }

  Future<void> showEditHorarioDialog(Horario horario) async {
    _nHorarioController.text = horario.nHorario.toString();
    _nProfesorController.text = horario.nProfesor;
    _nMatController.text = horario.nMat;
    _horaController.text = horario.hora;
    _edificioController.text = horario.edificio;
    _salonController.text = horario.salon;

    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar datos del horario"),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
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
                    controller: _nProfesorController,
                    decoration: const InputDecoration(
                      labelText: "Número de Profesor",
                    ),
                    enabled: false,
                  ),
                  TextField(
                    controller: _nMatController,
                    decoration: const InputDecoration(
                      labelText: "Nombre de Materia",
                    ),
                    enabled: false,
                  ),
                  TextField(
                    controller: _horaController,
                    decoration: const InputDecoration(
                      labelText: "Hora",
                    ),
                  ),
                  TextField(
                    controller: _edificioController,
                    decoration: const InputDecoration(
                      labelText: "Edificio",
                    ),
                  ),
                  TextField(
                    controller: _salonController,
                    decoration: const InputDecoration(
                      labelText: "Salón",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nProfesorController.text.isEmpty ||
                    _nMatController.text.isEmpty ||
                    _horaController.text.isEmpty ||
                    _edificioController.text.isEmpty ||
                    _salonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Todos los campos son obligatorios"),
                    backgroundColor: Color.fromARGB(255, 208, 120, 140),
                  ));
                } else {
                  Navigator.pop(context, true); // Guardar cambios
                }
              },
              child: Text("Guardar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cancelar
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (result != null && result == true) {
      try {
        horario.nProfesor = _nProfesorController.text;
        horario.nMat = _nMatController.text;
        horario.hora = _horaController.text;
        horario.edificio = _edificioController.text;
        horario.salon = _salonController.text;

        await HorarioDB.update(horario); // Actualiza el horario
        loadHorarios(); // Actualiza la lista de horarios
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Horario actualizado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar el horario"),
          backgroundColor: const Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios'),
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
                    'Horarios',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: horarios.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(horarios[index].nHorario.toString()),
                          onDismissed: (direction) async {
                            try {
                              await HorarioDB.delete(horarios[index].nHorario!);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("Horario eliminado correctamente"),
                                backgroundColor:
                                    Color.fromARGB(255, 80, 188, 150),
                              ));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Error al eliminar el horario"),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 54, 67),
                              ));
                            }
                            setState(() {
                              horarios.removeAt(index);
                            });
                          },
                          background: Container(color: Colors.red),
                          child: ListTile(
                            title: Text('Horario: ${horarios[index].nHorario}'),
                            subtitle: Text(
                                'Profesor: ${horarios[index].nProfesor}\nMateria: ${horarios[index].nMat}\nHora: ${horarios[index].hora}\nEdificio: ${horarios[index].edificio}\nSalón: ${horarios[index].salon}'),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              showEditHorarioDialog(horarios[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                      title: const Text('Agregar Horario'),
                      leading: const Icon(Icons.add),
                      onTap: () {
                        showAddHorarioDialog();
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
