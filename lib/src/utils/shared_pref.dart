import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluflu/src/provider/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluflu/src/models/user.dart';

class SharedPref {

  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    return json.decode(jsonString);
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<User?> loadUser() async {
    final json = await read('user');
    if (json == null) return null;
    try {
      return User.fromJson(json);
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    await save('user', user.toJson());
  }

  void logout(BuildContext context, String idUser) async {
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);
    await usersProvider.logout(idUser);
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  Future<String?> getUserId() async {
    try {
      final json = await read('user');
      if (json != null && json['id'] != null) {
        return json['id'].toString();
      }
    } catch (e) {
      print('Error getting userId: $e');
    }
    return null;
  }


}




