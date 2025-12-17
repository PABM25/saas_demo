import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Importamos para leer el color corporativo

class SideMenu extends StatelessWidget {
  final Function(int) onMenuClick;
  final int indiceSeleccionado;

  const SideMenu({
    super.key, 
    required this.onMenuClick, 
    required this.indiceSeleccionado
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos el color primario del tema configurado en main.dart
    final colorPrimario = Theme.of(context).primaryColor;

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                // Icono Genérico de "Dashboard/Gestión"
                Icon(FontAwesomeIcons.cube, size: 40, color: colorPrimario),
                const SizedBox(height: 15),
                const Text(
                  "PORTAL GESTIÓN", // Texto genérico en mayúsculas
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 16, 
                    letterSpacing: 1.2
                  ),
                ),
                const Text(
                  "v1.0 Enterprise",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Opciones del menú
          _botonMenu(context, 0, FontAwesomeIcons.chartPie, "Dashboard"),
          _botonMenu(context, 1, FontAwesomeIcons.layerGroup, "Activos / Pecheras"),
          _botonMenu(context, 2, FontAwesomeIcons.plus, "Registro"),
          _botonMenu(context, 3, FontAwesomeIcons.building, "Empresas Clientes"),
          _botonMenu(context, 4, FontAwesomeIcons.handsBubbles, "Servicios Lavado"),
          _botonMenu(context, 5, FontAwesomeIcons.usersGear, "Usuarios"),
          _botonMenu(context, 6, FontAwesomeIcons.leaf, "Sustentabilidad"),
        ],
      ),
    );
  }

  Widget _botonMenu(BuildContext context, int index, IconData icono, String texto) {
    bool activo = index == indiceSeleccionado;
    final colorPrimario = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: activo ? colorPrimario.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icono, 
          color: activo ? colorPrimario : Colors.grey[600], 
          size: 18
        ),
        title: Text(
          texto,
          style: TextStyle(
            color: activo ? colorPrimario : Colors.grey[700],
            fontWeight: activo ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: () => onMenuClick(index),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}