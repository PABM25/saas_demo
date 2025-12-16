import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/mock_data.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({super.key});

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  final MockDataService _servicio = MockDataService();
  List<EmpresaModelo> _empresas = [];

  @override
  void initState() {
    super.initState();
    _cargarEmpresas();
  }

  void _cargarEmpresas() async {
    final datos = await _servicio.obtenerEmpresas();
    setState(() => _empresas = datos);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Empresas Registradas", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.plus),
                label: const Text("Nueva Empresa"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _empresas.length,
              itemBuilder: (context, index) {
                final emp = _empresas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: const Icon(FontAwesomeIcons.building, color: Colors.blue),
                    ),
                    title: Text(emp.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Pecheras: ${emp.cantidadAsociada} | Solicitadas: ${emp.cantidadSolicitada}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(emp.estado),
                          backgroundColor: emp.estado == 'Activa' ? Colors.green[100] : Colors.grey[300],
                        ),
                        const SizedBox(width: 10),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 1, child: Text("Modificar")),
                            const PopupMenuItem(value: 2, child: Text("Inhabilitar")),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}