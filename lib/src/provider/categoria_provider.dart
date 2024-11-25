// categoria_provider.dart
import 'dart:convert';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/categoria.dart';
import 'package:http/http.dart' as http;

class CategoriaProvider {
  String _url = Environment.API_FLUFLU;
  String _api = '/api/categorias';

  Future<List<Categoria>> getAll() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAll');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = json.decode(res.body)['data'] as List;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        print('Error al obtener categorías: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
