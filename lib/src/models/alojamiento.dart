import 'service.dart';

class Alojamiento {
  String id;
  String idUser;
  String nombre;
  String descripcion;
  double precio;
  String direccionId;
  String image1;
  String image2;
  String image3;
  String direccion;
  String neighborhood;
  double lat;
  double lng;
  String? categoriaId;
  List<Service> services;

  Alojamiento({
    required this.id,
    required this.idUser,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.direccionId,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.direccion,
    required this.neighborhood,
    required this.lat,
    required this.lng,
    this.categoriaId,
    this.services = const [],
  });

  factory Alojamiento.fromJson(Map<String, dynamic> json) {
    return Alojamiento(
      id: json['id']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: double.parse(json['precio'] ?? '0.0'),
      direccionId: json['direccion_id'] ?? '',
      image1: json['image1'] ?? '',
      image2: json['image2'] ?? '',
      image3: json['image3'] ?? '',
      direccion: json['direccion'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      lat: double.parse(json['lat'] ?? '0.0'),
      lng: double.parse(json['lng'] ?? '0.0'),
      categoriaId: json['categoria_id']?.toString(),
      services: json['services'] != null
          ? List<Service>.from(json['services'].map((model) => Service.fromJson(model)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'direccion_id': direccionId,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'direccion': direccion,
      'neighborhood': neighborhood,
      'lat': lat,
      'lng': lng,
      'categoria_id': categoriaId,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
