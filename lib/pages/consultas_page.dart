// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/widgets/drawer.dart';

class ConsultasPage extends StatefulWidget {
  const ConsultasPage({super.key});

  @override
  State<ConsultasPage> createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Consulta 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Consulta 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Consulta 3',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      body: Center(
        child: SizedBox.expand(
          child: Card(
            margin: const EdgeInsets.all(10),
            child: dinamico(),
          ),
        ),
      ),
    );
  }

  Widget dinamico() {
    switch (_selectedIndex) {
      case 0:
        return consulta1();
      case 1:
        return consulta2();
      case 2:
        return consulta3();
      default:
        return consulta1();
    }
  }

  Widget consulta1() {
    return Center(
      child: Text('ITEM1'),
    );
  }

  Widget consulta2() {
    return Center(
      child: Text('ITEM2'),
    );
  }

  Widget consulta3() {
    return Center(
      child: Text('ITEM3'),
    );
  }
}
