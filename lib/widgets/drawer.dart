import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/main.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/profesor_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/materias_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/horarios_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/asistencias_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/consultas_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Tec Tepic'),
            accountEmail: Text('tecnologico@tecnm.edu.mx'),
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
            leading: const Icon(Icons.school),
            title: const Text('Profesores'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfesorPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Materias'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MateriasPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Horarios'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HorariosPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Asistencias'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AsistenciasPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Consultas Avanzadas'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsultasPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmación'),
                    content: const Text(
                        '¿Estás seguro de que deseas cerrar la sesión?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Practica0301()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
