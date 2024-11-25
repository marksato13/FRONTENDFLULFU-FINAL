import 'dart:convert';
import 'package:fluflu/src/models/address.dart';
import 'package:fluflu/src/models/service.dart';


class Alojamientoclass {
  String? idUser;
  String? nombre;
  String? descripcion;
  double? precio;
  Address? address;
  String? idCategoria;
  List<String>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Service>? services; // Asociación de servicios

  Alojamientoclass({
    this.idUser,
    this.nombre,
    this.descripcion,
    this.precio,
    this.address,
    this.idCategoria,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.services,
  });

  factory Alojamientoclass.fromJson(Map<String, dynamic> json) {
    return Alojamientoclass(
      idUser: json['id_user'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'] != null ? double.parse(json['precio'].toString()) : null,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      idCategoria: json['id_categoria'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      services: json['services'] != null
          ? List<Service>.from(json['services'].map((s) => Service.fromJson(s)))
          : null, // Mapeo de servicios desde el JSON
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'address': address?.toJson(),
      'id_categoria': idCategoria,
      'images': images,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'services': services?.map((s) => s.toJson()).toList(), // Conversión de servicios a JSON

    };
  }
}
