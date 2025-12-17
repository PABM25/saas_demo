import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/mock_data.dart';

class PecherasScreen extends StatefulWidget {
  const PecherasScreen({super.key});

  @override
  State<PecherasScreen> createState() => _PecherasScreenState();
}

class _PecherasScreenState extends State<PecherasScreen> {
  final MockDataService _servicio = MockDataService();
  
  // Estado del filtro
  String _filtroEmpresa = "Todas";
  
  // Future para la carga de datos (Patrón Clean)
  late Future<List<Pechera>> _pecherasFuture;

  @override
  void initState() {
    super.initState();
    _pecherasFuture = _servicio.obtenerTodasLasPecheras();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pechera>>(
      future: _pecherasFuture,
      builder: (context, snapshot) {
        // 1. Estado de Carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Estado de Error
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar datos"));
        }

        final todasLasPecheras = snapshot.data ?? [];
        
        // 3. Aplicamos el filtro sobre los datos ya cargados
        final pecherasFiltradas = _filtroEmpresa == "Todas"
            ? todasLasPecheras
            : todasLasPecheras.where((p) => p.planta == _filtroEmpresa).toList();

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Gestión de Pecheras", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // --- BARRA DE HERRAMIENTAS ---
              // Usamos Wrap para que los botones se acomoden automáticamente
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _botonAccion("Info Pechera", FontAwesomeIcons.magnifyingGlass, Colors.blue),
                  _botonAccion("Distribución", FontAwesomeIcons.chartBar, Colors.teal),
                  _botonAccion("Modificar", FontAwesomeIcons.penToSquare, Colors.orange),
                  _botonAccion("Eliminar", FontAwesomeIcons.trash, Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              
              // --- FILTROS (CORREGIDO: RenderFlex Error) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                // CORRECCIÓN 1: Usamos Wrap en lugar de Row.
                // Esto permite que el botón "Excel" baje si no hay espacio.
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    // Grupo etiqueta + dropdown
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Filtrar: "),
                        const SizedBox(width: 5),
                        DropdownButton<String>(
                          value: _filtroEmpresa,
                          items: ["Todas", "Pesquera Del Sur", "Salmonera Norte"]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (v) => setState(() => _filtroEmpresa = v!),
                        ),
                      ],
                    ),
                    
                    // Botón Excel
                    ElevatedButton.icon(
                      onPressed: () {}, 
                      icon: const Icon(FontAwesomeIcons.fileExcel),
                      label: const Text("Excel"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- TABLA DE DATOS (CORREGIDO) ---
              Expanded(
                child: Card(
                  color: Colors.white,
                  child: SingleChildScrollView( // Scroll Vertical original
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView( // CORRECCIÓN 2: Scroll Horizontal
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 600), // Asegura un ancho mínimo
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                          columns: const [
                            DataColumn(label: Text("UID")),
                            DataColumn(label: Text("Planta")),
                            DataColumn(label: Text("Talla")),
                            DataColumn(label: Text("Lavados")),
                            DataColumn(label: Text("Estado")),
                            DataColumn(label: Text("Acciones")),
                          ],
                          rows: pecherasFiltradas.map((p) => DataRow(cells: [
                            DataCell(Text(p.uid, style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(p.planta)),
                            DataCell(const Text("M")),
                            DataCell(Text(p.lavados.toString())),
                            DataCell(_badgeEstado(p.estado)),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                              ],
                            )),
                          ])).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _botonAccion(String texto, IconData icono, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icono, size: 16),
      label: Text(texto),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
    );
  }

  Widget _badgeEstado(String estado) {
    Color color = estado == "Bueno" ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(estado, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}