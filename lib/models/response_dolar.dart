class DolarEuro {
  final String fuente;
  final String nombre;
  final String moneda;
  final dynamic compra;
  final dynamic venta;
  final double promedio;
  final DateTime fechaActualizacion;

  DolarEuro({
    required this.fuente,
    required this.nombre,
    required this.moneda,
    this.compra,
    this.venta,
    required this.promedio,
    required this.fechaActualizacion,
  });

  DolarEuro.fromJson(Map<String, dynamic> json)
    : fuente = json['fuente']?.toString() ?? 'desconocida',
      nombre = json['nombre']?.toString() ?? 'Sin nombre',
      moneda = json['moneda']?.toString() ?? 'VES',
      compra = json['compra'], // Dinámico, acepta null
      venta = json['venta'], // Dinámico, acepta null
      promedio = (json['promedio'] ?? 0.0).toDouble(),
      fechaActualizacion = json['fechaActualizacion'] != null
          ? DateTime.parse(json['fechaActualizacion'])
          : DateTime.now();
}
