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
  
  // Usamos Future para manejar la carga de datos sin errores de estado
  late Future<List<EmpresaModelo>> _empresasFuture;

  @override
  void initState() {
    super.initState();
    _empresasFuture = _servicio.obtenerEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CORRECCIÓN 1: Encabezado Responsivo (Wrap)
          // Evita que el botón se salga de la pantalla en celulares
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0, // Espacio horizontal
            runSpacing: 10.0, // Espacio vertical si baja de línea
            children: [
              const Text(
                "Empresas Registradas",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.plus),
                label: const Text("Nueva Empresa"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
          
          const SizedBox(height: 20),
          
          // CORRECCIÓN 2: Manejo de Datos con FutureBuilder
          Expanded(
            child: FutureBuilder<List<EmpresaModelo>>(
              future: _empresasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar datos"));
                }

                final lista = snapshot.data ?? [];

                if (lista.isEmpty) {
                  return const Center(child: Text("No hay empresas registradas."));
                }

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final emp = lista[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          // Icono Izquierdo
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: const Icon(FontAwesomeIcons.building, color: Colors.blue),
                          ),
                          
                          // Título y Subtítulo organizados para no desbordar
                          title: Text(emp.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text("Pecheras: ${emp.cantidadAsociada} | Solicitadas: ${emp.cantidadSolicitada}"),
                              const SizedBox(height: 8),
                              // Chip de Estado movido aquí para evitar error de ancho
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: emp.estado == 'Activa' ? Colors.green[50] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: emp.estado == 'Activa' ? Colors.green.withOpacity(0.5) : Colors.grey,
                                  )
                                ),
                                child: Text(
                                  emp.estado,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: emp.estado == 'Activa' ? Colors.green[800] : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Menú de opciones (siempre fijo a la derecha)
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 1, child: Text("Modificar")),
                              const PopupMenuItem(value: 2, child: Text("Inhabilitar")),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}