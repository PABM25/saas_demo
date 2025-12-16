import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MiAppSaaS());
}

class MiAppSaaS extends StatelessWidget {
  const MiAppSaaS({super.key});

  // --- CONFIGURACIÓN DE MARCA BLANCA ---
  static const String tituloApp = "Portal de Gestión"; // Nombre genérico
  static const Color colorCorporativo = Colors.indigo; // Color estándar y serio
  // -------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tituloApp,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Usamos el color corporativo definido arriba
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorCorporativo,
          primary: colorCorporativo,
          secondary: Colors.blueGrey,
        ),
        textTheme: GoogleFonts.interTextTheme(), // Fuente 'Inter' es muy usada en software moderno
        scaffoldBackgroundColor: const Color(0xFFF4F6F8), // Fondo gris profesional
        
        // Estilo estándar para botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorCorporativo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        
        // Estilo estándar para Inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorCorporativo, width: 2)),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}