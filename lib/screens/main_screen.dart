import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:google_fonts/google_fonts.dart';
import '../services/mock_data.dart';
import '../widgets/side_menu.dart';
// Importamos las nuevas pantallas
import 'pecheras_screen.dart';
import 'empresas_screen.dart';
import 'ecovista_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indiceMenu = 0; 
  final MockDataService _servicio = MockDataService();
  
  // Estado del Dashboard
  Map<String, int>? kpis;
  List<Pechera> listaPecheras = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDashboard();
  }

  void _cargarDatosDashboard() async {
    final datosKpi = await _servicio.obtenerKpis();
    final datosPecheras = await _servicio.obtenerPecherasRecientes();
    setState(() {
      kpis = datosKpi;
      listaPecheras = datosPecheras;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          SideMenu(
            indiceSeleccionado: _indiceMenu,
            onMenuClick: (index) => setState(() => _indiceMenu = index),
          ),
          Expanded(
            child: _obtenerVistaActual(), // Función que decide qué mostrar
          ),
        ],
      ),
    );
  }

  // SWITCH DE PANTALLAS
  Widget _obtenerVistaActual() {
    switch (_indiceMenu) {
      case 0: return _buildDashboard(); // Muestra el dashboard definido abajo
      case 1: return const PecherasScreen();
      case 3: return const EmpresasScreen();
      case 6: return const EcoVistaScreen();
      default: 
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 10),
              Text("Módulo en construcción", style: TextStyle(fontSize: 20, color: Colors.grey[600])),
            ],
          ),
        );
    }
  }

  // --- CONTENIDO DEL DASHBOARD (HOME) ---
  Widget _buildDashboard() {
    if (cargando) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Panel Principal", style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Centro de control e información principal", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),

          // KPIs
          Row(
            children: [
              _tarjetaResumen("Total Fabricadas", kpis?['fabricadas'] ?? 0, Colors.blue),
              _tarjetaResumen("Fabricadas Mes", kpis?['mes'] ?? 0, Colors.purple),
              _tarjetaResumen("Pecheras Lavadas", kpis?['lavadas'] ?? 0, Colors.orange),
              _tarjetaResumen("Eliminadas", kpis?['eliminadas'] ?? 0, Colors.red),
            ],
          ),
          
          const SizedBox(height: 30),

          // Gráfico y Tabla Dashboard
          SizedBox(
            height: 400,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.blue, width: 20)]),
                            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: Colors.blue, width: 20)]),
                            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15, color: Colors.blue, width: 20)]),
                            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 10, color: Colors.blue, width: 20)]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Últimas Pecheras Agregadas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listaPecheras.length,
                              itemBuilder: (context, index) {
                                final p = listaPecheras[index];
                                return ListTile(
                                  leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Text(p.uid.substring(4,6), style: const TextStyle(fontSize: 12))),
                                  title: Text(p.uid, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text("Planta: ${p.planta} | Lavados: ${p.lavados}"),
                                  trailing: Chip(
                                    label: Text(p.estado),
                                    backgroundColor: p.estado == 'Bueno' ? Colors.green[100] : Colors.orange[100],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tarjetaResumen(String titulo, int cantidad, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: color, width: 5)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 5),
            Text(cantidad.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}