// users_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider {
  String _url = Environment.API_FLUFLU;
  String _api = '/api/users';

  late BuildContext context;
  late User sessionUser;


  Future<void> init(BuildContext context, {User? sessionUser}) async {
    this.context = context;

    if (sessionUser != null) {
      this.sessionUser = sessionUser;
    }

    return Future.value();
  }


  Future<Stream?> createWithImage(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if (image != null) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // ENVIARA LA PETICION
      return response.stream.transform(utf8.decoder);
    }
    catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<User?> getById(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) { // NO AUTORIZADO
        Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    }
    catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Stream?> update(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = sessionUser.sessionToken;

      if (image != null) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send();

      if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      return response.stream.transform(utf8.decoder);
    }
    catch (e) {
      print('Error: $e');
      return null;
    }
  }


  // Método para registrar un usuario
  Future<ResponseApi> create(User user) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return ResponseApi(
        success: false,
        message: 'Error: $e',
        error: 'Error',
      );
    }
  }

  // Método para iniciar sesión
  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({'email': email, 'password': password});
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return ResponseApi(
        success: false,
        message: 'Error: $e',
        error: 'Error',
      );
    }
  }


  Future<ResponseApi?> logout(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/logout');
      String bodyParams = json.encode({
        'id': idUser
      });
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch (e) {
      print('Error: $e');
      return null;
    }
  }




// Método para asignar un rol al usuario
  Future<ResponseApi> assignRole(String idUser, String idRol) async {
    try {
      Uri url = Uri.http(_url, '$_api/assignRole');  // Aquí corregimos la URL
      String bodyParams = json.encode({
        'id_user': idUser,
        'id_rol': idRol
      });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    } catch (e) {
      print('Error: $e');
      return ResponseApi(
        success: false,
        message: 'Error: $e',
        error: 'Error',
      );
    }
  }


}
