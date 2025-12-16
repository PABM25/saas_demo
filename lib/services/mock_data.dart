import 'dart:async';

// MODELO: Pechera
class Pechera {
  final String uid;
  final String planta;
  final String talla;
  final int lavados;
  final String estado;

  Pechera({
    required this.uid,
    required this.planta,
    required this.talla,
    required this.lavados,
    required this.estado,
  });
}

// MODELO: Empresa
class EmpresaModelo {
  final String id;
  final String nombre;
  final int cantidadAsociada;
  final int cantidadSolicitada;
  final int kilos;
  String estado; // 'Activa' o 'Inactiva'

  EmpresaModelo({
    required this.id,
    required this.nombre,
    required this.cantidadAsociada,
    required this.cantidadSolicitada,
    required this.kilos,
    required this.estado,
  });
}

// SERVICIO DE DATOS (BACKEND FALSO)
class MockDataService {
  
  // -- KPI / DASHBOARD --
  Future<Map<String, int>> obtenerKpis() async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    return {
      'fabricadas': 150,
      'mes': 25,
      'lavadas': 320,
      'eliminadas': 5,
      'stock': 30,
    };
  }

  // -- DASHBOARD: LISTA CORTA --
  Future<List<Pechera>> obtenerPecherasRecientes() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Pechera(uid: 'UID-111', planta: 'Planta A', talla: 'M', lavados: 5, estado: 'Bueno'),
      Pechera(uid: 'UID-222', planta: 'Planta B', talla: 'L', lavados: 2, estado: 'Excelente'),
      Pechera(uid: 'UID-333', planta: 'Planta A', talla: 'S', lavados: 12, estado: 'Desgaste'),
      Pechera(uid: 'UID-444', planta: 'Planta C', talla: 'M', lavados: 0, estado: 'Nueva'),
      Pechera(uid: 'UID-555', planta: 'Planta B', talla: 'XL', lavados: 8, estado: 'Regular'),
    ];
  }

  // -- GESTIÓN PECHERAS: LISTA COMPLETA --
  Future<List<Pechera>> obtenerTodasLasPecheras() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Generamos 20 datos ficticios automáticamente
    return List.generate(20, (index) {
      String planta = index % 2 == 0 ? 'Pesquera Del Sur' : 'Salmonera Norte';
      String estado = index % 5 == 0 ? 'Dada de baja' : 'Bueno';
      return Pechera(
        uid: 'UID-${1000 + index}',
        planta: planta,
        talla: index % 3 == 0 ? 'M' : 'L',
        lavados: index * 3,
        estado: estado,
      );
    });
  }

  // -- EMPRESAS --
  Future<List<EmpresaModelo>> obtenerEmpresas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      EmpresaModelo(id: '1', nombre: 'Pesquera Del Sur', cantidadAsociada: 100, cantidadSolicitada: 5, kilos: 50, estado: 'Activa'),
      EmpresaModelo(id: '2', nombre: 'Salmonera Norte', cantidadAsociada: 80, cantidadSolicitada: 2, kilos: 40, estado: 'Activa'),
      EmpresaModelo(id: '3', nombre: 'Procesadora Central', cantidadAsociada: 0, cantidadSolicitada: 0, kilos: 0, estado: 'Inactiva'),
      EmpresaModelo(id: '4', nombre: 'Alimentos del Mar', cantidadAsociada: 120, cantidadSolicitada: 10, kilos: 60, estado: 'Activa'),
    ];
  }
}