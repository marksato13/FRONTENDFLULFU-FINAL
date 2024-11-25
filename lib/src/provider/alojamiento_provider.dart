import 'dart:convert';
import 'dart:io';
import 'package:fluflu/src/models/service.dart';
import 'package:flutter/material.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/alojamiento.dart';
import 'package:fluflu/src/models/categoria.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class AlojamientoProvider {
  String _url = Environment.API_FLUFLU; // URL base de la API
  String _api = '/api/alojamientos'; // Ruta de alojamientos
  String _apiCategorias = '/api/categorias'; // Ruta de categorías

  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }






  Future<List<Service>> getAllServices() async {
    try {
      Uri url = Uri.http(_url, '/api/services/getAll');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> servicesJson = json.decode(response.body);
        return servicesJson.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener servicios');
      }
    } catch (e) {
      throw Exception('Error al obtener servicios: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getAllCategorias() async {
    try {
      Uri url = Uri.http(_url, '/api/categorias/getAll');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      throw Exception('Error al obtener categorías');
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }







  /// Filtrar alojamientos por categoría y servicios
  Future<List<Alojamiento>> findByFilters({String? categoriaId, List<int>? serviceIds}) async {
    try {
      // Construir la URL con parámetros de consulta
      final Map<String, String> queryParams = {};

      if (categoriaId != null) {
        queryParams['categoriaId'] = categoriaId;
      }
      if (serviceIds != null && serviceIds.isNotEmpty) {
        queryParams['serviceIds'] = serviceIds.join(',');
      }

      Uri url = Uri.http(_url, '$_api/filter', queryParams);

      // Encabezados
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,
      };

      // Solicitud GET
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body)['data'];
        return data.map((json) => Alojamiento.fromJson(json)).toList();
      } else {
        print('Error al filtrar alojamientos, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al filtrar alojamientos: $e');
      return [];
    }
  }










  /// Obtener todas las categorías
  Future<List<Categoria>> getCategorias() async {
    try {
      Uri url = Uri.http(_url, '$_apiCategorias/getAll');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body)['data'];
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        print('Error al obtener categorías, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }

  /// Obtener todos los alojamientos
  Future<List<Alojamiento>> getAll({bool isGuest = false}) async {
    try {
      Uri url = Uri.http(_url, isGuest ? '$_api/getAllGuest' : '$_api/getAll');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        if (!isGuest) 'Authorization': sessionUser.sessionToken,
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((json) => Alojamiento.fromJson(json)).toList();
      } else {
        print('Error al obtener alojamientos, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener alojamientos: $e');
      return [];
    }
  }

  /// Obtener alojamientos por usuario (propietario)
  Future<List<Alojamiento>> findByUserId(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/user/$idUser');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((json) => Alojamiento.fromJson(json)).toList();
      } else {
        print('Error al obtener alojamientos por usuario, código: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener alojamientos por usuario: $e');
      return [];
    }
  }

  /// Eliminar un alojamiento
  Future<bool> deleteAlojamiento(String idAlojamiento) async {
    try {
      Uri url = Uri.http(_url, '$_api/delete/$idAlojamiento');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken,
      };

      final res = await http.delete(url, headers: headers);

      if (res.statusCode == 200) {
        return true;
      } else {
        print('Error al eliminar alojamiento, código: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al eliminar alojamiento: $e');
      return false;
    }
  }
}
