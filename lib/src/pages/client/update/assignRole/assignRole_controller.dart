import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/provider/users_provider.dart';
import 'package:fluflu/src/utils/shared_pref.dart';  // Importa SharedPreferences
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluflu/src/models/user.dart';

class AssignRoleController {
  UsersProvider _usersProvider = UsersProvider();
  SharedPref _sharedPref = SharedPref();

  late User user;

  Future<void> loadUserFromSession() async {
    user = User.fromJson(await _sharedPref.read('user'));
  }

  Future<void> assignArrendadorRole(BuildContext context) async {
    await loadUserFromSession();

    await _usersProvider.init(context, sessionUser: user);

    ResponseApi responseApi = await _usersProvider.assignRole(user.id, '2');

    if (responseApi.success) {
      Fluttertoast.showToast(msg: 'Rol asignado correctamente');
      // Redirigir a la página de "Arrendador"
      Navigator.pushReplacementNamed(context, 'arrendador/arrendador/list');
    } else {
      Fluttertoast.showToast(msg: 'Error: ${responseApi.message}');
    }
  }
}
