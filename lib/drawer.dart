// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/main.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/profesor_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/materias_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/horarios_page.dart';
import 'package:dam_u3_practica1_asistenciaprofesores/pages/asistencias_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfesorPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Materias'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MateriasPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Horarios'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HorariosPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Asistencias'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AsistenciasPage()));
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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirmación'),
                    content:
                        Text('¿Estás seguro de que deseas cerrar la sesión?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Practica0301()),
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
