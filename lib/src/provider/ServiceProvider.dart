import 'dart:convert';
import 'package:fluflu/src/models/service.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:http/http.dart' as http;

class ServiceProvider {
  final String _url = Environment.API_FLUFLU;
  final String _api = '/api/services';

  Future<List<Service>> getAllServices() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAll');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> servicesJson = json.decode(response.body);
        return servicesJson.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los servicios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los servicios: $e');
    }
  }
}
