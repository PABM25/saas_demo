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
  List<Pechera> _pecheras = [];
  List<Pechera> _pecherasFiltradas = [];
  bool _cargando = true;
  String _filtroEmpresa = "Todas";

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final datos = await _servicio.obtenerTodasLasPecheras();
    setState(() {
      _pecheras = datos;
      _pecherasFiltradas = datos;
      _cargando = false;
    });
  }

  void _filtrar(String empresa) {
    setState(() {
      _filtroEmpresa = empresa;
      if (empresa == "Todas") {
        _pecherasFiltradas = _pecheras;
      } else {
        _pecherasFiltradas = _pecheras.where((p) => p.planta == empresa).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gestión de Pecheras", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // --- BARRA DE HERRAMIENTAS (Botones y Filtros) ---
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
          
          // --- FILTROS ---
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Text("Filtrar por Empresa: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _filtroEmpresa,
                  items: ["Todas", "Pesquera Del Sur", "Salmonera Norte"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => _filtrar(v!),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {}, // Lógica mock
                  icon: const Icon(FontAwesomeIcons.fileExcel),
                  label: const Text("Excel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- TABLA DE DATOS ---
          Expanded(
            child: Card(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
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
                    rows: _pecherasFiltradas.map((p) => DataRow(cells: [
                      DataCell(Text(p.uid, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(p.planta)),
                      DataCell(const Text("M")), // Dato mock fijo por simplicidad
                      DataCell(Text(p.lavados.toString())),
                      DataCell(_badgeEstado(p.estado)),
                      DataCell(Row(
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
        ],
      ),
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