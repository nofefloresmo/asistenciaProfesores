import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio - Asistencia de Profesores'),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text(
          "BIENVENIDO",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
