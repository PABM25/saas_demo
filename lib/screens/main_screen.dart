import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:google_fonts/google_fonts.dart';
import '../services/mock_data.dart';
import '../widgets/side_menu.dart';
// Importamos las pantallas
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
  
  // Future para carga de datos optimizada
  late Future<Map<String, dynamic>> _datosDashboardFuture;

  @override
  void initState() {
    super.initState();
    _datosDashboardFuture = _cargarDatos();
  }

  Future<Map<String, dynamic>> _cargarDatos() async {
    final resultados = await Future.wait([
      _servicio.obtenerKpis(),
      _servicio.obtenerPecherasRecientes(),
    ]);
    return {
      'kpis': resultados[0] as Map<String, int>,
      'pecheras': resultados[1] as List<Pechera>,
    };
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder nos dice de qué tamaño es la pantalla
    return LayoutBuilder(
      builder: (context, constraints) {
        // Consideramos "Móvil" cualquier pantalla menor a 900px de ancho
        bool isMobile = constraints.maxWidth < 900;

        if (isMobile) {
          // --- DISEÑO MÓVIL (Con Menú Hamburguesa) ---
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              title: Text("Portal SaaS", style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.indigo),
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            // El menú lateral se convierte en un Drawer
            drawer: Drawer(
              child: SideMenu(
                indiceSeleccionado: _indiceMenu,
                onMenuClick: (index) {
                  setState(() => _indiceMenu = index);
                  Navigator.pop(context); // Cierra el menú al seleccionar
                },
              ),
            ),
            body: _obtenerVistaActual(isMobile),
          );
        } else {
          // --- DISEÑO ESCRITORIO (Menú Fijo) ---
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Row(
              children: [
                SideMenu(
                  indiceSeleccionado: _indiceMenu,
                  onMenuClick: (index) => setState(() => _indiceMenu = index),
                ),
                Expanded(
                  child: _obtenerVistaActual(isMobile),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _obtenerVistaActual(bool isMobile) {
    switch (_indiceMenu) {
      case 0: return _buildDashboard(isMobile); 
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

  // --- CONTENIDO DEL DASHBOARD ---
  Widget _buildDashboard(bool isMobile) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _datosDashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final kpis = snapshot.data!['kpis'] as Map<String, int>;
        final listaPecheras = snapshot.data!['pecheras'] as List<Pechera>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Panel Principal", style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Centro de control e información principal", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              // SECCIÓN 1: KPIs (Tarjetas de números)
              // En móvil usamos Grid (cuadrícula), en escritorio Row (fila)
              if (isMobile)
                GridView.count(
                  crossAxisCount: 2, // 2 columnas en celular
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true, // Importante para que no rompa el scroll
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _tarjetaResumen("Total Fabricadas", kpis['fabricadas'] ?? 0, Colors.blue),
                    _tarjetaResumen("Fabricadas Mes", kpis['mes'] ?? 0, Colors.purple),
                    _tarjetaResumen("Pecheras Lavadas", kpis['lavadas'] ?? 0, Colors.orange),
                    _tarjetaResumen("Eliminadas", kpis['eliminadas'] ?? 0, Colors.red),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: _tarjetaResumen("Total Fabricadas", kpis['fabricadas'] ?? 0, Colors.blue)),
                    const SizedBox(width: 15),
                    Expanded(child: _tarjetaResumen("Fabricadas Mes", kpis['mes'] ?? 0, Colors.purple)),
                    const SizedBox(width: 15),
                    Expanded(child: _tarjetaResumen("Pecheras Lavadas", kpis['lavadas'] ?? 0, Colors.orange)),
                    const SizedBox(width: 15),
                    Expanded(child: _tarjetaResumen("Eliminadas", kpis['eliminadas'] ?? 0, Colors.red)),
                  ],
                ),
              
              const SizedBox(height: 30),

              // SECCIÓN 2: Gráficos y Listas
              // En móvil usamos Column (uno abajo de otro), en escritorio Row (lado a lado)
              if (isMobile)
                 Column(
                   children: [
                     SizedBox(height: 300, child: _buildGraficoCard()),
                     const SizedBox(height: 20),
                     SizedBox(height: 400, child: _buildListaCard(listaPecheras)),
                   ],
                 )
              else
                SizedBox(
                  height: 400,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _buildGraficoCard()),
                      const SizedBox(width: 20),
                      Expanded(flex: 2, child: _buildListaCard(listaPecheras)),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  // Widget auxiliar para el gráfico
  Widget _buildGraficoCard() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.blue, width: 15)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: Colors.blue, width: 15)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15, color: Colors.blue, width: 15)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 10, color: Colors.blue, width: 15)]),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para la lista
  Widget _buildListaCard(List<Pechera> listaPecheras) {
    return Card(
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
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Text(p.uid.substring(4,6), style: const TextStyle(fontSize: 12))),
                    title: Text(p.uid, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("Planta: ${p.planta}", style: const TextStyle(fontSize: 12)),
                    trailing: Chip(
                      label: Text(p.estado, style: const TextStyle(fontSize: 10)),
                      backgroundColor: p.estado == 'Bueno' ? Colors.green[100] : Colors.orange[100],
                      padding: EdgeInsets.zero,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de tarjeta KPI modificado para ser flexible
  Widget _tarjetaResumen(String titulo, int cantidad, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(color: Colors.grey[600], fontSize: 12), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 5),
          Text(cantidad.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}