import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Recuerda tener fl_chart en pubspec.yaml

class EcoVistaScreen extends StatefulWidget {
  const EcoVistaScreen({super.key});

  @override
  State<EcoVistaScreen> createState() => _EcoVistaScreenState();
}

class _EcoVistaScreenState extends State<EcoVistaScreen> {
  // Estado para los controles deslizantes (Sliders)
  double kgPlastico = 100;
  double anios = 5;
  String tipoPechera = "Desechable";

  @override
  Widget build(BuildContext context) {
    // Cálculos simples para la demo (replicando lógica básica)
    double ahorro = tipoPechera == "Desechable" ? kgPlastico * 0.2 : kgPlastico * 0.8;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("EcoVista: Impacto Ecológico", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 20),

          // --- TARJETAS DE RESUMEN ---
          Row(
            children: [
              _infoCard("Plástico Total", "${kgPlastico.toInt()} kg", Colors.blue),
              _infoCard("Ahorro Estimado", "${ahorro.toInt()} kg", Colors.green),
              _infoCard("CO2 Reducido", "${(ahorro * 1.5).toInt()} kg", Colors.orange),
            ],
          ),
          const SizedBox(height: 30),

          // --- CONTROLES ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Configuración de Proyección"),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Tipo: "),
                      DropdownButton<String>(
                        value: tipoPechera,
                        items: ["Desechable", "Reutilizable"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => tipoPechera = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Kg de Plástico: ${kgPlastico.toInt()}"),
                  Slider(
                    value: kgPlastico,
                    min: 0, max: 1000,
                    activeColor: Colors.green,
                    onChanged: (v) => setState(() => kgPlastico = v),
                  ),
                  Text("Años de Proyección: ${anios.toInt()}"),
                  Slider(
                    value: anios,
                    min: 1, max: 10,
                    divisions: 9,
                    onChanged: (v) => setState(() => anios = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // --- GRÁFICO ---
          Container(
            height: 300,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
                lineBarsData: [
                  // Línea de proyección simulada
                  LineChartBarData(
                    spots: List.generate(anios.toInt(), (index) {
                      return FlSpot(index.toDouble(), (index + 1) * ahorro / 10);
                    }),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoCard(String titulo, String valor, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(titulo, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}