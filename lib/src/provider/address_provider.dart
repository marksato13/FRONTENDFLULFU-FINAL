import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/address.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:http/http.dart' as http;

class AddressProvider {
  String _url = Environment.API_FLUFLU; // URL base de la API
  String _api = '/api/address'; // Ruta base de direcciones

  late BuildContext context;

  // Método para inicializar el contexto
  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  /// Crear una nueva dirección
  Future<ResponseApi> create(Address address) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(address.toJson());
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseApi.fromJson(data);
    } catch (e) {
      print('Error al crear dirección: $e');
      return ResponseApi(
        success: false,
        message: 'Error al crear dirección',
        error: e.toString(),
      );
    }
  }

  /// Obtener todas las direcciones de un usuario por su ID
  Future<List<Address>> findByUserId(String userId) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByUserId/$userId');
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body)['data'];
        return data.map((json) => Address.fromJson(json)).toList();
      } else {
        print('Error al obtener direcciones, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener direcciones: $e');
      return [];
    }
  }

  /// Actualizar una dirección existente
  Future<ResponseApi> update(Address address) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      String bodyParams = json.encode(address.toJson());
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseApi.fromJson(data);
    } catch (e) {
      print('Error al actualizar dirección: $e');
      return ResponseApi(
        success: false,
        message: 'Error al actualizar dirección',
        error: e.toString(),
      );
    }
  }

  /// Eliminar una dirección por su ID
  Future<ResponseApi> delete(String addressId) async {
    try {
      Uri url = Uri.http(_url, '$_api/delete/$addressId');
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.delete(url, headers: headers);
      final data = json.decode(res.body);

      return ResponseApi.fromJson(data);
    } catch (e) {
      print('Error al eliminar dirección: $e');
      return ResponseApi(
        success: false,
        message: 'Error al eliminar dirección',
        error: e.toString(),
      );
    }
  }

  /// Obtener una dirección por su ID
  Future<Address?> findById(String addressId) async {
    try {
      Uri url = Uri.http(_url, '$_api/findById/$addressId');
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'];
        return Address.fromJson(data);
      } else {
        print('Error al obtener dirección, código: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al obtener dirección: $e');
      return null;
    }
  }
}
