import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el tema para los colores
    final colorPrimario = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo de la marca (Icono genérico)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorPrimario.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(FontAwesomeIcons.cube, size: 40, color: colorPrimario),
                ),
                const SizedBox(height: 30),
                
                const Text(
                  "Bienvenido",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Ingrese sus credenciales para continuar",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                
                const TextField(
                  decoration: InputDecoration(
                    labelText: "Usuario o Correo Corporativo",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 20),
                
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){}, 
                    child: const Text("¿Olvidó su contraseña?")
                  ),
                ),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                    child: const Text("INICIAR SESIÓN", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text("Powered by SaaS Solutions © 2024", style: TextStyle(fontSize: 10, color: Colors.grey))
              ],
            ),
          ),
        ),
      ),
    );
  }
}