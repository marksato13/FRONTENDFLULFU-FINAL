class Service {
  String id;
  String nombre;
  String descripcion;

  Service({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'].toString(),
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
  };
}
