# 🏢 Portal de Gestión Enterprise (SaaS White Label)

> **Solución multiplataforma de gestión de activos y sustentabilidad para entornos industriales.**
> *Desarrollado con Flutter & Clean Architecture.*

![Banner del Proyecto](https://via.placeholder.com/1000x400.png?text=Vista+Previa+del+Dashboard+Corporativo)

## 📋 Descripción

Este proyecto es una demostración técnica de un **Sistema de Gestión de Recursos (ERP)** diseñado bajo el modelo **White Label** (Marca Blanca). La arquitectura permite que el software adapte su identidad visual (colores, logos y nombres) dinámicamente según el cliente corporativo, utilizando una única base de código.

El sistema simula un entorno de producción real para la gestión de inventario, control de calidad y análisis de impacto ambiental ("EcoVista"), ideal para industrias como la pesquera, minera o manufacturera.

## 🚀 Características Principales

* **🎨 Diseño White Label:** Sistema de temas dinámico que permite personalizar la identidad corporativa en segundos desde una configuración centralizada.
* **📊 Dashboard Ejecutivo:** Visualización de KPIs en tiempo real con gráficos interactivos y resumen de operaciones.
* **📦 Gestión de Activos:** Control de inventario, trazabilidad de estados y ciclos de vida de productos (EPP/Pecheras).
* **🏭 Multi-Empresa:** Arquitectura preparada para entornos SaaS multi-tenant, gestionando diferentes plantas o clientes.
* **🌱 Módulo EcoVista:** Calculadora de impacto ambiental que proyecta la reducción de huella de carbono y ahorro de plásticos.
* **📱 Multiplataforma:** Compilado desde una sola base de código para **Web, Windows, macOS, Android e iOS**.

## 🛠️ Tecnologías y Arquitectura

Este proyecto utiliza un ecosistema **Flutter** moderno para maximizar la portabilidad y el rendimiento.

* **Frontend/Mobile:** Flutter (Dart).
* **Arquitectura:** Clean Architecture (Separación de Capas: UI, Dominio, Datos).
* **Gestión de Estado:** Optimizado para demos fluidas.
* **Gráficos:** Librería `fl_chart` para visualización de datos.
* **Iconografía:** FontAwesome & Google Fonts (Inter).
* **Backend:** *Serverless Mock Mode* (Patrón de Repositorio para simulación de datos y portabilidad total).

## 📸 Galería de Vistas

| Login Corporativo | Gestión de Inventario | Módulo EcoVista |
|:---:|:---:|:---:|
| ![Login](https://via.placeholder.com/300x200?text=Login) | ![Tabla](https://via.placeholder.com/300x200?text=Inventario) | ![EcoVista](https://via.placeholder.com/300x200?text=EcoVista) |

*(Nota: Estas imágenes son referenciales. El diseño final se adapta al manual de marca del cliente).*

## 🔧 Instalación y Despliegue

Este repositorio está configurado como **Demo Pública**. No requiere backend ni base de datos, ya que utiliza un servicio de datos simulados (`MockDataService`) para facilitar la revisión del código y la funcionalidad inmediata.

### Requisitos Previos
* Flutter SDK (v3.0 o superior)
* Dart SDK


## 🔒 Estructura del Proyecto

El código sigue una estructura modular para facilitar la escalabilidad y el mantenimiento:

```text
lib/
├── models/       # Definición de entidades de negocio
├── screens/      # Pantallas (Dashboard, Login, Inventario)
├── services/     # Capa de datos (Mock Repositories)
├── theme/        # Configuración de estilos y White Label
├── widgets/      # Componentes UI reutilizables (Sidebar, Cards)
└── main.dart     # Punto de entrada y configuración de marca