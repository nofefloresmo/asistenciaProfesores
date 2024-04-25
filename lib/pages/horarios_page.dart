// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/horario.dart';
import '../controllers/horarioDB.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/drawer.dart';

class HorariosPage extends StatefulWidget {
  const HorariosPage({super.key});

  @override
  State createState() => _HorariosPageState();
}

class _HorariosPageState extends State {
  List horarios = [];
  final TextEditingController _nHorarioController = TextEditingController();
  final TextEditingController _nProfesorController = TextEditingController();
  final TextEditingController _nMatController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _edificioController = TextEditingController();
  final TextEditingController _salonController = TextEditingController();

  Future loadHorarios() async {
    List result = await HorarioDB.getHorarios();
    setState(() {
      horarios = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadHorarios();
  }

  Future showEditHorarioDialog(Horario horario) async {
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
                    labelText: "Nombre del Profesor",
                  ),
                ),
                TextField(
                  controller: _nMatController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de la Materia",
                  ),
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
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nHorarioController.text.isEmpty ||
                    _nProfesorController.text.isEmpty ||
                    _nMatController.text.isEmpty ||
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
        horario.nHorario = int.parse(_nHorarioController.text);
        horario.nProfesor = _nProfesorController.text;
        horario.nMat = _nMatController.text;
        horario.hora = _horaController.text;
        horario.edificio = _edificioController.text;
        horario.salon = _salonController.text;
        await HorarioDB.update(horario);
        loadHorarios();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Horario actualizado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al actualizar el horario"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  Future showAddHorarioDialog() async {
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
                  controller: _nProfesorController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del Profesor",
                  ),
                ),
                TextField(
                  controller: _nMatController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de la Materia",
                  ),
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
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_nHorarioController.text.isEmpty ||
                    _nProfesorController.text.isEmpty ||
                    _nMatController.text.isEmpty ||
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

    if (result != null && result) {
      try {
        Horario newHorario = Horario(
          nHorario: int.parse(_nHorarioController.text),
          nProfesor: _nProfesorController.text,
          nMat: _nMatController.text,
          hora: _horaController.text,
          edificio: _edificioController.text,
          salon: _salonController.text,
        );
        await HorarioDB.insert(newHorario);
        loadHorarios();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Horario agregado correctamente"),
          backgroundColor: Color.fromARGB(255, 80, 188, 150),
        ));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error al agregar el horario"),
          backgroundColor: Color.fromARGB(255, 58, 54, 67),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horarios'),
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
                    'Horarios',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: horarios.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Horario: ${horarios[index].nHorario}'),
                          subtitle: Text(
                              'Profesor: ${horarios[index].nProfesor}\nMateria: ${horarios[index].nMat}\nHora: ${horarios[index].hora}\nEdificio: ${horarios[index].edificio}\nSalón: ${horarios[index].salon}'),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            showEditHorarioDialog(horarios[index]);
                          },
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
