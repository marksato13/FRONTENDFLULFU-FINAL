import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/service.dart';

class NewAlojamientoProvider {
  final String _url = Environment.API_FLUFLU;
  final String _api = '/api/alojamientos';

  late BuildContext context;
  final SharedPref _sharedPref = SharedPref();


  Future<void> init(BuildContext context) async {
    this.context = context;
    return Future.value();
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




  Future<ResponseApi> createAlojamiento({
   //required String idUser,
    required String direccion,
    required String neighborhood,
    required double lat,
    required double lng,
    required String placeId,
    required String pais,
    required String estado,
    required String ciudad,
    required String codigoPostal,
    required String idCategoria, // Cambiado de nombreCategoria a idCategoria
    required String nombreAlojamiento,
    required String descripcion,
    required double precio,
    required List<File> images,
    required List<String> serviceIds, // Campo de servicios agregado

  }) async {
    try {
      // Obtener ID del usuario autenticado
      String? idUser = await _sharedPref.getUserId();
      if (idUser == null || idUser.isEmpty) {
        return ResponseApi(
          success: false,
          message: 'No se encontró el usuario autenticado.',
        );
      }

      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      request.fields['id_user'] = idUser;
      request.fields['direccion'] = direccion;
      request.fields['neighborhood'] = neighborhood;
      request.fields['lat'] = lat.toString();
      request.fields['lng'] = lng.toString();
      request.fields['place_id'] = placeId;
      request.fields['pais'] = pais;
      request.fields['estado'] = estado;
      request.fields['ciudad'] = ciudad;
      request.fields['codigo_postal'] = codigoPostal;
      request.fields['id_categoria'] = idCategoria; // Cambiado para usar ID
      request.fields['nombre_alojamiento'] = nombreAlojamiento;
      request.fields['descripcion'] = descripcion;
      request.fields['precio'] = precio.toString();


      // Agregar IDs de servicios seleccionados
      request.fields['services'] = serviceIds.join(',');

      for (File image in images) {
        String fileName = basename(image.path);
        request.files.add(await http.MultipartFile.fromPath('images', image.path, filename: fileName));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return ResponseApi.fromJson(responseData);
      } else {
        return ResponseApi(
          success: false,
          message: 'Error al crear alojamiento. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Error al crear alojamiento: $e',
      );
    }
  }
}
