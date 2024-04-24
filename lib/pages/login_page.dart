import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _visible = true; // Variable para mostrar u ocultar la contraseña
  Route homePageRoute = MaterialPageRoute(builder: (BuildContext context) {
    return HomePage();
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeControlers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 170),
              Container(
                width: 200,
                height: 200,
                alignment: AlignmentGeometry.lerp(
                    Alignment.centerLeft, Alignment.centerRight, 0.5),
                child: Image.asset(
                  'assets/logo/ittb&w.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                widthFactor: 6,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 360,
                height: 35,
                alignment: AlignmentGeometry.lerp(
                    Alignment.centerLeft, Alignment.centerRight, 0.5),
                child: const AutoSizeText(
                  "REGISTRO DE ASISTENCIA DE DOCENCIA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    textFormFieldLogin(
                      icon: Icons.person,
                      label: 'Usuario',
                      hint: 'Escribe tu usuario',
                      controller: _usernameController,
                      autofocus: true,
                    ),
                    const SizedBox(height: 10),
                    textFormFieldLogin(
                      icon: Icons.lock,
                      label: 'Contraseña',
                      hint: 'Escribe tu contraseña',
                      controller: _passwordController,
                      autofocus: false,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 200,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.redAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(context, homePageRoute);
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormFieldLogin({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool autofocus,
    bool obscureText = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      onTap: onTap,
      validator: label == 'Usuario'
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Usuario requerido';
              }
              if (value != 'a') {
                return 'Usuario incorrecto';
              }
              return null;
            }
          : (value) {
              if (value == null || value.isEmpty) {
                return 'Contraseña requerida';
              }
              if (value != 'a') {
                return 'Contraseña incorrecta';
              }
              return null;
            },
      obscureText: label == 'Contraseña' ? _visible : obscureText,
      autofocus: autofocus,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white.withOpacity(0.05),
        filled: true,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 232, 57, 115)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white10),
        labelText: label,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF252525),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF03A9F4),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFB00020),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFB00020),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(_visible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
              )
            : null,
      ),
      controller: controller,
    );
  }

  void disposeControlers() {
    _usernameController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
  }
}
